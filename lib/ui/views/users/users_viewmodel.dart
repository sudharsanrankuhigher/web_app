import 'dart:developer';

import 'package:flutter/material.dart';
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
    tableSource = UserTableSource(users: users, onAdd: () {});
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

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
    try {
      final res = await _apiService.getUsers();
      users = res.data ?? [];
    } catch (e) {
      users = [];
      log('Error loading users: $e');
    } finally {
      // Update tableSource after fetching data
      tableSource = UserTableSource(users: users, onAdd: () {});
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
        "plan": user.plan,
        "connections": user.connections,
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
          plan: result["plan"] ?? user.plan,
          connections: result["connections"] ?? user.connections,
        );

        tableSource = UserTableSource(users: users, onAdd: () {});
        notifyListeners();
      }
    }
  }

  // ---------------- Delete User ----------------
  void deleteUser(user_model.Datum user) {
    users.removeWhere((u) => u.id == user.id);
    tableSource = UserTableSource(users: users, onAdd: () {});
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
    if (specialFilter) {
      // Add special filter logic if needed
    }

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
              ? DateTime.parse(a.createdAt.toString())
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.parse(b.createdAt.toString())
              : DateTime(1970);
          return bDate.compareTo(aDate);
        });
        break;
      case "older":
        users.sort((a, b) {
          DateTime aDate = a.createdAt != null
              ? DateTime.parse(a.createdAt.toString())
              : DateTime(1970);
          DateTime bDate = b.createdAt != null
              ? DateTime.parse(b.createdAt.toString())
              : DateTime(1970);
          return aDate.compareTo(bDate);
        });
        break;
      default:
        // No sorting
        break;
    }

    tableSource = UserTableSource(users: users, onAdd: () {});
    notifyListeners();
  }
}
