import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as StateModel;

class StateCityDropdownWidget extends StatefulWidget {
  final List<StateModel.Datum> states; // API states
  final bool showCity;
  final int? initialStateId;
  final String? initialCityId;
  final String? initialCityName;
  final bool isStateError;
  final bool isCityError;
  final Function(int stateId) onStateChanged;
  final Function(String? cityId)? onCityChanged;
  final String? Function(dynamic?)? stateValidator;
  final String? Function(dynamic?)? cityValidator;
  final bool? isVertical;

  const StateCityDropdownWidget({
    super.key,
    required this.states,
    required this.onStateChanged,
    this.onCityChanged,
    this.initialCityName,
    this.showCity = false,
    this.initialStateId,
    this.initialCityId,
    this.isStateError = false,
    this.isCityError = false,
    this.stateValidator,
    this.cityValidator,
    this.isVertical = false,
  });

  @override
  State<StateCityDropdownWidget> createState() =>
      _StateCityDropdownWidgetState();
}

class _StateCityDropdownWidgetState extends State<StateCityDropdownWidget> {
  StateModel.Datum? selectedState;
  CityModel? selectedCity;

  List<CityModel> allCities = [];
  List<CityModel> filteredCities = [];

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    // Load JSON cities
    final String data = await rootBundle.loadString('assets/json/cities.json');
    final List jsonData = json.decode(data);
    allCities = jsonData.map((e) => CityModel.fromJson(e)).toList();

    // ---------------- Set initial state ----------------
    if (widget.initialStateId != null) {
      selectedState =
          widget.states.firstWhereOrNull((s) => s.id == widget.initialStateId);
    }

    // ---------------- Filter cities ----------------
    if (selectedState != null) {
      _filterCities(selectedState!.name!);
    }

    // ---------------- Set initial city by name ----------------
    if (widget.initialCityId != null || widget.initialCityName != null) {
      // Search by ID first
      if (widget.initialCityId != null) {
        selectedCity = allCities
            .firstWhereOrNull((c) => c.id == widget.initialCityId.toString());
      }

      // If not found by ID or you want to select by city name
      if (selectedCity == null && widget.initialCityName != null) {
        selectedCity = allCities.firstWhereOrNull((c) =>
            c.name!.toLowerCase().trim() ==
            widget.initialCityName!.toLowerCase().trim());
      }

      // Ensure selected city is in filteredCities
      if (selectedCity != null &&
          !filteredCities.any((c) => c.id == selectedCity!.id)) {
        filteredCities.add(selectedCity!);
      }
    }

    setState(() {
      isInitialized = true;
    });
  }

  void _filterCities(String stateName) {
    final normalized = stateName.toLowerCase().trim().replaceAll(' ', '');
    filteredCities = allCities.where((c) {
      final cityState = c.state.toLowerCase().trim().replaceAll(' ', '');
      return cityState == normalized;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading until initial state/city are set
    if (!isInitialized) {
      return const SizedBox(
          height: 60, child: Center(child: CircularProgressIndicator()));
    }

    return widget.isVertical == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- STATE DROPDOWN ----------------
              DropdownSearch<StateModel.Datum>(
                selectedItem: selectedState,
                compareFn: (a, b) => a.id == b.id,
                validator: widget.stateValidator,
                items: (String filter, LoadProps? _) {
                  final search = filter.toLowerCase().replaceAll(' ', '');
                  return widget.states.where((s) {
                    final name =
                        s.name?.toLowerCase().replaceAll(' ', '') ?? '';
                    return search.isEmpty || name.contains(search);
                  }).toList();
                },
                itemAsString: (s) => s.name!,
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  constraints: BoxConstraints(maxHeight: 300),
                ),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "State",
                    filled: true,
                    fillColor: Colors.white,
                    errorText: widget.isStateError ? "Select state" : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onChanged: (state) {
                  setState(() {
                    selectedState = state;
                    selectedCity = null;
                    if (state != null) _filterCities(state.name!);
                  });
                  if (state != null) widget.onStateChanged(state.id!);
                },
              ),

              if (widget.showCity) ...[
                const SizedBox(height: 16),

                // ---------------- CITY DROPDOWN ----------------
                DropdownSearch<CityModel>(
                  selectedItem: selectedCity,
                  compareFn: (a, b) => a.id == b.id,
                  validator: widget.cityValidator,
                  items: (String filter, LoadProps? _) {
                    if (selectedState == null) return [];
                    final search = filter.toLowerCase().replaceAll(' ', '');
                    return filteredCities.where((c) {
                      final name = c.name.toLowerCase().replaceAll(' ', '');
                      return search.isEmpty || name.contains(search);
                    }).toList();
                  },
                  itemAsString: (c) => c.name,
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    constraints: BoxConstraints(maxHeight: 300),
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: "City",
                      filled: true,
                      fillColor: Colors.white,
                      errorText: widget.isCityError ? "Select city" : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onChanged: (city) {
                    setState(() => selectedCity = city);
                    widget.onCityChanged?.call(city?.name);
                  },
                ),
              ],
            ],
          )
        : Row(children: [
            DropdownSearch<StateModel.Datum>(
              selectedItem: selectedState,
              compareFn: (a, b) => a.id == b.id,
              validator: widget.stateValidator,
              items: (String filter, LoadProps? _) {
                final search = filter.toLowerCase().replaceAll(' ', '');
                return widget.states.where((s) {
                  final name = s.name?.toLowerCase().replaceAll(' ', '') ?? '';
                  return search.isEmpty || name.contains(search);
                }).toList();
              },
              itemAsString: (s) => s.name!,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                constraints: BoxConstraints(maxHeight: 300),
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "State",
                  filled: true,
                  fillColor: Colors.white,
                  errorText: widget.isStateError ? "Select state" : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onChanged: (state) {
                setState(() {
                  selectedState = state;
                  selectedCity = null;
                  if (state != null) _filterCities(state.name!);
                });
                if (state != null) widget.onStateChanged(state.id!);
              },
            ),
            if (widget.showCity) ...[
              const SizedBox(height: 16),

              // ---------------- CITY DROPDOWN ----------------
              DropdownSearch<CityModel>(
                selectedItem: selectedCity,
                compareFn: (a, b) => a.id == b.id,
                validator: widget.cityValidator,
                items: (String filter, LoadProps? _) {
                  if (selectedState == null) return [];
                  final search = filter.toLowerCase().replaceAll(' ', '');
                  return filteredCities.where((c) {
                    final name = c.name.toLowerCase().replaceAll(' ', '');
                    return search.isEmpty || name.contains(search);
                  }).toList();
                },
                itemAsString: (c) => c.name,
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  constraints: BoxConstraints(maxHeight: 300),
                ),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "City",
                    filled: true,
                    fillColor: Colors.white,
                    errorText: widget.isCityError ? "Select city" : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onChanged: (city) {
                  setState(() => selectedCity = city);
                  widget.onCityChanged?.call(city?.name);
                },
              ),
            ],
          ]);
  }
}
