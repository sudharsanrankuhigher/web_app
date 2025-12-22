import 'package:stacked/stacked.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart';
import 'package:webapp/ui/views/promote_projects/widgets/project_table_source.dart';

class PromoteProjectsViewModel extends BaseViewModel with NavigationMixin {
  PromoteProjectsViewModel() {
    init();
  }

  List<ProjectModel> plans = [];
  late PromoteProjectsTableSource tableSource;

  bool hasSelection = false;
  List<int> selectedIds = [];

  void init() {
    plans = _dummyData();

    tableSource = PromoteProjectsTableSource(
      data: plans,
      vm: this,
    );

    notifyListeners();
  }

  void notifySelectionChanged() {
    hasSelection = plans.any((e) => e.isSelected);
    selectedIds
      ..clear()
      ..addAll(plans.where((e) => e.isSelected).map((e) => e.id));
    notifyListeners();
  }

  void toggleProjectStatus(ProjectModel item) {
    item.isCompleted = !item.isCompleted;
    tableSource.notifyListeners();
  }

  List<ProjectModel> _dummyData() {
    return List.generate(
      5,
      (i) => ProjectModel(
        id: i,
        projectCode: 'PRJ-00$i',
        clientName: 'Client $i',
        projectTitle: 'Campaign $i',
        note: 'Design work',
        influencerImages: [
          'https://i.pravatar.cc/150?img=${i + 1}',
          'https://i.pravatar.cc/150?img=${i + 2}',
          'https://i.pravatar.cc/150?img=${i + 3}',
        ],
        isCompleted: i % 2 == 0,
        assignedDate: DateTime.now(),
      ),
    );
  }
}
