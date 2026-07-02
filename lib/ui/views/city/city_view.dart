import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

import 'city_viewmodel.dart';

class CityView extends StackedView<CityViewModel> {
  const CityView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CityViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = MediaQuery.of(context).size.width > 900;

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
                      'City Management',
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
                  width: isMobile ? screenWidth * 0.9 : 300,
                  child: StateCityDropdown(
                    showCity:
                        false, // true to show both State and City dropdown
                    initialState: viewModel.stateValue,
                    initialCity: '',
                    onStateChanged: (state) {
                      viewModel.setState(state);
                    },
                    onCityChanged: (city) {
                      viewModel.setCity(city);
                    },
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
                              viewModel.applySort(isChecked, sortType);
                            },
                          );
                        },
                      ),
                    ),
                    horizontalSpacing10,
                    CommonButton(
                        width: isExtended ? 180 : null,
                        icon: const Icon(Icons.add, color: white, size: 16),
                        buttonColor: continueButton,
                        textStyle: fontFamilyMedium.size14.white,
                        padding: defaultPadding12,
                        borderRadius: 10,
                        text: isExtended ? "Add State" : '',
                        onTap: () async {
                          viewModel.addCity();
                        }),
                  ],
                ),
              ],
            ),
            verticalSpacing20,
            Expanded(
                child: viewModel.cities.isEmpty || viewModel.isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        columns: const [
                          DataColumn(label: Text("S.No")),
                          DataColumn(label: Text("Name")),
                          DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text("Actions")),
                          // DataColumn(label: Text("Status")),
                        ],
                        rowsperPage: viewModel.tableSource.rowCount < 10
                            ? viewModel.tableSource.rowCount
                            : 10,
                        source: viewModel.tableSource,
                        minWidth: 1000,
                      )),
          ],
        ),
      ),
    );
  }

  @override
  CityViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CityViewModel();
}
