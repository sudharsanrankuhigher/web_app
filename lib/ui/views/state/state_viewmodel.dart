import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as state_model;
import 'package:webapp/ui/views/state/widget/State_table_source.dart';
import 'package:webapp/ui/views/state/widget/common_state_add_edit_dialog.dart';
import 'package:webapp/widgets/common_button.dart';

class StateViewModel extends BaseViewModel with NavigationMixin {
  StateViewModel() {
    loadStates();
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  String? _stateValue = "Tamil Nadu";

  String? get stateValue => _stateValue;

  List<state_model.Datum> states = [];
  late StateTableSource tableSource;
  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  String? stateName;

  void setCity(state) {
    _stateValue = state;
    notifyListeners();
  }

  Future<void> loadStates() async {
    setBusy(true);
    try {
      final res = await _apiService.getStates();
      states = res ?? [];
      allStates = List.from(res); // 🔥 MASTER LIST
      filteredStates = List.from(res); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      states = [];
    } finally {
      setBusy(false);
      _refreshTable(filtered: states);
    }
  }

  Future<void> saveOrUpdate(state_model.Datum state) async {
    _setLoading(true);
    try {
      final index = states.indexWhere((p) => p.id == state.id);

      if (index >= 0) {
        /// UPDATE
        await _apiService.updateState(state);
      } else {
        /// ADD
        await _apiService.addState(state);
      }

      /// 🔥 Always reload full list
      states = await _apiService.getStates();
    } catch (e) {
      debugPrint('Save/Update failed: $e');
    } finally {
      _setLoading(false);
      _refreshTable();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> deleteState(state_model.Datum state) async {
    _setLoading(true);
    try {
      await _apiService.deleteState(state.id!);

      states = await _apiService.getStates();
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      _setLoading(false);
      _refreshTable();
    }
  }

  // 🔹 Refresh table
  void _refreshTable({List<state_model.Datum>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = StateTableSource(
      states: filtered ?? states,
      onEdit: (state) => editState(state),
      onDelete: (state) => confirmDelete(context, state),
    );
    notifyListeners();
  }

  // 🔥 Add State
  Future<void> addState() async {
    final result = await AddEditStatePage.show(
        StackedService.navigatorKey!.currentContext!);
    if (result != null) {
      final newState = state_model.Datum(name: result['name']);
      saveOrUpdate(newState);
    }
  }

  // 🔥 Edit State
  Future<void> editState(state_model.Datum state) async {
    final result = await AddEditStatePage.show(
        StackedService.navigatorKey!.currentContext!,
        initial: state);
    if (result != null) {
      final updated = state_model.Datum(
        id: state.id,
        name: result['name'],
      );
      saveOrUpdate(updated);
    }
  }

  void confirmDelete(BuildContext context, state_model.Datum state) {
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
              deleteState(state);
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
      states.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortType == "clientAsc") {
      states.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      states.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      states.sort((a, b) {
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

  List<state_model.Datum> allStates = [];
  List<state_model.Datum> filteredStates = [];

  void applySearch(String query) {
    final search = query.trim().toLowerCase();

    filteredStates = allStates.where((item) {
      final name = item.name?.toLowerCase() ?? '';
      return search.isEmpty || name.contains(search);
    }).toList();

    _refreshTable(filtered: filteredStates);
    notifyListeners();
  }
}
