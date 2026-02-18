import 'package:flutter/material.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class AddressDialog extends StatefulWidget {
  final List<String> states;
  final bool isView;
  final bool isEdit;
  final Map<String, dynamic>? initialData;

  final void Function({
    required String state,
    required CityModel city,
    required String phone,
  }) onSave;

  const AddressDialog({
    super.key,
    required this.states,
    required this.onSave,
    this.isView = false,
    this.isEdit = false,
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

  bool isStateError = false;
  bool isCityError = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    setState(() {
      isStateError = selectedState == null;
      isCityError = selectedCity == null;
    });

    if (_formKey.currentState!.validate() &&
        selectedState != null &&
        selectedCity != null) {
      widget.onSave(
        state: selectedState!,
        city: CityModel(
          id: "1",
          name: selectedCity!,
          state: selectedState!,
        ),
        phone: _phoneController.text.trim(),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
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
                const Text(
                  "Add Address",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// STATE & CITY
                StateCityDropdown(
                  showCity: true,
                  states: widget.states,
                  initialState: selectedState,
                  initialCity: selectedCity,
                  isStateError: isStateError,
                  isCityError: isCityError,
                  onStateChanged: (state) {
                    setState(() {
                      selectedState = state;
                      selectedCity = null;
                      isStateError = false;
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      selectedCity = city;

                      isCityError = false;
                    });
                  },
                ),

                const SizedBox(height: 16),

                /// PHONE NUMBER
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
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
                    prefixIcon: const Icon(Icons.phone),
                    counterText: "",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSave,
                        child: const Text("Save"),
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
