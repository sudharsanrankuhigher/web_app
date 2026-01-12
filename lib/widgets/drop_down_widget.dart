import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class DynamicMultiSearchDropdown extends StatelessWidget {
  final String label;
  final List<dynamic> items;
  final List<dynamic> selectedItems;
  final String nameKey;
  final bool? isError;
  final String? errorText;
  final void Function(List<dynamic>) onChanged;

  const DynamicMultiSearchDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.nameKey = "name",
    this.isError,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>.multiSelection(
      selectedItems: selectedItems,
      compareFn: (a, b) => a['id'] == b['id'],
      items: (String filter, LoadProps? props) {
        if (filter.isEmpty) return items;
        return items
            .where((e) => e[nameKey]
                .toString()
                .toLowerCase()
                .contains(filter.toLowerCase()))
            .toList();
      },
      dropdownBuilder: (context, selectedItems) {
        if (selectedItems.isEmpty) {
          return Text(
            "Select $label",
            style: fontFamilyMedium.size12.greyColor,
          );
        }
        return Wrap(
          spacing: 6,
          runSpacing: 4,
          children: selectedItems
              .map(
                (e) => Chip(
                  label: Text(
                    e[nameKey],
                    style: fontFamilyMedium.size11.black,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              )
              .toList(),
        );
      },
      popupProps: PopupPropsMultiSelection.menu(
        showSearchBox: true,
        itemBuilder: (context, item, isSelected, _) {
          return ListTile(
            dense: true,
            title: Text(
              item[nameKey],
              style: fontFamilyMedium.size12.black,
            ),
            trailing: isSelected ? const Icon(Icons.check, size: 18) : null,
          );
        },
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: fontFamilyMedium.size12.greyColor,
          fillColor: backgroundColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isError == true ? Colors.red : disableColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isError == true ? Colors.red : Colors.blue,
              width: 2,
            ),
          ),
          errorText:
              isError == true ? errorText ?? "Please select values" : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
