import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/services/user_authentication_service.dart';
import 'package:webapp/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:webapp/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/services/api_service.dart';

// part 'app.router.dart'; // <<– add this line

// @stacked-import
@StackedApp(
  routes: [],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // LazySingleton(classType: HomeViewModel),
    Presolve(
        classType: SharedPreferences,
        presolveUsing: SharedPreferences.getInstance),
    LazySingleton(classType: UserAuthenticationService),
    LazySingleton(classType: ApiService, resolveUsing: ApiService.init),
    // LazySingleton(classType: ApiService),

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
