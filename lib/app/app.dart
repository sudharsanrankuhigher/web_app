import 'package:webapp/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:webapp/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/ui/views/home/home_viewmodel.dart';
import 'package:webapp/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/login/login_view.dart';
import 'package:webapp/ui/views/dash_board/dash_board_view.dart';
import 'package:webapp/ui/views/users/users_view.dart';
import 'package:webapp/ui/views/influencers/influencers_view.dart';
import 'package:webapp/ui/views/services/services_view.dart';
import 'package:webapp/ui/views/plans/plans_view.dart';
import 'package:webapp/ui/views/requests/requests_view.dart';
import 'package:webapp/ui/views/sub_admin/sub_admin_view.dart';
import 'package:webapp/ui/views/state/state_view.dart';
import 'package:webapp/ui/views/city/city_view.dart';
import 'package:webapp/ui/views/contact_support/contact_support_view.dart';
import 'package:webapp/ui/views/promote_projects/promote_projects_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(
      page: HomeView,
      path: '/home',
      children: [
        MaterialRoute(page: DashBoardView, path: 'dashboard'),
        MaterialRoute(page: UsersView, path: 'users'),
        MaterialRoute(page: InfluencersView, path: 'influencers'),
        MaterialRoute(page: ServicesView, path: 'services'),
        MaterialRoute(page: PlansView, path: 'plans'),
        MaterialRoute(page: RequestsView, path: 'requests'),
      ],
    ),
    // MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: StartupView, path: "/startup"),
    MaterialRoute(page: LoginView, path: "/login"),
    // MaterialRoute(page: DashBoardView, path: "/dashBoard"),
    // MaterialRoute(page: UsersView, path: "/users"),
    // MaterialRoute(page: InfluencersView, path: "/influencers"),
    // MaterialRoute(page: ServicesView, path: "/services"),
    // MaterialRoute(page: PlansView, path: "/plans"),
    // MaterialRoute(page: RequestsView, path: "/requests"),
    MaterialRoute(page: SubAdminView),
    MaterialRoute(page: StateView),
    MaterialRoute(page: CityView),
    MaterialRoute(page: ContactSupportView),
    MaterialRoute(page: PromoteProjectsView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: HomeViewModel),

    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
