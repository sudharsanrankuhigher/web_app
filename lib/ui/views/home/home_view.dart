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

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? _) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Container(
            width: isExtended ? 230 : 80,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              crossAxisAlignment: isExtended
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                // Logo + App Name
                InkWell(
                  onTap: () => viewModel.onMenuTap(0, context),
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
                      final bool selected = viewModel.selectedIndex == index;

                      return Padding(
                        padding: defaultPadding4,
                        child: GestureDetector(
                          onTap: () => viewModel.onMenuTap(index, context),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 48.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF1DA1F2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                // SizedBox(
                                //   height: !isExtended ? 44.h : 24.h,
                                //   width: !isExtended ? 44.w : 24.w,
                                //   child: Image.asset(
                                //     viewModel.railIcon[index],
                                //     color: selected
                                //         ? Colors.white
                                //         : Colors.black87,
                                //   ),
                                // ),
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
                                          viewModel.unreadNotificationsCount >
                                              0 &&
                                          !isExtended) {
                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            icon,
                                            Positioned(
                                              right: -6,
                                              top: -6,
                                              child: _buildNotificationBadge(
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
                                          viewModel.pendingRequestsCount > 0 &&
                                          !isExtended) {
                                        return Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            icon,
                                            Positioned(
                                              right: -6,
                                              top: -6,
                                              child: _buildNotificationBadge(
                                                viewModel.pendingRequestsCount,
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
                                      viewModel.unreadNotificationsCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
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
                                      padding: const EdgeInsets.only(left: 8.0),
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
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: kIsWeb
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: WebImage(
                                      imageUrl: (viewModel.profileImage !=
                                                  null &&
                                              viewModel
                                                  .profileImage!.isNotEmpty)
                                          ? (viewModel.profileImage!
                                                  .startsWith('http')
                                              ? viewModel.profileImage!
                                              : viewModel.profileImage!
                                                      .startsWith('storage/')
                                                  ? "https://admin.promoteapp.in/${viewModel.profileImage}"
                                                  : "https://admin.promoteapp.in/storage/${viewModel.profileImage}")
                                          : "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3",
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: (viewModel.profileImage != null &&
                                            viewModel.profileImage!.isNotEmpty)
                                        ? (viewModel.profileImage!
                                                .startsWith('http')
                                            ? viewModel.profileImage!
                                            : viewModel.profileImage!
                                                    .startsWith('storage/')
                                                ? "https://admin.promoteapp.in/${viewModel.profileImage}"
                                                : "https://admin.promoteapp.in/storage/${viewModel.profileImage}")
                                        : "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3",
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 22,
                                      backgroundImage: imageProvider,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      radius: 22,
                                      backgroundImage: NetworkImage(
                                          "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3"),
                                    ),
                                    placeholder: (context, url) => CircleAvatar(
                                      radius: 22,
                                      backgroundImage: const AssetImage(
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
                                    // errorWidget: (context, url, error) =>
                                    //     const CircleAvatar(
                                    //   radius: 22,
                                    //   child: Icon(Icons.error),
                                    // ),
                                  ),
                          ),
                          if (isExtended) ...[
                            const SizedBox(width: 10),
                            Text(
                              viewModel.name ?? "Admin Name",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ],
                      ),
                      if (isExtended)
                        Text(
                          viewModel.role ?? "Administrator",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      verticalSpacing16,
                      ListenableBuilder(
                        listenable: ThemeService.instance,
                        builder: (context, _) {
                          final isDark = ThemeService.instance.isDarkMode;
                          return InkWell(
                            onTap: () => ThemeService.instance.toggleTheme(),
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
            ),
          ),
          Expanded(
            child: child ?? const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

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

  // @override
  // void onViewModelReady(HomeViewModel viewModel) {
  //   viewModel.init(StackedService.navigatorKey!.currentContext!);
  // }
}
