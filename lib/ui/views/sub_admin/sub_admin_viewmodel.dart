import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart'
    as sub_admin_model;
import 'package:webapp/ui/views/sub_admin/widgets/sub_admin_add_edit_dialog.dart';
import 'package:webapp/ui/views/sub_admin/widgets/sub_admin_table_source.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as roles_model;

class SubAdminViewModel extends BaseViewModel with NavigationMixin {
  SubAdminTableSource? tableSource; // ✅ nullable
  SubAdminViewModel() {
    init();
  }

  Future<void> init() async {
    setBusy(true);

    await getRoles();
    await loadData();

    setBusy(false);
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<sub_admin_model.Datum> subAdmins = [];

  List<roles_model.Datum> roles = [];
  List<Map<String, dynamic>> roleDropdownItems = [];

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getRoles() async {
    try {
      final role = await runBusyFuture(_apiService.getAllRole());
      roles = role.data ?? [];
      roleDropdownItems = roles.map((e) {
        return {
          "id": e.id,
          "name": e.name,
        };
      }).toList();
    } catch (e) {
      roles = [];
    } finally {
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadData() async {
    setBusy(true);
    try {
      final res = await _apiService.getAllSubAdmin();
      subAdmins = res;
      // allService = List.from(services); // 🔥 MASTER LIST
      // filteredService = List.from(services); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      subAdmins = [];
    } finally {
      setBusy(false);
      _refreshTable(filtered: subAdmins);
    }
  }

  // ---------- ADD ----------
  Future<void> onAdd(BuildContext context) async {
    final result =
        await CommonSubAdminDialog.show(context, rolesModel: roleDropdownItems);
    if (result == null) return;

    final formData = FormData();

    // Helper
    void addField(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    // ---------- REQUIRED ----------
    addField('name', result["name"]);
    addField('phone', result["phone"]);
    addField('email', result["email"]);
    addField('password', result["password"]);
    addField('gender', result["gender"]);

    if (result["dob"] != null) {
      // ensure yyyy-MM-dd format
      final dobStr = result["dob"] is DateTime
          ? (result["dob"] as DateTime).toIso8601String().split('T').first
          : result["dob"].toString();
      addField('date_of_birth', dobStr);
    }

    addField('state', result["state"]);
    addField('city', result["city"]);
    addField('role_id', result["roles"]);

    // ---------- PROFILE IMAGE ----------
    if (result['image'] != null) {
      formData.files.add(
        MapEntry(
          'profile_image',
          MultipartFile.fromBytes(
            result['image'],
            filename: 'profile_image.png',
          ),
        ),
      );
    } else if (result['existing_image'] != null) {
      addField('existing_image', result['existing_image']);
    }

    // ---------- DOCUMENT IMAGE ----------
    if (result['idImage'] != null) {
      formData.files.add(
        MapEntry(
          'document_image',
          MultipartFile.fromBytes(
            result['idImage'],
            filename: 'document_image.pdf',
          ),
        ),
      );
    } else if (result['existing_doc'] != null) {
      addField('existing_doc', result['existing_doc']);
    }

    await saveOrUpdate(formData);
  }

  // ---------- EDIT ----------
  Future<void> onEdit(sub_admin_model.Datum model) async {
    final result = await CommonSubAdminDialog.show(
        StackedService.navigatorKey!.currentContext!,
        model: model,
        rolesModel: roleDropdownItems);
    if (result == null) return;

    final formData = FormData();

    void addField(String key, dynamic value) {
      if (value != null) formData.fields.add(MapEntry(key, value.toString()));
    }

    addField('id', model.id);
    addField('name', result["name"]);
    addField('phone', result["phone"]);
    addField('email', result["email"]);
    addField('password', result["password"]);
    addField('gender', result["gender"]);
    addField('date_of_birth', result["dob"].toString());
    addField('state', result["state"]);
    addField('city', result["city"]);
    addField('role_id', result["roles"]);
    // addField('profile_image', result["image"]);

    if (result['image'] != null) {
      // Web upload
      formData.files.add(
        MapEntry(
          "profile_image",
          MultipartFile.fromBytes(
            result['image'],
            filename: "profile_image.png",
          ),
        ),
      );
    } else if (result['existing_image'] != null) {
      addField("existing_profile_image", result['existing_image']);
    }

    if (result['idImage'] != null) {
      formData.files.add(
        MapEntry(
          "document_image",
          MultipartFile.fromBytes(
            result['idImage'],
            filename: "document_image.png",
          ),
        ),
      );
    } else if (result['existing_doc'] != null) {
      addField("existing_document_image", result['existing_doc']);
    }

    saveOrUpdate(formData);
  }

  Future<void> saveOrUpdate(FormData formData) async {
    _setLoading(true);

    try {
      await _apiService.addSubAdmin(formData);

      await loadData();
      _refreshTable();
    } catch (e, stack) {
      debugPrint("Error saving/updating subadmin: $e");
      debugPrint("$stack");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> onDelete(model) async {
    _setLoading(true);

    try {
      await _apiService.deleteSubAdmin(model.id!);

      await loadData();
      _refreshTable();
    } catch (e, stack) {
      debugPrint("Error delete subadmin: $e");
      debugPrint("$stack");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  _refreshTable({filtered}) {
    tableSource = SubAdminTableSource(
        filtered ?? subAdmins, // updated list with toggled status
        onEdit,
        confirmDelete,
        roles,
        toggleInfluencerStatus);
    notifyListeners();
  }

  Future<void> toggleInfluencerStatus(item) async {
    final oldStatus = item.status;

    // UI first
    item.status = oldStatus == 1 ? 0 : 1;
    notifyListeners();

    try {
      _setLoading(true);
      final formData = buildSubAdminFormDataFromItem(
        item,
        type: (oldStatus == 1) ? "0" : "1",
      );
      await _apiService.addSubAdmin(formData);
    } catch (e) {
      // rollback
      item.status = oldStatus;
      notifyListeners();
    } finally {
      await loadData();
      _refreshTable();
      _setLoading(false);
    }
  }

  void confirmDelete(service) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete ${service.name} Sub-Admin?"),
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
                  onDelete(service);
                  Navigator.pop(StackedService
                      .navigatorKey!.currentContext!); // close dialog
                }),
          ],
        );
      },
    );
  }

  FormData buildSubAdminFormDataFromItem(
    sub_admin_model.Datum item, {
    Map<String, dynamic>? extraFields, // any extra fields like password
    String? type, // optional control field
  }) {
    final formData = FormData();

    // ---------- HELPER ----------
    void add(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    // ---------- CONTROL ----------
    if (type != null) add("type", type);

    // ---------- REQUIRED ----------
    add("id", item.id);
    add("status", item.status);

    // ---------- BASIC INFO ----------
    add("name", item.name);
    add("email", item.email);
    add("phone", item.mobileNumber);
    add("gender", item.gender);
    if (item.dateOfBirth != null) {
      add("date_of_birth",
          item.dateOfBirth!.toIso8601String().split('T').first);
    }
    add("state", item.state);
    add("city", item.city);
    add("role_id", item.roleId);

    // ---------- IMAGES ----------
    // Profile image
    if (item.profileImage != null) {
      add("existing_profile_image", item.profileImage);
    }

    // Document image
    if (item.docImg != null) {
      add("existing_document_image", item.docImg);
    }

    // ---------- EXTRA FIELDS ----------
    if (extraFields != null) {
      extraFields.forEach((key, value) => add(key, value));
    }

    return formData;
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      subAdmins.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortType == "clientAsc") {
      subAdmins.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      subAdmins.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      subAdmins.sort((a, b) {
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

  /// SEARCH
  // ================== SEARCH / FILTER ==================
  void searchInfluencer(String query) {
    query = query.toLowerCase();

    final filtered = subAdmins.where((inf) {
      return inf.name!.toLowerCase().contains(query) ||
          inf.state!.contains(query) ||
          inf.city!.toLowerCase().contains(query) ||
          inf.state!.toLowerCase().contains(query);
    }).toList();

    tableSource = SubAdminTableSource(
      filtered,
      onEdit,
      confirmDelete,
      roles,
      toggleInfluencerStatus,
    );

    notifyListeners();
  }
}
