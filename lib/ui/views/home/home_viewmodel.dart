import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:webapp/services/notification_service.dart';
import 'package:webapp/services/profile_service.dart';

import 'package:webapp/services/floating_overlay_service.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
  HomeViewModel() {
    ProfileService.instance.fetchProfile();
    ProfileService.instance.addListener(notifyListeners);
    fetchPendingRequestsCount();
    NotificationService.instance.fetchNotifications();
    NotificationService.instance.addListener(notifyListeners);
    _syncFloatingOverlayCount();
    initMonthYear();
  }

  // ─── Profile Panel State ───
  bool _showProfilePanel = false;
  bool get showProfilePanel => _showProfilePanel;

  bool _isHistoryLoading = false;
  bool get isHistoryLoading => _isHistoryLoading;

  void toggleProfilePanel() {
    _showProfilePanel = !_showProfilePanel;
    if (_showProfilePanel) {
      fetchAttendanceHistory();
    }
    notifyListeners();
  }

  void closeProfilePanel() {
    _showProfilePanel = false;
    notifyListeners();
  }

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<int> years = [2024, 2025, 2026, 2027];

  String _selectedMonth = 'June';
  String get selectedMonth => _selectedMonth;

  int _selectedYear = 2026;
  int get selectedYear => _selectedYear;

  List<Map<String, String>> _loginLogoutHistory = [];
  List<Map<String, String>> get loginLogoutHistory => _loginLogoutHistory;

  void initMonthYear() {
    final now = DateTime.now();
    _selectedMonth = months[now.month - 1];
    _selectedYear = now.year;
  }

  void setSelectedMonth(String month) {
    _selectedMonth = month;
    fetchAttendanceHistory();
    notifyListeners();
  }

  void setSelectedYear(int year) {
    _selectedYear = year;
    fetchAttendanceHistory();
    notifyListeners();
  }

  Future<void> selectYearFromCalendar(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDate: DateTime(_selectedYear, 1),
              selectedDate: DateTime(_selectedYear, 1),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );
    if (picked != null) {
      setSelectedYear(picked.year);
    }
  }

  Future<void> fetchAttendanceHistory() async {
    _isHistoryLoading = true;
    notifyListeners();

    try {
      final monthIndex = months.indexOf(_selectedMonth) + 1;
      final monthStr = monthIndex.toString().padLeft(2, '0');
      final queryMonth = '$monthStr-$_selectedYear';

      final res = await locator<ApiService>().getAttendance(queryMonth);
      if (res != null &&
          res['data'] != null &&
          res['data']['attendance'] != null) {
        final attendanceList = res['data']['attendance'] as List<dynamic>;
        _loginLogoutHistory = attendanceList.map((x) {
          final item = x as Map<String, dynamic>;

          final loginDateStr = item['login_date'] as String?;
          final loginTimeStr = item['login_time'] as String?;
          final logoutTimeStr = item['logout_time'] as String?;

          String formattedDate = '-';
          if (loginDateStr != null) {
            try {
              final parsedDate = DateTime.parse(loginDateStr);
              final monthShort = _selectedMonth.substring(0, 3);
              formattedDate =
                  '${parsedDate.day.toString().padLeft(2, '0')} $monthShort ${parsedDate.year}';
            } catch (_) {
              formattedDate = loginDateStr;
            }
          }

          String formattedLogin = '-';
          if (loginTimeStr != null) {
            formattedLogin = _formatTimeString(loginTimeStr);
          }

          String formattedLogout = '-';
          if (logoutTimeStr != null) {
            formattedLogout = _formatTimeString(logoutTimeStr);
          }

          return {
            'date': formattedDate,
            'login': formattedLogin,
            'logout': formattedLogout,
          };
        }).toList();
      } else {
        _loginLogoutHistory = [];
      }
    } catch (e) {
      log('Error fetching attendance history: $e');
      _loginLogoutHistory = [];
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }

  String _formatTimeString(String timeStr) {
    try {
      final parts = timeStr.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      final isAM = hour < 12;
      hour = hour % 12;
      if (hour == 0) hour = 12;

      final minuteStr = minute.toString().padLeft(2, '0');
      return '$hour.$minuteStr ${isAM ? 'AM' : 'PM'}';
    } catch (_) {
      return timeStr;
    }
  }

  @override
  void dispose() {
    ProfileService.instance.removeListener(notifyListeners);
    FloatingOverlayService.instance.remove();
    NotificationService.instance.removeListener(notifyListeners);
    super.dispose();
  }

  void _syncFloatingOverlayCount() {
    FloatingOverlayService.instance.updateBadgeCount(unreadNotificationsCount);
    NotificationService.instance.addListener(() {
      FloatingOverlayService.instance
          .updateBadgeCount(unreadNotificationsCount);
    });
  }

  int _pendingRequestsCount = 0;
  int get pendingRequestsCount => _pendingRequestsCount;

  int get unreadNotificationsCount => NotificationService.instance.unreadCount;

  Future<void> fetchPendingRequestsCount() async {
    try {
      final res = await locator<ApiService>().getClientRequest(1);
      _pendingRequestsCount = res.data?.length ?? 0;
      notifyListeners();
    } catch (e) {
      log('Error fetching client request count: $e');
    }
  }

  // void init(context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //   });
  // }

  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _sharedPreferences = locator<SharedPreferences>();

  int _counter = 0;
  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 0;

  final GlobalKey<NavigatorState> rightPanelNavigatorKey =
      GlobalKey<NavigatorState>();

  Future<void> clearUserData() async {
    await ProfileService.instance.clearProfile();
    await _sharedPreferences.clear();
  }

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
    'Client Projects',
    'Promotion Projects',
    'Ticket Support',
    "Contact",
    'Company',
    'Sub Admin',
    'Report',
    'Roles',
    'Permissions',
    'Notifications',
  ];

  final List<String> railIcon = [
    'assets/images/dash_board.svg', // dashboard
    'assets/images/user.svg', //  users
    'assets/images/influencer_dashboard.svg', // influencers
    'assets/images/service_dashboard.svg', // services
    // 'assets/images/city.svg',
    'assets/images/plans_dashboard.svg', // plans
    'assets/images/banner.svg', // banner
    'assets/images/requests_dashboard.svg', // client requests
    'assets/images/promotes_proj_dashboard.svg', // promotion projects
    'assets/images/ticket_support.svg', // ticket support
    'assets/images/support_dashboard.svg', // location contact
    'assets/images/company.svg', // company
    'assets/images/sub-admin_dashboard.svg', // sub admin
    'assets/images/report.svg', // reports
    'assets/images/roles.svg', // roles
    'assets/images/permission.svg', // permissions
    'assets/images/notification.svg', // client requests
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
      case 15:
        context.pushReplacementNamed('notifications');
        _selectedIndex = 15;
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
      case '/home/notifications':
        _selectedIndex = 15;
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
                          onPressed: () async {
                            try {
                              await locator<ApiService>().logout();
                              FloatingOverlayService.instance
                                  .remove(); // 🧹 remove overlay
                              await clearUserData(); // 🧹 clear storage
                              Navigator.pop(context); // ❌ close dialog
                              rootContext
                                  .pushReplacementNamed('login'); // 🔁 redirect
                            } catch (e) {
                              log('Error calling logout API: $e');
                            }
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

  String? get name => ProfileService.instance.name;
  String? get email => ProfileService.instance.email;
  String? get profileImage => ProfileService.instance.profileImage;
  String? get role =>
      ProfileService.instance.roleId == '1' ? 'Super Admin' : 'Admin';
  String? get roleId => ProfileService.instance.roleId;

  String get profileImageUrl {
    final image = profileImage;
    if (image == null || image.isEmpty) {
      return "https://tse4.mm.bing.net/th/id/OIP.K_MocKRlIvuJ7ryQAtlErwHaIS?w=559&h=626&rs=1&pid=ImgDetMain&o=7&rm=3";
    }
    if (image.startsWith('http')) {
      return image;
    }

    // Clean leading slash if any
    String cleanPath = image;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    if (cleanPath.startsWith('storage/')) {
      return "https://admin.promoteapp.in/$cleanPath";
    }
    return "https://admin.promoteapp.in/storage/$cleanPath";
  }
}
