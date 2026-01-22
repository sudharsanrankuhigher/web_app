import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/contact_support/model/client_model.dart'
    as client_model;
import 'package:webapp/ui/views/contact_support/widget/contact_client_table_source.dart';
import 'package:webapp/ui/views/contact_support/widget/show_note_dialog.dart';

class ContactSupportViewModel extends BaseViewModel {
  List<client_model.Datum> clients = [];
  late ClientTableSource tableSource;

  bool hasSelection = false;
  final Set<int> selectedIds = {};

  ContactSupportViewModel() {
    // Initialize the table source first
    tableSource = ClientTableSource(data: clients, vm: this);

    // Load initial data
    loadClients();
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  bool? _isRequestLoading = false;
  bool? get isRequestLoading => _isRequestLoading;

  setLoading(value) {
    _isRequestLoading = value;
    notifyListeners();
  }

  /// Load client data
  Future<void> loadClients() async {
    setBusy(true);
    setLoading(true);
    try {
      final response = await _apiService.getAllContactSupport();
      clients = response.data ?? [];
      tableSource = ClientTableSource(data: clients, vm: this);

      // allCities = List.from(response); // 🔥 MASTER LIST
      // filteredCities = List.from(response); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      clients = [];
    } finally {
      setBusy(false);
      _refreshTable();
      setLoading(false);
    }
  }

  Future<void> updateContactSupport({note, id, status}) async {
    setLoading(true);
    try {
      final res = await _apiService.updateContactSupport({
        "note": note,
        "ticket_id": id,
        "status": status,
      });

      if (res.status == 200) {
        final data = await _dialogService.showDialog(
          title: 'Success',
          description: res.message ?? 'Contact support updated successfully',
        );
        if (data!.confirmed == true) {
          loadClients();
        }
      } else {
        _dialogService.showDialog(
          title: 'Error',
          description: res.message ?? 'Failed to update contact support',
        );
      }
    } catch (e) {
      _dialogService.showDialog(
          title: 'Error', description: 'Something went wrong ');
    }
    setLoading(false);
  }

  /// Refresh table
  void _refreshTable() {
    tableSource.notifyListeners();
    notifyListeners();
  }

  /// Toggle Select All / Deselect All
  void toggleSelectAll(bool value) {
    for (final c in clients) {
      c.isSelected = value;
    }

    selectedIds
      ..clear()
      ..addAll(value ? clients.map((e) => e.id!) : []);

    hasSelection = value;

    // Notify table rebuild
    _refreshTable();

    print('After Select All: $selectedIds');
  }

  /// Bulk approve selected rows
  void approveSelected() {
    if (!hasSelection) return;

    final ids = selectedIds.toList();
    print('Approved IDs: $ids');

    clearSelection();
  }

  /// Clear selection
  void clearSelection() {
    for (final c in clients) {
      c.isSelected = false;
    }
    selectedIds.clear();
    hasSelection = false;

    notifyListeners();
  }

  /// Handle single row selection change (if needed externally)
  void onRowSelectionChanged(int id, bool isSelected) {
    if (isSelected) {
      selectedIds.add(id);
    } else {
      selectedIds.remove(id);
    }

    hasSelection = selectedIds.isNotEmpty;
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    setLoading(true);
    try {
      final res = await _apiService.deleteContactSupport(selectedIds.toList());
      if (res.status == 200) {
        final data = await _dialogService.showDialog(
          title: 'Success',
          description: res.message ?? 'Client deleted successfully',
        );
        if (data!.confirmed == true) {
          loadClients();
        }
      } else {
        _dialogService.showDialog(
          title: 'Error',
          description: res.message ?? 'Failed to delete client',
        );
      }
    } catch (e) {
      _dialogService.showDialog(
          title: 'Error', description: 'Something went wrong ');
    } finally {
      // loadClients();
      setLoading(false);
    }
  }

  void delete(BuildContext context) {
    showBulkDeleteDialog(
      context: context,
      itemName: "clients",
      onConfirm: () => deleteSelected(),
    );
  }
}
