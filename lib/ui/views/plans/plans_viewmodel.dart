import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart';
import 'package:webapp/ui/views/plans/widgets/common_plans_dialog.dart';
import 'package:webapp/ui/views/plans/widgets/plans_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class PlansViewModel extends BaseViewModel {
  PlansViewModel() {
    loadPlans();
  }

  List<PlanModel> plans = [];
  late PlanTableSource tableSource;

  // Form data
  String? planName;
  int? connections;
  int? amount;
  String? badge;

  void setPlanName(String v) {
    planName = v;
    notifyListeners();
  }

  void setConnections(String v) {
    connections = int.tryParse(v);
    notifyListeners();
  }

  void setAmount(String v) {
    amount = int.tryParse(v);
    notifyListeners();
  }

  void setBadge(String v) {
    badge = v;
    notifyListeners();
  }

  // Initial load
  void loadPlans() {
    plans = [
      PlanModel(
          id: 1,
          planName: "Basic",
          connections: 1,
          amount: 199,
          badge: "Starter"),
      PlanModel(
          id: 2,
          planName: "Pro",
          connections: 3,
          amount: 499,
          badge: "Popular"),
    ];
    _refreshTable();
  }

  /// SEARCH
  void searchPlans(String query) {
    final filtered = plans.where((p) {
      return p.planName.toLowerCase().contains(query.toLowerCase()) ||
          p.badge.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _refreshTable(filtered: filtered);
  }

  // Add or update
  void saveOrUpdate(PlanModel plan) {
    final index = plans.indexWhere((p) => p.id == plan.id);
    if (index >= 0) {
      plans[index] = plan;
    } else {
      plans.add(plan);
    }
    _refreshTable();
  }

  void deletePlan(PlanModel plan) {
    plans.remove(plan);
    _refreshTable();
  }

  // 🔹 Refresh table
  void _refreshTable({List<PlanModel>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = PlanTableSource(
      plans: filtered ?? plans,
      onEdit: (plan) => editPlan(context, plan),
      onView: (plan) => viewPlan(context, plan),
      onDelete: (plan) => confirmDelete(context, plan),
    );
    notifyListeners();
  }

  // 🔥 Add Plan
  Future<void> addPlan(BuildContext context) async {
    final result = await CommonPlanDialog.show(context);
    if (result != null) {
      final newPlan = PlanModel(
        id: DateTime.now().millisecondsSinceEpoch,
        planName: result['planName'],
        connections: result['connections'],
        amount: result['amount'],
        badge: result['badge'],
      );
      saveOrUpdate(newPlan);
    }
  }

  // 🔥 Edit Plan
  Future<void> editPlan(BuildContext context, PlanModel plan) async {
    final result = await CommonPlanDialog.show(context, initial: plan);
    if (result != null) {
      final updated = PlanModel(
        id: plan.id,
        planName: result['planName'],
        connections: result['connections'],
        amount: result['amount'],
        badge: result['badge'],
      );
      saveOrUpdate(updated);
    }
  }

  // 🔥 View Plan
  Future<void> viewPlan(BuildContext context, PlanModel plan) async {
    await CommonPlanDialog.show(context, initial: plan, isView: true);
  }

  void applySort(bool specialFilter, String sortType) {
    if (specialFilter) {
      // implement custom filter
    }
    if (sortType == "A-Z")
      plans.sort((a, b) => a.planName.compareTo(b.planName));
    else if (sortType == "clientAsc")
      plans.sort((a, b) => a.id.compareTo(b.id));
    _refreshTable();
  }

  // 🔹 Confirm Delete
  void confirmDelete(BuildContext context, PlanModel plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${plan.planName}?"),
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
              deletePlan(plan);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
