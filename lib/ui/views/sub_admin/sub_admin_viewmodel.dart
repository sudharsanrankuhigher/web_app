import 'dart:typed_data';

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
import 'package:webapp/widgets/file_preview_widget.dart';

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
            filename: 'profile_image',
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
            filename: 'document_image.${result['id_proof_extension'] ?? 'jpg'}',
          ),
        ),
      );
    } else if (result['existing_doc'] != null) {
      addField('existing_doc', result['existing_doc']);
    }

    await saveOrUpdate(formData);
  }

  String getFileExtension(Uint8List bytes) {
    if (bytes.length < 4) return 'bin';

    // PDF: %PDF
    if (bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return 'pdf';
    }

    // PNG
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }

    // JPG
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'jpg';
    }

    return 'bin'; // fallback
  }

  String generateFileName(Uint8List bytes, String prefix) {
    final ext = getFileExtension(bytes);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$timestamp.$ext';
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
      final bytes = result['image'];
      final fileName = generateFileName(bytes, 'profile_image');

      // Web upload
      formData.files.add(
        MapEntry(
          "profile_image",
          MultipartFile.fromBytes(
            result['image'],
            filename: fileName,
          ),
        ),
      );
    } else if (result['existing_image'] != null) {
      addField("existing_profile_image", result['existing_image']);
    }

    if (result['idImage'] != null) {
      final bytes = result['idImage'];
      final fileName = generateFileName(bytes, 'document');
      formData.files.add(
        MapEntry(
          "document_image",
          MultipartFile.fromBytes(
            result['idImage'],
            filename: fileName,
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
        toggleInfluencerStatus,
        viewDoc,
        viewHistory);
    notifyListeners();
  }

  // ─── Profile Panel State for Sub-Admin ───
  bool _showProfilePanel = false;
  bool get showProfilePanel => _showProfilePanel;

  bool _isHistoryLoading = false;
  bool get isHistoryLoading => _isHistoryLoading;

  String? _historyUserId;
  String? get historyUserId => _historyUserId;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<int> years = [2024, 2025, 2026, 2027];

  String _selectedMonth = 'June';
  String get selectedMonth => _selectedMonth;

  int _selectedYear = 2026;
  int get selectedYear => _selectedYear;

  List<Map<String, String>> _loginLogoutHistory = [];
  List<Map<String, String>> get loginLogoutHistory => _loginLogoutHistory;

  // Sub-admin details fetched from API
  String? _historyName;
  String? get historyName => _historyName;

  String? _historyEmail;
  String? get historyEmail => _historyEmail;

  String? _historyRole;
  String? get historyRole => _historyRole;

  String? _historyProfileImg;
  String? get historyProfileImg => _historyProfileImg;

  void toggleProfilePanel() {
    _showProfilePanel = !_showProfilePanel;
    notifyListeners();
  }

  void closeProfilePanel() {
    _showProfilePanel = false;
    notifyListeners();
  }

  void initMonthYear() {
    final now = DateTime.now();
    _selectedMonth = months[now.month - 1];
    _selectedYear = now.year;
  }

  void setSelectedMonth(String month) {
    _selectedMonth = month;
    if (_historyUserId != null) {
      fetchAttendanceHistory(_historyUserId!);
    }
    notifyListeners();
  }

  void setSelectedYear(int year) {
    _selectedYear = year;
    if (_historyUserId != null) {
      fetchAttendanceHistory(_historyUserId!);
    }
    notifyListeners();
  }

  Future<void> selectYearFromCalendar(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDate: DateTime(_selectedYear, 1),
              selectedDate: DateTime(_selectedYear, 1),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );
    if (picked != null) {
      setSelectedYear(picked.year);
    }
  }

  Future<void> viewHistory(String id) async {
    debugPrint("View history clicked for user ID: $id");
    _historyUserId = id;
    _showProfilePanel = true;
    initMonthYear();
    fetchAttendanceHistory(id);
    notifyListeners();
  }

  Future<void> fetchAttendanceHistory(String id) async {
    _isHistoryLoading = true;
    notifyListeners();

    try {
      final monthIndex = months.indexOf(_selectedMonth) + 1;
      final monthStr = monthIndex.toString().padLeft(2, '0');
      final queryMonth = '$monthStr-$_selectedYear';

      final res = await locator<ApiService>().getAttendance(queryMonth, id: id);
      if (res != null && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;

        // Extract sub-admin profile details
        _historyName = data['name'] as String?;
        _historyEmail = data['email'] as String?;
        _historyRole = data['role_id'] as String?;
        _historyProfileImg = data['profile_img'] as String?;

        if (data['attendance'] != null) {
          final attendanceList = data['attendance'] as List<dynamic>;
          _loginLogoutHistory = attendanceList.map((x) {
            final item = x as Map<String, dynamic>;

            final loginDateStr = item['login_date'] as String?;
            final loginTimeStr = item['login_time'] as String?;
            final logoutTimeStr = item['logout_time'] as String?;

            String formattedDate = '-';
            if (loginDateStr != null) {
              try {
                final parsedDate = DateTime.parse(loginDateStr);
                final monthShort = _selectedMonth.substring(0, 3);
                formattedDate =
                    '${parsedDate.day.toString().padLeft(2, '0')} $monthShort ${parsedDate.year}';
              } catch (_) {
                formattedDate = loginDateStr;
              }
            }

            String formattedLogin = '-';
            if (loginTimeStr != null) {
              formattedLogin = _formatTimeString(loginTimeStr);
            }

            String formattedLogout = '-';
            if (logoutTimeStr != null) {
              formattedLogout = _formatTimeString(logoutTimeStr);
            }

            return {
              'date': formattedDate,
              'login': formattedLogin,
              'logout': formattedLogout,
            };
          }).toList();
        } else {
          _loginLogoutHistory = [];
        }
      } else {
        _loginLogoutHistory = [];
      }
    } catch (e) {
      debugPrint('Error fetching attendance history: $e');
      _loginLogoutHistory = [];
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }

  String _formatTimeString(String timeStr) {
    try {
      final parts = timeStr.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final isAM = hour < 12;
      hour = hour % 12;
      if (hour == 0) hour = 12;

      final minuteStr = minute.toString().padLeft(2, '0');
      return '$hour.$minuteStr ${isAM ? 'AM' : 'PM'}';
    } catch (_) {
      return timeStr;
    }
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

    tableSource = SubAdminTableSource(filtered, onEdit, confirmDelete, roles,
        toggleInfluencerStatus, viewDoc, viewHistory);

    notifyListeners();
  }

  void viewDoc(String imageUrl) {
    var isPdf = imageUrl.toLowerCase().endsWith(".pdf");
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              /// 🔥 IMAGE (your WebImageTwo)
              SizedBox(
                width: 400,
                height: 400,
                child:
                    // WebImage(
                    //   imageUrl: imageUrl,
                    //   fit: BoxFit.contain,
                    // ),
                    FullPreviewWidget(url: imageUrl),
              ),

              // Positioned(
              //   top: 10,
              //   left: 10,
              //   child: GestureDetector(
              //     onTap: () => Navigator.pop(context),
              //     child: const Icon(
              //       Icons.close,
              //       color: Colors.white,
              //       size: 28,
              //     ),
              //   ),
              // ),   /// ❌ CLOSE BUTTON
            ],
          ),
        );
      },
    );
  }
}
