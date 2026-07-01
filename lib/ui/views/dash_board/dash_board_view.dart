import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/client_project_info_card.dart';
import 'package:webapp/widgets/monthly_bar_chart.dart';
import 'package:webapp/widgets/no_access_widget.dart';

import 'dash_board_viewmodel.dart';

class DashBoardView extends StackedView<DashBoardViewModel> {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashBoardViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    String formatCurrency(double amount) {
      if (amount >= 1000000) {
        return '₹${(amount / 1000000).toStringAsFixed(2)}M';
      } else if (amount >= 1000) {
        return '₹${(amount / 1000).toStringAsFixed(1)}K';
      } else {
        return '₹${amount.toStringAsFixed(0)}';
      }
    }

    String formatNumber(int number) {
      if (number >= 1000000) {
        return '${(number / 1000000).toStringAsFixed(2)}M';
      } else if (number >= 1000) {
        return '${(number / 1000).toStringAsFixed(1)}K';
      } else {
        return number.toString();
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PermissionHelper.instance.canView('dashboard')
          ? SingleChildScrollView(
              child: Padding(
                padding: defaultPadding16 - topPadding12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dashboard',
                            style: fontFamilyBold.size26.black,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: continueButton,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => viewModel.exportPdfWeb(context),
                            icon: const Icon(Icons.picture_as_pdf, size: 18),
                            label: Text(
                              'Download PDF',
                              style: fontFamilySemiBold.size12.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Filter Card Panel
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.withOpacity(0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Period Switcher Toggle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Period Type',
                                  style: fontFamilyMedium.size11.greyColor),
                              verticalSpacing8,
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => viewModel.setMonthly(true),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: viewModel.isMonthly
                                              ? continueButton
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Text(
                                          'Monthly',
                                          style: fontFamilySemiBold.size12
                                              .copyWith(
                                            color: viewModel.isMonthly
                                                ? Colors.white
                                                : (isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[700]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => viewModel.setMonthly(false),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: !viewModel.isMonthly
                                              ? continueButton
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Text(
                                          'Yearly',
                                          style: fontFamilySemiBold.size12
                                              .copyWith(
                                            color: !viewModel.isMonthly
                                                ? Colors.white
                                                : (isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[700]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Monthly Filter (Month Selector Dropdown)
                          if (viewModel.isMonthly)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Select Month',
                                    style: fontFamilyMedium.size11.greyColor),
                                verticalSpacing8,
                                SizedBox(
                                  width: 150,
                                  height: 42,
                                  child: DropdownButtonFormField<String>(
                                    value: viewModel.selectedMonth,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                      ),
                                    ),
                                    items: viewModel.months.map((m) {
                                      return DropdownMenuItem<String>(
                                        value: m,
                                        child: Text(m,
                                            style:
                                                fontFamilyRegular.size12.black),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null)
                                        viewModel.setSelectedMonth(val);
                                    },
                                  ),
                                ),
                              ],
                            ),

                          // Year Selector Dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select Year',
                                  style: fontFamilyMedium.size11.greyColor),
                              verticalSpacing8,
                              SizedBox(
                                width: 120,
                                height: 42,
                                child: DropdownButtonFormField<String>(
                                  value: viewModel.selectedYear,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                  ),
                                  items: viewModel.years.map((y) {
                                    return DropdownMenuItem<String>(
                                      value: y,
                                      child: Text(y,
                                          style:
                                              fontFamilyRegular.size12.black),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null)
                                      viewModel.setSelectedYear(val);
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Location / State Selector Dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location (State)',
                                  style: fontFamilyMedium.size11.greyColor),
                              verticalSpacing8,
                              SizedBox(
                                width: 220,
                                height: 42,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: viewModel.selectedState,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: continueButton),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                  ),
                                  items: viewModel.states.map((s) {
                                    return DropdownMenuItem<String>(
                                      value: s,
                                      child: Text(
                                        s,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: fontFamilyRegular.size12.black,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null)
                                      viewModel.setSelectedState(val);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Selected Period Summary
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: continueButton,
                          ),
                          horizontalSpacing8,
                          Text(
                            viewModel.isMonthly
                                ? "Showing Data for: ${viewModel.selectedMonth} ${viewModel.selectedYear}"
                                : "Showing Data for Year: ${viewModel.selectedYear}",
                            style: fontFamilySemiBold.size14.copyWith(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SECTION 1: Client Side Overview
                    _buildSectionHeader('Total count Client side'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'No. of Clients',
                          count: formatNumber(viewModel.clientCount),
                          color: continueButton,
                          icon: Icons.people_alt_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Client Projects',
                          count: formatNumber(viewModel.clientProjects),
                          color: publisButtonColor,
                          icon: Icons.work_outline,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Client Revenue',
                          count: formatCurrency(viewModel.clientRevenue),
                          color: appGreen500,
                          icon: Icons.monetization_on_outlined,
                        ),
                      ],
                    ),

                    // SECTION 2: Promote Side Overview
                    _buildSectionHeader('Total count Promote side'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'No. of Companies',
                          count: formatNumber(viewModel.companyCount),
                          color: activeColor,
                          icon: Icons.business_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Companies Projects',
                          count: formatNumber(viewModel.companyProjects),
                          color: pending,
                          icon: Icons.assignment_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Company Revenue',
                          count: formatCurrency(viewModel.companyRevenue),
                          color: appGreen600,
                          icon: Icons.payments_outlined,
                        ),
                      ],
                    ),

                    // SECTION 3: Influencers Breakdown
                    _buildSectionHeader('Influencers Count'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Total Influencers',
                          count: formatNumber(viewModel.totalInfluencersCount),
                          color: continueButton,
                          icon: Icons.group_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'TV Stars',
                          count: formatNumber(viewModel.tvStarsCount),
                          color: pending,
                          icon: Icons.tv_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Sport Stars',
                          count: formatNumber(viewModel.sportStarsCount),
                          color: appGreen600,
                          icon: Icons.sports_soccer_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Movie Stars',
                          count: formatNumber(viewModel.movieStarsCount),
                          color: red,
                          icon: Icons.movie_filter_outlined,
                        ),
                      ],
                    ),

                    // SECTION 4: Projects Breakdown
                    _buildSectionHeader('Projects Count'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Total Projects',
                          count: formatNumber(viewModel.totalProjectsCount),
                          color: publisButtonColor,
                          icon: Icons.folder_shared_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Influencer Projects',
                          count:
                              formatNumber(viewModel.regularInfluencerProjects),
                          color: activeColor,
                          icon: Icons.campaign_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'TV Stars Projects',
                          count: formatNumber(viewModel.tvStarsProjects),
                          color: pending,
                          icon: Icons.live_tv_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Sport Stars Projects',
                          count: formatNumber(viewModel.sportStarsProjects),
                          color: appGreen500,
                          icon: Icons.emoji_events_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Movie Stars Projects',
                          count: formatNumber(viewModel.movieStarsProjects),
                          color: red,
                          icon: Icons.theater_comedy_outlined,
                        ),
                      ],
                    ),

                    // SECTION 5: Commissions
                    _buildSectionHeader('Influencers Give Money Count'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Client Project Commission',
                          count:
                              formatCurrency(viewModel.clientProjectCommission),
                          color: appGreen600,
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Promote Project Commission',
                          count: formatCurrency(
                              viewModel.promoteProjectCommission),
                          color: continueButton,
                          icon: Icons.receipt_long_outlined,
                        ),
                      ],
                    ),

                    // SECTION 6: Advertising Revenue
                    _buildSectionHeader('Package & Banner Revenue'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Package Revenue',
                          count: formatCurrency(viewModel.packageRevenue),
                          color: activeColor,
                          icon: Icons.card_membership_outlined,
                        ),
                        _buildPremiumMetricCard(
                          context: context,
                          title: 'Banner Revenue',
                          count: formatCurrency(viewModel.bannerRevenue),
                          color: publisButtonColor,
                          icon: Icons.featured_video_outlined,
                        ),
                      ],
                    ),

                    // SECTION 7 & 8: Projects Status Breakdown & Comparative Chart
                    _buildSectionHeader(
                        'Commissions Comparison & Project Breakdowns'),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        // Chart Card
                        Card(
                          elevation: Theme.of(context).cardTheme.elevation ?? 2,
                          child: SizedBox(
                            width: isExtended
                                ? MediaQuery.of(context).size.width * 0.58
                                : MediaQuery.of(context).size.width * 0.94,
                            height: 380,
                            child: Container(
                              padding: defaultPadding16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Commissions Comparison',
                                            style:
                                                fontFamilySemiBold.size16.black,
                                          ),
                                          verticalSpacing4,
                                          Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? const Color(0xFF34D399)
                                                      : appGreen500,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              horizontalSpacing4,
                                              Text('Client Comm.',
                                                  style: fontFamilyRegular
                                                      .size10.greyColor),
                                              horizontalSpacing12,
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? const Color(0xFF60A5FA)
                                                      : continueButton,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              horizontalSpacing4,
                                              Text('Promote Comm.',
                                                  style: fontFamilyRegular
                                                      .size10.greyColor),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: appGreen600.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          viewModel.selectedYear,
                                          style: fontFamilySemiBold.size12
                                              .copyWith(
                                                  color: isDark
                                                      ? appGreen300
                                                      : appGreen700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalSpacing16,
                                  MonthlyBarChart(
                                    ongoing: viewModel
                                        .getMonthlyPromoteCommissions(),
                                    completed:
                                        viewModel.getMonthlyClientCommissions(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Status Breakdown Cards
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          direction:
                              isExtended ? Axis.vertical : Axis.horizontal,
                          children: [
                            // Client Status Card
                            Card(
                              elevation:
                                  Theme.of(context).cardTheme.elevation ?? 2,
                              child: Container(
                                width: 320,
                                padding: defaultPadding16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client Project Status',
                                      style: fontFamilySemiBold.size14.black,
                                    ),
                                    verticalSpacing12,
                                    ClientProjectInfoCard(
                                      boxColor: pending.withOpacity(0.10),
                                      dotColor: pending,
                                      text: "Pending",
                                      textColor: isDark
                                          ? const Color(0xFFFBBF24)
                                          : Colors.orange[800]!,
                                      count: formatNumber(
                                          viewModel.clientPendingCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    ClientProjectInfoCard(
                                      boxColor: onGoing.withOpacity(0.10),
                                      dotColor: onGoing,
                                      text: "Ongoing",
                                      textColor: isDark
                                          ? const Color(0xFF60A5FA)
                                          : Colors.blue[600]!,
                                      count: formatNumber(
                                          viewModel.clientOngoingCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    ClientProjectInfoCard(
                                      boxColor: greenShade1.withOpacity(0.10),
                                      dotColor: greenShade1,
                                      text: "Completed",
                                      textColor: isDark
                                          ? const Color(0xFF34D399)
                                          : Colors.green[600]!,
                                      count: formatNumber(
                                          viewModel.clientCompletedCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    ClientProjectInfoCard(
                                      boxColor:
                                          monthlyProjects.withOpacity(0.10),
                                      dotColor: monthlyProjects,
                                      text: "Monthly Project",
                                      textColor: isDark
                                          ? const Color(0xFF60A5FA)
                                          : Colors.blue[600]!,
                                      count: formatNumber(
                                          viewModel.clientMonthlyCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Promote Status Card
                            Card(
                              elevation:
                                  Theme.of(context).cardTheme.elevation ?? 2,
                              child: Container(
                                width: 320,
                                padding: defaultPadding16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Promote Project Status',
                                      style: fontFamilySemiBold.size14.black,
                                    ),
                                    verticalSpacing12,
                                    ClientProjectInfoCard(
                                      boxColor:
                                          publisButtonColor.withOpacity(0.10),
                                      dotColor: publisButtonColor,
                                      text: "In Progress",
                                      textColor: isDark
                                          ? const Color(0xFF38BDF8)
                                          : Colors.lightBlue[800]!,
                                      count: formatNumber(
                                          viewModel.promoteInProgressCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    ClientProjectInfoCard(
                                      boxColor: appGreen400.withOpacity(0.10),
                                      dotColor: appGreen400,
                                      text: "Completed",
                                      textColor: isDark
                                          ? const Color(0xFF34D399)
                                          : Colors.green[600]!,
                                      count: formatNumber(
                                          viewModel.promoteCompletedCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    ClientProjectInfoCard(
                                      boxColor:
                                          continueButton.withOpacity(0.10),
                                      dotColor: continueButton,
                                      text: "Monthly Project",
                                      textColor: isDark
                                          ? const Color(0xFF60A5FA)
                                          : Colors.blue[600]!,
                                      count: formatNumber(
                                          viewModel.promoteMonthlyCount),
                                      countColor:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const NoAccessWidget(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: Text(
        title,
        style: fontFamilySemiBold.size16.black,
      ),
    );
  }

  Widget _buildPremiumMetricCard({
    required BuildContext context,
    required String title,
    required String count,
    required Color color,
    required IconData icon,
    String? subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: fontFamilyMedium.size12.greyColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          verticalSpacing12,
          Text(
            count,
            style: fontFamilyBold.size22.black,
          ),
          if (subtitle != null) ...[
            verticalSpacing4,
            Text(
              subtitle,
              style: fontFamilyMedium.size10.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }

  @override
  DashBoardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashBoardViewModel();
}
