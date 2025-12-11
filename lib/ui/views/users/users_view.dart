import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/users/widgets/common_user_dialog.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'users_viewmodel.dart';

class UsersView extends StackedView<UsersViewModel> {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UsersViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      body: Padding(
        padding: defaultPadding20 - topPadding20,
        child: Container(
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
                  'User Management',
                  style: fontFamilyBold.size26.black,
                ),
              ),
              verticalSpacing12,
              Wrap(
                spacing: 40,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  SizedBox(
                    height: 45.h,
                    width: 500,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search name, email, phone...",
                        hintStyle: fontFamilyRegular.size14.grey,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: viewModel.searchUser,
                    ),
                  ),
                  if (isExtended)
                    SizedBox(
                      width: 240,
                    ),
                  // Filter Button
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
                          child: Image.asset('assets/images/filter.png')),
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
                  SizedBox(
                    width: 180,
                    child: CommonButton(
                      icon: Icon(Icons.add, color: white, size: 16),
                      buttonColor: continueButton,
                      textStyle: fontFamilyMedium.size14.white,
                      margin: EdgeInsets.zero,
                      borderRadius: 10,
                      text: isExtended ? "Add Users" : "",
                      onTap: () async {
                        final result = await CommonUserDialog.show(
                          StackedService.navigatorKey!.currentContext!,
                        );

                        if (result != null) {
                          print('name: ${result['name']}');
                          print('email: ${result['email']}');
                          print('phone: ${result['amount']}');
                          print('city: ${result['city']}');
                          print('state: ${result['state']}');
                        }
                      },
                    ),
                  ),
                ],
              ),
              verticalSpacing20,
              Expanded(
                child: viewModel.users.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        columns: const [
                          DataColumn(label: Text("S.No")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Phone")),
                          DataColumn(label: Text("Type")),
                          DataColumn(label: Text("City/State")),
                          DataColumn(label: Text("Plan")),
                          DataColumn(label: Text("Connections")),
                          DataColumn(label: Text("Actions")),
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
      ),
    );
  }

  @override
  UsersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UsersViewModel();

  @override
  void onViewModelReady(UsersViewModel viewModel) {
    viewModel.loadUsers();
    super.onViewModelReady(viewModel);
  }
}
