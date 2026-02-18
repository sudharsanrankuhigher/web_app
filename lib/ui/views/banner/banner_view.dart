import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'banner_viewmodel.dart';

class BannerView extends StackedView<BannerViewModel> {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BannerViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1200;
    final rowCount = viewModel.bannerTableSource?.rowCount ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
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
                'Banner Management',
                style: fontFamilyBold.size26.black,
              ),
            ),
            verticalSpacing12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 55.h,
                  width: isExtended
                      ? 500
                      : 500.w, // search field fixed width (responsive)
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search plan name...",
                      hintStyle: fontFamilyRegular.size14.grey,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // onChanged: viewModel.applySearch,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 180,
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
                              // viewModel.applySort(isChecked, sortType);
                            },
                          );
                        },
                      ),
                    ),
                    if (PermissionHelper.instance.canAdd('company')) ...{
                      horizontalSpacing10,
                      SizedBox(
                        width: isExtended ? 180 : null,
                        child: CommonButton(
                          icon: const Icon(Icons.add, color: white, size: 16),
                          buttonColor: continueButton,
                          textStyle: fontFamilyMedium.size14.white,
                          margin: EdgeInsets.zero,
                          borderRadius: 10,
                          text: isExtended ? "Add Banner" : "",
                          onTap: () async {
                            viewModel.addBanner();
                          },
                        ),
                      ),
                    }
                  ],
                ),
              ],
            ),
            verticalSpacing20,
            Expanded(
              child: viewModel.isBusy || viewModel.isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.bannerTableSource == null
                      ? const Center(child: Text("No Data Found"))
                      : CommonPaginatedTable(
                          headingTextStyle: fontFamilySemiBold.size12.greyColor,
                          heddingRowColor: availableCampaignColor,
                          columns: viewModel.bannerColumn,
                          source: viewModel.bannerTableSource!,
                          rowsperPage:
                              viewModel.bannerTableSource!.rowCount < 10
                                  ? viewModel.bannerTableSource!.rowCount
                                  : 10,
                          minWidth: 1100,
                          hidePaginator: false,
                        ),
            )
          ],
        ),
      ),
    );
  }

  @override
  BannerViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BannerViewModel();
}
