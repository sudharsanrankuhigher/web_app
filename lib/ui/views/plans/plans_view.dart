import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan_model;
import 'package:webapp/ui/views/plans/widgets/common_plans_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

import 'plans_viewmodel.dart';

class PlansView extends StackedView<PlansViewModel> {
  const PlansView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PlansViewModel viewModel,
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
                  height: 45.h,
                  width: 450, // search field fixed width (responsive)
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search plan name...",
                      hintStyle: fontFamilyRegular.size14.grey,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: viewModel.searchPlans,
                  ),
                ),
                if (isExtended)
                  const SizedBox(
                    width: 240,
                  ),
                horizontalSpacing20,
                // Filter Button
                SizedBox(
                  width: 180,
                  child: CommonButton(
                    buttonColor: continueButton,
                    margin: EdgeInsets.zero,
                    padding: defaultPadding4 - leftPadding4,
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
                    icon: const Icon(Icons.add, color: white, size: 16),
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
                        final newPlan = {
                          "id": null,
                          "name": result['planName'],
                          "connections": result['connections'] is int
                              ? result['connections']
                              : int.tryParse(
                                      result['connections']?.toString() ??
                                          '0') ??
                                  0,
                          "amount": (result['amount'] is int
                                  ? result['amount']
                                  : int.tryParse(result['amount']?.toString() ??
                                          '0') ??
                                      0)
                              .toString(),
                          "badge": result['badge'],
                          "category": result['category'],
                        };

                        viewModel.saveOrUpdate(newPlan);
                      }
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing10,
            // StateCityDropdown(
            //   showCity: true, // true to show both State and City dropdown
            //   initialState: viewModel.stateValue,
            //   initialCity: '',
            //   onStateChanged: (state) {
            //     viewModel.stateValue = state;
            //     viewModel.cityValue = ''; // reset city when state changes
            //     viewModel.notifyListeners();
            //   },
            //   // onCityChanged: (city) {
            //   //   viewModel.stateValue = city.toString();
            //   // },
            // ),
            verticalSpacing20,
            Expanded(
              child: viewModel.plans.isEmpty || viewModel.isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : CommonPaginatedTable(
                      columns: const [
                        DataColumn(label: Text("S.No")),
                        DataColumn(label: Text("Plan Name")),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.start,
                            label: Text("Connections")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Badge")),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text("Actions")),
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
  PlansViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PlansViewModel();
}
