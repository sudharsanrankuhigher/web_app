import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart';
import 'package:webapp/ui/views/influencers/widgets/add_edit_influencer_dialog.dart';
import 'package:webapp/ui/views/influencers/widgets/influencers_table_source.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;

class InfluencersViewModel extends BaseViewModel {
  InfluencersViewModel() {
    getServices();
  }

  List<InfluencerModel> influencers = [];
  List<service_model.Datum> services = [];

  late InfluencerTableSource tableSource;
  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  String selectedCategory = "All";
  Future<void> getServices() async {
    final res = await _apiService.getAllService();
    services = res.data ?? [];
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addInfluencer(influencerData) async {
    _setLoading(true);

    try {
      final formData = FormData();

      // ---------- TEXT FIELD HELPER ----------
      void addField(String key, dynamic value) {
        if (value != null) {
          formData.fields.add(
            MapEntry(key, value.toString()),
          );
        }
      }

      // ---------- TEXT FIELDS ----------
      addField("id", influencerData['id']);
      addField("name", influencerData['name']);
      addField("email", influencerData['email']);
      addField("phone", influencerData['phone']);
      addField("dob", influencerData['dob']);
      addField("alt_phone", influencerData['altPhone']);
      addField("inf_id", influencerData['inf_id']);
      addField("state", influencerData['state']);
      addField("password", influencerData['password']);
      // addField("service", influencerData['service']);
      final services = influencerData['service'];

      if (services is List && services.isNotEmpty) {
        for (int i = 0; i < services.length; i++) {
          formData.fields.add(
            MapEntry('service[$i]', services[i].toString()),
          );
        }
      }

      addField("city", influencerData['city']);
      addField("instagram_link", influencerData['instagram']);
      addField("instagram_followers", influencerData['instagramFollowers']);
      addField("facebook_link", influencerData['facebook']);
      addField("facebook_followers", influencerData['facebookFollowers']);
      addField("youtube_link", influencerData['youtube']);
      addField("youtube_followers", influencerData['youtubeFollowers']);
      addField("account_no", influencerData['bankAccount']);
      addField("account_holder_name", influencerData['bankHolder']);
      addField("ifsc_code", influencerData['ifsc']);
      addField("upi_id", influencerData['upi']);
      addField("description", influencerData['description']);
      addField("existing_image", influencerData['existing_image']);

      // ---------- IMAGE (WEB) ----------
      final bytes = influencerData['imageBytes'];
      if (kIsWeb && bytes is List<int> && bytes.isNotEmpty) {
        formData.files.add(
          MapEntry(
            "image",
            MultipartFile.fromBytes(
              bytes,
              filename: "influencer.png",
            ),
          ),
        );
      }

      // ---------- IMAGE (MOBILE) ----------
      if (!kIsWeb && influencerData['imagePath'] != null) {
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              influencerData['imagePath'],
              filename: influencerData['imagePath'].split('/').last,
            ),
          ),
        );
      }

      // ✅ SAFE DEBUG (NO CRASH)
      debugPrint(
          "FormData fields: ${formData.fields.map((e) => e.key).toList()}");
      debugPrint(
          "FormData files: ${formData.files.map((e) => e.key).toList()}");

      await _apiService.addInfluencer(formData);
      notifyListeners();
    } catch (e) {
      debugPrint("Add influencer error: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editInfluencer(influencerData) async {
    _setLoading(true);
    try {
      final formData = FormData.fromMap({
        "id": influencerData['id'],
        "name": influencerData['name'],
        "email": influencerData['email'],
        "phone": influencerData['phone'],
        "dob": influencerData['dob'],
        "altPhone": influencerData['alt_phone'],
        "inf_id": influencerData['inf_id'],
        "state": influencerData['state'],
        "password": influencerData['password'],
        "service": influencerData['service'],
        "city": influencerData['city'],
        "instagram_link": influencerData['instagram'],
        "instagram_followers": influencerData['instagramFollowers'],
        "instagram_desc": influencerData['instagramDesc'],
        "instagramFollowers": influencerData['instagram_followers'],
        "instagramDesc": influencerData['instagram_desc'],
        "facebook_link": influencerData['facebook'],
        "facebook_followers": influencerData['facebookFollowers'],
        "youtube_link": influencerData['youtube'],
        "youtube_followers": influencerData['youtubeFollowers'],
        "account_no": influencerData['bankAccount'],
        "account_holder_name": influencerData['bankHolder'],
        "ifsc_code": influencerData['ifsc'],
        "upi_id": influencerData['upi'],
        "description": influencerData['description'],
        if (influencerData['existing_image'] != null)
          "existing_image": influencerData['existing_image'],
        if (influencerData['imageBytes'] != null)

          /// IMAGE (WEB)
          if (kIsWeb && influencerData['imageBytes'] != null)
            "image": MultipartFile.fromBytes(
              influencerData['imageBytes'], // ✅ map access
              filename: "influencer.png", // ✅ MUST be string
            ),

        /// IMAGE (MOBILE)
        if (!kIsWeb && influencerData['imagePath'] != null)
          "image": await MultipartFile.fromFile(
            influencerData['imagePath'], // ✅ map access
            filename: influencerData['imagePath'].split('/').last,
          ),
      });
      await _apiService.updateInfluencer(formData);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      debugPrint("Add influencer error: $e");
      rethrow;
    }
  }

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
              constraints: const BoxConstraints(
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
              constraints: const BoxConstraints(
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
      // onDelete: confirmDelete, // <-- ADD THIS
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
      // onDelete:
      //     confirmDelete, // <-- ADD THIS      // onDelete: (item) => print("Delete ${item.name}"),
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
      // onDelete:
      //     confirmDelete, // <-- ADD THIS      // onDelete: (item) => print("Delete ${item.name}"),
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
              editInfluencer(updated);
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

  void applySort(bool specialFilter, String sortType) {
    if (specialFilter) {}

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
