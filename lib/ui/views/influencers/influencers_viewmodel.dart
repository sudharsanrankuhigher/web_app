import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart';
import 'package:webapp/ui/views/influencers/widgets/add_edit_influencer_dialog.dart';
import 'package:webapp/ui/views/influencers/widgets/influencers_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class InfluencersViewModel extends BaseViewModel {
  List<InfluencerModel> influencers = [];
  late InfluencerTableSource tableSource;

  String selectedCategory = "All";

  Future<void> loadInfluencers() async {
    influencers = [
      InfluencerModel(
        id: 1,
        name: "Mahendran",
        phone: "9876543210",
        city: "Coimbatore",
        state: "Tamilnadu",
        category: "Fashion",
        instagramFollowers: "13M",
        youtubeFollowers: "15M",
        facebookFollowers: "13M",
      ),
      // Add more...
    ];

    tableSource = InfluencerTableSource(
      influencers: influencers,
      onEdit: (item, view) {
        showDialog(
          context: StackedService.navigatorKey!.currentContext!,
          builder: (_) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 800, // set your desired width
                minWidth: 400,
              ),
              child: InfluencerDialog(
                isView: view,
                influencer: item,
                onSave: (updated) {
                  // Update your list
                  final index = influencers.indexOf(item);
                  influencers[index] = updated;
                  notifyListeners();
                },
              ),
            ),
          ),
        );
        notifyListeners();
      },
      onView: (item, view) {
        showDialog(
          context: StackedService.navigatorKey!.currentContext!,
          builder: (_) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 800, // set your desired width
                minWidth: 400,
              ),
              child: InfluencerDialog(
                isView: view,
                influencer: item,
                onSave: (updated) {
                  final index = influencers.indexOf(item);
                  influencers[index] = updated;
                  notifyListeners();
                },
              ),
            ),
          ),
        );
        notifyListeners();
      },
      onDelete: confirmDelete, // <-- ADD THIS
      // onDelete: (item) => print("Delete ${item.name}"),
      onToggle: (item) {
        item.isActive = !item.isActive;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  /// SEARCH
  void searchInfluencer(String query) {
    query = query.toLowerCase();

    final filtered = influencers.where((inf) {
      return inf.name.toLowerCase().contains(query) ||
          inf.phone.contains(query) ||
          inf.city!.toLowerCase().contains(query) ||
          inf.category.toLowerCase().contains(query);
    }).toList();

    tableSource = InfluencerTableSource(
      influencers: filtered,
      onEdit: openEditDialog,
      onView: openEditDialog,
      onDelete:
          confirmDelete, // <-- ADD THIS      // onDelete: (item) => print("Delete ${item.name}"),
      onToggle: (item) {
        item.isActive = !item.isActive;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void applyCategory(String cat) {
    selectedCategory = cat;

    if (cat == "All") {
      searchInfluencer("");
      return;
    }

    final filtered = influencers.where((inf) {
      return inf.category.toLowerCase() == cat.toLowerCase();
    }).toList();

    tableSource = InfluencerTableSource(
      influencers: filtered,
      onEdit: openEditDialog,
      onView: openEditDialog,
      onDelete:
          confirmDelete, // <-- ADD THIS      // onDelete: (item) => print("Delete ${item.name}"),
      onToggle: (item) {
        item.isActive = !item.isActive;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void openEditDialog(InfluencerModel item, bool view) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, minWidth: 400),
          child: InfluencerDialog(
            isView: view,
            influencer: item,
            onSave: (updated) {
              final index = influencers.indexOf(item);
              influencers[index] = updated;
              notifyListeners();
            },
          ),
        ),
      ),
    );
  }

  void deleteInfluencer(InfluencerModel item) {
    influencers.remove(item);
    notifyListeners();
  }

  void confirmDelete(InfluencerModel item) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${item.name}?"),
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
                  deleteInfluencer(item);
                  Navigator.pop(context); // close dialog
                }),
          ],
        );
      },
    );
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
      influencers.sort((a, b) => a.name.compareTo(b.name));
    }
    // else if (sortType == "newer") {
    //   influencers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // } else if (sortType == "older") {
    //   influencers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    // }
    else if (sortType == "clientAsc") {
      influencers.sort((a, b) => a.id.compareTo(b.id));
    }

    notifyListeners();
  }
}
