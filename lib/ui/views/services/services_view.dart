import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/services/widgets/service_add_edit_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'services_viewmodel.dart';

class ServicesView extends StackedView<ServicesViewModel> {
  const ServicesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ServicesViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
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
                'Service Management',
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
                  width: 500,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search service name...",
                      hintStyle: fontFamilyRegular.size14.grey,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // onChanged: viewModel.searcServices,
                  ),
                ),
                if (isExtended)
                  SizedBox(
                    width: 240,
                  ),
                SizedBox(
                  width: 180,
                  child: CommonButton(
                    buttonColor: appGreen400,
                    margin: EdgeInsets.zero,
                    padding: defaultPadding8,
                    text: isExtended ? "Filter & Sort" : "",
                    icon1: const Icon(Icons.filter_list),
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
                    icon: Icon(Icons.add, color: white, size: 16),
                    buttonColor: continueButton,
                    textStyle: fontFamilyMedium.size14.white,
                    margin: leftPadding12 + rightPadding12,
                    borderRadius: 10,
                    text: "Add Service",
                    onTap: () async {
                      final result = await CommonServiceDialog.show(
                        StackedService.navigatorKey!.currentContext!,
                      );

                      if (result != null) {
                        print('Service Name: ${result['serviceName']}');
                        print('Image Path: ${result['imagePath']}');
                        // You can save to API or database here
                      }
                    }),
              ],
            ),
            verticalSpacing20,
            Expanded(
              child: viewModel.services.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : PaginatedDataTable2(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.blueAccent),

                      headingRowDecoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      headingTextStyle:
                          fontFamilyBold.size14.white, // custom typography
                      dataTextStyle: fontFamilyRegular.size12.black,
                      columns: const [
                        DataColumn(label: Text("S.No")),
                        DataColumn(label: Text("Name")),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text("Actions")),
                      ],
                      source: viewModel.tableSource,
                      columnSpacing: 20,
                      horizontalMargin: 15,
                      rowsPerPage: viewModel.tableSource.rowCount < 10
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
  ServicesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ServicesViewModel();
}
