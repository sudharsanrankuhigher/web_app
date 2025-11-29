import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/app/app.router.dart';

mixin NavigationMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  void goToHome() => _navigationService.navigateTo(Routes.homeView);
  void goToLogin() => _navigationService.navigateTo(Routes.loginView);
}
