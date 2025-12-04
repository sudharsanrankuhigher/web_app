import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';

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
              decoration: BoxDecoration(
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
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // onChanged: viewModel.searchInfluencer,
                    onChanged: viewModel.searchInfluencer,
                  ),
                ),
                if (isExtended)
                  SizedBox(
                    width: 240,
                  ),
                CommonButton(
                  width: 180,
                  buttonColor: appGreen400,
                  padding: defaultPadding8,
                  text: "Filter & Sort",
                  icon1: Icon(Icons.filter_list),
                  onTap: () async {
                    final result =
                        await viewModel.showSortingFilterDialog(context);
                    if (result == null) return;

                    bool isChecked = result["checkbox"];
                    String sortType = result["sort"];

                    // Apply filters/sorting
                    viewModel.applySort(isChecked, sortType);
                  },
                ),
                CommonButton(
                    width: 180,
                    icon: Icon(Icons.add, color: white, size: 16),
                    buttonColor: continueButton,
                    textStyle: fontFamilyMedium.size14.white,
                    borderRadius: 10,
                    text: "Add Influencer",
                    onTap: () {}),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PaginatedDataTable2(
                dataRowHeight: 65.h,
                headingRowColor: MaterialStateProperty.all(Colors.blueAccent),
                headingTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                dataTextStyle: fontFamilyRegular.size12.black,
                headingRowDecoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                columns: const [
                  DataColumn(label: Text("S.No")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Phone")),
                  DataColumn(label: Text("City/State")),
                  DataColumn(label: Text("Bank/UPI")),
                  DataColumn(label: Text("Instagram")),
                  DataColumn(label: Text("YouTube")),
                  DataColumn(label: Text("Facebook")),
                  DataColumn(label: Text("Actions")),
                  DataColumn(label: Text("Status")),
                ],
                source: viewModel.tableSource,
                rowsPerPage: viewModel.tableSource.rowCount < 10
                    ? viewModel.tableSource.rowCount
                    : 10,
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
