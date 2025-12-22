import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/state/model/state_model.dart';
import 'package:webapp/ui/views/state/widget/State_table_source.dart';
import 'package:webapp/ui/views/state/widget/common_state_add_edit_dialog.dart';
import 'package:webapp/widgets/common_button.dart';

class StateViewModel extends BaseViewModel with NavigationMixin {
  StateViewModel() {
    loadPlans();
  }

  String? _stateValue = "Tamil Nadu";

  String? get stateValue => _stateValue;

  List<StateModel> states = [];
  late StateTableSource tableSource;

  String? stateName;

  void setCity(state) {
    _stateValue = state;
    notifyListeners();
  }

  void loadPlans() {
    states = [
      StateModel(id: 1, name: "Tamil Nadu", status: 'active'),
      StateModel(id: 2, name: "Andrapredesh", status: 'inactive'),
      StateModel(id: 3, name: "Kerala", status: 'active'),
    ];
    _refreshTable();
  }

  void saveOrUpdate(StateModel state) {
    final index = states.indexWhere((p) => p.id == state.id);
    if (index >= 0) {
      states[index] = state;
    } else {
      states.add(state);
    }
    _refreshTable();
  }

  void deletePlan(StateModel plan) {
    states.remove(plan);
    _refreshTable();
  }

  // 🔹 Refresh table
  void _refreshTable({List<StateModel>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = StateTableSource(
      states: filtered ?? states,
      onEdit: (plan) => editPlan(context, plan),
      onDelete: (plan) => confirmDelete(context, plan),
    );
    notifyListeners();
  }

  // 🔥 Add Plan
  Future<void> addPlan() async {
    final result = await AddEditStatePage.show(
        StackedService.navigatorKey!.currentContext!);
    if (result != null) {
      final newPlan =
          StateModel(name: result['name'], status: result['status']);
      saveOrUpdate(newPlan);
    }
  }

  // 🔥 Edit Plan
  Future<void> editPlan(BuildContext context, StateModel state) async {
    final result = await AddEditStatePage.show(context, initial: state);
    if (result != null) {
      final updated = StateModel(
        id: state.id,
        name: result['name'],
        status: result['status'],
      );
      saveOrUpdate(updated);
    }
  }

  void confirmDelete(BuildContext context, StateModel state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${state.name}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          CommonButton(
            width: 100,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            buttonColor: Colors.red,
            text: "Delete",
            textStyle: const TextStyle(color: Colors.white),
            onTap: () {
              deletePlan(state);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    //   if (sortType == "A-Z") {
    //     plans.sort((a, b) => a.planName.compareTo(b.planName));
    //   } else if (sortType == "clientAsc")
    //     plans.sort((a, b) => a.id.compareTo(b.id));
    //   _refreshTable();
  }
}
