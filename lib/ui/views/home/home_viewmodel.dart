import 'package:flutter/material.dart';
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
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void selectedIndexes(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

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

  final List<IconData> railIcons = [
    Icons.dashboard,
    Icons.people,
    Icons.person_search,
    Icons.miscellaneous_services,
    Icons.location_city,
    Icons.map,
    Icons.subscriptions,
    Icons.request_page,
    Icons.campaign,
    Icons.support_agent,
    Icons.admin_panel_settings,
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

  // Bottom rail labels
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
}
