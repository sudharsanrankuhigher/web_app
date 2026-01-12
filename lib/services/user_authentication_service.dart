import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/app/router.dart';
import 'package:webapp/core/model/login_model.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';

class UserAuthenticationService with NavigationMixin {
  final _dialogService = locator<DialogService>();
  final _sharedPreference = locator<SharedPreferences>();

  LoginResponse? _loginResponse;

  LoginResponse? get loginResponse => _loginResponse;

  String get token =>
      _loginResponse?.response!.token ??
      _sharedPreference.getString('accessToken').toString();

  Future<void> loginApi(LoginRequest logInRequest) async {
    try {
      final res = await locator<ApiService>().loginAdmin(logInRequest);

      if (res.status == 200) {
        _loginResponse = res;
        _sharedPreference.setString(
          'accessToken',
          res.response?.token ?? '',
        );
        List<String>? accessList =
            res.response?.access; // make sure this is List<String>?

        if (accessList != null) {
          await _sharedPreference.setStringList('access', accessList);
        } else {
          await _sharedPreference.remove('access'); // optional, remove if null
        }
        goRouterKey.currentContext!.pushReplacementNamed('dashboard');
      } else {
        // ✅ This will now run if response is like status: 303, message: "OTP not found"
        _dialogService.showCustomDialog(
          title: 'Login Failed',
          description: res.message,
        );
      }
    } catch (e, stack) {
      log('Unexpected login error: $e');
      log(stack.toString());

      _dialogService.showDialog(
        title: 'Unexpected Error',
        description: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<String?> getToken() async {
    return _loginResponse?.response?.token ??
        _sharedPreference.getString('accessToken');
  }
}
