import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/contact_support/contact_support_viewmodel.dart';
import 'package:webapp/ui/views/contact_support/model/client_model.dart'
    as client_model;
import 'package:webapp/ui/views/contact_support/widget/show_note_dialog.dart';

class ClientTableSource extends DataTableSource {
  final List<client_model.Datum> data;
  final ContactSupportViewModel vm;

  ClientTableSource({
    required this.data,
    required this.vm,
  });

  void _notifySelection() {
    vm.selectedIds
      ..clear()
      ..addAll(data.where((e) => e.isSelected).map((e) => e.id!));

    vm.hasSelection = vm.selectedIds.isNotEmpty;
    vm.notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    if (data.isEmpty) {
      return DataRow(
        cells: List.generate(
          8, // total columns
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
    final item = data[index];

    final status = item.status;

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
        DataCell(Text(item.name!)), // Client Name
        DataCell(Text('${item.city}/${item.state}')), // City / State
        DataCell(Text(item.mobile!)), // Phone
        DataCell(Text(item.description!)), // Phone
        DataCell(Text(item.note!)), // Note
        DataCell(Text(item.alternativeNo!)), // Contact No
        DataCell(
          (status == 'pending')
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        print('Approved ${item.id}');
                        showNoteDialog(
                          context: StackedService.navigatorKey!.currentContext!,
                          title: "Add completed Note",
                          noteString: 'Approved',
                          onSubmit: (notes) {
                            print("Submitted note: $notes");
                            vm.updateContactSupport(
                              id: item.id!,
                              note: notes,
                              status: "completed",
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          print('Rejected ${item.id}');
                          showNoteDialog(
                            context:
                                StackedService.navigatorKey!.currentContext!,
                            noteString: 'Rejected',
                            title: "Add Rejected Note",
                            onSubmit: (note) {
                              print("Submitted note: $note");
                              vm.updateContactSupport(
                                note: note,
                                id: item.id!,
                                status: "rejected",
                              );
                            },
                          );
                        }),
                  ],
                )
              : (status == 'completed')
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: greenShade1,
                      ),
                      padding: defaultPadding8 - topPadding4 - bottomPadding4,
                      child: Text(
                        item.status!,
                        style: fontFamilySemiBold.size12.white,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: red,
                      ),
                      padding: defaultPadding8 - topPadding4 - bottomPadding4,
                      child: Text(
                        item.status!,
                        style: fontFamilySemiBold.size12.white,
                      ),
                    ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.isEmpty ? 1 : data.length;

  @override
  int get selectedRowCount => 0;
  // int get selectedRowCount => data.where((e) => e.isSelected).length;
}
