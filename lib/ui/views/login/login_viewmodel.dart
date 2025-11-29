import 'package:stacked/stacked.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';

class LoginViewModel extends BaseViewModel with NavigationMixin {
  void gohome() {
    goToHome();
    notifyListeners();
  }
}
