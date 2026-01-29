import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart' show locator;
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/promote_projects/model/prmote_table_model.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart';
import 'package:webapp/ui/views/promote_projects/widgets/add_edit_dialog.dart';
import 'package:webapp/ui/views/promote_projects/widgets/project_table_source.dart';
import 'package:webapp/ui/views/promote_projects/widgets/promote_status.dart';
import 'package:webapp/ui/views/promote_projects/widgets/promote_table_source.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/requests/widgets/confirmation_dialog.dart';

class PromoteProjectsViewModel extends BaseViewModel with NavigationMixin {
  PromoteProjectsViewModel() {
    init();
  }

  /// 🔹 Master data
  List<ProjectModel> plans = [];

  /// 🔹 Table source
  late PromoteProjectsTableSource tableSource;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<influencer_model.Datum> influencers = [];

  bool hasSelection = false;
  List<int> selectedIds = [];

  bool _isProjectVisible = false;
  bool get isProjectVisible => _isProjectVisible;

  int _isChipSelected = 0;
  int get isChipSelected => _isChipSelected;

  bool _isRequest = false;
  bool get isRequest => _isRequest;

  /// 🔥 Toggle flag
  bool _isInprogress = true;
  bool get isInprogress => _isInprogress;

  /// 🔥 FILTERED DATA (KEY LOGIC)
  List<ProjectModel> get filteredPlans {
    if (_isInprogress) {
      // In-Progress
      return plans.where((e) => e.isCompleted == false).toList();
    } else {
      // Completed
      return plans.where((e) => e.isCompleted == true).toList();
    }
  }

  Future<void> getInfluencers() async {
    try {
      final res = await runBusyFuture(_apiService.getAllInfluencer());
      influencers = res.data ?? [];
    } catch (e) {
      influencers = [];
    }
  }

  /// 🔥 Initial load
  void init() {
    _isProjectVisible = false;
    plans = _dummyData();
    getInfluencers();

    tableSource = PromoteProjectsTableSource(
      data: filteredPlans,
      vm: this,
      // onEdit: (project) {
      //   editProject(StackedService.navigatorKey!.currentContext!, project);
      // },
      onView: (project) {
        viewProject(StackedService.navigatorKey!.currentContext!, project);
      },
    );

    notifyListeners();
  }

  void createProject(BuildContext context) {
    final newProject = ProjectModel.empty(
      DateTime.now().millisecondsSinceEpoch,
    );
    ProjectDetailsDialog.show(
      context,
      model: newProject,
      isEdit: true,
      influencers: influencers,
      onSave: (project) {
        addProject(project);
      },
    );
  }

  void editProject(BuildContext context, ProjectModel project) {
    ProjectDetailsDialog.show(context, model: project, isEdit: true,
        onSave: (updatedProject) {
      updateProject(updatedProject);
    }, influencers: influencers);
  }

  void viewProject(BuildContext context, ProjectModel project) {
    ProjectDetailsDialog.show(context,
        model: project,
        isEdit: false, // 👈 read-only
        influencers: influencers);
  }

  /// 🔥 Toggle table
  void isInprogresToggle(bool value) {
    _isInprogress = value;
    tableSource.updateData(filteredPlans);
    notifyListeners();
  }

  void addProject(ProjectModel project) {
    plans.insert(0, project);
    tableSource.updateData(filteredPlans);
    notifyListeners();
  }

  void updateProject(ProjectModel updated) {
    final index = plans.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    plans[index] = updated;
    tableSource.updateData(filteredPlans);
    notifyListeners();
  }

  void toggleProjectStatus(ProjectModel item) {
    item.isCompleted = !item.isCompleted;
    tableSource.updateData(filteredPlans);
    notifyListeners();
  }

  void backToScreen() {
    _isProjectVisible = false;
    _isChipSelected = 0;
    notifyListeners();
  }

  /// 🔹 Dummy data
  List<ProjectModel> _dummyData() {
    return List.generate(
      5,
      (i) => ProjectModel(
        id: i,
        projectCode: 'PRJ-00$i',
        clientName: 'Client $i',
        companyName: 'ABC Company',
        projectTitle: 'Campaign $i',
        gender: 'Male',
        state: 'Tamil Nadu',
        city: 'Coimbatore',
        service: 'Instagram Promotion',
        influencers: [
          {
            'id': 4,
            'name': 'sudharsan D',
            'image':
                "http://172.20.25.23:8005/storage/influencer_image/1768215142_influencer.png"
          },
          {
            'id': 5,
            'name': "sudharsan",
            'image':
                'http://172.20.25.23:8005/storage/influencer_image/1768203188_influencer.png'
          },
          {
            'id': 6,
            'name': 'hema latha',
            'image':
                "http://172.20.25.23:8005/storage/influencer_image/1768214946_influencer.png"
          }
        ],
        projectImages: [],
        note: 'Design work',
        payment: 2000,
        commission: 500,
        isCompleted: i.isEven, // even → completed
        assignedDate: DateTime.now(),
      ),
    );
  }

  /// 🔹 Columns
  final inProgressColumns = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Project Code")),
    DataColumn(label: Text("Client Name")),
    DataColumn(label: Text("Project Title")),
    DataColumn(label: Text("Inf_icons")),
    DataColumn(label: Text("Project Count")),
    DataColumn(label: Text("Note")),
    DataColumn(
        label: Text("Total promote pay"),
        tooltip: "Total promote pay",
        headingRowAlignment: MainAxisAlignment.end),
    DataColumn(
        label: Text("Total Commission"),
        tooltip: "Total Commission",
        headingRowAlignment: MainAxisAlignment.end),
    DataColumn(
      label: Text("Actions"),
      headingRowAlignment: MainAxisAlignment.center,
    ),
  ];

  final completedColumns = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Project Code")),
    DataColumn(label: Text("Client Name")),
    DataColumn(label: Text("Project Title")),
    DataColumn(label: Text("Inf_icons")),
    DataColumn(label: Text("Notes")),
    DataColumn(label: Text("Project Count")),
    DataColumn(label: Text("Total promotepay")),
    DataColumn(label: Text("Total commission")),
    DataColumn(label: Text("Payment")),
  ];

  ///////////////////////////////////////////////////////////////////////////////
  //---------------------------promote table load------------------------------//
  ///////////////////////////////////////////////////////////////////////////////

  late PromoteTableSource promoteTableSource;
  List<PromoteTableModel> tableData = [];
  String selectedStatus = 'assigned';
  bool isLoading = false;

  String? _projectCode;
  String? get projectCode => _projectCode;

  Future<void> notifySelectionChanged() async {
    _isProjectVisible = true;
    _isChipSelected = 0;

    final selectedPlans = plans.where((e) => e.isSelected).toList();
    hasSelection = selectedPlans.isNotEmpty;

    selectedIds
      ..clear()
      ..addAll(selectedPlans.map((e) => e.id));

    _projectCode =
        selectedPlans.isNotEmpty ? selectedPlans.last.projectCode : null;

    _isRequest = true;

    // 🔥 IMPORTANT: clear table before reload
    tableData = [];
    promoteTableSource = PromoteTableSource(data: [], status: selectedStatus);

    notifyListeners();

    await loadPromoteTable(selectedStatus);

    _isRequest = false;
    notifyListeners();
  }

  Future<void> loadPromoteTable(String status) async {
    _isRequest = true;
    selectedStatus = status;

    // 🔥 Reset table immediately
    tableData = [];
    promoteTableSource = PromoteTableSource(data: [], status: status);

    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final allData = <PromoteTableModel>[
        PromoteTableModel(
          projectCode: "PR001",
          influencer: "John Doe",
          influencerId: "INF001",
          phone: "9898984562",
          tCode: "T001",
          prSubCode: "PRSUB001",
          note: "First project",
          assignedDate: "11-12-2025",
          completedDate: "12-12-2025",
          status: PromoteStatus.assigned,
          bankDetails: "Bank XYZ",
          amount: 5000,
          viewLink: "http://link1.com",
        ),
        PromoteTableModel(
          projectCode: "PR002",
          influencer: "Jane Doe",
          influencerId: "INF002",
          phone: "9898986532",
          tCode: "T002",
          prSubCode: "PRSUB002",
          note: "Second project",
          assignedDate: "11-12-2025",
          completedDate: "12-12-2025",
          status: PromoteStatus.assigned,
          bankDetails: "Bank ABC",
          amount: 6000,
          viewLink: "http://link2.com",
        ),
      ];

      tableData = allData
          .where(
            (e) => e.status.toLowerCase() == status.toLowerCase(),
          )
          .toList();

      promoteTableSource = PromoteTableSource(
          data: tableData, status: status, onPreparing: onPreparing);
    } catch (_) {
      tableData = [];
      promoteTableSource = PromoteTableSource(data: [], status: status);
    }

    _isRequest = false;
    notifyListeners();
  }

  List<DataColumn> getColumnsByStatus(String status) {
    switch (status) {
      case PromoteStatus.assigned:
        return const [
          // Columns
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Inf_name / Inf_ID")),
          DataColumn(label: Text("Inf_Number")),
          DataColumn(label: Text("Note")),
          DataColumn(label: Text("Link")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(
              label: Text("Status"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center), // 9 columns
        ];

      case PromoteStatus.completed:
        return const [
          // Columns
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("T-Code")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Action")), // 7 columns
        ];

      case PromoteStatus.verified:
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("PR Sub Code")),
          DataColumn(label: Text("Influencers")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("Phone No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("View Link")),
          DataColumn(label: Text("Promote Pay")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Completed Date")),
        ];

      case PromoteStatus.pay:
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Influencers")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("Phone No")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Payment Amount")),
          DataColumn(
            label: Text("Action"),
            headingRowAlignment: MainAxisAlignment.center,
          ),
        ];

      case PromoteStatus.commission:
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Influencers")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("Phone No")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Commission")),
        ];

      default:
        return const [];
    }
  }

  Future<void> setChipSelected(int index) async {
    _isRequest = true;
    _isChipSelected = index;
    notifyListeners();

    switch (index) {
      case 0:
        await loadPromoteTable(PromoteStatus.assigned);
        break;
      case 1:
        await loadPromoteTable(PromoteStatus.completed);
        break;
      case 2:
        await loadPromoteTable(PromoteStatus.verified);
        break;
      case 3:
        await loadPromoteTable(PromoteStatus.pay);
        break;
      case 4:
        await loadPromoteTable(PromoteStatus.commission);
        break;
    }

    _isRequest = false;
    notifyListeners();
  }

  /// functions
  ///
  onPreparing(model) async {
    final result = await showStatusDialog(
      StackedService.navigatorKey!.currentContext!,
    );
    if (result != null) {
      print("Selected status: ${result['projectCode']}");
    }
  }
}
