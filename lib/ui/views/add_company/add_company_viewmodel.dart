import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/add_company/model/company_model.dart'
    as company_model;
import 'package:webapp/ui/views/add_company/widgets/add_edit_company_dialog.dart';
import 'package:webapp/ui/views/add_company/widgets/company_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class AddCompanyViewModel extends BaseViewModel {
  AddCompanyViewModel() {
    loadCompany();
  }

  List<company_model.Datum> companies = [];
  late CompanyTableSource tableSource;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  String? _cityValue;
  String? _stateValue = "Tamil Nadu";

  String? get cityValue => _cityValue;
  String? get stateValue => _stateValue;

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final companyColumn = const [
    DataColumn(
      label: Text("S.No"),
    ),
    DataColumn(
        label: Text("Image"), headingRowAlignment: MainAxisAlignment.center),
    DataColumn(label: Text("Company Name")),
    DataColumn(label: Text("Client Name")),
    DataColumn(label: Text("phone")),
    DataColumn(label: Text("Alt phone")),
    DataColumn(label: Text("city/state")),
    DataColumn(label: Text("GST no")),
    DataColumn(label: Text("project count")),
    DataColumn(
        label: Text("Action"), headingRowAlignment: MainAxisAlignment.center),
  ];

  String? cityName;

  void setState(state) {
    _stateValue = state;
    notifyListeners();
  }

  void setCity(city) {
    _cityValue = city;
    notifyListeners();
  }

  Future<void> loadCompany() async {
    _setLoading(true);

    try {
      final res = await _apiService.getCompany();
      companies = res.data ?? [];
      allCompany = List.from(companies);
      filteredCompany = List.from(companies);
    } catch (e) {
      companies = [];
    } finally {
      _refreshTable(filtered: companies);
      _setLoading(false);
    }

    tableSource = CompanyTableSource(
      companies: companies,
      onView: (company) => viewPlan(
        StackedService.navigatorKey!.currentContext!,
        company,
      ),
    );

    notifyListeners();
  }

  Future<void> saveOrUpdate(FormData formData) async {
    _setLoading(true);

    try {
      // Just call API — no indexWhere on companies needed
      await _apiService.addCompany(formData);

      // Reload table after API call
      await loadCompany();
      _refreshTable();
    } catch (e, stack) {
      debugPrint("Error saving/updating company: $e");
      debugPrint("$stack");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void deletePlan(company_model.Datum plan) {
    companies.remove(plan);
    _refreshTable();
  }

  void _refreshTable({filtered}) {
    tableSource = CompanyTableSource(
      companies: filtered ?? companies,
      onView: (company) => viewPlan(
        StackedService.navigatorKey!.currentContext!,
        company,
      ),
    );
    notifyListeners();
  }

  // 🔥 Add Plan
  Future<void> addCompany() async {
    final result = await AddEditCompanyPage.show(
      vm: this,
      StackedService.navigatorKey!.currentContext!,
    );

    if (result == null) return;

    final formData = FormData();

    // ---------- Add text fields ----------
    void addField(String key, dynamic value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    addField("id", result['id']);
    addField("company_name", result['companyName']);
    addField("phone", result['phone']);
    addField("gst_no", result['gstNo']);
    addField("client_name", result['clientName']);
    addField("alt_phone_no", result['altPhone']);
    addField("city", result['city']);
    addField("state", result['state']);
    addField("project_count", result['projectCount']);

    // ---------- Add image ----------
    final bytes = result['imageBytes'];
    final existingImage = result['existing_image'];

    if (bytes != null) {
      // Web upload
      formData.files.add(
        MapEntry(
          "company_image",
          MultipartFile.fromBytes(bytes, filename: "company.png"),
        ),
      );
    } else if (existingImage != null) {
      // send existing image reference (backend expects this)
      addField("existing_image", existingImage);
    }

    // ---------- Save / update ----------
    await saveOrUpdate(formData);
  }

  // 🔥 View Plan
  Future<void> viewPlan(
    BuildContext context,
    company_model.Datum company,
  ) async {
    final result = await AddEditCompanyPage.show(
      context,
      initial: company,
      vm: this,
    );
    if (result == null) return;

    final formData = FormData();

    // ---------- Helper to add fields ----------
    void addField(String key, dynamic value) {
      if (value != null) formData.fields.add(MapEntry(key, value.toString()));
    }

    addField("id", company.id);
    addField("company_name", result['companyName']);
    addField("client_name", result['clientName']);
    addField("phone", result['phone']);
    addField("alt_phone_no", result['altPhone']);
    addField("gst_no", result['gstNo']);
    addField("state", result['state']);
    addField("city", result['city']);
    addField("project_count", result['projectCount']);

    // ---------- Handle image ----------
    if (result['imageBytes'] != null) {
      // Web upload
      formData.files.add(
        MapEntry(
          "company_image",
          MultipartFile.fromBytes(
            result['imageBytes'],
            filename: "company.png",
          ),
        ),
      );
    } else if (result['existing_image'] != null) {
      // send existing image reference
      addField("existing_image", result['existing_image']);
    }

    // ---------- Call saveOrUpdate ----------
    await saveOrUpdate(formData);
  }

  void confirmDelete(BuildContext context, company_model.Datum company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content:
            Text("Are you sure you want to delete ${company.companyName}?"),
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
              deletePlan(company);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      companies.sort((a, b) => a.companyName!.compareTo(b.companyName!));
    } else if (sortType == "clientAsc") {
      companies.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      companies.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      companies.sort((a, b) {
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

  List<company_model.Datum> allCompany = [];
  List<company_model.Datum> filteredCompany = [];

  void applySearch(String query) {
    final search = query.trim().toLowerCase();

    filteredCompany = allCompany.where((item) {
      if (search.isEmpty) return true;

      return (item.companyName?.toLowerCase().contains(search) ?? false) ||
          (item.clientName?.toLowerCase().contains(search) ?? false) ||
          (item.city?.toLowerCase().contains(search) ?? false) ||
          (item.gstNo?.toLowerCase().contains(search) ?? false) ||
          (item.altPhoneNo?.toLowerCase().contains(search) ?? false) ||
          (item.phone?.toLowerCase().contains(search) ?? false);
    }).toList();

    _refreshTable(filtered: filteredCompany);
    notifyListeners();
  }
}
