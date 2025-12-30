import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'add_company_viewmodel.dart';

class AddCompanyView extends StackedView<AddCompanyViewModel> {
  const AddCompanyView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddCompanyViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: defaultPadding12 - topPadding12,
        child: Column(
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
                'Company Management',
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
                    // onChanged: viewModel.searchPlans,
                  ),
                ),
                if (isExtended)
                  const SizedBox(
                    width: 240,
                  ),
                // horizontalSpacing20,
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
                          // viewModel.applySort(isChecked, sortType);
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
                    text: isExtended ? "Add Company" : "",
                    onTap: () async {
                      viewModel.addCompany();
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing12,
            Expanded(
                child: viewModel.companies.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        columns: viewModel.companyColumn,
                        rowsperPage: viewModel.tableSource.rowCount < 10
                            ? viewModel.tableSource.rowCount
                            : 10,
                        source: viewModel.tableSource,
                        minWidth: 1000,
                      ))
          ],
        ),
      ),
    );
  }

  @override
  AddCompanyViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddCompanyViewModel();
}
