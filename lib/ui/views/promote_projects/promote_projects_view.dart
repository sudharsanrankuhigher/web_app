import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'promote_projects_viewmodel.dart';

class PromoteProjectsView extends StackedView<PromoteProjectsViewModel> {
  const PromoteProjectsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PromoteProjectsViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1440;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        padding: defaultPadding20 - topPadding20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: defaultPadding16,
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
              ),
              child: Text(
                'Promote Projects',
                style: fontFamilyBold.size26.black,
              ),
            ),
            verticalSpacing12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 45.h,
                  width: isExtended
                      ? 450
                      : 130, // search field fixed width (responsive)
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: fontFamilyRegular.size14.grey,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // onChanged: viewModel.searchPlans,
                  ),
                ),
                horizontalSpacing10,
                // Filter Button

                // Add Plan Button
                Row(
                  children: [
                    SizedBox(
                      // width: 180,
                      child: CommonButton(
                        padding: defaultPadding12,
                        icon: const Icon(Icons.donut_large,
                            color: Colors.black, size: 16),
                        buttonColor: white,
                        textStyle: fontFamilyMedium.size14.black,
                        margin: EdgeInsets.zero,
                        borderRadius: 10,
                        text: isExtended ? "In-Progress" : "",
                        onTap: () async {},
                      ),
                    ),
                    horizontalSpacing8,
                    SizedBox(
                      // width: 180,
                      child: CommonButton(
                        padding: defaultPadding12,
                        icon: const Icon(Icons.check,
                            color: Colors.black, size: 16),
                        buttonColor: white,
                        textStyle: fontFamilyMedium.size14.black,
                        margin: EdgeInsets.zero,
                        borderRadius: 10,
                        text: isExtended ? "Completed" : "",
                        onTap: () async {},
                      ),
                    ),
                    horizontalSpacing8,
                    SizedBox(
                      // width: 180,
                      child: CommonButton(
                        padding: defaultPadding12,
                        icon: const Icon(Icons.add, color: white, size: 16),
                        buttonColor: continueButton,
                        textStyle: fontFamilyMedium.size14.white,
                        margin: EdgeInsets.zero,
                        borderRadius: 10,
                        text: isExtended ? "Add Projects" : "",
                        onTap: () async {
                          // final result = await CommonPlanDialog.show(
                          //   StackedService.navigatorKey!.currentContext!,
                          // );

                          // if (result != null) {
                          //   print('Plan Name: ${result['planName']}');
                          //   print('Connections: ${result['connections']}');
                          //   print('Amount: ${result['amount']}');
                          //   print('Badge: ${result['badge']}');
                          // }
                        },
                      ),
                    ),
                    horizontalSpacing8,
                    SizedBox(
                      // width: 180,
                      child: CommonButton(
                        buttonColor: continueButton,
                        margin: EdgeInsets.zero,
                        padding: defaultPadding4,
                        text: isExtended ? "Filter & Sort" : "",
                        borderRadius: 10,
                        textStyle: fontFamilyMedium.size14.white
                            .copyWith(overflow: TextOverflow.ellipsis),
                        icon: SizedBox(
                          height: 35,
                          width: 35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.asset(
                              height: 34,
                              width: 34,
                              'assets/images/filter.jpg',
                            ),
                          ),
                        ),
                        onTap: () {
                          CommonFilterDialog.show(
                            context,
                            initialCheckbox: false,
                            initialSort: "A-Z",
                            onApply: (isChecked, sortType) {
                              // viewModel.applySort(isChecked, sortType);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            verticalSpacing10,
            Expanded(
              child: viewModel.plans.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : CommonPaginatedTable(
                      columns: const [
                        DataColumn(label: Text("S.No")),
                        DataColumn(label: Text("Project Code")),
                        DataColumn(label: Text("Client Name")),
                        DataColumn(label: Text("Project Title")),
                        DataColumn(label: Text("Note")),
                        DataColumn(label: Text("Project Code")),
                        DataColumn(label: Text("In-Progress")),
                        DataColumn(label: Text("Payment")),
                        DataColumn(label: Text("Commission")),
                        DataColumn(label: Text("Assigned Date")),
                        DataColumn(label: Text("Actions")),
                        DataColumn(label: Text("")),
                      ],
                      source: viewModel.tableSource,
                      rowsperPage: viewModel.tableSource.rowCount < 10
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
  PromoteProjectsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PromoteProjectsViewModel();
}
