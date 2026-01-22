import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

import 'contact_support_viewmodel.dart';

class ContactSupportView extends StackedView<ContactSupportViewModel> {
  const ContactSupportView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ContactSupportViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
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
                'Contact Support Management',
                style: fontFamilyBold.size26.black,
              ),
            ),
            verticalSpacing12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // spacing: 40, // horizontal spacing between items
              // runSpacing: 16, // vertical spacing when wrapping
              // crossAxisAlignment: WrapCrossAlignment.center,
              // alignment: WrapAlignment.start,
              children: [
                CommonButton(
                  text: 'Client App',
                  textStyle: fontFamilySemiBold.size14.black,
                  buttonColor: white,
                  borderRadius: 12,
                ),
                horizontalSpacing10,
                Row(
                  children: [
                    if (viewModel.selectedIds.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          viewModel.selectedIds.isEmpty
                              ? null
                              : viewModel.delete(context);
                        },
                        icon: Icon(Icons.delete),
                        iconSize: 35,
                        color: red,
                      ),
                    horizontalSpacing10,
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
                              // viewModel.applySort(isChecked, sortType);
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
                child: viewModel.isBusy || viewModel.isRequestLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        enableCheckBox: true,
                        columns: const [
                          DataColumn(label: Text('S.No')),
                          DataColumn(label: Text('Client Name')),
                          DataColumn(label: Text('City / State')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('description')),
                          DataColumn(label: Text('Note')),
                          DataColumn(label: Text('Contact No')),
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
      ),
    );
  }

  @override
  ContactSupportViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ContactSupportViewModel();
}
