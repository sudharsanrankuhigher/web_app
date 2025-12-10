import 'package:webapp/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:webapp/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:webapp/ui/views/home/home_view.dart';
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
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, path: '/Home'),
    MaterialRoute(page: StartupView, path: "/startup"),
    MaterialRoute(page: LoginView, path: "/login"),
    MaterialRoute(page: DashBoardView, path: "/dashBoard"),
    MaterialRoute(page: UsersView),
    MaterialRoute(page: InfluencersView),
    MaterialRoute(page: ServicesView),
    MaterialRoute(page: PlansView),
    MaterialRoute(page: RequestsView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
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
