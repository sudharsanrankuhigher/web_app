import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'contact_support_viewmodel.dart';
import 'package:webapp/widgets/search_text_field.dart';
import 'package:webapp/services/profile_service.dart';

class ContactSupportView extends StackedView<ContactSupportViewModel> {
  const ContactSupportView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ContactSupportViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: PermissionHelper.instance.has('add_call')
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
                              onPressed: () => HomeView.scaffoldKey.currentState
                                  ?.openDrawer(),
                            ),
                            horizontalSpacing8,
                          ],
                          Expanded(
                            child: Text(
                              'Contact Support Management',
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
                        CommonButton(
                          text: 'Client App',
                          textStyle: fontFamilySemiBold.size14.black,
                          buttonColor: white,
                          borderRadius: 12,
                        ),
                        // Search bar
                        SizedBox(
                          height: 45,
                          width: isMobile ? screenWidth * 0.9 : 300,
                          child: SearchTextField(
                            hintText: "Search name, phone, status, ID...",
                            onChanged: (val) {
                              viewModel.setSearchQuery(val);
                            },
                          ),
                        ),
                        // Status Filter Dropdown
                        Container(
                          height: 45,
                          width: isMobile ? screenWidth * 0.9 : 160,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: viewModel.selectedStatus,
                              isExpanded: true,
                              icon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              items: <String>[
                                'All',
                                'Pending',
                                'Completed',
                                'Processing'
                              ].map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  viewModel.setSelectedStatus(val);
                                }
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ProfileService.instance.roleId == '1' &&
                                viewModel.selectedIds.isNotEmpty) ...[
                              IconButton(
                                onPressed: () {
                                  viewModel.selectedIds.isEmpty
                                      ? null
                                      : viewModel.delete(context);
                                },
                                icon: const Icon(Icons.delete),
                                iconSize: 35,
                                color: red,
                              ),
                              horizontalSpacing10,
                            ],
                            SizedBox(
                              width: isExtended ? 180 : null,
                              child: CommonButton(
                                buttonColor: continueButton,
                                margin: EdgeInsets.zero,
                                padding: defaultPadding4,
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
                      ],
                    ),
                    verticalSpacing20,
                    Expanded(
                        child: viewModel.isBusy ||
                                viewModel.isRequestLoading == true
                            ? const Center(child: CircularProgressIndicator())
                            : CommonPaginatedTable(
                                enableCheckBox:
                                    ProfileService.instance.roleId == '1',
                                columns: const [
                                  DataColumn(label: Text('S.No')),
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Client Name')),
                                  DataColumn(label: Text('City / State')),
                                  DataColumn(label: Text('Phone')),
                                  DataColumn(label: Text('description')),
                                  DataColumn(label: Text('Note')),
                                  DataColumn(label: Text('Create Ticket')),
                                  DataColumn(label: Text('Update Ticket')),
                                  DataColumn(label: Text('status')),
                                  DataColumn(label: Text('Actions')),
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
            : const NoAccessWidget());
  }

  @override
  ContactSupportViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ContactSupportViewModel();
}
