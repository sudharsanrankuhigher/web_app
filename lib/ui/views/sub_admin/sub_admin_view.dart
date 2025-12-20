import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'sub_admin_viewmodel.dart';

class SubAdminView extends StackedView<SubAdminViewModel> {
  const SubAdminView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SubAdminViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      body: Padding(
        padding: defaultPadding20 - topPadding20,
        child: SizedBox(
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
                  'Sub-Admin Management',
                  style: fontFamilyBold.size26.black,
                ),
              ),
              verticalSpacing12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 45.h,
                    width: isExtended ? 500.w : 300.h,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search name, email, phone...",
                        hintStyle: fontFamilyRegular.size14.grey,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // onChanged: viewModel.searchUser,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonButton(
                        buttonColor: continueButton,
                        padding: defaultPadding8 -
                            topPadding4 -
                            bottomPadding4 +
                            rightPadding4,
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
                      horizontalSpacing10,
                      CommonButton(
                        padding:
                            defaultPadding12 + rightPadding4 + leftPadding4,
                        icon: const Icon(Icons.add, color: white, size: 16),
                        buttonColor: continueButton,
                        textStyle: fontFamilyMedium.size14.white,
                        margin: EdgeInsets.zero,
                        borderRadius: 10,
                        text: isExtended ? "Add Sub-Admin" : "",
                        onTap: () async {
                          viewModel.onAdd(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpacing20,
              Expanded(
                child: viewModel.subAdmins.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        columns: const [
                          DataColumn(label: Text("S.No")),
                          DataColumn(label: Text("Profile")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Location")),
                          DataColumn(label: Text("Login")),
                          DataColumn(label: Text("Logout")),
                          DataColumn(label: Text("Online At")),
                          DataColumn(label: Text("Access")),
                          DataColumn(label: Text("Action")),
                          DataColumn(label: Text("Status")),
                        ],
                        source: viewModel.tableSource,
                        rowsperPage: viewModel.tableSource.rowCount < 10
                            ? viewModel.tableSource.rowCount
                            : 10,
                        minWidth: 1200,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SubAdminViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SubAdminViewModel();
}
