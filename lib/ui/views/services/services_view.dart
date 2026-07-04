import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/services/widgets/service_add_edit_dialog.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'package:webapp/widgets/search_text_field.dart';
import 'services_viewmodel.dart';

class ServicesView extends StackedView<ServicesViewModel> {
  const ServicesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ServicesViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = screenWidth > 1200;

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
                            'Service Management',
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
                          hintText: "Search service name...",
                          onChanged: viewModel.applySearch,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
          : const NoAccessWidget(),
    );
  }

  @override
  ServicesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ServicesViewModel();
}
