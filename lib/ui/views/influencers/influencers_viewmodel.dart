import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/influencers/widgets/add_edit_influencer_dialog.dart';
import 'package:webapp/ui/views/influencers/widgets/influencers_table_source.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;

class InfluencersViewModel extends BaseViewModel {
  // InfluencersViewModel() {
  //   getServices();
  // }

  List<influencer_model.Datum> influencers = [];
  List<service_model.Datum> services = [];

  late InfluencerTableSource tableSource;
  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  String selectedCategory = "All";
  Future<void> getServices() async {
    final res = await runBusyFuture(_apiService.getAllService());
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
      loadInfluencers();

      _setLoading(false);
    }
  }

  Future<void> editInfluencer(Map<String, dynamic> influencerData) async {
    _setLoading(true);

    try {
      final formData = FormData();

      void addField(String key, dynamic value) {
        if (value != null && value.toString().isNotEmpty) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      }

      /// ---------------- TEXT FIELDS ----------------
      addField("id", influencerData['id']);
      addField("name", influencerData['name']);
      addField("email", influencerData['email']);
      addField("phone", influencerData['phone']);
      addField("alt_phone", influencerData['altPhone']); // ✅ FIXED
      addField("dob", influencerData['dob']);
      addField("inf_id", influencerData['inf_id']);
      addField("state", influencerData['state']);
      addField("city", influencerData['city']);

      /// ---------------- PASSWORD (ONLY IF GIVEN) ----------------
      if (influencerData['password'] != null &&
          influencerData['password'].toString().isNotEmpty) {
        addField("password", influencerData['password']);
      }

      /// ---------------- SERVICES ----------------
      final services = influencerData['service'];
      if (services is List && services.isNotEmpty) {
        for (int i = 0; i < services.length; i++) {
          formData.fields.add(
            MapEntry('service[$i]', services[i].toString()),
          );
        }
      }

      /// ---------------- SOCIAL ----------------
      addField("instagram_link", influencerData['instagram']);
      addField("instagram_followers", influencerData['instagramFollowers']);
      addField("facebook_link", influencerData['facebook']);
      addField("facebook_followers", influencerData['facebookFollowers']);
      addField("youtube_link", influencerData['youtube']);
      addField("youtube_followers", influencerData['youtubeFollowers']);

      /// ---------------- BANK ----------------
      addField("account_no", influencerData['bankAccount']);
      addField("account_holder_name", influencerData['bankHolder']);
      addField("ifsc_code", influencerData['ifsc']);
      addField("upi_id", influencerData['upi']);
      addField("description", influencerData['description']);

      /// ---------------- IMAGE LOGIC ----------------
      final bytes = influencerData['imageBytes'];
      final imagePath = influencerData['imagePath'];

      if (kIsWeb && bytes is List<int> && bytes.isNotEmpty) {
        /// ✅ NEW IMAGE (WEB)
        formData.files.add(
          MapEntry(
            "image",
            MultipartFile.fromBytes(bytes, filename: "influencer.png"),
          ),
        );
      } else if (!kIsWeb && imagePath != null && imagePath.isNotEmpty) {
        /// ✅ NEW IMAGE (MOBILE)
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
          ),
        );
      } else {
        /// ✅ NO NEW IMAGE → SEND EXISTING
        addField("existing_image", influencerData['existing_image']);
      }

      /// DEBUG
      debugPrint("FIELDS → ${formData.fields}");
      debugPrint("FILES → ${formData.files.map((e) => e.key).toList()}");

      /// 🔥 SAME API FOR ADD & EDIT
      await _apiService.addInfluencer(formData);

      notifyListeners();
    } catch (e) {
      debugPrint("Save influencer error: $e");
      rethrow;
    } finally {
      loadInfluencers();
      _setLoading(false);
    }
  }

  Future<void> loadInfluencers() async {
    setBusy(true);
    _setLoading(true);

    try {
      final res = await _apiService.getAllInfluencer();
      influencers = res.data ?? [];
    } catch (e) {
      influencers = [];
    } finally {
      setBusy(false);
      _refreshTable(filtered: influencers);
      _setLoading(false);
    }

    tableSource = InfluencerTableSource(
      influencers: influencers,
      service: services,
      onEdit: openEditDialog,
      onView: openEditDialog,
      onToggle: (_) => toggleInfluencerStatus(_),
    );

    notifyListeners();
  }

  Future<void>? _refreshTable({List<influencer_model.Datum>? filtered}) async {
    tableSource = InfluencerTableSource(
      influencers: filtered ?? influencers,
      service: services,
      onEdit: (influencer, _) => openEditDialog(influencer, false),
      onView: (influencer, _) => openEditDialog(influencer, true),
      onToggle: (influencer) => toggleInfluencerStatus(influencer),
    );
    notifyListeners();
  }

  /// SEARCH
  // ================== SEARCH / FILTER ==================
  void searchInfluencer(String query) {
    query = query.toLowerCase();

    final filtered = influencers.where((inf) {
      return inf.name!.toLowerCase().contains(query) ||
          inf.phone!.contains(query) ||
          inf.city!.toLowerCase().contains(query);
    }).toList();

    tableSource = InfluencerTableSource(
      influencers: filtered,
      onEdit: openEditDialog,
      onView: openEditDialog,
      onToggle: (_) => toggleInfluencerStatus(_),
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
      // return inf.category.toLowerCase() == cat.toLowerCase();
      return true;
    }).toList();

    tableSource = InfluencerTableSource(
      influencers: filtered,
      onEdit: openEditDialog,
      onView: openEditDialog,
      // onDelete:
      //     confirmDelete, // <-- ADD THIS      // onDelete: (item) => print("Delete ${item.name}"),
      onToggle: (item) {
        // item.isActive = !item.isActive;
        toggleInfluencerStatus(item);
      },
    );

    notifyListeners();
  }

  void openEditDialog(influencer_model.Datum item, bool view) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, minWidth: 400),
          child: InfluencerDialog(
            isView: view,
            influencer: item,
            service: services,
            onSave: (updated) {
              editInfluencer(updated);
              notifyListeners();
            },
          ),
        ),
      ),
    );
  }

  void deleteInfluencer(influencer_model.Datum item) {
    influencers.remove(item);
    notifyListeners();
  }

  void confirmDelete(influencer_model.Datum item) {
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

  FormData buildInfluencerFormDataFromItem(
    item, {
    String? type,
  }) {
    final formData = FormData();

    void add(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        formData.fields.add(
          MapEntry(key, value.toString()),
        );
      }
    }

    // ---------- CONTROL ----------
    if (type != null) add("type", type); // <-- "toggle"

    // ---------- REQUIRED ----------
    add("id", item.id);
    add("status", item.status);

    // ---------- BASIC ----------
    add("name", item.name);
    add("email", item.email);
    add("phone", item.phone);
    add("alt_phone", item.altPhone);

    if (item.dob != null) {
      add("dob", item.dob!.toIso8601String().split('T').first);
    }

    add("inf_id", item.infId);
    add("state", item.state);
    add("city", item.city);

    // ---------- SERVICES ----------
    if (item.service != null && item.service!.isNotEmpty) {
      for (int i = 0; i < item.service!.length; i++) {
        formData.fields.add(
          MapEntry(
            'service[$i]',
            item.service![i].toString(),
          ),
        );
      }
    }

    // ---------- SOCIAL ----------
    add("instagram_link", item.instagramLink);
    add("instagram_followers", item.instagramFollowers);
    add("facebook_link", item.facebookLink);
    add("facebook_followers", item.facebookFollowers);
    add("youtube_link", item.youtubeLink);
    add("youtube_followers", item.youtubeFollowers);

    // ---------- BANK ----------
    add("account_no", item.accountNo);
    add("account_holder_name", item.accountHolderName);
    add("ifsc_code", item.ifscCode);
    add("upi_id", item.upiId);

    // ---------- EXTRA ----------
    add("description", item.description);

    // ---------- IMAGE ----------
    add("existing_image", item.image);

    return formData;
  }

  Future<void> toggleInfluencerStatus(item) async {
    final oldStatus = item.status;

    // UI first
    item.status = oldStatus == 1 ? 0 : 1;
    notifyListeners();

    try {
      final formData = buildInfluencerFormDataFromItem(
        item,
        type: (oldStatus == 1) ? "0" : "1",
      );
      await _apiService.addInfluencer(formData);
    } catch (e) {
      // rollback
      item.status = oldStatus;
      notifyListeners();
    } finally {
      loadInfluencers();
      _refreshTable();
    }
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      influencers.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortType == "clientAsc") {
      influencers.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      influencers.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      influencers.sort((a, b) {
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
}
