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
    this.minWidth = 1300,
    this.rowsperPage = 10,
    this.dataRowHeight = 48,
    this.enableCheckBox = false,
    this.heddingRowColor,
    this.headingTextStyle,
    this.hidePaginator = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedHeaderColor = isDark
        ? const Color(0xFF334155) // Premium slate header in dark mode
        : (heddingRowColor ?? appGreen400);

    final resolvedHeaderTextStyle = isDark
        ? fontFamilyBold.size12.copyWith(color: Colors.white)
        : (headingTextStyle ?? fontFamilyBold.size14.white);

    return PaginatedDataTable2(
      columns: columns,
      hidePaginator: hidePaginator,
      source: source,
      columnSpacing: 10,
      minWidth: minWidth,
      horizontalMargin: 12,
      rowsPerPage: rowsperPage!,
      showFirstLastButtons: true,
      headingRowHeight: 48,
      dataRowHeight: dataRowHeight,
      headingRowColor: WidgetStateProperty.all(resolvedHeaderColor),
      headingRowDecoration: BoxDecoration(
        color: resolvedHeaderColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      headingTextStyle: resolvedHeaderTextStyle,
      dataTextStyle: fontFamilyRegular.size12.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      showCheckboxColumn: enableCheckBox,
    );
  }
}
