import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/add_company/model/company_model.dart';
import 'package:webapp/ui/views/add_company/widgets/add_edit_company_dialog.dart';
import 'package:webapp/ui/views/add_company/widgets/company_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class AddCompanyViewModel extends BaseViewModel {
  AddCompanyViewModel() {
    loadCompany();
  }

  List<CompanyModel> companies = [];
  late CompanyTableSource tableSource;
  String? _cityValue;
  String? _stateValue = "Tamil Nadu";

  String? get cityValue => _cityValue;
  String? get stateValue => _stateValue;

  final companyColumn = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Image")),
    DataColumn(label: Text("Company Name")),
    DataColumn(label: Text("Client Name")),
    DataColumn(label: Text("phone")),
    DataColumn(label: Text("Alt phone")),
    DataColumn(label: Text("city/state")),
    DataColumn(label: Text("GST no")),
    DataColumn(label: Text("project count")),
    DataColumn(label: Text("Action")),
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

  void loadCompany() {
    companies = [
      CompanyModel(
        id: 1,
        companyImage:
            "data:image/jpeg;base64,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",
        alterNativePhone: "9876543210",
        city: "Coimbatore",
        clientName: "ABC Company",
        gstNo: "1234567890",
        phone: "9876543210",
        companyName: "ABC Company",
        projectCount: 5,
        state: "Tamil Nadu",
      ),
      CompanyModel(
        id: 2,
        companyImage: "https://share.google/33LuU0hsxx1qSINTa",
        alterNativePhone: "9876543210",
        city: "Chennai",
        clientName: "ABCd Company",
        gstNo: "7234567890",
        phone: "9876543710",
        companyName: "ABC Company",
        projectCount: 3,
        state: "Tamil Nadu",
      ),
      CompanyModel(
        id: 3,
        companyImage: "https://share.google/33LuU0hsxx1qSINTa",
        alterNativePhone: "9876743210",
        city: "Salem",
        clientName: "XYZ Company",
        gstNo: "7234567890",
        phone: "9876543710",
        companyName: "XYZ Company",
        projectCount: 8,
        state: "Tamil Nadu",
      ),
    ];
    _refreshTable();
  }

  void saveOrUpdate(CompanyModel state) {
    final index = companies.indexWhere((p) => p.id == state.id);
    if (index >= 0) {
      companies[index] = state;
    } else {
      companies.add(state);
    }
    _refreshTable();
  }

  void deletePlan(CompanyModel plan) {
    companies.remove(plan);
    _refreshTable();
  }

  void _refreshTable() {
    tableSource = CompanyTableSource(
      companies: companies,
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
        StackedService.navigatorKey!.currentContext!);
    if (result != null) {
      final newCompany = CompanyModel(
          companyName: result['companyName'],
          phone: result['phone'],
          gstNo: result['gstNo'],
          clientName: result['clientName'],
          alterNativePhone: result['alterNativePhone'],
          city: result['city'],
          state: result['state'],
          projectCount: result['projectCount']);

      saveOrUpdate(newCompany);
    }
  }

  // 🔥 View Plan
  Future<void> viewPlan(BuildContext context, CompanyModel company) async {
    final result = await AddEditCompanyPage.show(
      context,
      initial: company,
    );
    if (result == null) return;

    final updatedCompany = CompanyModel(
      id: company.id,
      companyName: result['companyName'],
      clientName: result['clientName'],
      phone: result['phone'],
      alterNativePhone: result['alterNativePhone'],
      gstNo: result['gstNo'],
      state: result['state'],
      city: result['city'],
      projectCount: int.parse(result['projectCount'].toString()),
      companyImage: result['companyImage'] ?? company.companyImage,
    );

    saveOrUpdate(updatedCompany);
  }

  void confirmDelete(BuildContext context, CompanyModel company) {
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
    //   if (sortType == "A-Z") {
    //     plans.sort((a, b) => a.planName.compareTo(b.planName));
    //   } else if (sortType == "clientAsc")
    //     plans.sort((a, b) => a.id.compareTo(b.id));
    //   _refreshTable();
  }
}
