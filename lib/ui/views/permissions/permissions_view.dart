import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/permissions/widgets/permission_table.dart';
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
    String role = 'Super Admin';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
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
                  'Roles & Permissions',
                  style: fontFamilyBold.size26.black,
                ),
              ),
              verticalSpacing12,
              Container(
                padding: leftPadding8,
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: role,
                  decoration: decoration("Roles"),
                  items: const [
                    DropdownMenuItem(
                        value: "Super Admin", child: Text("Super Admin")),
                    DropdownMenuItem(value: "Admin", child: Text("Admin")),
                    DropdownMenuItem(
                        value: "Sub Admin", child: Text("Sub Admin")),
                  ],
                  onChanged: (v) => role = v!,
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
              Container(
                  padding: defaultPadding12,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: permissionTable(viewModel)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PermissionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PermissionsViewModel();
}
