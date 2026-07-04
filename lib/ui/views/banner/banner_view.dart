import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'package:webapp/widgets/search_text_field.dart';
import 'banner_viewmodel.dart';

class BannerView extends StackedView<BannerViewModel> {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BannerViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = MediaQuery.of(context).size.width > 1200;
    final rowCount = viewModel.bannerTableSource.rowCount ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PermissionHelper.instance.canView('banner')
          ? Container(
              padding: defaultPadding12 - topPadding12,
              child: Column(
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
                            onPressed: () =>
                                HomeView.scaffoldKey.currentState?.openDrawer(),
                          ),
                          horizontalSpacing8,
                        ],
                        Expanded(
                          child: Text(
                            'Banner Management',
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
                        height: 55.h,
                        width: isMobile ? screenWidth * 0.9 : 300,
                        child: SearchTextField(
                          hintText:
                              "Search banners (influencer, amount, priority)...",
                          onChanged: (value) {
                            viewModel.applySearch(value);
                          },
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
                                    viewModel.applySort(isChecked, sortType);
                                  },
                                );
                              },
                            ),
                          ),
                          if (PermissionHelper.instance.canAdd('banner')) ...{
                            horizontalSpacing10,
                            SizedBox(
                              width: isExtended ? 180 : null,
                              child: CommonButton(
                                icon: const Icon(Icons.add,
                                    color: white, size: 16),
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
                        : CommonPaginatedTable(
                            key: ValueKey(
                                viewModel.filteredService.length), // ✅ ADD THIS

                            headingTextStyle:
                                fontFamilySemiBold.size12.greyColor,
                            heddingRowColor: availableCampaignColor,
                            columns: viewModel.bannerColumn,
                            source: viewModel.bannerTableSource,
                            rowsperPage:
                                viewModel.bannerTableSource.rowCount < 10
                                    ? viewModel.bannerTableSource.rowCount
                                    : 10,
                            minWidth: 1100,
                            hidePaginator: false,
                          ),
                  )
                ],
              ),
            )
          : const NoAccessWidget(),
    );
  }

  @override
  BannerViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BannerViewModel();
}
