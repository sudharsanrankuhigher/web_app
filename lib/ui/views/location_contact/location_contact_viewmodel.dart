import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/location_contact/models/location_contact_model.dart'
    as contact;
import 'package:webapp/ui/views/location_contact/widgets/common_add_edit_dialog.dart';
import 'package:webapp/ui/views/location_contact/widgets/contact_table_source.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as StateModel;

class LocationContactViewModel extends BaseViewModel with NavigationMixin {
  LocationContactViewModel() {
    loadContacts();
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<contact.Datum> contacts = [];
  late ContactTableSource tableSource;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _stateValue = "Search by Selected State";
  String? get stateValue => _stateValue;

  void setState(state) {
    _stateValue = state;
    print("state $_stateValue");
    searchPlans(_stateValue!);
    notifyListeners();
  }

  void clearChip() {
    _stateValue = "Search by Selected State";
    searchPlans('');
    notifyListeners();
  }

  /// 🔥 MASTER STATE LIST (load once)
  List<StateModel.Datum> allStates = [];

  // ------------------------------------------------------------
  // INITIAL LOAD
  // ------------------------------------------------------------
  Future<void> loadContacts() async {
    setBusy(true);
    _setLoading(true);
    try {
      final res = await _apiService.getLocationContact();
      contacts = res.data ?? [];
    } catch (e) {
      contacts = [];
    } finally {
      _refreshTable(filtered: contacts);
      _setLoading(false);
      setBusy(false);
    }
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------
  void searchContacts(String query) {
    final filtered = contacts.where((c) {
      return c.state!.toLowerCase().contains(query.toLowerCase()) ||
          c.city!.toLowerCase().contains(query.toLowerCase()) ||
          c.code!.contains(query);
    }).toList();

    // _refreshTable(filtered: filtered);
  }

  // ------------------------------------------------------------
  // ADD CONTACT
  // ------------------------------------------------------------
  Future<void> addContact(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddressDialog(
        states: allStates.map((e) => e.name!).toList(),
        onSave: ({
          required String state,
          required CityModel city,
          required String phone,
          String? code,
        }) {
          final newContact = {
            "state": state,
            "city": city.name,
            "code": city.id,
            "mobile_number": phone
          };

          _saveOrUpdate(newContact);
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // EDIT CONTACT
  // ------------------------------------------------------------
  Future<void> editContact(
    BuildContext context,
    contact.Datum contact,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddressDialog(
        states: allStates.map((e) => e.name!).toList(),

        isView: false, // 🔥 View mode
        isEdit: true,
        initialData: contact.toJson(),

        onSave: ({
          required String state,
          required CityModel city,
          required String phone,
        }) {
          final updatedContact = {
            "state": state,
            "city": city.name,
            "code": city.id,
            "mobile_number": phone,
            "id": contact.id,
          };
          _saveOrUpdate(updatedContact);
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // VIEW CONTACT (READ ONLY)
  // ------------------------------------------------------------
  Future<void> viewContact(
    BuildContext context,
    contact.Datum contact,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddressDialog(
        states: allStates.map((e) => e.name!).toList(),

        isView: true, // 🔥 View mode
        isEdit: false,
        initialData: contact.toJson(),

        onSave: ({
          required String state,
          required CityModel city,
          required String phone,
        }) {
          // Not used in view mode
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // SAVE / UPDATE
  // ------------------------------------------------------------
  Future<void> _saveOrUpdate(contact) async {
    _setLoading(true);
    try {
      await _apiService.createLocationContact(contact);

      final res = await _apiService.getLocationContact();
      contacts = res.data ?? [];
      // }
    } catch (e) {
      debugPrint("Save failed: $e");
    } finally {
      _setLoading(false);
      _refreshTable(filtered: contacts);
    }
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------
  void deleteContact(contact.Datum contact) {
    _setLoading(true);
    try {
      print(contact.id!);
      final id = {
        "id": contact.id,
      };
      _apiService.deleteLocationContact(id);

      loadContacts();
      // contacts.removeWhere((c) => c.id == contact.id);
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      _refreshTable();
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // TABLE REFRESH
  // ------------------------------------------------------------
  _refreshTable({filtered}) {
    final context = StackedService.navigatorKey!.currentContext!;

    tableSource = ContactTableSource(
      contacts: filtered ?? contacts,
      onEdit: (contact) => editContact(context, contact),
      onView: (contact) => viewContact(context, contact),
      onDelete: (contact) {
        confirmDelete(context, contact);
      },
    );

    notifyListeners();
  }

  // ------------------------------------------------------------
  // CONFIRM DELETE
  // ------------------------------------------------------------
  void confirmDelete(BuildContext context, contact.Datum contact) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Delete ${contact.city}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CommonButton(
            width: 100,
            buttonColor: Colors.red,
            text: "Delete",
            textStyle: const TextStyle(color: Colors.white),
            onTap: () {
              deleteContact(contact);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// SEARCH
  void searchPlans(String query) {
    final filtered = contacts.where((p) {
      return p.state!.toLowerCase().contains(query.toLowerCase()) ||
          p.city!.toLowerCase().contains(query.toLowerCase()) ||
          p.mobileNumber.toString().contains(query);
    }).toList();

    _refreshTable(filtered: filtered);
  }

  void applySort(bool specialFilter, String sortType) {
    //   if (specialFilter) {
    //     // implement custom filter
    //   }
    if (sortType == "A-Z") {
      contacts.sort((a, b) {
        final cityCompare = a.city!.compareTo(b.city!);

        final phoneCompare = a.mobileNumber!.compareTo(b.mobileNumber!);

        if (phoneCompare != 0) {
          return phoneCompare;
        }

        if (cityCompare != 0) {
          return cityCompare;
        }

        return a.state!.compareTo(b.state!);
      });
    } else if (sortType == "clientAsc") {
      contacts.sort((a, b) => a.id!.compareTo(b.id!));
    } else if (sortType == "older") {
      contacts.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt.toString())
            : DateTime(1970);
        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt.toString())
            : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (sortType == "newer") {
      contacts.sort((a, b) {
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
