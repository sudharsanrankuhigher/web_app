import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:webapp/ui/views/contact_support/model/client_model.dart';
import 'package:webapp/ui/views/contact_support/widget/contact_client_table_source.dart';

class ContactSupportViewModel extends BaseViewModel {
  List<ClientModel> clients = [];
  late ClientTableSource tableSource;

  bool hasSelection = false;
  final Set<int> selectedIds = {};

  ContactSupportViewModel() {
    // Initialize the table source first
    tableSource = ClientTableSource(data: clients, vm: this);

    // Load initial data
    loadClients();
  }

  /// Load client data
  void loadClients() {
    clients.clear();
    clients.addAll([
      ClientModel(
        id: 1,
        name: 'Arun',
        city: 'Coimbatore',
        state: 'Tamil Nadu',
        phone: '9876543210',
        contactNo: '0422-123456',
        note: 'Regular client',
      ),
      ClientModel(
        id: 2,
        name: 'Bala',
        city: 'Salem',
        state: 'Tamil Nadu',
        phone: '9876501234',
        contactNo: '0427-987654',
        note: 'New enquiry',
      ),
      ClientModel(
        id: 3,
        name: 'Karthik',
        city: 'Chennai',
        state: 'Tamil Nadu',
        phone: '9123456789',
        contactNo: '044-456789',
        note: 'VIP client',
      ),
    ]);

    clearSelection();
    _refreshTable();
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
      ..addAll(value ? clients.map((e) => e.id) : []);

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
}
