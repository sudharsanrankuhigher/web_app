import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/widgets/web_image_loading.dart';
import 'package:webapp/services/floating_overlay_service.dart';
import 'package:webapp/services/theme_service.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  final Widget child;
  const HomeView({Key? key, required this.child}) : super(key: key);

  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? _) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isExtended = screenWidth >= 1100;
    
    final currentLocation =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    viewModel.updateIndexFromRoute(currentLocation);

    // Mount the premium global draggable notification overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FloatingOverlayService.instance.show(
        context,
        onTap: (clickContext) {
          // Redirect to Notifications screen upon tap
          viewModel.onMenuTap(15, clickContext);
        },
      );
    });

    return Scaffold(
      key: HomeView.scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: SafeArea(
                  child: _buildSidebarContent(context, viewModel, isExtended: true, isDrawer: true),
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          Row(
            children: [
              if (!isMobile)
                Container(
                  width: isExtended ? 230 : 80,
                  color: Theme.of(context).colorScheme.surface,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: _buildSidebarContent(context, viewModel, isExtended: isExtended, isDrawer: false),
                ),
              Expanded(
                child:
                    child ?? const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
          if (viewModel.showProfilePanel)
            _buildProfilePanel(context, viewModel),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  Widget _buildSidebarContent(
    BuildContext context,
    HomeViewModel viewModel, {
    required bool isExtended,
    required bool isDrawer,
  }) {
    final bool selectedMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: isExtended
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // Logo + App Name
        InkWell(
          onTap: () {
            if (isDrawer) {
              Navigator.of(context).pop();
            }
            viewModel.onMenuTap(0, context);
          },
          child: Row(
            children: [
              Container(
                color: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 22,
                  backgroundImage:
                      const AssetImage("assets/images/logo.png"),
                  child: SvgPicture.asset(
                    "assets/images/logo.svg",
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 24,
                    width: 24,
                    package: null,
                  ),
                ),
              ),
              if (isExtended) ...[
                const SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "promote",
                        style: TextStyle(
                          color: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : const Color(0xff0B0952),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const TextSpan(
                        text: "app",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        verticalSpacing16,

        // Menu Items
        Expanded(
          child: ListView.builder(
            itemCount: viewModel.railLabel.length,
            itemBuilder: (context, index) {
              final bool selected =
                  viewModel.selectedIndex == index;

              return Padding(
                padding: defaultPadding4,
                child: GestureDetector(
                  onTap: () {
                    if (isDrawer) {
                      Navigator.of(context).pop();
                    }
                    viewModel.onMenuTap(index, context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 48.h,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1DA1F2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Tooltip(
                          message: viewModel.railLabel[index],
                          child: Builder(
                            builder: (context) {
                              final isNotification =
                                  viewModel.railLabel[index] ==
                                      'Notifications';
                              final isClientRequests =
                                  viewModel.railLabel[index] ==
                                      'Client Requests';
                              Widget icon = SvgPicture.asset(
                                viewModel.railIcon[index],
                                height: isExtended ? 24.h : 34.h,
                                width: isExtended ? 24.w : 34.w,
                                color: selected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                              );

                              if (isNotification &&
                                  viewModel
                                          .unreadNotificationsCount >
                                      0 &&
                                  !isExtended) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    icon,
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child:
                                          _buildNotificationBadge(
                                        viewModel
                                            .unreadNotificationsCount,
                                        selected,
                                        isMini: true,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              if (isClientRequests &&
                                  viewModel.pendingRequestsCount >
                                      0 &&
                                  !isExtended) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    icon,
                                    Positioned(
                                      right: -6,
                                      top: -6,
                                      child:
                                          _buildNotificationBadge(
                                        viewModel
                                            .pendingRequestsCount,
                                        selected,
                                        isMini: true,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return icon;
                            },
                          ),
                        ),
                        if (isExtended) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              viewModel.railLabel[index],
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                fontSize: 15,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (viewModel.railLabel[index] ==
                                  'Notifications' &&
                              viewModel.unreadNotificationsCount >
                                  0)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0),
                              child: _buildNotificationBadge(
                                viewModel.unreadNotificationsCount,
                                selected,
                                isMini: false,
                              ),
                            ),
                          if (viewModel.railLabel[index] ==
                                  'Client Requests' &&
                              viewModel.pendingRequestsCount > 0)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0),
                              child: _buildNotificationBadge(
                                viewModel.pendingRequestsCount,
                                selected,
                                isMini: false,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        verticalSpacing12,

        // Profile & Logout
        Padding(
          padding: leftPadding12,
          child: Column(
            crossAxisAlignment: isExtended
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (isDrawer) {
                    Navigator.of(context).pop();
                  }
                  viewModel.toggleProfilePanel();
                },
                borderRadius: BorderRadius.circular(12),
                hoverColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 4),
                  child: Column(
                    crossAxisAlignment: isExtended
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: kIsWeb
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(22),
                                    child: WebImage(
                                      imageUrl:
                                          viewModel.profileImageUrl,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        viewModel.profileImageUrl,
                                    imageBuilder:
                                        (context, imageProvider) =>
                                            CircleAvatar(
                                      radius: 22,
                                      backgroundImage:
                                          imageProvider,
                                    ),
                                    errorWidget:
                                        (context, url, error) =>
                                            const CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                          "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3"),
                                    ),
                                    placeholder: (context, url) =>
                                        CircleAvatar(
                                      radius: 22,
                                      backgroundImage:
                                          const AssetImage(
                                              "assets/images/logo.png",
                                              package: null),
                                      child: SvgPicture.asset(
                                        "assets/images/logo.svg",
                                        color: Colors.black,
                                        height: 24,
                                        width: 24,
                                        package: null,
                                      ),
                                    ),
                                  ),
                          ),
                          if (isExtended) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                viewModel.name ?? "Admin Name",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow:
                                        TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (isExtended) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 54),
                          child: Text(
                            viewModel.role ?? "Administrator",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              verticalSpacing16,
              ListenableBuilder(
                listenable: ThemeService.instance,
                builder: (context, _) {
                  final isDark = ThemeService.instance.isDarkMode;
                  return InkWell(
                    onTap: () =>
                        ThemeService.instance.toggleTheme(),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 48.h,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        mainAxisAlignment: isExtended
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: isDark
                                ? Colors.amber
                                : Colors.indigo[800],
                            size: isExtended ? 22 : 28,
                          ),
                          if (isExtended) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isDark ? "Light Mode" : "Dark Mode",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              verticalSpacing12,
              GestureDetector(
                onTap: () {
                  if (isDrawer) {
                    Navigator.of(context).pop();
                  }
                  viewModel.logOut(context);
                },
                child: Row(
                  mainAxisAlignment: isExtended
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    if (isExtended) const SizedBox(width: 10),
                    if (isExtended)
                      const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationBadge(int count, bool selected,
      {required bool isMini}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMini ? 4.w : 8.w,
        vertical: isMini ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.red,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(
        minWidth: isMini ? 12.w : 20.w,
        minHeight: isMini ? 12.h : 20.h,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyle(
          color: selected ? const Color(0xFF1DA1F2) : Colors.white,
          fontSize: isMini ? 8.sp : 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfilePanel(BuildContext context, HomeViewModel viewModel) {
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
                            'Admin Profile',
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
                                          imageUrl: viewModel.profileImageUrl,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: viewModel.profileImageUrl,
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
                              viewModel.name ?? "Admin Name",
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
                                viewModel.role ?? "Administrator",
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
                                    viewModel.email ?? "admin@promoteapp.in",
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

  // @override
  // void onViewModelReady(HomeViewModel viewModel) {
  //   viewModel.init(StackedService.navigatorKey!.currentContext!);
  // }
}
