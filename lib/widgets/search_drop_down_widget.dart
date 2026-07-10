import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/web_image_loading.dart';

class DynamicSingleSearchDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? selectedItem;
  final String nameKey;
  final bool? isError;
  final String? errorText;
  final void Function(T?) onChanged;
  final String Function(T)? itemLabelMapper;
  final String? Function(T)? itemImageMapper;
  final bool Function(T, T)? compareFn;
  final bool enabled;

  const DynamicSingleSearchDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.nameKey = "name",
    this.isError,
    this.errorText,
    this.itemLabelMapper,
    this.itemImageMapper,
    this.compareFn,
    this.enabled = true,
  });

  String getLabel(T? item) {
    if (item == null) return "";
    if (itemLabelMapper != null) return itemLabelMapper!(item);
    if (item is String) return item;
    if (item is Map && item.containsKey(nameKey)) {
      return item[nameKey].toString();
    }
    return item.toString();
  }

  String? getImage(T? item) {
    if (item == null) return null;
    if (itemImageMapper != null) return itemImageMapper!(item);
    if (item is Map && item.containsKey("image")) {
      return item["image"];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      enabled: enabled,
      selectedItem: selectedItem,
      itemAsString: (item) => getLabel(item),

      /// 🔹 Compare safely using id if exists
      compareFn: compareFn ??
          (a, b) {
            if (a is Map &&
                b is Map &&
                a.containsKey('id') &&
                b.containsKey('id')) {
              return a['id'] == b['id'];
            }
            return getLabel(a) == getLabel(b);
          },

      /// 🔹 Search filter
      items: (filter, props) {
        if (filter.isEmpty) return items;
        return items
            .where(
                (e) => getLabel(e).toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },

      /// ================= SELECTED VALUE VIEW =================
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) {
          return Text(
            "Select $label",
            style: fontFamilyMedium.size12.greyColor,
          );
        }

        final image = getImage(selectedItem);
        final hasImage = image != null && image.isNotEmpty;

        return Row(
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: WebImage(
                  imageUrl: image,
                  height: 28,
                  width: 28,
                  fit: BoxFit.cover,
                ),
              )
            else
              CircleAvatar(
                radius: 14,
                child: Text(
                  (getLabel(selectedItem).isNotEmpty
                          ? getLabel(selectedItem)[0]
                          : "?")
                      .toUpperCase(),
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                getLabel(selectedItem),
                style: fontFamilyMedium.size12.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },

      /// ================= POPUP ITEM VIEW =================
      popupProps: PopupProps.menu(
        showSearchBox: true,
        itemBuilder: (context, item, isSelected, _) {
          final image = getImage(item);
          final hasImage = image != null && image.isNotEmpty;

          return ListTile(
            dense: true,
            leading: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: WebImage(
                      imageUrl: image,
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    radius: 18,
                    child: Text(getLabel(item)[0].toUpperCase()),
                  ),
            title: Text(
              getLabel(item),
              style: fontFamilyMedium.size12.black,
            ),
            trailing: isSelected ? const Icon(Icons.check, size: 18) : null,
          );
        },
      ),

      /// ================= DECORATION =================
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF334155)
              : backgroundColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isError == true
                  ? Colors.red
                  : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : disableColor),
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
              isError == true ? errorText ?? "Please select value" : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),

      onChanged: onChanged,
    );
  }
}
