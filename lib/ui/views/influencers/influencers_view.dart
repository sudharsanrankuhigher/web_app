import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/influencers/widgets/add_edit_influencer_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'influencers_viewmodel.dart';

class InfluencersView extends StackedView<InfluencersViewModel> {
  const InfluencersView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InfluencersViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Padding(
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
            Wrap(
              spacing: 40, // horizontal spacing between items
              runSpacing: 16, // vertical spacing when wrapping
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  height: 45.h,
                  width: 500,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search name, phone, city...",
                      hintStyle: fontFamilyRegular.size14.grey,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // onChanged: viewModel.searchInfluencer,
                    onChanged: viewModel.searchInfluencer,
                  ),
                ),
                if (isExtended)
                  const SizedBox(
                    width: 240,
                  ),
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
                CommonButton(
                    width: 180,
                    icon: const Icon(Icons.add, color: white, size: 16),
                    buttonColor: continueButton,
                    textStyle: fontFamilyMedium.size14.white,
                    borderRadius: 10,
                    text: "Add Influencer",
                    onTap: () {
                      showDialog(
                        context: StackedService.navigatorKey!.currentContext!,
                        builder: (_) => Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxWidth: 800, minWidth: 400),
                            child: InfluencerDialog(
                              isView: false,
                              influencer: null,
                              onSave: (newInfluencer) {
                                viewModel.influencers.add(newInfluencer);
                                viewModel.notifyListeners();
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: viewModel.influencers.isEmpty
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
      ),
    );
  }

  @override
  InfluencersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      InfluencersViewModel();

  @override
  void onViewModelReady(InfluencersViewModel viewModel) {
    viewModel.loadInfluencers();
  }
}
