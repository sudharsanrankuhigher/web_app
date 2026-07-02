import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webapp/widgets/web_image_loading.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'package:webapp/widgets/search_text_field.dart';
import 'sub_admin_viewmodel.dart';

class SubAdminView extends StackedView<SubAdminViewModel> {
  const SubAdminView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SubAdminViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      body: Stack(
        children: [
          PermissionHelper.instance.canView('sub_admin')
              ? Padding(
                  padding: defaultPadding20 - topPadding20,
                  child: SizedBox(
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
                                  onPressed: () => HomeView.scaffoldKey.currentState?.openDrawer(),
                                ),
                                horizontalSpacing8,
                              ],
                              Expanded(
                                child: Text(
                                  'Sub-Admin Management',
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
                                hintText: "Search name, email, phone...",
                                onChanged: (value) =>
                                    viewModel.searchInfluencer(value),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CommonButton(
                                  buttonColor: continueButton,
                                  padding: isExtended
                                      ? defaultPadding4 + rightPadding4
                                      : defaultPadding4 + leftPadding8,
                                  text: isExtended ? "Filter & Sort" : "",
                                  borderRadius: 10,
                                  textStyle: fontFamilyMedium.size14.white
                                      .copyWith(
                                          overflow: TextOverflow.ellipsis),
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
                                        viewModel.applySort(
                                            isChecked, sortType);
                                      },
                                    );
                                  },
                                ),
                                if (PermissionHelper.instance
                                    .canAdd('sub_admin')) ...{
                                  horizontalSpacing10,
                                  CommonButton(
                                    padding: defaultPadding12 +
                                        rightPadding4 +
                                        leftPadding4,
                                    icon: const Icon(Icons.add,
                                        color: white, size: 16),
                                    buttonColor: continueButton,
                                    textStyle: fontFamilyMedium.size14.white,
                                    margin: EdgeInsets.zero,
                                    borderRadius: 10,
                                    text: isExtended ? "Add Sub-Admin" : "",
                                    onTap: () async {
                                      viewModel.onAdd(context);
                                    },
                                  ),
                                }
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
                                    DataColumn(label: Text("Profile")),
                                    DataColumn(label: Text("Name")),
                                    DataColumn(label: Text("Location")),
                                    DataColumn(label: Text("Login")),
                                    DataColumn(label: Text("Logout")),
                                    DataColumn(label: Text("Attendance")),
                                    DataColumn(label: Text("Online At")),
                                    DataColumn(label: Text("Access")),
                                    DataColumn2(
                                        fixedWidth: 80,
                                        label: Text("Action")),
                                    DataColumn(label: Text("View Id")),
                                    DataColumn(label: Text("Status")),
                                  ],
                                  source: viewModel.tableSource!,
                                  rowsperPage:
                                      viewModel.tableSource!.rowCount < 10
                                          ? viewModel.tableSource!.rowCount
                                          : 10,
                                  minWidth: 1200,
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              : const NoAccessWidget(),
          if (viewModel.showProfilePanel)
            _buildProfilePanel(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildProfilePanel(BuildContext context, SubAdminViewModel viewModel) {
    String profileImageUrl =
        "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3";
    final image = viewModel.historyProfileImg;
    if (image != null && image.isNotEmpty) {
      if (image.startsWith('http')) {
        profileImageUrl = image;
      } else {
        String cleanPath = image;
        if (cleanPath.startsWith('/')) {
          cleanPath = cleanPath.substring(1);
        }
        profileImageUrl = "http://172.20.25.23:8001/$cleanPath";
      }
    }

    return Positioned.fill(
      child: Stack(
        children: [
          // Semi-transparent overlay to close panel when clicking outside
          GestureDetector(
            onTap: () => viewModel.closeProfilePanel(),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Right aligned sliding panel
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 380,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(-8, 0),
                  ),
                ],
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'User Attendance Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => viewModel.closeProfilePanel(),
                            hoverColor: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.08),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Content Section
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Image
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.15),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: kIsWeb
                                      ? WebImage(
                                          imageUrl: profileImageUrl,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: profileImageUrl,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                            "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3",
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // User Name
                            Text(
                              viewModel.historyName ?? "User Name",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Designation/Role Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                viewModel.historyRole ?? "Sub-Admin",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Email Address Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    viewModel.historyEmail ??
                                        "user@example.com",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.7),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 18),

                            // Attendance History Section Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Logs & Attendance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Month-wise',
                                    style: TextStyle(
                                      color: Color(0xFF1DA1F2),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Filter Selectors (Month and Year)
                            Row(
                              children: [
                                // Month Selector
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.3),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: viewModel.selectedMonth,
                                        isExpanded: true,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        items: viewModel.months
                                            .map((String month) {
                                          return DropdownMenuItem<String>(
                                            value: month,
                                            child: Text(month),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            viewModel.setSelectedMonth(val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Year Selector
                                Expanded(
                                  child: InkWell(
                                    onTap: () => viewModel
                                        .selectYearFromCalendar(context),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 52,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.3),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            viewModel.selectedYear.toString(),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            size: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // List of Login/Logout details
                            if (viewModel.isHistoryLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (viewModel.loginLogoutHistory.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.history_toggle_off_rounded,
                                      size: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'No records found',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.loginLogoutHistory.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final logItem =
                                      viewModel.loginLogoutHistory[index];
                                  return Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.12),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.015),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              logItem['date'] ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.login_rounded,
                                                    size: 15,
                                                    color: Colors.blue,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Login',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onSurface
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        logItem['login'] ?? '-',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.logout_rounded,
                                                    size: 15,
                                                    color: Colors.redAccent,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Logout',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onSurface
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        logItem['logout'] ??
                                                            '-',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  SubAdminViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SubAdminViewModel();
}
