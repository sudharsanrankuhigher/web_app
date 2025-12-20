import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/users/model/users_model.dart';
import 'package:webapp/ui/views/users/widgets/common_user_dialog.dart';
import 'package:webapp/ui/views/users/widgets/user_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class UsersViewModel extends BaseViewModel with NavigationMixin {
  List<UserModel> users = [];

  late UserTableSource tableSource;

  String selectedType = "All";

  void searchUser(String query) {
    tableSource.applySearch(query, selectedType);
    notifyListeners();
  }

  void applyFilter(String type) {
    selectedType = type;
    tableSource.applySearch("", selectedType);
    notifyListeners();
  }

  Future<void> loadUsers() async {
    // mock API
    users = [
      UserModel(
        id: 1,
        name: "Suresh",
        email: "suresh@gmail.com",
        phone: "9876543210",
        type: "Influencer",
        city: "Coimbatore",
        state: "TN",
        plan: "Gold",
        connections: 120,
      ),
      // add more items...
    ];

    tableSource = UserTableSource(
      users: users,
      // onEdit: editUser,
      // onDelete: confirmDelete
      onAdd: () {},
    );
    notifyListeners();
  }

  Future<void> editUser(UserModel user) async {
    final result = await CommonUserDialog.show(
      StackedService.navigatorKey!.currentContext!,
      existingUser: {
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "type": user.type,
        "city": user.city,
        "state": user.state,
        "plan": user.plan,
        "connections": user.connections,
      },
    );
  }

  void deleteUser(UserModel user) {
    users.remove(user);
    tableSource = UserTableSource(
      users: users,
      // onEdit: editUser,
      // onDelete: confirmDelete,
      onAdd: () {},
    );
    notifyListeners();
  }

  void confirmDelete(UserModel user) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${user.name}?"),
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
                  deleteUser(user);
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
      users.sort((a, b) => a.name.compareTo(b.name));
    }
    // else if (sortType == "newer") {
    //   influencers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // } else if (sortType == "older") {
    //   influencers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // }
    else if (sortType == "clientAsc") {
      users.sort((a, b) => a.id.compareTo(b.id));
    }

    notifyListeners();
  }
}
