import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
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

  // Form data (no controller)
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

  // Initial load (dummy)
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

    tableSource = PlanTableSource(
      plans: plans,
      onEdit: editPlan,
      onView: viewPlan,
      onDelete: confirmDelete,
    );

    notifyListeners();
  }

  /// SEARCH
  void searchPlans(String query) {
    query = query.toLowerCase();

    final filtered = plans.where((inf) {
      return inf.planName.toLowerCase().contains(query) ||
          inf.badge.contains(query);
    }).toList();

    tableSource = PlanTableSource(
      plans: filtered,
      onEdit: editPlan,
      onView: viewPlan,
      onDelete:
          deletePlan, // <-- ADD THIS      // onDelete: (item) => print("Delete ${item.name}"),
    );

    notifyListeners();
  }

  // Add or update
  void saveOrUpdate(PlanModel plan) {
    final index = plans.indexWhere((p) => p.id == plan.id);

    if (index >= 0) {
      plans[index] = plan; // update
    } else {
      plans.add(plan); // add new
    }

    _refreshTable();
  }

  void deletePlan(PlanModel plan) {
    plans.remove(plan);
    _refreshTable();
  }

  void _refreshTable() {
    tableSource = PlanTableSource(
      plans: plans,
      onEdit: editPlan,
      onView: viewPlan,
      onDelete: deletePlan,
    );
    notifyListeners();
  }

  // 🔥 Open common dialogs
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

  Future<void> editPlan(PlanModel plan) async {
    final result = await CommonPlanDialog.show(
      StackedService.navigatorKey!.currentContext!,
      initial: plan,
    );

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

  Future<void> viewPlan(PlanModel plan) async {
    await CommonPlanDialog.show(
      StackedService.navigatorKey!.currentContext!,
      initial: plan,
      isView: true,
    );
  }

  Future<Map<String, dynamic>?> showSortingFilterDialog(BuildContext context) {
    bool checkStatus = false;
    String? selectedSort = "A-Z";

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Filters & Sorting"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sort By",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  RadioListTile(
                    value: "A-Z",
                    groupValue: selectedSort,
                    title: const Text("A - Z"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                  RadioListTile(
                    value: "newer",
                    groupValue: selectedSort,
                    title: const Text("Newer First"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                  RadioListTile(
                    value: "older",
                    groupValue: selectedSort,
                    title: const Text("Older First"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                  RadioListTile(
                    value: "clientAsc",
                    groupValue: selectedSort,
                    title: const Text("Client ID (Ascending → Descending)"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "checkbox": checkStatus,
                  "sort": selectedSort,
                });
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  void openFilter() async {
    final result = await showSortingFilterDialog(
        StackedService.navigatorKey!.currentContext!);

    if (result == null) return;

    bool isChecked = result["checkbox"];
    String sortType = result["sort"];

    print("Checkbox: $isChecked");
    print("Sort: $sortType");

    // Apply sorting
    applySort(isChecked, sortType);
  }

  void applySort(bool specialFilter, String sortType) {
    if (specialFilter) {
      // whatever you want...
    }

    if (sortType == "A-Z") {
      plans.sort((a, b) => a.planName.compareTo(b.planName));
    }
    // else if (sortType == "newer") {
    //   influencers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // } else if (sortType == "older") {
    //   influencers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // }
    else if (sortType == "clientAsc") {
      plans.sort((a, b) => a.id.compareTo(b.id));
    }

    notifyListeners();
  }

  void confirmDelete(PlanModel item) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${item.planName}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text("Cancel"),
            ),
            CommonButton(
                width: 100,
                margin: defaultPadding10,
                padding: defaultPadding8,
                buttonColor: Colors.red,
                text: "Delete",
                textStyle: fontFamilyMedium.size14.white,
                onTap: () {
                  deletePlan(item);
                  Navigator.pop(context); // close dialog
                }),
          ],
        );
      },
    );
  }
}
