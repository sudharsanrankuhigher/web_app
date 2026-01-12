import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

import 'state_viewmodel.dart';

class StateView extends StackedView<StateViewModel> {
  const StateView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StateViewModel viewModel,
    Widget? child,
  ) {
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
              decoration: const BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
              ),
              child: Text(
                'State Management',
                style: fontFamilyBold.size26.black,
              ),
            ),
            verticalSpacing12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // spacing: 40, // horizontal spacing between items
              // runSpacing: 16, // vertical spacing when wrapping
              // crossAxisAlignment: WrapCrossAlignment.center,
              // alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  height: 45.h,
                  width: isExtended ? 500 : 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search state name...",
                      hintStyle: fontFamilyRegular.size14.grey,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => viewModel.applySearch(value),
                  ),
                ),
                Row(
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
                          viewModel.addState();
                        }),
                  ],
                ),
              ],
            ),
            verticalSpacing20,
            Expanded(
                child: viewModel.states.isEmpty || viewModel.isLoading!
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        columns: const [
                          DataColumn(label: Text("S.No")),
                          DataColumn(label: Text("Name")),
                          DataColumn(
                              headingRowAlignment: MainAxisAlignment.center,
                              label: Text("Actions")),
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
  StateViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StateViewModel();
}
