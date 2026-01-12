import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/city/model/city_model.dart' as city_model;
import 'package:webapp/ui/views/city/widget/add_edit_city_page.dart';
import 'package:webapp/ui/views/city/widget/city_table_source.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as state_model;
import 'package:webapp/widgets/common_button.dart';

class CityViewModel extends BaseViewModel with NavigationMixin {
  CityViewModel() {
    init();
  }

  init() async {
    runBusyFuture(getStateName());
    runBusyFuture(loadCity());
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();
  String? _cityValue;
  String? _stateValue = "Tamil Nadu";

  String? get cityValue => _cityValue;
  String? get stateValue => _stateValue;

  List<city_model.Datum> cities = [];
  List<state_model.Datum> states = [];
  late CityTableSource tableSource;

  List<city_model.Datum> allCities = [];
  List<city_model.Datum> filteredCities = [];

  String? cityName;
  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  void setState(state) {
    _stateValue = state;
    notifyListeners();
  }

  void setCity(city) {
    _cityValue = city;
    notifyListeners();
  }

  Future<void> getStateName() async {
    setBusy(true);
    try {
      final res = await _apiService.getStates();
      states = res ?? [];
    } catch (e) {
      states = [];
    } finally {
      setBusy(false);
    }
  }

  Future<void> loadCity() async {
    setBusy(true);
    try {
      final response = await _apiService.getCities();
      cities = response;
      allCities = List.from(response); // 🔥 MASTER LIST
      filteredCities = List.from(response); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      cities = [];
    } finally {
      setBusy(false);
      _refreshTable(filtered: cities);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> saveOrUpdate(city) async {
    _setLoading(true);
    try {
      final index = cities.indexWhere((p) => p.id == city['city_id']);
      if (index >= 0) {
        // cities[index] = city;
        await _apiService.updateCity(city);
      } else {
        await _apiService.addCity(city);

        // cities.add(city);
      }
      cities = await _apiService.getCities();
    } catch (e) {
      print(e);
    } finally {
      _setLoading(false);
      _refreshTable(filtered: cities);
    }
  }

  Future<void> deleteCity(city_model.Datum city) async {
    _setLoading(true);
    try {
      await _apiService.deleteCity(city.id!);

      cities = await _apiService.getCities();
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      _setLoading(false);
      _refreshTable();
    }
    // cities.remove(plan);
    // _refreshTable();
  }

  // 🔹 Refresh table
  void _refreshTable({List<city_model.Datum>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = CityTableSource(
      cities: filtered ?? cities,
      onEdit: (plan) => editCity(context, plan),
      onDelete: (plan) => confirmDelete(context, plan),
    );
    notifyListeners();
  }

  // 🔥 Add Plan
  Future<void> addCity() async {
    final result = await AddEditCityPage.show(
        states: states,
        cities: cities,
        StackedService.navigatorKey!.currentContext!);
    if (result != null) {
      final newPlan = {
        "name": result['name'],
        "state_id": result['stateId'],
      };
      saveOrUpdate(newPlan);
    }
  }

  // 🔥 Edit Plan
  Future<void> editCity(BuildContext context, city_model.Datum city) async {
    final result = await AddEditCityPage.show(context,
        initial: city,
        states: states,
        cities: cities,
        initialCityId: city.id,
        initialStateId: city.stateId);
    if (result != null) {
      final updated = {
        "name": result['name'],
        "state_id": result['stateId'],
      };
      updated['city_id'] = city.id;
      saveOrUpdate(updated);
    }
  }

  void confirmDelete(BuildContext context, city_model.Datum city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${city.name}?"),
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
              deleteCity(city);
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
    if (sortType == "A-Z") {
      cities.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortType == "clientAsc") {
      cities.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      cities.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      cities.sort((a, b) {
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

    _refreshTable();
  }
}
