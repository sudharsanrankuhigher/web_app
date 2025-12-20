import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webapp/app/app.bottomsheets.dart';
import 'package:webapp/app/app.dialogs.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/dash_board/dash_board_view.dart';
import 'package:webapp/ui/views/influencers/influencers_view.dart';
import 'package:webapp/ui/views/plans/plans_view.dart';
import 'package:webapp/ui/views/services/services_view.dart';
import 'package:webapp/ui/views/users/users_view.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
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
    'City',
    'State',
    'Plans',
    'Requests',
    'Promotion Projects',
    'Contact Support',
    'Sub Admin',
  ];

  final List<String> railIcon = [
    'assets/images/dash_board.svg',
    'assets/images/user.svg',
    'assets/images/influencer_dashboard.svg',
    'assets/images/service_dashboard.svg',
    'assets/images/city.svg',
    'assets/images/city.svg',
    'assets/images/plans_dashboard.svg',
    'assets/images/requests_dashboard.svg',
    'assets/images/promotes_proj_dashboard.svg',
    'assets/images/support_dashboard.svg',
    'assets/images/sub-admin_dashboard.svg',
  ];

  final List<Widget> pages = [
    const DashBoardView(),
    const UsersView(),
    const InfluencersView(),
    const ServicesView(),
    const Center(child: Text('City', style: TextStyle(fontSize: 20))),
    const Center(child: Text('State', style: TextStyle(fontSize: 20))),
    const PlansView(),
    const Center(child: Text('Requests', style: TextStyle(fontSize: 20))),
    const Center(
        child: Text('Promotion Projects', style: TextStyle(fontSize: 20))),
    const Center(
        child: Text('Contact Support', style: TextStyle(fontSize: 20))),
    const Center(child: Text('Sub Admin', style: TextStyle(fontSize: 20))),
  ];

  // ─── Bottom Labels ───
  final List<String> bottomLabel = ['Profile', 'Logout'];
  final List<String> bottomIcons = ['assets/profile.png', 'assets/logout.png'];

  void showDialog() {
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
      case 4:
        context.pushReplacementNamed('city');
        _selectedIndex = 4;
        break;
      case 5:
        context.pushReplacementNamed('state');
        _selectedIndex = 5;
        break;
      case 6:
        context.pushReplacementNamed('plans');
        _selectedIndex = 6;
        break;
      case 7:
        context.pushReplacementNamed('requests');
        _selectedIndex = 7;
        break;
      case 8:
        context.pushReplacementNamed('promotion-projects');
        _selectedIndex = 8;
        break;
      case 9:
        context.pushReplacementNamed('contact-support');
        _selectedIndex = 9;
        break;
      case 10:
        context.pushReplacementNamed('sub-admin');
        _selectedIndex = 10;
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
      case '/home/city':
        _selectedIndex = 4;
        break;
      case '/home/state':
        _selectedIndex = 5;
        break;
      case '/home/plans':
        _selectedIndex = 6;
        break;
      case '/home/requests':
        _selectedIndex = 7;
        break;
      case '/home/promotion-projects':
        _selectedIndex = 8;
        break;
      case '/home/contact-support':
        _selectedIndex = 9;
        break;
      case '/home/sub-admin':
        _selectedIndex = 10;
        break;
      default:
        _selectedIndex = 0;
    }
  }

  void logOut(BuildContext context) {
    context.pushReplacementNamed('login');
  }
}
