import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/services/model/service_model.dart';
import 'package:webapp/ui/views/services/widgets/service_add_edit_dialog.dart';
import 'package:webapp/ui/views/services/widgets/service_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class ServicesViewModel extends BaseViewModel with NavigationMixin {
  ServicesViewModel({
    String? initialName,
    Uint8List? initialBytes,
    String? initialPath,
  })  : serviceName = initialName ?? '',
        imageBytes = initialBytes,
        imagePath = initialPath {
    loadServices();
  }
  // ServicesViewModel() {
  //   ServiceViewModel();
  // }
  List<ServiceModel> services = [];
  late ServiceTableSource tableSource;

  final TextEditingController nameController = TextEditingController();
  String? imagePath; // mobile
  Uint8List? imageBytes; // web
  String serviceName = '';

  void setServiceName(String value) {
    serviceName = value;
    notifyListeners();
  }

  void setImagePath(String path) {
    imagePath = path;
    imageBytes = null;
    notifyListeners();
  }

  void setImageBytes(Uint8List bytes) {
    imageBytes = bytes;
    imagePath = null;
    notifyListeners();
  }

  void loadServices() {
    services = [
      ServiceModel(
        id: 1,
        name: "Service 1",
        image: "",
        status: "active",
        createdAt: "2025-12-01",
        updatedAt: "2025-12-01",
      ),
      ServiceModel(
        id: 2,
        name: "Service 2",
        image: "",
        status: "inactive",
        createdAt: "2025-11-01",
        updatedAt: "2025-11-01",
      ),
      // Add more...
    ];

    tableSource = ServiceTableSource(
      services: services,
      onEdit: editService,
      onDelete: confirmDelete,
    );

    notifyListeners();
  }

  void _updateTableSource() {
    tableSource = ServiceTableSource(
      services: services,
      onEdit: editService,
      onDelete: confirmDelete,
    );
    notifyListeners();
  }

  // ------------------ ADD SERVICE ------------------
  void addService(ServiceModel service) {
    services.add(service);
    _updateTableSource();
  }

  void editService(ServiceModel service) async {
    final result = await CommonServiceDialog.show(
      StackedService.navigatorKey!.currentContext!,
      existingName: service.name,
      existingImagePath: service.image,
      existingBytes: null,
    );

    if (result == null) return;

    // Create updated model
    final updated = ServiceModel(
      id: service.id,
      name: result["serviceName"],
      image: result["imagePath"] ?? service.image,
      status: service.status,
      createdAt: service.createdAt,
      updatedAt: DateTime.now().toString(),
    );

    // 🚀 Call your UPDATE API here
    // await updateServiceApi(updated);

    // After API success → reload entire table
    loadServices();
  }

  void deleteService(ServiceModel service) {
    services.remove(service);
    tableSource = ServiceTableSource(
      services: services,
      onEdit: editService,
      onDelete: confirmDelete,
    );
    notifyListeners();
  }

  void confirmDelete(ServiceModel service) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${service.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text("Cancel"),
            ),
            CommonButton(
                width: 100,
                margin: defaultPadding10,
                padding: defaultPadding8,
                buttonColor: Colors.red,
                text: "Delete",
                textStyle: fontFamilyMedium.size14.white,
                onTap: () {
                  deleteService(service);
                  Navigator.pop(context); // close dialog
                }),
          ],
        );
      },
    );
  }

  void applySort(bool specialFilter, String sortType) {
    if (specialFilter) {
      // whatever you want...
    }

    if (sortType == "A-Z") {
      services.sort((a, b) => a.name.compareTo(b.name));
    }
    // else if (sortType == "newer") {
    //   influencers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // } else if (sortType == "older") {
    //   influencers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // }
    else if (sortType == "clientAsc") {
      services.sort((a, b) => a.id.compareTo(b.id));
    }

    notifyListeners();
  }
}
