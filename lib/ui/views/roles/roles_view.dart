import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/roles/widgets/role_add_edit_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'roles_viewmodel.dart';

class RolesView extends StackedView<RolesViewModel> {
  const RolesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RolesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: PermissionHelper.instance.canView('role')
            ? Padding(
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
                        'Roles Management',
                        style: fontFamilyBold.size26.black,
                      ),
                    ),
                    verticalSpacing12,
                    if (PermissionHelper.instance.canAdd('role'))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommonButton(
                              width: 180,
                              icon:
                                  const Icon(Icons.add, color: white, size: 16),
                              buttonColor: continueButton,
                              textStyle: fontFamilyMedium.size14.white,
                              margin: leftPadding12 + rightPadding12,
                              borderRadius: 10,
                              text: "Add Roles",
                              onTap: () async {
                                final result = await CommonRoleDialog.show(
                                  StackedService.navigatorKey!.currentContext!,
                                );

                                if (result != null) {
                                  print('role Name: ${result['name']}');
                                  print(result);
                                  viewModel.addRole(result);
                                  // You can save to API or database here
                                }
                              }),
                        ],
                      ),
                    verticalSpacing12,
                    Expanded(
                        child: viewModel.isBusy || viewModel.isLoading == true
                            ? const Center(child: CircularProgressIndicator())
                            : CommonPaginatedTable(
                                columns: const [
                                  DataColumn(label: Text("S.No")),
                                  DataColumn(label: Text("Id")),
                                  DataColumn(label: Text("Name")),
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
            : NoAccessWidget());
  }

  @override
  RolesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RolesViewModel();
}
