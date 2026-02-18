import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webapp/app/app.bottomsheets.dart';
import 'package:webapp/app/app.dialogs.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
  HomeViewModel() {
    getProfile();
  }

  // void init(context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //   });
  // }

  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  int _counter = 0;
  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 0;

  final GlobalKey<NavigatorState> rightPanelNavigatorKey =
      GlobalKey<NavigatorState>();

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void selectedIndexes(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // ─── Left Menu Labels ───
  final List<String> railLabel = [
    'Dashboard',
    'Users',
    'Influencers',
    'Services',
    // 'City',
    // 'State',
    'Plans',
    "Banner",
    'Client Requests',
    'Promotion Projects',
    'Ticket Support',
    "Contact",
    'Company',
    'Sub Admin',
    'Report',
    'Roles',
    'Permissions',
  ];

  final List<String> railIcon = [
    'assets/images/dash_board.svg',
    'assets/images/user.svg',
    'assets/images/influencer_dashboard.svg',
    'assets/images/service_dashboard.svg',
    // 'assets/images/city.svg',
    'assets/images/plans_dashboard.svg',
    'assets/images/city.svg', // banner
    'assets/images/requests_dashboard.svg',
    'assets/images/promotes_proj_dashboard.svg',
    'assets/images/support_dashboard.svg',
    'assets/images/support_dashboard.svg',
    'assets/images/support_dashboard.svg',
    'assets/images/sub-admin_dashboard.svg',
    'assets/images/sub-admin_dashboard.svg',
    'assets/images/sub-admin_dashboard.svg',
    'assets/images/sub-admin_dashboard.svg',
  ];

  // ─── Bottom Labels ───
  final List<String> bottomLabel = ['Profile', 'Logout'];
  final List<String> bottomIcons = ['assets/profile.png', 'assets/logout.png'];

  void showDialogs() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  void onMenuTap(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        context.pushReplacementNamed('dashboard');
        _selectedIndex = 0;
        break;
      case 1:
        context.pushReplacementNamed('users');
        _selectedIndex = 1;
        break;
      case 2:
        context.pushReplacementNamed('influencers');
        _selectedIndex = 2;
        break;
      case 3:
        context.pushReplacementNamed('services');
        _selectedIndex = 3;
        break;
      // case 4:
      //   context.pushReplacementNamed('city');
      //   _selectedIndex = 4;
      //   break;
      // case 5:
      //   context.pushReplacementNamed('state');
      //   _selectedIndex = 5;
      //   break;
      case 4:
        context.pushReplacementNamed('plans');
        _selectedIndex = 4;
        break;
      case 5:
        context.pushReplacementNamed('banner');
        _selectedIndex = 5;
        break;
      case 6:
        context.pushReplacementNamed('requests');
        _selectedIndex = 6;
        break;
      case 7:
        context.pushReplacementNamed('promotion-projects');
        _selectedIndex = 7;
        break;
      case 8:
        context.pushReplacementNamed('contact-support');
        _selectedIndex = 8;
      case 9:
        context.pushReplacementNamed('contact');
        _selectedIndex = 9;
        break;
      case 10:
        context.pushReplacementNamed('company');
        _selectedIndex = 10;
        break;
      case 11:
        context.pushReplacementNamed('sub-admin');
        _selectedIndex = 11;
        break;
      case 12:
        context.pushReplacementNamed('report');
        _selectedIndex = 12;
        break;
      case 13:
        context.pushReplacementNamed('roles');
        _selectedIndex = 13;
        break;
      case 14:
        context.pushReplacementNamed('permissions');
        _selectedIndex = 14;
        break;
    }
  }

  void updateIndexFromRoute(String path) {
    switch (path) {
      case '/home/dashboard':
        _selectedIndex = 0;
        break;
      case '/home/users':
        _selectedIndex = 1;
        break;
      case '/home/influencers':
        _selectedIndex = 2;
        break;
      case '/home/services':
        _selectedIndex = 3;
        break;
      // case '/home/city':
      //   _selectedIndex = 4;
      //   break;
      // case '/home/state':
      //   _selectedIndex = 5;
      //   break;
      case '/home/plans':
        _selectedIndex = 4;
        break;
      case '/home/banner':
        _selectedIndex = 5;
        break;
      case '/home/requests':
        _selectedIndex = 6;
        break;
      case '/home/promotion-projects':
        _selectedIndex = 7;
        break;
      case '/home/ticket-support':
        _selectedIndex = 8;
        break;
      case '/home/contact':
        _selectedIndex = 9;
        break;
      case '/home/company':
        _selectedIndex = 10;
        break;
      case '/home/sub-admin':
        _selectedIndex = 11;
        break;
      case '/home/report':
        _selectedIndex = 12;
        break;
      case '/home/roles':
        _selectedIndex = 13;
        break;
      case '/home/permissions':
        _selectedIndex = 14;
        break;
      default:
        _selectedIndex = 0;
    }
  }

  void logOut(BuildContext context) {
    // context.pushReplacementNamed('login');
    showLogoutConfirmation(context);
  }

  void showLogoutConfirmation(BuildContext context) {
    final rootContext = context;

    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
              minWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔒 Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Confirm Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  const Text(
                    'Are you sure you want to log out?\nYou will need to login again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      // Cancel
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Logout
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // context.pushReplacementNamed('login');
                            Navigator.pop(context);
                            rootContext.pushReplacementNamed('login');
                            // context.pushReplacementNamed('login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: fontFamilySemiBold.size14.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _name;
  String? get name => _name;
  String? _email;
  String? get email => _email;
  String? _profileImage;
  String? get profileImage => _profileImage;
  String? _role;
  String? get role => _role;

  Future<void> getProfile() async {
    final res = await runBusyFuture(locator<ApiService>().getProfile());

    if (res.status == 200) {
      _name = res.data?.name;
      _email = res.data?.email;
      _profileImage = res.data?.profilePic;
      res.data?.roleId;
      log('Profile fetched successfully: ${res.data?.name}');
    } else {
      log('Failed to fetch profile: ${res.message}');
    }
  }
}
