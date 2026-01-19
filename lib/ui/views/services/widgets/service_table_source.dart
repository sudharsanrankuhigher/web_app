import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;
import 'package:webapp/widgets/profile_image.dart';

class ServiceTableSource extends DataTableSource {
  final List<service_model.Datum> services;
  final Function(service_model.Datum) onEdit;
  final Function(service_model.Datum) onDelete;

  ServiceTableSource({
    required this.services,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (services.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Center(child: Text("No data found"))),
          DataCell(Text("")),
        ],
      );
    }

    final service = services[index];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      cells: [
        DataCell(Text("${index + 1}")), // S.No
        DataCell(Text(service.name!)), // Name
        DataCell(

            // Text(row.imageUrl)
            IgnorePointer(
          ignoring: true,
          child: Padding(
            padding: defaultPadding4,
            child: ProfileImageEdit(
              imageUrl: service.image,
              radius: 30,
              onImageSelected: (_, a) {},
            ),
          ),
        )), // Name
        DataCell(
          Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                  color: grey,
                ),
                onPressed: () => onEdit(service),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 16, color: red),
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
