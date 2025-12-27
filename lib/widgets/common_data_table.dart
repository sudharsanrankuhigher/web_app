import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class CommonPaginatedTable extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;
  final double minWidth;
  final int? rowsperPage;
  final double dataRowHeight;
  final bool enableCheckBox;
  final bool hidePaginator;
  final Color? heddingRowColor;
  final TextStyle? headingTextStyle;

  const CommonPaginatedTable({
    super.key,
    required this.columns,
    required this.source,
    this.minWidth = 800,
    this.rowsperPage = 10,
    this.dataRowHeight = 48,
    this.enableCheckBox = false,
    this.heddingRowColor,
    this.headingTextStyle,
    this.hidePaginator = false,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      columns: columns,
      hidePaginator: hidePaginator ?? false,
      source: source,
      columnSpacing: 14,
      minWidth: minWidth,
      horizontalMargin: 12,
      rowsPerPage: rowsperPage!,
      showFirstLastButtons: true,
      headingRowHeight: 48,
      dataRowHeight: dataRowHeight,
      headingRowColor: WidgetStateProperty.all(appGreen400),
      headingRowDecoration: BoxDecoration(
        color: heddingRowColor ?? appGreen400,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      headingTextStyle:
          headingTextStyle ?? fontFamilyBold.size14.white, // custom typography
      dataTextStyle: fontFamilyRegular.size12.black,
      showCheckboxColumn: enableCheckBox,
    );
  }
}
