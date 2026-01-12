import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class StateCityDropdown extends StatefulWidget {
  final bool showCity;
  final String? initialState;
  final String? initialCity;
  final Function(String) onStateChanged;
  final Function(String?)? onCityChanged;
  final String? Function(dynamic?)? stateValidator;
  final String? Function(dynamic?)? cityValidator;
  final bool? isCityError;
  final bool? isStateError;
  final bool? isVertical;

  final List<String>? states;
  final List<CityModel>? cities;

  const StateCityDropdown({
    super.key,
    this.showCity = false,
    this.initialState,
    this.initialCity,
    required this.onStateChanged,
    this.onCityChanged,
    this.cityValidator,
    this.stateValidator,
    this.isCityError = false,
    this.isStateError = false,
    this.isVertical = false,
    this.states,
    this.cities,
  });

  @override
  State<StateCityDropdown> createState() => _StateCityDropdownState();
}

class _StateCityDropdownState extends State<StateCityDropdown> {
  List<CityModel> cities = [];
  List<String> states = [];
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    if (widget.states != null && widget.states!.isNotEmpty) {
      /// 🔥 External states provided
      states = widget.states!;
      cities = widget.cities ?? [];
      _setInitialValues();
    } else {
      /// 🔥 Fallback to asset JSON
      loadCities();
    }
  }

  void _setInitialValues() {
    setState(() {
      selectedState = widget.initialState;
      selectedCity = widget.initialCity;
    });
  }

  Future<void> loadCities() async {
    final String data = await rootBundle.loadString('assets/json/cities.json');
    final List jsonData = json.decode(data);

    cities = jsonData.map((e) => CityModel.fromJson(e)).toList();
    states = cities.map((e) => e.state).toSet().toList();

    _setInitialValues();
  }

  List<String> getCitiesByState(String state) {
    if (cities.isEmpty) return [];
    return cities.where((c) => c.state == state).map((c) => c.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVertical == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STATE DROPDOWN
              DropdownSearch<String>(
                selectedItem: selectedState,
                validator: widget.stateValidator,
                items: (String filter, LoadProps? props) async {
                  final search =
                      filter.trim().toLowerCase().replaceAll(' ', '');

                  return states.where((s) {
                    if (search.isEmpty) return true;
                    return s.toLowerCase().replaceAll(' ', '').contains(search);
                  }).toList();
                },
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem ?? "",
                  style: fontFamilyMedium.size12.black,
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, String item, bool isSelected, bool _) {
                    return ListTile(
                      title: Text(item),
                      selected: isSelected,
                    );
                  },
                ),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    fillColor: backgroundColor,
                    filled: true,
                    labelText: "State",
                    labelStyle: fontFamilyMedium.size12.greyColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.isStateError == true
                            ? Colors.red
                            : disableColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.isStateError == true
                            ? Colors.red
                            : Colors.blue,
                        width: 2,
                      ),
                    ),
                    errorText: widget.isStateError == true
                        ? "Please select a states"
                        : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                    if (widget.showCity) selectedCity = null;
                  });

                  if (value != null) widget.onStateChanged(value);
                },
              ),

              if (widget.showCity) ...[
                const SizedBox(height: 16),
                DropdownSearch<String>(
                  selectedItem: selectedCity,
                  validator: widget.cityValidator,
                  items: (String filter, LoadProps? props) {
                    if (selectedState == null) return [];
                    final allCities = getCitiesByState(selectedState!);
                    return allCities
                        .where((c) =>
                            filter.isEmpty ||
                            c.toLowerCase().contains(filter.toLowerCase()))
                        .toList();
                  },
                  dropdownBuilder: (context, selectedItem) => Text(
                    selectedItem ?? "",
                    style: fontFamilyMedium.size12.black,
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    itemBuilder:
                        (context, String item, bool isSelected, bool _) {
                      return ListTile(
                        title: Text(item),
                        selected: isSelected,
                      );
                    },
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      fillColor: backgroundColor,
                      filled: true,
                      labelText: "City",
                      labelStyle: fontFamilyMedium.size12.greyColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.isCityError == true
                              ? Colors.red
                              : disableColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.isCityError == true
                              ? Colors.red
                              : Colors.blue,
                          width: 2,
                        ),
                      ),
                      errorText: widget.isCityError == true
                          ? "Please select a City"
                          : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });

                    if (widget.onCityChanged != null) {
                      widget.onCityChanged!(value);
                    }
                  },
                )
              ]
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= STATE DROPDOWN =================
              Expanded(
                child: DropdownSearch<String>(
                  selectedItem: selectedState,
                  validator: widget.stateValidator,
                  items: (String filter, LoadProps? props) async {
                    final search =
                        filter.trim().toLowerCase().replaceAll(' ', '');

                    return states.where((s) {
                      if (search.isEmpty) return true;
                      return s
                          .toLowerCase()
                          .replaceAll(' ', '')
                          .contains(search);
                    }).toList();
                  },
                  dropdownBuilder: (context, selectedItem) => Text(
                    selectedItem ?? "",
                    style: fontFamilyMedium.size12.black,
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    itemBuilder:
                        (context, String item, bool isSelected, bool _) {
                      return ListTile(
                        title: Text(item),
                        selected: isSelected,
                      );
                    },
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: "State",
                      labelStyle: fontFamilyMedium.size12.greyColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.isStateError == true
                              ? Colors.red
                              : disableColor,
                        ),
                      ),
                      fillColor: backgroundColor,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.isStateError == true
                              ? Colors.red
                              : Colors.blue,
                          width: 2,
                        ),
                      ),
                      errorText: widget.isStateError == true
                          ? "Please select a states"
                          : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                      if (widget.showCity) selectedCity = null;
                    });

                    if (value != null) widget.onStateChanged(value);
                  },
                ),
              ),

              // ================= SPACE BETWEEN DROPDOWNS =================
              if (widget.showCity) const SizedBox(width: 16),

              // ================= CITY DROPDOWN =================
              if (widget.showCity)
                Expanded(
                  child: DropdownSearch<String>(
                    selectedItem: selectedCity,
                    validator: widget.cityValidator,
                    items: (String filter, LoadProps? props) {
                      if (selectedState == null) return [];
                      final allCities = getCitiesByState(selectedState!);
                      return allCities
                          .where((c) =>
                              filter.isEmpty ||
                              c.toLowerCase().contains(filter.toLowerCase()))
                          .toList();
                    },
                    dropdownBuilder: (context, selectedItem) => Text(
                      selectedItem ?? "",
                      style: fontFamilyMedium.size12.black,
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder:
                          (context, String item, bool isSelected, bool _) {
                        return ListTile(
                          title: Text(item),
                          selected: isSelected,
                        );
                      },
                    ),
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "City",
                        labelStyle: fontFamilyMedium.size12.greyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: widget.isCityError == true
                                ? Colors.red
                                : disableColor,
                          ),
                        ),
                        fillColor: backgroundColor,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: widget.isCityError == true
                                ? Colors.red
                                : Colors.blue,
                            width: 2,
                          ),
                        ),
                        errorText: widget.isCityError == true
                            ? "Please select a City"
                            : null,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });

                      if (widget.onCityChanged != null) {
                        widget.onCityChanged!(value);
                      }
                    },
                  ),
                ),
            ],
          );
  }
}
