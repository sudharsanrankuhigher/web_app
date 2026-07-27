import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/banner/model/all_banner_model.dart'
    as banner_model;
import 'package:webapp/ui/views/banner/widgtes/add_edit_dialog.dart';
import 'package:webapp/ui/views/banner/widgtes/banner_table_source.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/widgets/common_button.dart';

class BannerViewModel extends BaseViewModel with NavigationMixin {
  BannerViewModel() {
    init();
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<influencer_model.Datum> influencers = [];
  List<banner_model.Datum> bannerList = [];

  BannerTableSource bannerTableSource = BannerTableSource(
    data: [],
    status: "requested",
    influencers: [],
    onView: (item) {},
    onDelete: (item, name) {},
  );

  bool? _isLoading;
  bool get isLoading => _isLoading ?? false;
  isLoadingFn(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init() {
    getInfluencers();
  }

  final bannerColumn = [
    const DataColumn(label: Text("S.No")),
    const DataColumn(label: Text("Image")),
    const DataColumn(label: Text("Influencer")),
    const DataColumn(label: Text("Amount")),
    const DataColumn(label: Text("Priority")),
    const DataColumn(label: Text("Start Date")),
    const DataColumn(label: Text("End Date")),
    const DataColumn(label: Text("State/City")),
    const DataColumn(label: Text("status")),
    const DataColumn(
        label: Text('Action'), headingRowAlignment: MainAxisAlignment.center)
  ];

  Map<int, String> influencerNameMap = {};

  Future<void> getInfluencers() async {
    try {
      final res = await runBusyFuture(_apiService.getAllInfluencer());
      influencers = res.data ?? [];
      // Create ID → Name map
      influencerNameMap = {
        for (var inf in influencers)
          if (inf.id != null) inf.id!: inf.name ?? ''
      };
      await getBanner();
    } catch (e) {
      influencers = [];
    }
  }

  Future<void> getBanner() async {
    isLoadingFn(true);
    bannerList = [];
    try {
      final res = await runBusyFuture(_apiService.getAllBanner());
      bannerList = res.data ?? [];

      allService = List.from(bannerList); // store original
      filteredService = List.from(bannerList);
    } catch (e) {
      bannerList = [];
    } finally {
      refreshBanner();
      isLoadingFn(false);
      notifyListeners();
    }
  }

  /// create banner ///
  Future<void> createBanner(data) async {
    try {
      FormData formData = FormData();

      // 🔹 Normal fields
      if (data["id"] != null) {
        formData.fields.add(MapEntry("id", data['id'].toString()));
      }

      if (data['is_promote'] != null) {
        formData.fields.add(MapEntry(
            "is_promote", (data['is_promote'] == true ? 1 : 0).toString()));
      }

      if (data["inf_id"] != null) {
        if (data["inf_id"] is List) {
          formData.fields.add(
            MapEntry(
              "inf_id",
              (data["inf_id"] as List).join(","), // 👈 FIXED
            ),
          );
        } else {
          formData.fields.add(
            MapEntry("inf_id", data["inf_id"].toString()),
          );
        }
      } else {
        formData.fields.add(const MapEntry("inf_id", ""));
      }
      formData.fields
          .add(MapEntry("amount", (data['amount'] ?? "").toString()));
      formData.fields
          .add(MapEntry("start_date", data['start_date'].toString()));
      formData.fields.add(MapEntry("end_date", data['end_date'].toString()));

      if (data['priority'] != null) {
        formData.fields.add(MapEntry("priority", data['priority'].toString()));
      }

      if (data['state'] != null) {
        formData.fields.add(MapEntry("state", data['state'].toString()));
      }

      if (data['city'] != null) {
        formData.fields.add(MapEntry("city", data['city'].toString()));
      }

      if (data['existing_image'] != null) {
        formData.fields.add(MapEntry("existing_image", data['existing_image']));
      }

      // 🔹 Image multipart
      if (data['image'] != null) {
        final image = data['image'];

        if (image.bytes != null) {
          formData.files.add(
            MapEntry(
              "image",
              MultipartFile.fromBytes(
                image.bytes!,
                filename: "banner_${DateTime.now().millisecondsSinceEpoch}.png",
              ),
            ),
          );
        } else if (image.path != null) {
          formData.files.add(
            MapEntry(
              "image",
              await MultipartFile.fromFile(
                image.path!,
                filename: "banner_${DateTime.now().millisecondsSinceEpoch}.png",
              ),
            ),
          );
        }
      }

      await runBusyFuture(_apiService.createBanner(formData));

      await getBanner();
    } catch (e) {
      bannerList = [];
    } finally {
      refreshBanner();
      notifyListeners();
    }
  }

  /// 🔹 Open Add Banner Dialog
  Future<void> addBanner() async {
    final result = await AddEditBannerDialog.show(
      StackedService.navigatorKey!.currentContext!,
      initial: null,
      influencers: influencers,
    );

    if (result != null) {
      print("Banner Data: $result");
      print("influencers ${result['influencers']}");
      createBanner(result);
      notifyListeners();
    }
  }

  Future<void> viewBanner(banner_model.Datum banner) async {
    final result = await AddEditBannerDialog.show(
      StackedService.navigatorKey!.currentContext!,
      initial: banner,
      influencers: influencers,
      isView: true, // 👈 add this
    );
    if (result != null) {
      print("Banner Data: $result");
      createBanner(result);
      notifyListeners();
    }
  }

  Future<void> deleteBanner(banner_model.Datum banner) async {
    isLoadingFn(true);
    try {
      await _apiService.deleteBanner(banner.id!);
      await getBanner();
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      refreshBanner();
      notifyListeners();
    }
  }

  void confirmDelete(
      BuildContext context, banner_model.Datum banner, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete $name?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          CommonButton(
            width: 100,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            buttonColor: Colors.red,
            text: "Delete",
            textStyle: const TextStyle(color: Colors.white),
            onTap: () {
              deleteBanner(banner);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  refreshBanner() {
    bannerTableSource = BannerTableSource(
      data: filteredService,
      status: "requested",
      influencers: influencers,
      onView: (item) async => await viewBanner(item),
      onDelete: (item, name) async => confirmDelete(
        StackedService.navigatorKey!.currentContext!,
        item,
        name,
      ),
    );
    print('filteredService $filteredService');
    notifyListeners();
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      influencers.sort((a, b) => a.name!.compareTo(b.name!));
      filteredService.sort((a, b) {
        final nameA = influencerNameMap[a.infId] ?? '';
        final nameB = influencerNameMap[b.infId] ?? '';
        return nameA.compareTo(nameB);
      });
      allService.sort((a, b) {
        final nameA = influencerNameMap[a.infId] ?? '';
        final nameB = influencerNameMap[b.infId] ?? '';
        return nameA.compareTo(nameB);
      });
    } else if (sortType == "clientAsc") {
      filteredService.sort((a, b) => a.id!.compareTo(b.id!));
      allService.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      filteredService.sort((a, b) {
        DateTime aDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
      allService.sort((a, b) {
        DateTime aDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      filteredService.sort((a, b) {
        DateTime aDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        return aDate.compareTo(bDate);
      });
      allService.sort((a, b) {
        DateTime aDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        return aDate.compareTo(bDate);
      });
    } else {
      // No sorting
    }

    refreshBanner();
  }

  List<banner_model.Datum> allService = [];
  List<banner_model.Datum> filteredService = [];

  void applySearch(String query) {
    final search = query.trim().toLowerCase();

    filteredService = allService.where((item) {
      final influencerName = influencerNameMap[item.infId] ?? '';

      final amount = item.amount?.toLowerCase() ?? '';
      final priority = item.priority?.toString() ?? '';
      final isPromoteMatch =
          item.isPromote == true && 'promoted'.contains(search);

      return search.isEmpty ||
          influencerName.toLowerCase().contains(search) ||
          amount.contains(search) ||
          priority.contains(search) ||
          isPromoteMatch;
    }).toList();

    refreshBanner(); // ✅ important
  }
}
