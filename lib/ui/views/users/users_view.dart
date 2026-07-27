import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/month_year_picker.dart';
import 'package:webapp/widgets/no_access_widget.dart';
import 'package:webapp/widgets/responsive_menu_button.dart';
import 'package:webapp/widgets/search_text_field.dart';
import 'users_viewmodel.dart';

class UsersView extends StackedView<UsersViewModel> {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UsersViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = screenWidth > 1000;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: isMobile ? const ResponsiveMenuButton() : null,
          title: Text(
            'User Management',
            style: fontFamilyBold.size20.black,
          ),
          actions: isMobile
              ? null
              : [
                  Padding(
                    padding: defaultPadding12,
                    child: InkWell(
                      onTap: () {
                        viewModel.loadUsers(getAll: true, ignoreState: true);
                      },
                      child: Container(
                          padding: defaultPadding8,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2.w),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade50,
                          ),
                          child: Text(
                            'Get All Users',
                            style: fontFamilySemiBold.size11.black,
                          )),
                    ),
                  ),
                  Padding(
                    padding: defaultPadding12,
                    child: MonthYearPickerField(
                      selectedDate: viewModel.selectedMonth,
                      onChanged: (viewDate) {
                        viewModel.selectedMonth = viewDate;
                        print(viewModel.selectedMonth.toString());
                        viewModel.loadUsers();
                        viewModel.notifyListeners();
                        print(viewDate);
                      },
                    ),
                  ),
                ],
        ),
        body: PermissionHelper.instance.canView('users')
            ? Padding(
                padding: defaultPadding20 - topPadding20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile) ...[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              viewModel.loadUsers(
                                  getAll: true, ignoreState: true);
                            },
                            child: Container(
                                padding: defaultPadding8,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 2.w),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade50,
                                ),
                                child: Text(
                                  'Get All Users',
                                  style: fontFamilySemiBold.size11.black,
                                )),
                          ),
                          MonthYearPickerField(
                            selectedDate: viewModel.selectedMonth,
                            onChanged: (viewDate) {
                              viewModel.selectedMonth = viewDate;
                              print(viewModel.selectedMonth.toString());
                              viewModel.loadUsers();
                              viewModel.notifyListeners();
                              print(viewDate);
                            },
                          ),
                        ],
                      ),
                      verticalSpacing12,
                    ],
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          height: 48.h,
                          width: isMobile
                              ? screenWidth * 0.9
                              : (isExtended ? 500 : 250),
                          child: SearchTextField(
                            hintText: "Search name, email, phone...",
                            onChanged: viewModel.searchUser,
                          ),
                        ),
                        if (viewModel.isSuperAdmin)
                          SizedBox(
                            height: 48.h,
                            width: isMobile ? screenWidth * 0.9 : 200,
                            child: DropdownSearch<String>(
                              selectedItem: viewModel.selectedState,
                              items: (String filter, LoadProps? props) async {
                                final search = filter
                                    .trim()
                                    .toLowerCase()
                                    .replaceAll(' ', '');
                                return viewModel.states.where((s) {
                                  if (search.isEmpty) return true;
                                  return s
                                      .toLowerCase()
                                      .replaceAll(' ', '')
                                      .contains(search);
                                }).toList();
                              },
                              dropdownBuilder: (context, selectedItem) =>
                                  FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  selectedItem ?? "All",
                                  style: fontFamilyMedium.size12.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                itemBuilder: (context, String item,
                                    bool isSelected, bool _) {
                                  return ListTile(
                                    title: Text(item),
                                    selected: isSelected,
                                  );
                                },
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  fillColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF334155)
                                      : backgroundColor,
                                  filled: true,
                                  hintText: "Filter by State",
                                  hintStyle: fontFamilyMedium.size12.greyColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[700]!
                                          : disableColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                              onChanged: viewModel.onStateChanged,
                            ),
                          ),
                        SizedBox(
                          width: isExtended ? 180 : null,
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
                      ],
                    ),
                    verticalSpacing20,
                    Expanded(
                      child: viewModel.isBusy
                          ? const Center(child: CircularProgressIndicator())
                          : CommonPaginatedTable(
                              columns: const [
                                DataColumn(label: Text("S.No")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Email")),
                                DataColumn(label: Text("Phone")),
                                DataColumn(label: Text("Type")),
                                DataColumn(label: Text("Onboard")),
                                DataColumn(
                                  label: Text("notes"),
                                  headingRowAlignment: MainAxisAlignment.center,
                                ),
                                DataColumn(label: Text("City/State")),
                                DataColumn(label: Text("View")),
                                // DataColumn(label: Text("Actions")),
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
              )
            : const NoAccessWidget());
  }

  @override
  UsersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UsersViewModel();

  @override
  void onViewModelReady(UsersViewModel viewModel) {
    if (viewModel.isSuperAdmin) {
      viewModel.loadStates();
    }
    viewModel.loadUsers();
    super.onViewModelReady(viewModel);
  }
}
