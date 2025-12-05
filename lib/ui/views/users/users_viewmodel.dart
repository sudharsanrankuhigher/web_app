import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/users/model/users_model.dart';
import 'package:webapp/ui/views/users/widgets/user_table_source.dart';

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
      // onAddPressed: (user) {
      //   print("Add clicked → ${user.name}");
      // },
    );

    notifyListeners();
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
