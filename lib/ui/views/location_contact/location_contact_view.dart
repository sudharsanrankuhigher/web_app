import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/widgets/common_button.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = MediaQuery.of(context).size.width > 1440;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: PermissionHelper.instance.canView('location_contact')
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
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () => HomeView.scaffoldKey.currentState?.openDrawer(),
                            ),
                            horizontalSpacing8,
                          ],
                          Expanded(
                            child: Text(
                              'Location Contact',
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: isMobile ? (screenWidth - 100) : 300,
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
                                  const WidgetSpan(
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
                            if (PermissionHelper.instance
                                .canAdd('location_contact'))
                              SizedBox(
                                width: isExtended ? 180 : null,
                                child: CommonButton(
                                  icon: const Icon(Icons.add,
                                      color: white, size: 16),
                                  buttonColor: continueButton,
                                  textStyle: fontFamilyMedium.size14.white,
                                  margin: EdgeInsets.zero,
                                  borderRadius: 10,
                                  text: isExtended ? "Add Contact" : "",
                                  onTap: () async {
                                    viewModel.addContact(context);
                                  },
                                ),
                              ),
                          ],
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
                      child: viewModel.isBusy || viewModel.isLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : CommonPaginatedTable(
                              columns: const [
                                DataColumn(label: Text("S.No")),
                                DataColumn(label: Text("state")),
                                // DataColumn(
                                //     headingRowAlignment:
                                //         MainAxisAlignment.start,
                                //     label: Text("city")),
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
            : const NoAccessWidget());
  }

  @override
  LocationContactViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LocationContactViewModel();
}
