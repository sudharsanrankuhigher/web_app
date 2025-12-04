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

  Future<Map<String, dynamic>?> showSortingFilterDialog(BuildContext context) {
    bool checkStatus = false;
    String? selectedSort = "A-Z";

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Filters & Sorting"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sort By",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  RadioListTile(
                    value: "A-Z",
                    groupValue: selectedSort,
                    title: const Text("A - Z"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                  RadioListTile(
                    value: "newer",
                    groupValue: selectedSort,
                    title: const Text("Newer First"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                  RadioListTile(
                    value: "older",
                    groupValue: selectedSort,
                    title: const Text("Older First"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                  RadioListTile(
                    value: "clientAsc",
                    groupValue: selectedSort,
                    title: const Text("Client ID (Ascending → Descending)"),
                    onChanged: (value) {
                      setState(() => selectedSort = value.toString());
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "checkbox": checkStatus,
                  "sort": selectedSort,
                });
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  void openFilter() async {
    final result = await showSortingFilterDialog(
        StackedService.navigatorKey!.currentContext!);

    if (result == null) return;

    bool isChecked = result["checkbox"];
    String sortType = result["sort"];

    print("Checkbox: $isChecked");
    print("Sort: $sortType");

    // Apply sorting
    applySort(isChecked, sortType);
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
