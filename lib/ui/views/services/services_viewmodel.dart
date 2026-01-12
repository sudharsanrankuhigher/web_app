import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;
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

  List<service_model.Datum> services = [];
  late ServiceTableSource tableSource;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  final TextEditingController nameController = TextEditingController();
  String? imagePath; // mobile
  Uint8List? imageBytes; // web
  String serviceName = '';

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

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

  // 🔹 Refresh table
  void _refreshTable({List<service_model.Datum>? filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;
    tableSource = ServiceTableSource(
      services: filtered ?? services,
      onEdit: (service) => editService(service),
      onDelete: (service) => confirmDelete(service),
    );
    notifyListeners();
  }

  Future<void> loadServices() async {
    setBusy(true);
    try {
      final res = await _apiService.getAllService();
      services = res.data ?? [];
      allService = List.from(services); // 🔥 MASTER LIST
      filteredService = List.from(services); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      services = [];
    } finally {
      setBusy(false);
      _refreshTable(filtered: services);
    }
  }

  Future<void> saveOrUpdate(service) async {
    _setLoading(true);
    try {
      final index = services.indexWhere((p) => p.id == service['id']);

      if (index >= 0) {
        /// UPDATE
        await _apiService.updateService(service);
      } else {
        /// ADD
        await _apiService.addService(service);
      }

      /// 🔥 Always reload full list
      final res = await _apiService.getAllService();
      services = res.data ?? [];
    } catch (e) {
      debugPrint('Save/Update failed: $e');
    } finally {
      _setLoading(false);
      _refreshTable();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ------------------ ADD SERVICE ------------------
  void addService(service) {
    saveOrUpdate(service);
    _refreshTable();
  }

  void editService(service_model.Datum service) async {
    final result = await CommonServiceDialog.show(
      StackedService.navigatorKey!.currentContext!,
      existingName: service.name,
      existingImagePath: service.image,
      existingBytes: null,
    );

    if (result == null) return;

    // Create updated model
    final updated = {
      "id": service.id, // 🔥 REQUIRED
      "serviceName": result["serviceName"],
      "imagePath": result["imagePath"], // mobile
      "imageBytes": result["imageBytes"], // web
      if (result["imageBytes"] == null)
        "existing_image": service.image, // keep existing
    };
    print("Updated Service Data: $updated");
    saveOrUpdate(updated);

    loadServices();
  }

  Future<void> deleteService(service_model.Datum service) async {
    _setLoading(true);

    try {
      // wait for backend delete
      await _apiService.deleteService(service.id!);

      // remove locally if needed
      services.removeWhere((s) => s.id == service.id);

      // refresh table
      tableSource = ServiceTableSource(
        services: services,
        onEdit: editService,
        onDelete: confirmDelete,
      );

      _refreshTable();
      notifyListeners();
    } catch (e) {
      // optional: show error
      print("Delete error: $e");
    } finally {
      _setLoading(false);
      Navigator.pop(StackedService.navigatorKey!.currentContext!);
    }
  }

  void confirmDelete(service_model.Datum service) {
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
                  // close dialog
                  deleteService(service);
                }),
          ],
        );
      },
    );
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      services.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortType == "clientAsc") {
      services.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      services.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      services.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return aDate.compareTo(bDate);
      });
    } else {
      // No sorting
    }

    _refreshTable();
  }

  List<service_model.Datum> allService = [];
  List<service_model.Datum> filteredService = [];

  void applySearch(String query) {
    final search = query.trim().toLowerCase();

    filteredService = allService.where((item) {
      final name = item.name?.toLowerCase() ?? '';
      return search.isEmpty || name.contains(search);
    }).toList();

    _refreshTable(filtered: filteredService);
    notifyListeners();
  }
}
