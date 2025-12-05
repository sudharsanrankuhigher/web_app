import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/plans/widgets/common_plans_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'plans_viewmodel.dart';

class PlansView extends StackedView<PlansViewModel> {
  const PlansView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PlansViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: defaultPadding20 - topPadding20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: defaultPadding16,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
              ),
              child: Text(
                'Plans Management',
                style: fontFamilyBold.size26.black,
              ),
            ),
            verticalSpacing12,
            Wrap(
              spacing: 40, // horizontal spacing between items
              runSpacing: 16, // vertical spacing when wrapping
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  width: 450, // search field fixed width (responsive)
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search plan name...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: viewModel.searchPlans,
                  ),
                ),
                if (isExtended)
                  SizedBox(
                    width: 240,
                  ),
                horizontalSpacing20,
                // Filter Button
                SizedBox(
                  width: 180,
                  child: CommonButton(
                    buttonColor: appGreen400,
                    margin: EdgeInsets.zero,
                    padding: defaultPadding8,
                    text: isExtended ? "Filter & Sort" : "",
                    icon1: const Icon(Icons.filter_list),
                    onTap: () {
                      CommonFilterDialog.show(
                        context,
                        initialCheckbox: false,
                        initialSort: "A-Z",
                        onApply: (isChecked, sortType) {
                          viewModel.applySort(isChecked, sortType);
                        },
                      );
                    },
                  ),
                ),

                // Add Plan Button
                SizedBox(
                  width: 180,
                  child: CommonButton(
                    icon: Icon(Icons.add, color: white, size: 16),
                    buttonColor: continueButton,
                    textStyle: fontFamilyMedium.size14.white,
                    margin: EdgeInsets.zero,
                    borderRadius: 10,
                    text: isExtended ? "Add Plans" : "",
                    onTap: () async {
                      final result = await CommonPlanDialog.show(
                        StackedService.navigatorKey!.currentContext!,
                      );

                      if (result != null) {
                        print('Plan Name: ${result['planName']}');
                        print('Connections: ${result['connections']}');
                        print('Amount: ${result['amount']}');
                        print('Badge: ${result['badge']}');
                      }
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing20,
            Expanded(
              child: viewModel.plans.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : PaginatedDataTable2(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.blueAccent),

                      headingRowDecoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      headingTextStyle:
                          fontFamilyBold.size14.white, // custom typography
                      dataTextStyle: fontFamilyRegular.size12.black,
                      columns: const [
                        DataColumn(label: Text("S.No")),
                        DataColumn(label: Text("Plan Name")),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.start,
                            label: Text("Connections")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Badge")),
                        DataColumn(label: Text("Actions")),
                      ],
                      source: viewModel.tableSource,
                      columnSpacing: 20,
                      horizontalMargin: 15,
                      rowsPerPage: viewModel.tableSource.rowCount < 10
                          ? viewModel.tableSource.rowCount
                          : 10,
                      minWidth: 1000,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PlansViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PlansViewModel();
}
