import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/services/profile_service.dart';
import 'package:webapp/ui/views/contact_support/model/client_model.dart'
    as client_model;
import 'package:webapp/ui/views/contact_support/widget/contact_client_table_source.dart';
import 'package:webapp/ui/views/contact_support/widget/show_note_dialog.dart';

class ContactSupportViewModel extends BaseViewModel {
  List<client_model.Datum> allClients = [];
  List<client_model.Datum> clients = [];
  late ClientTableSource tableSource;

  bool hasSelection = false;
  final Set<int> selectedIds = {};

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

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
      allClients = response.data ?? [];
      _applySearchAndFilter();
    } catch (e) {
      allClients = [];
      clients = [];
      tableSource.updateData([]);
    } finally {
      setBusy(false);
      _refreshTable();
      setLoading(false);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applySearchAndFilter();
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    _applySearchAndFilter();
  }

  void _applySearchAndFilter() {
    List<client_model.Datum> filtered = List.from(allClients);

    // 1. Apply Status Filter
    if (_selectedStatus != 'All') {
      filtered = filtered.where((client) {
        final status = client.status?.toLowerCase() ?? '';
        if (_selectedStatus.toLowerCase() == 'completed') {
          return status == 'completed';
        } else if (_selectedStatus.toLowerCase() == 'pending') {
          return status == 'pending';
        } else if (_selectedStatus.toLowerCase() == 'processing') {
          return status == 'rejected';
        }
        return true;
      }).toList();
    }

    // 2. Apply Search Query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((client) {
        final name = client.name?.toLowerCase() ?? '';
        final mobile = client.mobile?.toLowerCase() ?? '';
        final id = client.id?.toString() ?? '';

        String statusText = client.status?.toLowerCase() ?? '';
        if (statusText == 'rejected') {
          statusText = 'processing';
        }

        return name.contains(query) ||
            mobile.contains(query) ||
            id.contains(query) ||
            statusText.contains(query);
      }).toList();
    }

    clients = filtered;
    tableSource.updateData(clients);
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
    if (ProfileService.instance.roleId != '1') return;
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
    if (ProfileService.instance.roleId != '1') return;
    showBulkDeleteDialog(
      context: context,
      itemName: "clients",
      onConfirm: () => deleteSelected(),
    );
  }

  void applySort(bool isChecked, String sortType) {
    if (sortType == "A-Z") {
      allClients.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));
    } else if (sortType == "older") {
      allClients.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    } else if (sortType == "newer") {
      allClients.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    }
    _applySearchAndFilter();
    notifyListeners();
  }
}
