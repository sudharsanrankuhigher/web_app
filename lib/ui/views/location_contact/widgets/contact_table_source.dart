import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/location_contact/models/location_contact_model.dart'
    as contact;
import 'package:webapp/ui/views/state/model/state_model.dart' as StateModel;

class ContactTableSource extends DataTableSource {
  final List<contact.Datum> contacts;
  final Function(contact.Datum) onEdit;
  final Function(contact.Datum) onView;
  final Function(contact.Datum) onDelete;

  ContactTableSource({
    required this.contacts,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    // if (index >= plans.length) return null;
    if (contacts.isEmpty) {
      return DataRow(
        cells: List.generate(
          5, // total columns
          (i) {
            if (i == 3) {
              // column index where message should show
              return const DataCell(
                Center(
                  child: Text(
                    "No data found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
            return const DataCell(Text("")); // other cells empty
          },
        ),
      );
    }

    final plan = contacts[index];
    final sNo = index + 1;

    return DataRow(
        color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (index.isEven) return Colors.white;
            return Colors.grey.shade100;
          },
        ),
        cells: [
          DataCell(Text("$sNo")),
          DataCell(Text(plan.state!)),
          DataCell(Text("${plan.city}")),
          DataCell(Text("${plan.mobileNumber}")),
          DataCell(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.blue,
                  ),
                  onPressed: () => onView(plan)),
              IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: grey,
                  ),
                  onPressed: () => onEdit(plan)),
              IconButton(
                  icon: const Icon(Icons.delete, size: 16, color: red),
                  onPressed: () => onDelete(plan)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => contacts.isEmpty ? 1 : contacts.length;

  @override
  int get selectedRowCount => 0;
}
