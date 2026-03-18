import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/influencers/widgets/add_edit_influencer_dialog.dart';
import 'package:webapp/ui/views/influencers/widgets/inf_filter.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'influencers_viewmodel.dart';

class InfluencersView extends StackedView<InfluencersViewModel> {
  const InfluencersView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InfluencersViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
        body: PermissionHelper.instance.canView('influencers')
            ? Padding(
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
                        'Influencers Management',
                        style: fontFamilyBold.size26.black,
                      ),
                    ),
                    verticalSpacing12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // spacing: 40, // horizontal spacing between items
                      // runSpacing: 16, // vertical spacing when wrapping
                      // crossAxisAlignment: WrapCrossAlignment.start,
                      // alignment: WrapAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 47.h,
                              width: isExtended ? 500 : 500.w,
                              child: TextField(
                                controller: viewModel.searchController,
                                decoration: InputDecoration(
                                  hintText: "Search name, phone, city...",
                                  hintStyle: fontFamilyRegular.size12.grey,
                                  prefixIcon: const Icon(Icons.search),

                                  /// 🔥 CLEAR BUTTON
                                  suffixIcon: viewModel
                                          .searchController.text.isNotEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            viewModel.searchController.clear();
                                            viewModel.searchInfluencer(
                                                ""); // reset search
                                          },
                                          child: const Icon(Icons.close),
                                        )
                                      : null,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (value) {
                                  viewModel.searchInfluencer(value);

                                  /// 🔥 refresh UI to show/hide clear icon
                                  viewModel.notifyListeners();
                                },
                              ),
                            ),
                            if (viewModel.currentSearch.isNotEmpty ||
                                viewModel.currentSort.isNotEmpty)
                              Row(
                                children: [
                                  horizontalSpacing4,
                                  Text("clear filter",
                                      style: fontFamilyRegular.size12.red),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.clearFilter();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: red,
                                    ),
                                  ),
                                ],
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
                                  // CommonFilterDialog.show(
                                  //   context,
                                  //   initialCheckbox: false,
                                  //   initialSort: "A-Z",
                                  //   onApply: (isChecked, sortType) {
                                  //     viewModel.applySort(isChecked, sortType);
                                  //   },
                                  // );
                                  InfFilter.show(
                                    context,
                                    categoryList: viewModel.categoryList,
                                    services: viewModel.services,
                                    onApply: (check, sort) {
                                      viewModel.applySort(check, sort);
                                    },
                                    onFilter: (categoryId, serviceId) {
                                      viewModel.applyFilter(
                                        categoryId: categoryId,
                                        serviceId: serviceId,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            horizontalSpacing10,
                            if (PermissionHelper.instance.canAdd('influencers'))
                              CommonButton(
                                  width: isExtended ? 180 : null,
                                  icon: const Icon(Icons.add,
                                      color: white, size: 16),
                                  buttonColor: continueButton,
                                  textStyle: fontFamilyMedium.size14.white,
                                  borderRadius: 10,
                                  text: isExtended ? "Add Influencer" : "",
                                  onTap: () {
                                    showDialog(
                                      context: StackedService
                                          .navigatorKey!.currentContext!,
                                      builder: (_) => Center(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 800, minWidth: 400),
                                          child: InfluencerDialog(
                                            service: viewModel.services,
                                            isView: false,
                                            influencer: null,
                                            onSave: (newInfluencer) {
                                              print(newInfluencer.toString());

                                              viewModel
                                                  .addInfluencer(newInfluencer);
                                              viewModel.notifyListeners();
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: viewModel.isBusy || viewModel.isLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : CommonPaginatedTable(
                              dataRowHeight: 65.h,
                              columns: const [
                                DataColumn(label: Text("S.No")),
                                DataColumn(label: Text("IF.ID")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Phone")),
                                DataColumn(label: Text("City/State")),
                                DataColumn(label: Text("Service Type")),
                                DataColumn(
                                    label: Text("Category Type"),
                                    tooltip: "Category Type"),
                                DataColumn(label: Text("Instagram")),
                                DataColumn(label: Text("YouTube")),
                                DataColumn(label: Text("Facebook")),
                                DataColumn(label: Text("Actions")),
                                DataColumn(label: Text("Status")),
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
  InfluencersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InfluencersViewModel();

  @override
  void onViewModelReady(InfluencersViewModel viewModel) async {
    await viewModel.getServices();
    await viewModel.loadInfluencers();
  }
}
