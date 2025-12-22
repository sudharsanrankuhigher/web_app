import 'package:flutter/material.dart';
import 'package:webapp/ui/views/contact_support/contact_support_viewmodel.dart';
import 'package:webapp/ui/views/contact_support/model/client_model.dart';

class ClientTableSource extends DataTableSource {
  final List<ClientModel> data;
  final ContactSupportViewModel vm;

  ClientTableSource({
    required this.data,
    required this.vm,
  });

  void _notifySelection() {
    // Update selection state in ViewModel
    vm.selectedIds
      ..clear()
      ..addAll(data.where((e) => e.isSelected).map((e) => e.id));

    vm.hasSelection = vm.selectedIds.isNotEmpty;
    vm.notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final item = data[index];

    return DataRow.byIndex(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (index.isEven) return Colors.white;
          return Colors.grey.shade100;
        },
      ),
      index: index,
      selected: item.isSelected,
      onSelectChanged: (value) {
        item.isSelected = value ?? false;

        // Update ViewModel selection
        _notifySelection();

        // Rebuild table
        notifyListeners();

        print('Selected IDs: ${vm.selectedIds}');
      },
      cells: [
        DataCell(Text('${index + 1}')), // S.No
        DataCell(Text(item.name)), // Client Name
        DataCell(Text('${item.city}, ${item.state}')), // City / State
        DataCell(Text(item.phone)), // Phone
        DataCell(Text(item.note)), // Note
        DataCell(Text(item.contactNo)), // Contact No
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => print('Approved ${item.id}'),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => print('Rejected ${item.id}'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => data.where((e) => e.isSelected).length;
}
