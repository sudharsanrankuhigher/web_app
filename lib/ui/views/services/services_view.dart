
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/services/widgets/service_add_edit_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'services_viewmodel.dart';

class ServicesView extends StackedView<ServicesViewModel> {
  const ServicesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ServicesViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PermissionHelper.instance.canView('services')
          ? Container(
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
                      'Service Management',
                      style: fontFamilyBold.size26.black,
                    ),
                  ),
                  verticalSpacing12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 55.h,
                        width: isExtended ? 500 : 500.w,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search service name...",
                            hintStyle: fontFamilyRegular.size12.grey,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: viewModel.applySearch,
                        ),
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
                          if (PermissionHelper.instance.canAdd('services'))
                            CommonButton(
                                width: isExtended ? 180 : null,
                                icon: const Icon(Icons.add,
                                    color: white, size: 16),
                                buttonColor: continueButton,
                                textStyle: fontFamilyMedium.size14.white,
                                margin: leftPadding12 + rightPadding12,
                                borderRadius: 10,
                                text: isExtended ? "Add Service" : "",
                                onTap: () async {
                                  final result = await CommonServiceDialog.show(
                                    StackedService
                                        .navigatorKey!.currentContext!,
                                  );

                                  if (result != null) {
                                    print(
                                        'Service Name: ${result['serviceName']}');
                                    print('Image Path: ${result['imagePath']}');
                                    print(
                                        'Image Bytes: ${result['imageBytes']}');
                                    result['id'] = null;
                                    viewModel.addService(result);
                                    // You can save to API or database here
                                  }
                                }),
                        ],
                      ),
                    ],
                  ),
                  verticalSpacing20,
                  Expanded(
                      child: viewModel.isBusy || viewModel.isLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : CommonPaginatedTable(
                              columns: const [
                                DataColumn(label: Text("S.No")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Image")),
                                DataColumn(
                                    headingRowAlignment:
                                        MainAxisAlignment.center,
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
            )
          : NoAccessWidget(),
    );
  }

  @override
  ServicesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ServicesViewModel();
}
