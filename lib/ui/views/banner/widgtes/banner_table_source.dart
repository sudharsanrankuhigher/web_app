import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/banner/model/all_banner_model.dart'
    as banner_model;
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/widgets/web_image_loading.dart';

class BannerTableSource extends DataTableSource {
  final List<banner_model.Datum> data;
  final List<influencer_model.Datum>? influencers;
  final String status;
  final Function(banner_model.Datum) onView;
  final Function(banner_model.Datum, String name) onDelete;

  BannerTableSource(
      {required this.data,
      required this.status,
      this.influencers,
      required this.onView,
      required this.onDelete});

  @override
  DataRow? getRow(int index) {
    if (data.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Center(child: Text("No data found"))),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }

    final item = data[index];
    final influencer = influencers!.firstWhere(
      (inf) => inf.id == item.infId,
      orElse: () => influencer_model.Datum(),
    );

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      cells: [
        DataCell(Text(
          "${index + 1}",
          style: fontFamilySemiBold.size13.black,
        )), // S.No
        DataCell(CircleAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: WebImage(
              imageUrl: item.image.toString(),
            ),
          ),
        )),
        DataCell(Text(
          influencer.name ?? '-',
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          (item.amount ?? '-').toString(),
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          (item.priority ?? '-').toString(),
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(
                  Icons.visibility,
                  size: 16,
                  color: Colors.blue,
                ),
                onPressed: () => onView(item)),
            IconButton(
                icon: const Icon(Icons.delete, size: 16, color: red),
                onPressed: () => onDelete(item, influencer.name ?? '')),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.isEmpty ? 1 : data.length;
  @override
  int get selectedRowCount => 0;
}
