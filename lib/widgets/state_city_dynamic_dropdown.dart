import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class StateCityDynamicDropdown extends StatefulWidget {
  final bool showCity;
  final bool multi;
  final String? initialState;
  final String? initialCity;
  final List<String>? initialCities;

  final Function(String) onStateChanged;
  final Function(String?)? onCityChanged;
  final Function(List<String>)? onCitiesChanged;
  final Function(String?)? onChangeId;

  final Function(List<CityModel>)? onCitiesLoaded; // 🔥 ADDED

  final String? Function(dynamic)? stateValidator;
  final String? Function(dynamic)? cityValidator;

  final bool? isCityError;
  final bool? isStateError;
  final bool? isVertical;

  final List<String>? states;
  final List<CityModel>? cities;

  const StateCityDynamicDropdown({
    super.key,
    this.showCity = false,
    this.multi = false,
    this.initialState,
    this.initialCity,
    this.initialCities,
    required this.onStateChanged,
    this.onCityChanged,
    this.onCitiesChanged,
    this.onChangeId,
    this.onCitiesLoaded, // 🔥 ADDED
    this.cityValidator,
    this.stateValidator,
    this.isCityError = false,
    this.isStateError = false,
    this.isVertical = false,
    this.states,
    this.cities,
  });

  @override
  State<StateCityDynamicDropdown> createState() =>
      _StateCityDynamicDropdownState();
}

class _StateCityDynamicDropdownState extends State<StateCityDynamicDropdown> {
  List<CityModel> cities = [];
  List<String> states = [];

  String? selectedState;
  String? selectedCity;
  List<String> selectedCities = [];

  String? selectedStateId;

  @override
  void initState() {
    super.initState();

    if (widget.states != null && widget.states!.isNotEmpty) {
      states = widget.states!;
      cities = widget.cities ?? [];

      widget.onCitiesLoaded?.call(cities); // 🔥 ADDED

      _setInitialValues();
    } else {
      loadCities();
    }
  }

  void _setInitialValues() {
    setState(() {
      selectedState = widget.initialState;
      selectedCity = widget.initialCity;
      selectedCities = widget.initialCities ?? [];
    });
  }

  Future<void> loadCities() async {
    final String data = await rootBundle.loadString('assets/json/cities.json');
    final List jsonData = json.decode(data);

    cities = jsonData.map((e) => CityModel.fromJson(e)).toList();
    states = cities.map((e) => e.state).toSet().toList();

    widget.onCitiesLoaded?.call(cities); // 🔥 ADDED

    _setInitialValues();
  }

  List<String> getCitiesByState(String state) {
    if (cities.isEmpty) return [];
    return cities.where((c) => c.state == state).map((c) => c.name).toList();
  }

  CityModel? getCityByName(String name) {
    try {
      return cities.firstWhere((c) => c.name == name);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVertical == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// STATE
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
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                    selectedCity = null;
                    selectedCities = [];
                  });

                  if (value != null) widget.onStateChanged(value);
                },
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: "Select State",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    fillColor: white.withOpacity(0.5),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),

              if (widget.showCity) ...[
                const SizedBox(height: 16),

                /// CITY
                widget.multi
                    ? DropdownSearch<String>.multiSelection(
                        selectedItems: selectedCities,

                        items: (String filter, LoadProps? props) {
                          if (selectedState == null) return [];
                          return getCitiesByState(selectedState!);
                        },

                        onChanged: (values) {
                          setState(() => selectedCities = values);
                          widget.onCitiesChanged?.call(values);
                        },

                        /// ✅ UI display control (NOT data change)
                        dropdownBuilder: (context, selectedItems) {
                          if (selectedItems.isEmpty) {
                            return const Text("Select City");
                          }

                          if (selectedItems.contains("All")) {
                            return const Text("All");
                          }

                          final display = selectedItems.length <= 2
                              ? selectedItems.join(", ")
                              : "${selectedItems.take(2).join(", ")} +${selectedItems.length - 2} more";

                          return Text(
                            display,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            fillColor: white.withOpacity(0.5),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                        ),
                      )
                    : DropdownSearch<String>(
                        selectedItem: selectedCity,
                        items: (String filter, LoadProps? props) {
                          if (selectedState == null) return [];
                          return getCitiesByState(selectedState!);
                        },
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            hintText: "Select State",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            fillColor: white.withOpacity(0.5),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                        ),
                        onChanged: (value) {
                          final city = getCityByName(value ?? "");

                          setState(() {
                            selectedCity = value;
                            selectedStateId = city?.id;
                          });

                          widget.onCityChanged?.call(value);
                          widget.onChangeId?.call(city?.id);
                        },
                      ),
              ]
            ],
          )
        : Row(
            children: [
              Expanded(child: _buildState()),
              if (widget.showCity) const SizedBox(width: 16),
              if (widget.showCity)
                Expanded(
                  child: widget.multi
                      ? DropdownSearch<String>.multiSelection(
                          selectedItems: selectedCities,

                          items: (String filter, LoadProps? props) {
                            if (selectedState == null) return [];
                            return getCitiesByState(selectedState!);
                          },

                          onChanged: (values) {
                            setState(() => selectedCities = values);
                            widget.onCitiesChanged?.call(values);
                          },

                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              hintText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              fillColor: white.withOpacity(0.7),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),

                          /// ✅ UI display control (NOT data change)
                          dropdownBuilder: (context, selectedItems) {
                            if (selectedItems.isEmpty) {
                              return const Text("Select City");
                            }

                            if (selectedItems.contains("All")) {
                              return const Text("All");
                            }

                            final display = selectedItems.length <= 2
                                ? selectedItems.join(", ")
                                : "${selectedItems.take(2).join(", ")} +${selectedItems.length - 2} more";

                            return Text(
                              display,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        )
                      : _buildCity(),
                ),
            ],
          );
  }

  Widget _buildState() => DropdownSearch<String>(
        selectedItem: selectedState,
        items: (f, p) => states,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            hintText: "",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: white.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: white.withOpacity(0.7),
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        onChanged: (v) {
          setState(() {
            selectedState = v;
            selectedCity = null;
            selectedCities = [];
          });
          if (v != null) widget.onStateChanged(v);
        },
      );

  Widget _buildCity() => DropdownSearch<String>(
        selectedItem: selectedCity,
        items: (f, p) => getCitiesByState(selectedState ?? ''),
        onChanged: (v) {
          setState(() => selectedCity = v);
          widget.onCityChanged?.call(v);
        },
      );
}

String formatSelectedCities(List<String> cities) {
  if (cities.isEmpty) return "Select City";
  if (cities.contains("All")) return "All";

  if (cities.length <= 2) {
    return cities.join(", ");
  }

  final firstTwo = cities.take(2).join(", ");
  final remaining = cities.length - 2;

  return "$firstTwo +$remaining more";
}
