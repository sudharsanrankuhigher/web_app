import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/permissions/widgets/permission_table.dart';
import 'package:webapp/ui/views/permissions/widgets/simple_permission_table.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/permissions_cells.dart';

import 'permissions_viewmodel.dart';

class PermissionsView extends StackedView<PermissionsViewModel> {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PermissionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: defaultPadding12 - topPadding12,
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
                          'Permissions',
                          style: fontFamilyBold.size26.black,
                        ),
                      ),
                      verticalSpacing12,
                      Container(
                        padding: leftPadding8,
                        width: 300,
                        child: DropdownButtonFormField<int>(
                          value: viewModel.selectedRoleId,
                          decoration: decoration("Roles"),
                          items: viewModel.roles
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e.id,
                                  child: Text(e.name ?? ''),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            viewModel.setSelectedRoleId(value);
                          },
                        ),
                      ),

                      // verticalSpacing10,
                      // Container(
                      //   padding: rightPadding30,
                      //   width: double.infinity,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Text("Select All Permissions"),
                      //       horizontalSpacing10,
                      //       Checkbox(
                      //           value: viewModel.isCheck,
                      //           onChanged: (newValue) {
                      //             viewModel.toggleSelect(newValue!);
                      //           }),
                      //     ],
                      //   ),
                      // ),
                      verticalSpacing12,
                      (viewModel.selectedRoleId != null)
                          ? Container(
                              padding: defaultPadding12,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: permissionTable(viewModel))
                          : Center(
                              child: Text(
                                'Please select role',
                                style: fontFamilyMedium.size14.red,
                              ),
                            ),
                      verticalSpacing20,
                      if ((viewModel.selectedRoleId != null))
                        simplePermissionTable(viewModel),
                      verticalSpacing20,
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: (viewModel.selectedRoleId == null)
            ? Container(
                height: 0.1,
              )
            : Padding(
                padding: defaultPadding12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CommonButton(
                      width: 100,
                      padding: defaultPadding4 + leftPadding4 + rightPadding4,
                      height: 45,
                      text: 'Cancel',
                      buttonColor: white,
                      textStyle: fontFamilyBold.size14.black,
                    ),
                    CommonButton(
                      width: 100,
                      padding: defaultPadding4 + leftPadding4 + rightPadding4,
                      height: 45,
                      text: 'Save',
                      buttonColor: continueButton,
                      textStyle: fontFamilyBold.size14.white,
                    ),
                  ],
                ),
              ));
  }

  @override
  PermissionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PermissionsViewModel();
}
