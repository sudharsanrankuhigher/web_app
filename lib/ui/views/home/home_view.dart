import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:webapp/ui/common/shared/styles.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // ─────────── LEFT MENU ───────────
          Container(
            width: isExtended ? 230 : 80,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              crossAxisAlignment: isExtended
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                // Logo + App Name
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage("assets/logo.png"),
                    ),
                    if (isExtended) ...[
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "promote",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: "app",
                              style: TextStyle(
                                color: Colors.black,
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
                                Icon(
                                  viewModel.railIcons[index],
                                  size: 20,
                                  color:
                                      selected ? Colors.white : Colors.black87,
                                ),
                                if (isExtended) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    viewModel.railLabel[index],
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
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
                Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            "https://example.com/profile.jpg",
                          ),
                        ),
                        if (isExtended) ...[
                          const SizedBox(width: 10),
                          const Text(
                            "Sudharsan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Admin",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                    verticalSpacing16,
                    GestureDetector(
                      onTap: () {},
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
              ],
            ),
          ),

          Expanded(
            child: child ?? Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.init(StackedService.navigatorKey!.currentContext!);
  }
}
