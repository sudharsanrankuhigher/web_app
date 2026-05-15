import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan_model;
import 'package:webapp/ui/views/plans/widgets/common_plans_dialog.dart';
import 'package:webapp/ui/views/plans/widgets/plans_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class PlansViewModel extends BaseViewModel {
  PlansViewModel() {
    loadPlans();
  }

  List<plan_model.Datum> plans = [];
  late PlanTableSource tableSource;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  // Form data
  String? planName;
  int? connections;
  int? amount;
  String? badge;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

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
  Future<void> loadPlans() async {
    setBusy(true);
    try {
      final res = await _apiService.getAllPlans();
      plans = res.data ?? [];
      // allStates = List.from(res); // 🔥 MASTER LIST
      // filteredStates = List.from(res); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      plans = [];
    } finally {
      setBusy(false);
      _refreshTable(filtered: plans);
    }
  }

  /// SEARCH
  void searchPlans(String query) {
    final filtered = plans.where((p) {
      return p.name!.toLowerCase().contains(query.toLowerCase()) ||
          p.badge!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _refreshTable(filtered: filtered);
  }

  // Add or update
  Future<void> saveOrUpdate(plan) async {
    _setLoading(true);
    try {
      final index = plans.indexWhere((p) => p.id == plan['id']);
      if (index >= 0) {
        await _apiService.updatePlan(plan);
      } else {
        await _apiService.addPlan(plan);
      }
    } catch (e) {
      debugPrint('Save/Update failed: $e');
    } finally {
      plans = await _apiService.getAllPlans().then((value) => value.data ?? []);
      _setLoading(false);
      notifyListeners();
      _refreshTable(filtered: plans);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void deletePlan(plan_model.Datum plan) {
    // plans.remove(plan);
    _setLoading(true);
    try {
      _apiService.deletePlan(plan.id!);
      plans.removeWhere((p) => p.id == plan.id);
      loadPlans();
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      _setLoading(false);
      _refreshTable();
    }
  }

  // 🔹 Refresh table
  void _refreshTable({List<plan_model.Datum>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = PlanTableSource(
      plans: filtered ?? plans,
      onEdit: (plan) => PermissionHelper.instance.canEdit('plans')
          ? editPlan(context, plan)
          : _dialogService.showDialog(
              title: "Warning",
              description:
                  "Locked 🔒 – You need special permission to access this.",
              buttonTitle: 'ok'),
      onView: (plan) => viewPlan(context, plan),
      onDelete: (plan) => PermissionHelper.instance.canDelete('plans')
          ? confirmDelete(context, plan)
          : _dialogService.showDialog(
              title: "Warning",
              description:
                  "Locked 🔒 – You need special permission to access this.",
              buttonTitle: 'ok'),
    );
    notifyListeners();
  }

  // 🔥 Add Plan
  // Future<void> addPlan(BuildContext context) async {
  //   final result = await CommonPlanDialog.show(context, isAdd: true);
  //   if (result != null) {
  //     final newPlan = plan_model.Datum(
  //       // id: DateTime.now().millisecondsSinceEpoch,
  //       name: result['planName'],
  //       connections: result['connections'],
  //       amount: result['amount'],
  //       badge: result['badge'],
  //       category: result['category'] == 1
  //           ? "Influencers"
  //           : result['category'] == 2
  //               ? "Movie Stars"
  //               : "TV Stars",
  //     );
  //     saveOrUpdate(newPlan);
  //   }
  //   notifyListeners();
  // }

  Future<void> editPlan(BuildContext context, plan_model.Datum plan) async {
    final result = await CommonPlanDialog.show(context, initial: plan);
    if (result != null) {
      final updated = {
        "id": plan.id,
        "name": result['planName'],
        "connections": result['connections'] is int
            ? result['connections']
            : int.tryParse(result['connections']?.toString() ?? '0') ?? 0,
        "regular_price":
            double.tryParse(result['regular_price']?.toString() ?? '0')
                    ?.toString() ??
                "0",
        "sale_price": double.tryParse(result['sale_price']?.toString() ?? '0')
                ?.toString() ??
            "0",
        "gst": (result['gst'] is int
                ? result['gst']
                : int.tryParse(result['gst']?.toString() ?? '0') ?? 0)
            .toString(),
        "badge": result['badge'],
        "selected_plan": result['selectedPlan'],
        "category_id": result['category_id'],
      };
      saveOrUpdate(updated);
    }
  }

  Future<void> viewPlan(BuildContext context, plan_model.Datum plan) async {
    await CommonPlanDialog.show(context, initial: plan, isView: true);
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      plans.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortType == "clientAsc") {
      plans.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      plans.sort((a, b) {
        DateTime aDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      plans.sort((a, b) {
        DateTime aDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        return aDate.compareTo(bDate);
      });
    } else {
      // No sorting
    }

    _refreshTable();
  }

  // 🔹 Confirm Delete
  void confirmDelete(BuildContext context, plan_model.Datum plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${plan.name}?"),
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
