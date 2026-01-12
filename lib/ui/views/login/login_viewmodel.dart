import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/app/router.dart';
import 'package:webapp/core/model/login_model.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/user_authentication_service.dart';

class LoginViewModel extends BaseViewModel with NavigationMixin {
  final formKey = GlobalKey<FormState>();

  void goHome() {
    // final ctx = StackedService.navigatorKey!.currentContext!;
    goRouterKey.currentContext!.pushReplacementNamed('dashboard');
  }

  final userAuthentication = locator<UserAuthenticationService>();

  String get token => userAuthentication.token;

  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;

  void saveEmail(String? val) {
    _email = val ?? '';
  }

  void savePassword(String? val) {
    _password = val ?? '';
  }

  void validateAndSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final loginRequest = LoginRequest(
        emailId: _email,
        password: _password,
      );
      login(loginRequest);
      formKey.currentState!.reset();
    }
  }

  Future<void> login(LoginRequest loginRequest) async {
    setBusy(true);
    await userAuthentication.loginApi(loginRequest);
    setBusy(false);
  }
}
