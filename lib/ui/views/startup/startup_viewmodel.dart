import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/app/app.locator.dart';

import 'package:webapp/app/router.dart';

class StartupViewModel extends BaseViewModel {
  // final _navigationService = locator<NavigationService>();
  final _sharedPreference = locator<SharedPreferences>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    final token = _sharedPreference.getString('accessToken');

    await Future.delayed(const Duration(seconds: 3));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    // _navigationService.replaceWithLoginView();
    token == null
        ? goRouterKey.currentContext!.pushReplacementNamed('login')
        : goRouterKey.currentContext!.pushReplacementNamed('dashboard');
    // goRouterKey.currentContext!.pushReplacementNamed('login');
  }
}
