import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/services/theme_service.dart';

class InfluencerTableSource extends DataTableSource {
  final List<influencer_model.Datum> influencers;
  final List<service_model.Datum>? service;

  final Function(influencer_model.Datum, bool) onEdit;
  final Function(influencer_model.Datum, bool)? onView;
  // final Function(InfluencerModel) onDelete;
  final Function(influencer_model.Datum) onToggle;

  InfluencerTableSource({
    required this.influencers,
    required this.onEdit,
    // required this.onDelete,
    this.onView,
    this.service,
    required this.onToggle,
  });

  Map<int, String> get _serviceMap {
    return {
      for (final s in service ?? [])
        if (s.id != null) s.id!: s.name ?? ""
    };
  }

  String _getServiceNames(List<dynamic>? serviceIds) {
    if (serviceIds == null || serviceIds.isEmpty) return "-";

    return serviceIds.map((id) => _serviceMap[id] ?? "Unknown").join(", ");
  }

  String getCategoryName(int? categoryId) {
    print("categoryId: $categoryId");
    switch (categoryId) {
      case 1:
        return "Influencers";
      case 2:
        return "Movie Stars";
      case 3:
        return "TV Stars";
      case 4:
        return "Sports Stars";
      default:
        return "Unknown";
    }
  }

  String getFormattedId(int? categoryId, int? id) {
    if (categoryId == null || id == null) return "UNKNOWN";

    String prefix;

    switch (categoryId) {
      case 1:
        prefix = "INF";
        break;
      case 2:
        prefix = "MOV";
        break;
      case 3:
        prefix = "TV";
        break;
      case 4:
        prefix = "SP";
        break;
      default:
        prefix = "UNK";
    }

    // pad id to 4 digits → 1 => 0001, 10 => 0010
    final paddedId = id.toString().padLeft(4, '0');

    return "$prefix$paddedId";
  }

  @override
  DataRow? getRow(int index) {
    /// -------------------------------
    /// CASE: NO DATA FOUND
    /// -------------------------------
    ///
    ///
    if (influencers.isEmpty) {
      return DataRow(
        cells: List.generate(
          14, // total columns
          (i) {
            if (i == 6) {
              // column index where message should show
              return const DataCell(
                Center(
                  child: Text(
                    "No data found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
            return const DataCell(Text("")); // other cells empty
          },
        ),
      );
    }

    /// -------------------------------
    /// CASE: NORMAL ROW
    /// -------------------------------
    final item = influencers[index];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          final isDark = ThemeService.instance.isDarkMode;
          if (isDark) {
            return index.isEven
                ? const Color(0xFF1E293B)
                : const Color(0xFF0F172A);
          }
          return index.isEven ? Colors.white : Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(SelectableText(
          "${index + 1}",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(
            // Text(row.imageUrl)
            IgnorePointer(
          ignoring: true,
          child: Padding(
            padding: defaultPadding4,
            child: ProfileImageEdit(
              imageUrl: item.image,
              radius: 20,
              onImageSelected: (_, a) {},
            ),
          ),
        )), // Name

        DataCell(SelectableText(
          getFormattedId(item.category, item.id),
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          item.name!,
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          item.phone!,
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          "${item.city}/${item.state}",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(
          SelectableText(
            _getServiceNames(item.service),
            style: fontFamilyRegular.size12.black,
          ),
        ),
        DataCell(SelectableText(
          getCategoryName(item.category),
          style: fontFamilyRegular.size12.black,
        )),

        DataCell(SelectableText(
          item.instagramFollowers!.toString(),
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          item.youtubeFollowers.toString(),
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          item.facebookFollowers.toString(),
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(
          SelectableText(
            DateFormatter.formatToDDMMMYYYY(item.createdAt!).toString(),
            style: fontFamilyRegular.size12.black,
          ),
        ),

        /// ACTION BUTTONS
        DataCell(
          GestureDetector(
            onTap: () => onView?.call(item, true),
            child: const Icon(Icons.visibility, size: 20, color: Colors.blue),
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [

          //     const SizedBox(width: 8),
          //     GestureDetector(
          //       onTap: () => onEdit(item, false),
          //       child: const Icon(Icons.edit, size: 16, color: Colors.blue),
          //     ),
          //     const SizedBox(width: 8),
          //     GestureDetector(
          //       // onTap: () => onDelete(item),
          //       child: const Icon(Icons.delete, size: 16, color: Colors.red),
          //     ),
          //   ],
          // ),
        ),

        /// TOGGLE SWITCH
        DataCell(
          IgnorePointer(
            ignoring: PermissionHelper.instance.canEdit('influencers') == true
                ? false
                : true,
            child: Transform.scale(
              scale: 0.7,
              child: Switch(
                activeThumbColor: continueButton,
                value: item.status == 1 ? true : false,
                onChanged: (_) => onToggle(item),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  /// Return at least 1 row so table does not crash
  @override
  int get rowCount => influencers.isEmpty ? 1 : influencers.length;

  @override
  int get selectedRowCount => 0;
}
