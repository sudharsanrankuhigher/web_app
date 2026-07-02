import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/ui/views/plans/widgets/common_plans_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';
import 'package:webapp/widgets/responsive_menu_button.dart';

import 'package:webapp/widgets/search_text_field.dart';
import 'plans_viewmodel.dart';

class PlansView extends StackedView<PlansViewModel> {
  const PlansView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PlansViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = MediaQuery.of(context).size.width > 1440;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: PermissionHelper.instance.canView('plans')
            ? Container(
                padding: defaultPadding20 - topPadding20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: defaultPadding16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          if (isMobile) ...[
                            const ResponsiveMenuButton(),
                            horizontalSpacing8,
                          ],
                          Expanded(
                            child: Text(
                              'Plans Management',
                              style: fontFamilyBold.size26.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacing12,
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          height: 45.h,
                          width: isMobile ? screenWidth * 0.9 : 300,
                          child: SearchTextField(
                            hintText: "Search plan name...",
                            onChanged: viewModel.searchPlans,
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: isExtended ? 180 : null,
                              child: CommonButton(
                                buttonColor: continueButton,
                                margin: EdgeInsets.zero,
                                padding: isExtended
                                    ? defaultPadding4 - leftPadding4
                                    : defaultPadding4 + leftPadding8,
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
                            horizontalSpacing10,
                            if (PermissionHelper.instance.canAdd('plans'))
                              SizedBox(
                                width: isExtended ? 180 : null,
                                child: CommonButton(
                                  icon: const Icon(Icons.add,
                                      color: white, size: 16),
                                  buttonColor: continueButton,
                                  textStyle: fontFamilyMedium.size14.white,
                                  margin: EdgeInsets.zero,
                                  borderRadius: 10,
                                  text: isExtended ? "Add Plans" : "",
                                  onTap: () async {
                                    final result = await CommonPlanDialog.show(
                                      StackedService
                                          .navigatorKey!.currentContext!,
                                    );

                                    if (result != null) {
                                      final newPlan = {
                                        "id": null,
                                        "name": result['planName'],
                                        "selected_plan": result['selectedPlan'],
                                        "connections": result['connections']
                                                is int
                                            ? result['connections']
                                            : int.tryParse(result['connections']
                                                        ?.toString() ??
                                                    '0') ??
                                                0,
                                        "regular_price": (result[
                                                    'regular_price'] is int
                                                ? result['regular_price']
                                                : int.tryParse(
                                                        result['regular_price']
                                                                ?.toString() ??
                                                            '0') ??
                                                    0)
                                            .toString(),
                                        "sale_price": (result['sale_price']
                                                    is int
                                                ? result['sale_price']
                                                : int.tryParse(
                                                        result['sale_price']
                                                                ?.toString() ??
                                                            '0') ??
                                                    0)
                                            .toString(),
                                        "gst": (result['gst'] is int
                                                ? result['gst']
                                                : int.tryParse(result['gst']
                                                            ?.toString() ??
                                                        '0') ??
                                                    0)
                                            .toString(),
                                        "badge": result['badge'],
                                        "category_id": result['category_id'],
                                      };

                                      viewModel.saveOrUpdate(newPlan);
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),

                        // Add Plan Button
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
                      child: viewModel.isBusy || viewModel.isLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : CommonPaginatedTable(
                              columns: const [
                                DataColumn(label: Text("S.No")),
                                DataColumn(label: Text("Plan Name")),
                                DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.start,
                                    label: Text("Connections")),
                                DataColumn(label: Text("Regular Price")),
                                DataColumn(label: Text("Sale Price")),
                                DataColumn(label: Text("GST")),
                                DataColumn(label: Text("Category")),
                                DataColumn(label: Text("Badge")),
                                DataColumn2(
                                    fixedWidth: 100,
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
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
              )
            : const NoAccessWidget());
  }

  @override
  PlansViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PlansViewModel();
}
