import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/app/router.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';

class LoginViewModel extends BaseViewModel with NavigationMixin {
  void goHome() {
    // final ctx = StackedService.navigatorKey!.currentContext!;
    goRouterKey.currentContext!.pushReplacementNamed('dashboard');
  }
}
