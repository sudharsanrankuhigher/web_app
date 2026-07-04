import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/contact_support/contact_support_viewmodel.dart';
import 'package:webapp/ui/views/contact_support/model/client_model.dart'
    as client_model;
import 'package:webapp/services/theme_service.dart';
import 'package:webapp/ui/views/contact_support/widget/show_note_dialog.dart';
import 'package:webapp/services/profile_service.dart';
import 'package:webapp/core/helper/date_helper.dart';

class ClientTableSource extends DataTableSource {
  List<client_model.Datum> data;
  final ContactSupportViewModel vm;

  void updateData(List<client_model.Datum> newData) {
    data = newData;
    notifyListeners();
  }

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
          11, // total columns
          (i) {
            if (i == 5) {
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
          final isDark = ThemeService.instance.isDarkMode;
          if (isDark) {
            return index.isEven
                ? const Color(0xFF1E293B)
                : const Color(0xFF0F172A);
          }
          return index.isEven ? Colors.white : Colors.grey.shade100;
        },
      ),
      index: index,
      selected: item.isSelected,
      onSelectChanged: ProfileService.instance.roleId == '1'
          ? (value) {
              item.isSelected = value ?? false;

              // Update ViewModel selection
              _notifySelection();

              // Rebuild table
              notifyListeners();

              print('Selected IDs: ${vm.selectedIds}');
            }
          : null,
      cells: [
        DataCell(Text('${index + 1}')), // S.No
        DataCell(Text(item.id?.toString() ?? '')), // ID
        DataCell(Text(item.name!)), // Client Name
        DataCell(Text('${item.city}/${item.state}')), // City / State
        DataCell(Text(item.mobile!)), // Phone
        DataCell(Tooltip(
            message: item.description ?? 'No Description',
            child: Text(item.description!))), // Phone
        DataCell(Tooltip(
            message: item.note ?? 'No Note',
            child: Text(item.note ?? ''))), // Note
        DataCell(Text(
            DateFormatter.formatToDDMMMYYYY(item.createdAt))), // Create Ticket
        DataCell(Text(
            DateFormatter.formatToDDMMMYYYY(item.updatedAt))), // Update Ticket
        DataCell((status == 'completed')
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: greenShade1,
                ),
                padding: defaultPadding8 - topPadding4 - bottomPadding4,
                child: Text(
                  'Completed',
                  style: fontFamilySemiBold.size12.white,
                ),
              )
            : (status == 'rejected')
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: onGoing,
                    ),
                    padding: defaultPadding8 - topPadding4 - bottomPadding4,
                    child: Text(
                      'Processing',
                      style: fontFamilySemiBold.size12.white,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: pendingColor,
                    ),
                    padding: defaultPadding8 - topPadding4 - bottomPadding4,
                    child: Text(
                      'Pending',
                      style: fontFamilySemiBold.size12.white,
                    ),
                  )), // Status
        DataCell((status != 'completed')
            ? IgnorePointer(
                ignoring:
                    PermissionHelper.instance.has('add_call') ? false : true,
                child: Row(
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
                        icon: const Icon(Icons.hourglass_empty_rounded,
                            color: onGoing),
                        onPressed: () {
                          print('Processing ${item.id}');
                          showNoteDialog(
                            context:
                                StackedService.navigatorKey!.currentContext!,
                            noteString: 'Processing',
                            title: "Add Processing Note",
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
                ),
              )
            : Container()),
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
