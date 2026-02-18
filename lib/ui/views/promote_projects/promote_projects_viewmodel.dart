import 'dart:convert';
import 'dart:developer';

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart' show locator;
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/promote_projects/model/payment_split_model.dart'
    as split_model;
import 'package:webapp/ui/views/promote_projects/model/prmote_table_model.dart'
    as promote_table_model;
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart'
    as project_model;
import 'package:webapp/ui/views/promote_projects/widgets/add_edit_dialog.dart';
import 'package:webapp/ui/views/promote_projects/widgets/dialogs/common_split_amount_widget.dart';
import 'package:webapp/ui/views/promote_projects/widgets/image_items.dart';
import 'package:webapp/ui/views/promote_projects/widgets/project_table_source.dart';
import 'package:webapp/ui/views/promote_projects/widgets/promote_status.dart';
import 'package:webapp/ui/views/promote_projects/widgets/promote_table_source.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/requests/widgets/confirmation_dialog.dart';
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;
import 'package:webapp/ui/views/add_company/model/company_model.dart'
    as company_model;

class PromoteProjectsViewModel extends BaseViewModel with NavigationMixin {
  PromoteProjectsViewModel() {
    init();
  }

  /// 🔹 Master data
  List<project_model.Message> plans = [];
  List<service_model.Datum> services = [];
  List<company_model.Datum> companies = [];

  /// 🔹 Table source
  late PromoteProjectsTableSource tableSource;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<influencer_model.Datum> influencers = [];

  bool hasSelection = false;
  List<int> selectedIds = [];

  bool _isProjectVisible = false;
  bool get isProjectVisible => _isProjectVisible;

  bool _isProjectTableLoading = false;
  bool get isProjectTableLoading => _isProjectTableLoading;

  int _isChipSelected = 0;
  int get isChipSelected => _isChipSelected;

  bool _isRequest = false;
  bool get isRequest => _isRequest;

  /// 🔥 Toggle flag
  bool _isInprogress = true;
  bool get isInprogress => _isInprogress;

  // bool get isDialogOpen => DialogState.isDialogOpen;

  bool _isDialogOpen = false;

  bool get isDialogOpen => _isDialogOpen;

  List<int>? assignedInfluencerIds = [];

  void setDialogOpen(bool value) {
    _isDialogOpen = value;
    notifyListeners(); // 🔥 This triggers rebuild
  }

  /// 🔥 FILTERED DATA (KEY LOGIC)
  List<project_model.Message> get filteredPlans => plans;

  Future<void> getInfluencers() async {
    try {
      final res = await runBusyFuture(_apiService.getAllInfluencer());
      influencers = res.data ?? [];
    } catch (e) {
      influencers = [];
    }
  }

  Future<void> loadCompanies() async {
    _isProjectTableLoading = true;
    notifyListeners();
    try {
      final res = await runBusyFuture(_apiService.getCompany());
      companies = res.data ?? [];
    } catch (e) {
      companies = [];
    }
    _isProjectTableLoading = false;
    notifyListeners();
  }

  Future<void> getServices() async {
    final res = await runBusyFuture(_apiService.getAllService());
    services = res.data ?? [];
  }

  Future<void> changeStatus(request) async {
    try {
      final res = await _apiService.changePromoteStatus(request);

      // ✅ LOCAL variable (important)
      final bool isSuccess = res['status'] == 200;

      _dialogService.showDialog(
        title: isSuccess ? "Success" : "Error",
        description: res['message'] ??
            (isSuccess
                ? "Status changed successfully."
                : "Failed to change status."),
      );

      if (isSuccess) {
        loadPromoteTable(selectedStatus);
      }
    } catch (e) {
      log(e.toString());
      _dialogService.showDialog(
        title: "Error",
        description: "An error occurred while changing status.",
      );
    }
  }

  Future<void> createPromoteProject(request) async {
    setProjectLoading(true);
    final data = {
      if (request['id'] != null) "id": request['id'],
      "project_code": request["projectCode"],
      "project_name": request["projectTitle"],
      "company_id": request["companyId"],
      "service_ids": request["selectedServiceIds"],
      "state": request["state"],
      "city": request["city"],
      "gender": request["gender"].toLowerCase(),
      "inf_ids": request["selectedInfluencerIds"],
      "payment": [
        {
          "payment": request["payment"],
          "commission": request["commission"],
        }
      ],
      "description": request["note"],
      "images": request["projectImages"],
      "link": request["link"],
    };
    try {
      final formData = FormData();

      void addField(String key, dynamic value) {
        if (value != null) {
          formData.fields.add(
            MapEntry(key, value.toString()),
          );
        }
      }

      addField("id", data["id"]);
      addField("project_code", data["project_code"]);
      addField("project_name", data["project_name"]);
      addField("company_id", data["company_id"]);
      addField("state", data["state"]);
      addField("city", data["city"]);
      addField("gender", data["gender"]);
      // ================= LINK =================
      if (data["link"] is Map) {
        final linkMap = Map<dynamic, dynamic>.from(data["link"]);

        linkMap.forEach((key, value) {
          if (key != null && key.toString().trim().isNotEmpty) {
            formData.fields.add(
              MapEntry("link[0][$key]", value.toString()),
            );
          }
        });
      }

      print("RAW request['link']: ${request["link"]}");
      print("TYPE of request['link']: ${request["link"]?.runtimeType}");

      addField("description", data["description"]);
      if (data["payment"] is List && data["payment"].isNotEmpty) {
        for (var i = 0; i < data["payment"].length; i++) {
          final item = data["payment"][i];
          formData.fields.add(
            MapEntry("payment[$i][payment]", item["payment"].toString()),
          );
          formData.fields.add(
            MapEntry("payment[$i][commission]", item["commission"].toString()),
          );
        }
      }

      if (data["images"] is List && data["images"].isNotEmpty) {
        final List<ImageItem> imageList = List<ImageItem>.from(data["images"]);

        int newImageIndex = 0;
        int existingImageIndex = 0;

        for (final item in imageList) {
          // ✅ NEW IMAGE (WEB)
          if (item.bytes != null) {
            formData.files.add(
              MapEntry(
                "images[$newImageIndex]",
                MultipartFile.fromBytes(
                  item.bytes!,
                  filename:
                      "image_${DateTime.now().millisecondsSinceEpoch}_$newImageIndex.png",
                  contentType: MediaType("image", "png"),
                ),
              ),
            );
            newImageIndex++;
          }

          // ✅ NEW IMAGE (MOBILE)
          else if (item.path != null) {
            formData.files.add(
              MapEntry(
                "images[$newImageIndex]",
                await MultipartFile.fromFile(
                  item.path!,
                  filename: item.path!.split('/').last,
                ),
              ),
            );
            newImageIndex++;
          }

          // ✅ EXISTING IMAGE
          else if (item.url != null) {
            formData.fields.add(
              MapEntry(
                "existing_images[$existingImageIndex]",
                item.url!,
              ),
            );
            existingImageIndex++;
          }
        }
      }

      if (data["service_ids"] is List && data["service_ids"].isNotEmpty) {
        for (var i = 0; i < data["service_ids"].length; i++) {
          formData.fields.add(
            MapEntry("service_ids[$i]", data["service_ids"][i].toString()),
          );
        }
      }
      if (data["inf_ids"] is List && data["inf_ids"].isNotEmpty) {
        for (var i = 0; i < data["inf_ids"].length; i++) {
          formData.fields.add(
            MapEntry("inf_ids[$i]", data["inf_ids"][i].toString()),
          );
        }
      }

      print("FIELDS:");
      formData.fields.forEach((e) => print("${e.key} = ${e.value}"));

      print("FILES:");
      formData.files.forEach((e) => print("${e.key} = ${e.value}"));

      await _apiService.promoteProjectCreate(formData);

      _dialogService.showDialog(
        title: "Success",
        description: "Promotion project created successfully.",
      );
      // Optionally, refresh the list or navigate away
    } catch (e) {
      _dialogService.showDialog(
        title: "Error",
        description: "Failed to create promotion project.",
      );
      rethrow;
    } finally {
      loadProjects();
      setProjectLoading(false);
      notifyListeners();
    }
  }

  /// 🔥 Initial load
  void init() {
    _isProjectVisible = false;

    tableSource = PromoteProjectsTableSource(
      data: [],
      vm: this,
      onView: (project) {
        viewProject(
          StackedService.navigatorKey!.currentContext!,
          project,
        );
      },
    );

    runBusyFuture(loadProjects());
    getInfluencers();
    getServices();
    loadCompanies();
  }

  Future<void> loadProjects() async {
    setProjectLoading(true);

    final request = {"status": _isInprogress ? "0" : "1"};

    try {
      final res = await _apiService.getAllPromoteProjects(request);

      plans = res.message ?? [];

      tableSource.updateData(plans);
    } catch (e) {
      print(e);
      plans = [];
      tableSource.updateData([]);
    } finally {
      setProjectLoading(false);
    }
  }

  void createProject(BuildContext context) {
    final newProject = project_model.Message();
    ProjectDetailsDialog.show(
      context,
      model: newProject,
      isEdit: true,
      influencers: influencers,
      companies: companies,
      service: services,
      onSave: (project) {
        createPromoteProject(project);
        // addProject(project);
      },
    );
  }

  setProjectLoading(bool value) {
    _isProjectTableLoading = value;
    notifyListeners();
  }

  void viewProject(BuildContext context, project_model.Message project) {
    setDialogOpen(true);
    ProjectDetailsDialog.show(
      context,
      model: project,
      service: services,
      isEdit: false, // 👈 read-only
      influencers: influencers,
      companies: companies,
      onSave: (value) {
        createPromoteProject(value);
      },
    ).then((_) {
      setDialogOpen(false);
    });
  }

  /// 🔥 Toggle table
  void isInprogresToggle(bool value) {
    _isInprogress = value;
    loadProjects(); // ✅ fetch correct data
  }

  void updateProject(updated) {
    final index = plans.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    plans[index] = updated;
    tableSource.updateData(filteredPlans);
    notifyListeners();
  }

  void toggleProjectStatus(project_model.ProjectModel item) {
    // item.isCompleted = !item.isCompleted;
    tableSource.updateData(filteredPlans);
    notifyListeners();
  }

  void backToScreen() {
    selectedStatus = "assigned";
    _isProjectVisible = false;
    _isChipSelected = 0;
    _totalSplitAmount = "0";
    notifyListeners();
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

  void searchPlans(String query) {
    final filtered = plans.where((p) {
      return p.companyName!.toLowerCase().contains(query.toLowerCase()) ||
          p.projectCode!.toLowerCase().contains(query.toLowerCase()) ||
          p.projectName!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    tableSource.updateData(filtered);
  }

  ///////////////////////////////////////////////////////////////////////////////
  //---------------------------promote table load------------------------------//
  ///////////////////////////////////////////////////////////////////////////////

  late PromoteTableSource promoteTableSource;
  List<promote_table_model.Datum> tableData = [];
  String selectedStatus = PromoteStatus.assigned;
  bool isLoading = false;

  String? _projectCode;
  String? get projectCode => _projectCode;
  int? _selectedProjectId;
  int? _selectedSubProjectId;
  int? get selectedSubProjectId => _selectedSubProjectId;
  int? get selectedProjectId => _selectedProjectId;

  List<dynamic> dataLists = [];
  String? _totalSplitAmount;
  String? get totalSplitAmount => _totalSplitAmount;

  void onRowSelected(int projectId) {
    _selectedProjectId = projectId;
    _isProjectVisible = true;
    _isInprogress == true ? _isChipSelected = 0 : _isChipSelected = 2;
    loadPromoteTable(selectedStatus);
    getPaymentList();
    notifyListeners();
  }

  // Future<void> notifySelectionChanged() async {
  //   _isProjectVisible = true;
  //   _isChipSelected = 0;

  //   final selectedPlans = plans.where((e) => e.isSelected).toList();
  //   hasSelection = selectedPlans.isNotEmpty;

  //   selectedIds
  //     ..clear()
  //     ..addAll(selectedPlans.map((e) => e.id));

  //   _projectCode =
  //       selectedPlans.isNotEmpty ? selectedPlans.last.projectCode : null;

  //   _isRequest = true;

  //   // 🔥 IMPORTANT: clear table before reload
  //   tableData = [];
  //   promoteTableSource = PromoteTableSource(data: [], status: selectedStatus);

  //   notifyListeners();

  //   await loadPromoteTable(selectedStatus);

  //   _isRequest = false;
  //   notifyListeners();
  // }

  int? _projectStatus = 1;

  // 1:Assigned, 2:Inf-accepted, 3:Inf-completed, 4:Rejected, 5:Admin-verify-completed, 6:Promote-Verified, 7:Promote-Pay, 8:Promote-Commission, 9:company-payment-verified
  Future<void> loadPromoteTable(String status) async {
    _isRequest = true;
    selectedStatus = status;

    switch (selectedStatus) {
      case PromoteStatus.assigned:
        _projectStatus = 1;
        break;
      case PromoteStatus.infAccepted:
        _projectStatus = 2;
        break;
      case PromoteStatus.infCompleted:
        _projectStatus = 3;
        break;
      case PromoteStatus.rejected:
        _projectStatus = 4;
        break;
      case PromoteStatus.adminVerified:
        _projectStatus = 5;
        break;
      case PromoteStatus.promoteVerified:
        _projectStatus = 6;
        break;
      case PromoteStatus.promotePay:
        _projectStatus = 7;
        break;
      case PromoteStatus.promoteCommission:
        _projectStatus = 8;
        break;
      case PromoteStatus.companyPaymentVerified:
        _projectStatus = 9;
        break;
      default:
        _projectStatus = 0;
    }

    // 🔥 Reset table immediately
    tableData = [];
    promoteTableSource = PromoteTableSource(data: [], status: status);

    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final allData = await _apiService.getSubProjects(
          {"promote_id": _selectedProjectId, "status": _projectStatus});

      tableData = allData.data ?? [];

      _projectCode = allData.projectCode;

      promoteTableSource = PromoteTableSource(
          data: tableData,
          status: status,
          onReject: onReject,
          onVerify: onVerify,
          onGotoPromoteVerified: onGotoPromoteVerified,
          onGotoPromotePay: onGotoPromotePay,
          onGotoPromoteCommission: onGotoPromoteCommission,
          showBankDetails: showBankDetails,
          onReAssign: onReAssign,
          onRevoke: onRevoke);
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
          DataColumn(label: Text("Amount")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(
              label: Text("Status"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center), // 9 columns
        ];
      case PromoteStatus.infAccepted:
        return const [
          // Columns
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Inf_name / Inf_ID")),
          DataColumn(label: Text("Inf_Number")),
          DataColumn(label: Text("Note")),
          DataColumn(label: Text("Amount")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(
              label: Text("Status"),
              headingRowAlignment: MainAxisAlignment.center),
          // DataColumn(
          //     label: Text("Action"),
          //     headingRowAlignment: MainAxisAlignment.center), // 9 columns
        ];
      case PromoteStatus.infCompleted:
        return const [
          // Columns
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Inf_name / Inf_ID")),
          DataColumn(label: Text("Inf_Number")),
          DataColumn(label: Text("Note")),
          DataColumn(label: Text("Amount")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(
              label: Text("links"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center), // 9 columns
        ];

      case PromoteStatus.adminVerified:
        return const [
          // Columns
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("T-Code")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center), // 7 columns
        ];

      case PromoteStatus.promoteVerified:
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("PR Sub Code")),
          DataColumn(label: Text("Influencers")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("Phone No")),
          DataColumn(label: Text("View Link")),
          DataColumn(label: Text("Promote Pay")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center), // 10 columns
        ];

      case PromoteStatus.promotePay:
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

      case PromoteStatus.promoteCommission:
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
      case PromoteStatus.companyPaymentVerified:
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
      case PromoteStatus.rejected:
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
          DataColumn(label: Text("Action")),
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
        await loadPromoteTable(PromoteStatus.infAccepted);
        break;
      case 2:
        await loadPromoteTable(PromoteStatus.infCompleted);
        break;
      case 3:
        await loadPromoteTable(PromoteStatus.rejected);
        break;
      case 4:
        await loadPromoteTable(PromoteStatus.adminVerified);
        break;
      case 5:
        await loadPromoteTable(PromoteStatus.promoteVerified);
        break;
      case 6:
        await loadPromoteTable(PromoteStatus.promotePay);
        break;
      case 7:
        await loadPromoteTable(PromoteStatus.promoteCommission);
        break;
      case 8:
        await loadPromoteTable(PromoteStatus.companyPaymentVerified);
        break;
    }

    _isRequest = false;
    notifyListeners();
  }

  onProjectRowSelected(id) {
    _selectedSubProjectId = id;

    notifyListeners();
  }

  Future<void> getPaymentList() async {
    try {
      final res = await runBusyFuture(
        _apiService.getPaymentSplit({
          "promote_id": _selectedProjectId,
        }),
      );

      /// Convert Datum → Map (dialog-friendly)
      dataLists = (res.data ?? []).map((e) {
        final paymentDouble =
            double.tryParse(e.payment?.toString() ?? "0") ?? 0;

        return {
          "id": e.id,
          "inf_id": e.infId,
          "influencer_name": e.influencerName,
          "influencer_image": e.influencerImage,
          "payment": paymentDouble.toInt(), // 👈 dialog expects int
          "status": int.tryParse(e.status ?? "0"),
        };
      }).toList();

      _totalSplitAmount = (res.totalAmount ?? "0").toString();

      assignedInfluencerIds = dataLists
          .map((e) => int.tryParse(e["inf_id"].toString()) ?? 0)
          .toList();

      print("Payment Split Data: $dataLists");
      print("assign influencers: $assignedInfluencerIds");
      print("Total Split Amount: $_totalSplitAmount");
    } catch (e) {
      print("Error fetching payment split: $e");
    }
  }

  Future<void> splitAmount(BuildContext context) async {
    showCommonAmountDialog(
      context: context,
      dataList: dataLists,
      totalValue: int.tryParse(_totalSplitAmount ?? "0") ?? 0,
      title: 'Split Amount',
      nameKey: 'influencer_name',
      imageKey: 'influencer_image',
      amountKey: 'payment',
      itemStatusKey: 'status',
      lockedStatusValue: 4, // 🔒 locked when status == 4
      onNext: (updatedList) {
        print("UPDATED SPLIT 👉 $updatedList");

        // Optional: convert back to model if needed
        final updatedModels = updatedList
            .map((e) => split_model.Datum(
                  id: e["id"],
                  influencerName: e["influencer_name"],
                  influencerImage: e["influencer_image"],
                  payment: e["payment"]?.toString() ?? "0",
                  status: e["status"]?.toString(), // ✅ FIX HERE
                ))
            .toList();
        final payload = {
          "payment": updatedModels
              .map((e) => {
                    "id": e.id,
                    "payment": e.payment, // string OR int based on API
                  })
              .toList(),
        };
        updatePaymentSplit(payload);

        print(jsonEncode(payload));
      },
    );
  }

  Future<void> updatePaymentSplit(payload) async {
    try {
      final res = await _apiService.updatePaymentSplit(payload);

      if (res['status'] == 200) {
        _dialogService.showDialog(
          title: "Success",
          description: "Payment split updated successfully.",
        );
        loadPromoteTable(selectedStatus); // refresh table to show changes
      } else {
        _dialogService.showDialog(
          title: "Error",
          description: res['message'] ?? "Failed to update payment split.",
        );
      }
    } catch (e) {
      print("Error updating payment split: $e");
      _dialogService.showDialog(
        title: "Error",
        description: "An error occurred while updating payment split.",
      );
    }
  }

  Future<void> reAssignInfluencer(data) async {
    try {
      final res = await _apiService.reAssignInf(data);
    } catch (e) {
      print(e);
    } finally {
      loadPromoteTable(selectedStatus);
    }
  }

  /// functions
  ///
  onReject(model) async {
    await showRejectConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      itemName: model.projectCode,
      promotionProject: "Promotion Project",
      onConfirm: () {},
    );
  }

  onVerify(model) async {
    final result = await showStatusDialog(
      StackedService.navigatorKey!.currentContext!,
    );

    if (result != null) {
      print("Selected status: ${result['name']}");
      print("id: ${model.subId}");
      if (result['name'] == "Completed") {
        await changeStatus({
          "promote_project_id": model.subId,
          "status": 5,
        });
      } else if (result['name'] == "Rework") {
        await changeStatus({
          "promote_project_id": model.subId,
          "rework": 1,
        });
      }
    }
  }

  Future<void> onGotoPromoteVerified(model) async {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Move to Promote Verified',
      confirmText: "Move",
      message:
          "Are you sure you want to move the ${model.subId} to the promote verified section?",
      icon: Icons.hourglass_top,
      confirmColor: Colors.green,
      onConfirm: () async {
        await changeStatus({
          "promote_project_id": model.subId,
          "status": 6,
        });
      },
    );
  }

  onGotoPromotePay(model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Move to Promote Pay',
      confirmText: "Move",
      message:
          "Are you sure you want to move the ${model.subId} to the promote pay section?",
      icon: Icons.hourglass_top,
      confirmColor: greenShade1,
      onConfirm: () async {
        await changeStatus({
          "promote_project_id": model.subId,
          "status": 7,
        });
      },
    );
  }

  onGotoPromoteCommission(model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Move to Promote Commission',
      confirmText: "Move",
      message:
          "Are you sure you want to move the ${model.subId} to the promote commission section?",
      icon: Icons.hourglass_top,
      confirmColor: pendingColor,
      onConfirm: () async {
        await changeStatus({
          "promote_project_id": model.subId,
          "status": 8,
        });
      },
    );
  }

  showBankDetails(model) {
    showBankDetailsDialog(
        context: StackedService.navigatorKey!.currentContext!,
        bankDetails: model.payment);
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (_isProjectVisible == false) {
      if (sortType == "A-Z") {
        companies.sort((a, b) {
          final nameCompare = (a.companyName ?? '')
              .toLowerCase()
              .compareTo((b.companyName ?? '').toLowerCase());

          if (nameCompare != 0) return nameCompare;

          final cityCompare = (a.city ?? '')
              .toLowerCase()
              .compareTo((b.city ?? '').toLowerCase());

          if (cityCompare != 0) return cityCompare;

          return (a.state ?? '')
              .toLowerCase()
              .compareTo((b.state ?? '').toLowerCase());
        });
      } else if (sortType == "clientAsc") {
        companies.sort((a, b) => a.id!.compareTo(b.id!));
      } else if (sortType == "older") {
        companies.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.parse(a.createdAt.toString())
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.parse(b.createdAt.toString())
              : DateTime(1970);
          return bDate.compareTo(aDate);
        });
      } else if (sortType == "newer") {
        companies.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.parse(a.createdAt.toString())
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.parse(b.createdAt.toString())
              : DateTime(1970);
          return aDate.compareTo(bDate);
        });
      } else {
        // No sorting
      }

      loadCompanies();
    } else {
      if (sortType == "A-Z") {
        plans.sort((a, b) {
          final nameCompare = (a.companyName ?? '')
              .toLowerCase()
              .compareTo((b.companyName ?? '').toLowerCase());

          if (nameCompare != 0) return nameCompare;

          final cityCompare = (a.city ?? '')
              .toLowerCase()
              .compareTo((b.city ?? '').toLowerCase());

          if (cityCompare != 0) return cityCompare;

          final infComapre = (a.id.toString() ?? '')
              .toLowerCase()
              .compareTo((b.id.toString() ?? '').toLowerCase());

          if (infComapre != 0) return infComapre;

          return (a.state ?? '')
              .toLowerCase()
              .compareTo((b.state ?? '').toLowerCase());
        });
      } else if (sortType == "clientAsc") {
        plans.sort((a, b) => a.id!.compareTo(b.id!));
      } else if (sortType == "older") {
        plans.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.parse(a.createdAt.toString())
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.parse(b.createdAt.toString())
              : DateTime(1970);
          return bDate.compareTo(aDate);
        });
      } else if (sortType == "newer") {
        plans.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.parse(a.createdAt.toString())
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.parse(b.createdAt.toString())
              : DateTime(1970);
          return aDate.compareTo(bDate);
        });
      } else {
        // No sorting
      }

      loadProjects();
    }
  }

  onRevoke(model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Revoke',
      confirmText: "Revoke",
      message:
          "Are you sure you want to Revoke the ${model.subId} to the Reject section?",
      icon: Icons.free_cancellation,
      confirmColor: red,
      onConfirm: () {
        final data = {
          "promote_project_id": model.subId,
          "status": 2,
        };
        changeStatus(data);
      },
    );
  }

  onReAssign(model) async {
    final selected = await showReassignInfluencerDialog(
        context: StackedService.navigatorKey!.currentContext!,
        influencers: influencers,
        currentInfluencerId: model.infId,
        assignedInfluencerIds: assignedInfluencerIds!);

    if (selected != null) {
      print("Selected Influencer ID: ${selected.id}");
      final data = {
        "promote_project_id": model.subId,
        "inf_id": selected.id,
        "status": 1
      };
      print("status $data");
      if (data.isNotEmpty) {
        reAssignInfluencer(data);
      }
    }
  }
}

// 1:Assigned,
//2:Inf-accepted,
//3:Inf-completed,
//4:Rejected,
//5:Admin-verify-completed,
//6:Promote-Verified,
//7:Promote-Pay,
//8:Promote-Commission,
//9:company-payment-verified
