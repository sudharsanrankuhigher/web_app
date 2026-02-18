import 'package:flutter/material.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
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
  String? selectedId;

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

    print("Saving ID: $selectedId");

    if (_formKey.currentState!.validate() &&
        selectedState != null &&
        selectedCity != null) {
      widget.onSave(
        state: selectedState!,
        city: CityModel(
          name: selectedCity!,
          state: selectedState!,
          id: selectedId!,
        ),
        phone: _phoneController.text.trim(),
      );

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    if (widget.initialData != null) {
      selectedState = widget.initialData!['state'];
      selectedCity = widget.initialData!['city'];
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
                Text(
                  widget.isView == true
                      ? "View Address"
                      : widget.isEdit == true
                          ? "Edit Address"
                          : "Add Address",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// STATE & CITY
                IgnorePointer(
                  ignoring: widget.isView == true ? true : false,
                  child: StateCityDropdown(
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
                        selectedId = null; // reset id when state changes

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
                      setState(() {
                        selectedId = id;
                        print("Received ID in AddressDialog: $selectedId");
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// PHONE NUMBER
                IgnorePointer(
                  ignoring: widget.isView == true ? true : false,
                  child: TextFormField(
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
                                  MaterialStateProperty.all(continueButton)),
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
