import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/city/model/city_model.dart';
import 'package:webapp/ui/views/city/widget/add_edit_city_page.dart';
import 'package:webapp/ui/views/city/widget/city_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class CityViewModel extends BaseViewModel with NavigationMixin {
  CityViewModel() {
    loadPlans();
  }
  String? _cityValue;
  String? _stateValue = "Tamil Nadu";

  String? get cityValue => _cityValue;
  String? get stateValue => _stateValue;

  List<CityShowModel> cities = [];
  late CityTableSource tableSource;

  String? cityName;

  void setState(state) {
    _stateValue = state;
    notifyListeners();
  }

  void setCity(city) {
    _cityValue = city;
    notifyListeners();
  }

  void loadPlans() {
    cities = [
      CityShowModel(
          id: 1,
          stateName: 'Tamil Nadu',
          cityName: "Coimbatore",
          status: 'active'),
      CityShowModel(
          id: 2,
          stateName: 'Tamil Nadu',
          cityName: "Salem",
          status: 'inactive'),
      CityShowModel(
          id: 3,
          stateName: 'Tamil Nadu',
          cityName: "Chennai",
          status: 'active'),
    ];
    _refreshTable();
  }

  void saveOrUpdate(CityShowModel state) {
    final index = cities.indexWhere((p) => p.id == state.id);
    if (index >= 0) {
      cities[index] = state;
    } else {
      cities.add(state);
    }
    _refreshTable();
  }

  void deletePlan(CityShowModel plan) {
    cities.remove(plan);
    _refreshTable();
  }

  // 🔹 Refresh table
  void _refreshTable({List<CityShowModel>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = CityTableSource(
      cities: filtered ?? cities,
      onEdit: (plan) => editPlan(context, plan),
      onDelete: (plan) => confirmDelete(context, plan),
    );
    notifyListeners();
  }

  // 🔥 Add Plan
  Future<void> addPlan() async {
    final result = await AddEditCityPage.show(
        StackedService.navigatorKey!.currentContext!);
    if (result != null) {
      final newPlan = CityShowModel(
          stateName: result['stateName'],
          cityName: result['cityName'],
          status: result['status']);
      saveOrUpdate(newPlan);
    }
  }

  // 🔥 Edit Plan
  Future<void> editPlan(BuildContext context, CityShowModel city) async {
    final result = await AddEditCityPage.show(context, initial: city);
    if (result != null) {
      final updated = CityShowModel(
        id: city.id,
        cityName: result['cityName'],
        stateName: result['stateName'],
        status: result['status'],
      );
      saveOrUpdate(updated);
    }
  }

  void confirmDelete(BuildContext context, CityShowModel state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${state.cityName}?"),
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
