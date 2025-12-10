import 'package:flutter/material.dart';
import 'package:webapp/ui/views/services/model/service_model.dart';

class ServiceTableSource extends DataTableSource {
  final List<ServiceModel> services;
  final Function(ServiceModel) onEdit;
  final Function(ServiceModel) onDelete;

  ServiceTableSource({
    required this.services,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (services.isEmpty) {
      return DataRow(
        cells: [
          const DataCell(Text("")),
          const DataCell(Center(child: Text("No data found"))),
          const DataCell(Text("")),
        ],
      );
    }

    final service = services[index];

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      cells: [
        DataCell(Text("${index + 1}")), // S.No
        DataCell(Text(service.name)), // Name
        DataCell(
          Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(service),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(service),
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
  int get rowCount => services.isEmpty ? 1 : services.length;
  @override
  int get selectedRowCount => 0;
}
