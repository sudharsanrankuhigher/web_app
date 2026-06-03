import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/model/get_user_model.dart' as user_model;
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/users/widgets/common_user_dialog.dart';
import 'package:webapp/ui/views/users/widgets/user_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class UsersViewModel extends BaseViewModel with NavigationMixin {
  UsersViewModel() {
    // Initialize tableSource to avoid LateInitializationError
    tableSource = UserTableSource(
        users: users, onAdd: () {}, onNotesEdit: (user) => onNoteEdit(user));
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  DateTime selectedMonth = DateTime.now();

  List<user_model.Datum> users = [];

  late UserTableSource tableSource;

  String selectedType = "All";

  // ---------------- Search & Filter ----------------
  void searchUser(String query) {
    tableSource.applySearch(query, selectedType);
    notifyListeners();
  }

  void applyFilter(String type) {
    selectedType = type;
    tableSource.applySearch("", selectedType);
    notifyListeners();
  }

  // ---------------- Load Users ----------------
  Future<void> loadUsers() async {
    setBusy(true);
    String formattedDate = DateFormat('yyyy-MM').format(selectedMonth);

    try {
      final data = {"month": formattedDate};
      final res = await _apiService.getUsers(data: data);
      users = res.data ?? [];
    } catch (e) {
      users = [];
      log('Error loading users: $e');
    } finally {
      // Update tableSource after fetching data
      tableSource = UserTableSource(
          users: users, onAdd: () {}, onNotesEdit: (user) => onNoteEdit(user));
      setBusy(false);
      notifyListeners();
    }
  }

  // ---------------- Edit User ----------------
  Future<void> editUser(user_model.Datum user) async {
    final result = await CommonUserDialog.show(
      StackedService.navigatorKey!.currentContext!,
      existingUser: {
        "name": user.name,
        "email": user.email,
        "phone": user.mobileNumber,
        "type": user.type,
        "city": user.city,
        "state": user.state,
      },
    );

    if (result != null) {
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = user_model.Datum(
          id: user.id,
          name: result["name"] ?? user.name,
          email: result["email"] ?? user.email,
          mobileNumber: result["phone"] ?? user.mobileNumber,
          type: result["type"] ?? user.type,
          city: result["city"] ?? user.city,
          state: result["state"] ?? user.state,
        );

        tableSource = UserTableSource(
            users: users,
            onAdd: () {},
            onNotesEdit: (user) => onNoteEdit(user));
        notifyListeners();
      }
    }
  }

  // ---------------- Delete User ----------------
  void deleteUser(user_model.Datum user) {
    users.removeWhere((u) => u.id == user.id);
    tableSource = UserTableSource(
        users: users, onAdd: () {}, onNotesEdit: (user) => onNoteEdit(user));
    notifyListeners();
  }

  void confirmDelete(user_model.Datum user) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${user.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
                deleteUser(user);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ---------------- Sorting ----------------
  void applySort(bool specialFilter, String sortType) {
    switch (sortType) {
      case "A-Z":
        users.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;

      case "clientAsc":
        users.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        break;

      case "newer":
        users.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.tryParse(a.createdAt.toString()) ?? DateTime(1970)
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.tryParse(b.createdAt.toString()) ?? DateTime(1970)
              : DateTime(1970);

          int dateCompare = bDate.compareTo(aDate);
          if (dateCompare == 0) {
            return (b.id ?? 0).compareTo(a.id ?? 0);
          }
          return dateCompare;
        });
        break;

      case "older":
        users.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.tryParse(a.createdAt.toString()) ?? DateTime(1970)
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.tryParse(b.createdAt.toString()) ?? DateTime(1970)
              : DateTime(1970);

          int dateCompare = aDate.compareTo(bDate);
          if (dateCompare == 0) {
            return (a.id ?? 0).compareTo(b.id ?? 0);
          }
          return dateCompare;
        });
        break;
    }

    tableSource = UserTableSource(
      users: users,
      onAdd: () {},
      onNotesEdit: (user) => onNoteEdit(user),
    );

    notifyListeners();
  }

  Future<void> onNoteEdit(user_model.Datum user) async {
    final result = await showNotesDialog(user);
    if (result != null) {
      // 👉 call API here
      final res = await _apiService
          .updateNotes(
            userId: user.id,
            notes: result,
          )
          .then((value) => loadUsers());

      print("Updated Notes: $result for User ID: ${user.id}");
      // Fluttertoast.showToast(
      //   msg: "Notes updated successfully $result",
      // );
    }
  }

  Future<String?> showNotesDialog(user_model.Datum user) {
    final context = StackedService.navigatorKey!.currentContext!;
    final controller = TextEditingController(text: user.notes ?? "");

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("${user.name} Notes"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Enter notes...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: publisButtonColor,
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;

                Navigator.pop(dialogContext, text);
              },
              child: Text(
                "Update",
                style: fontFamilySemiBold.size13.white,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Close", style: fontFamilySemiBold.size13.red),
            ),
          ],
        );
      },
    );
  }
}

class CommonTableDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    double minWidth = 350,
    double maxWidth = 550,
    double minHeight = 100,
    double maxHeight = 400,
  }) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

    return showDialog<T>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxHeight: maxHeight,
              minWidth: minWidth,
              maxWidth: maxWidth,
            ),
            child: Scrollbar(
              controller: verticalController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: verticalController,
                child: Scrollbar(
                  controller: horizontalController,
                  thumbVisibility: true,
                  notificationPredicate: (notif) =>
                      notif.metrics.axis == Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: content,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
