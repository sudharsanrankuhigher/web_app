import 'package:flutter/material.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/state_city_dynamic_dropdown.dart';

class AddressDialog extends StatefulWidget {
  final List<String> states;
  final bool isView;
  final bool isEdit;
  final bool multi; // 🔥 NEW
  final Map<String, dynamic>? initialData;

  final void Function({
    required String state,
    required CityModel city,
    required String phone,
    required bool isHeadoffice,
  })? onSave;

  final void Function({
    required String state,
    required List<CityModel> cities,
    required String phone,
    required bool isHeadoffice,
  })? onSaveMulti; // 🔥 NEW

  const AddressDialog({
    super.key,
    required this.states,
    this.onSave,
    this.onSaveMulti,
    this.isView = false,
    this.isEdit = false,
    this.multi = false,
    this.initialData,
  });

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  String? selectedState;
  String? selectedCity;
  List<String> selectedCities = []; // 🔥 NEW
  bool isHeadoffice = false; // 🔥 NEW

  String? selectedId;

  bool isStateError = false;
  bool isCityError = false;

  List<CityModel> cities = []; // 🔥 IMPORTANT

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    setState(() {
      isStateError = selectedState == null;

      // 🔥 handle both cases
      isCityError = isHeadoffice
          ? false
          : (widget.multi ? selectedCities.isEmpty : selectedCity == null);
    });

    if (!_formKey.currentState!.validate() ||
        selectedState == null ||
        (!isHeadoffice && isCityError)) {
      return;
    }

    /// ================= MULTI SELECT =================
    if (widget.multi) {
      final selectedCityModels = isHeadoffice
          ? <CityModel>[]
          : cities.where((c) => selectedCities.contains(c.name)).toList();

      /// 🔥 DEBUG PRINT
      print("Selected Cities:");
      for (var city in selectedCityModels) {
        print("${city.id} - ${city.name}");
      }

      /// 🔥 API FORMAT
      final body = {
        "state": selectedState,
        "city_ids": selectedCityModels.map((e) => e.id).toList(),
        "phone": _phoneController.text.trim(),
        "isheadoffice": isHeadoffice,
      };

      print("API BODY (MULTI): $body");

      /// 🔥 CALLBACK
      widget.onSaveMulti?.call(
        state: selectedState!,
        cities: selectedCityModels,
        phone: _phoneController.text.trim(),
        isHeadoffice: isHeadoffice,
      );
    }

    /// ================= SINGLE SELECT =================
    else {
      final cityModel = isHeadoffice
          ? null
          : cities.firstWhere(
              (c) => c.name == selectedCity,
              orElse: () => CityModel(id: '', name: '', state: ''),
            );

      /// 🔥 CALLBACK
      widget.onSave!(
        state: selectedState!,
        city: cityModel ?? CityModel(id: '', name: '', state: ''),
        phone: _phoneController.text.trim(),
        isHeadoffice: isHeadoffice,
      );
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    if (widget.initialData != null) {
      selectedState = widget.initialData!['state'];
      isHeadoffice = widget.initialData!['isheadoffice'] ?? false;

      /// 🔥 FIX CITY LIST
      final cityData = widget.initialData!['city'];
      selectedCities = cityData == null
          ? []
          : List<String>.from(
              (cityData as List).map((e) => e['name'].toString()),
            );

      /// optional single city fallback
      selectedCity = selectedCities.isNotEmpty ? selectedCities.first : null;
      selectedId = widget.initialData!['code'];
      _phoneController.text = widget.initialData!['mobile_number'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          minWidth: 400,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  widget.isView == true
                      ? "View Address"
                      : widget.isEdit == true
                          ? "Edit Address"
                          : "Add Address",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// TOGGLE HEAD OFFICE
                SwitchListTile(
                  title: Text(
                    "Is Head Office",
                    style: fontFamilyMedium.size13.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  value: isHeadoffice,
                  activeColor: continueButton,
                  contentPadding: EdgeInsets.zero,
                  onChanged: widget.isView
                      ? null
                      : (val) {
                          setState(() {
                            isHeadoffice = val;
                            if (isHeadoffice) {
                              selectedCity = null;
                              selectedCities = [];
                              isCityError = false;
                            }
                          });
                        },
                ),

                const SizedBox(height: 10),

                /// STATE & CITY
                IgnorePointer(
                    ignoring: widget.isView == true ? true : false,
                    child: StateCityDynamicDropdown(
                      showCity: !isHeadoffice,
                      multi: widget.multi,
                      initialCities: selectedCities,
                      states: widget.states,
                      initialState: selectedState,
                      initialCity: selectedCity,
                      isStateError: isStateError,
                      isCityError: isCityError,

                      /// 🔥 ADD THIS (MULTI VALUES)
                      onCitiesChanged: (list) {
                        setState(() {
                          selectedCities = list;
                          isCityError = false;
                        });
                      },

                      /// 🔥 ADD THIS (FULL CITY DATA)
                      onCitiesLoaded: (list) {
                        cities = list;
                        print("Loaded cities count: ${cities.length}");
                      },

                      onStateChanged: (state) {
                        setState(() {
                          selectedState = state;
                          selectedCity = null;
                          selectedCities = []; // 🔥 reset multi
                          selectedId = null;
                          isStateError = false;
                        });
                      },

                      onCityChanged: (city) {
                        setState(() {
                          selectedCity = city;
                          isCityError = false;
                        });
                      },

                      onChangeId: (id) {
                        selectedId = id;
                      },
                    )),

                const SizedBox(height: 16),

                /// PHONE NUMBER
                IgnorePointer(
                  ignoring: widget.isView == true ? true : false,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Phone number required";
                      }
                      if (v.length != 10) {
                        return "Enter valid phone number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                      counterText: "",
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF334155)
                          : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child:
                            Text((widget.isView == true) ? "Close" : "Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (!widget.isView)
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(continueButton)),
                          onPressed: _onSave,
                          child: Text(
                            widget.isEdit == true ? "Update" : "Save",
                            style: fontFamilySemiBold.size13.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
