import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class DynamicSingleSearchDropdown extends StatelessWidget {
  final String label;
  final List<dynamic> items;
  final dynamic selectedItem;
  final String nameKey;
  final bool? isError;
  final String? errorText;
  final void Function(dynamic) onChanged;

  const DynamicSingleSearchDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.nameKey = "name",
    this.isError,
    this.errorText,
  });

  String getLabel(dynamic item) {
    if (item is String) return item;
    if (item is Map && item.containsKey(nameKey)) {
      return item[nameKey].toString();
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<dynamic>(
      selectedItem: selectedItem,

      /// 🔹 Compare safely
      compareFn: (a, b) => getLabel(a) == getLabel(b),

      /// 🔹 Search filter
      items: (filter, props) {
        if (filter.isEmpty) return items;
        return items
            .where(
                (e) => getLabel(e).toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },

      /// 🔹 Selected value UI
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) {
          return Text(
            "Select $label",
            style: fontFamilyMedium.size12.greyColor,
          );
        }
        return Text(
          getLabel(selectedItem),
          style: fontFamilyMedium.size12.black,
        );
      },

      /// 🔹 Popup UI
      popupProps: PopupProps.menu(
        showSearchBox: true,
        itemBuilder: (context, item, isSelected, _) {
          return ListTile(
            dense: true,
            title: Text(
              getLabel(item),
              style: fontFamilyMedium.size12.black,
            ),
            trailing: isSelected ? const Icon(Icons.check, size: 18) : null,
          );
        },
      ),

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          // labelText: "Select $label",
          // labelStyle: fontFamilyMedium.size12.greyColor,
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
