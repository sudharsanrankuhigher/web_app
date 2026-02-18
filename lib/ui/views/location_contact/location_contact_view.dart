import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/plans/widgets/common_plans_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_chips.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

import 'location_contact_viewmodel.dart';

class LocationContactView extends StackedView<LocationContactViewModel> {
  const LocationContactView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LocationContactViewModel viewModel,
    Widget? child,
  ) {
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
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Text(
                        'Location Contact',
                        style: fontFamilyBold.size26.black,
                      ),
                    ),
                    verticalSpacing12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //   height: 45.h,
                        //   width: isExtended
                        //       ? 500
                        //       : 450.w, // search field fixed width (responsive)
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       hintText: "Search plan name...",
                        //       hintStyle: fontFamilyRegular.size14.grey,
                        //       prefixIcon: const Icon(Icons.search),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     onChanged: viewModel.searchPlans,
                        //   ),
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: isExtended ? 500 : 200,
                              child: StateCityDropdown(
                                showCity:
                                    false, // true to show both State and City dropdown
                                initialState: viewModel.stateValue,
                                initialCity: '',
                                onStateChanged: (state) {
                                  viewModel.setState(state);
                                },
                              ),
                            ),
                            horizontalSpacing4,
                            if (viewModel.stateValue !=
                                "Search by Selected State")
                              InkWell(
                                onTap: () => viewModel.clearChip(),
                                child: RichText(
                                    text: TextSpan(children: [
                                  WidgetSpan(
                                    child: Text(
                                      "Clear",
                                      style: fontFamilyRegular.size11.red,
                                    ),
                                  ),
                                  WidgetSpan(
                                      child: Center(
                                          child: Icon(
                                    Icons.close,
                                    color: red,
                                    size: 15,
                                  )))
                                ])),
                              ),
                          ],
                        ),

                        Row(
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
                                    viewModel.addContact(context);
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
                                DataColumn(label: Text("state")),
                                DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.start,
                                    label: Text("city")),
                                DataColumn(label: Text("phone")),
                                DataColumn(
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
            : NoAccessWidget());
  }

  @override
  LocationContactViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LocationContactViewModel();
}
