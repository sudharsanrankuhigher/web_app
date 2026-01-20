import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/app/router.dart';
import 'package:webapp/core/helper/permission_helper.dart';
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

  Future<bool> loginApi(LoginRequest logInRequest) async {
    try {
      final res = await locator<ApiService>().loginAdmin(logInRequest);

      if (res.status == 200) {
        _loginResponse = res;

        await _sharedPreference.setString(
          'accessToken',
          res.response?.token ?? '',
        );

        List<String>? accessList = res.response?.access;

        if (accessList != null) {
          await _sharedPreference.setStringList('access', accessList);
          PermissionHelper.init(accessList.toSet());
        } else {
          await _sharedPreference.remove('access');
          PermissionHelper.init({});
        }

        goRouterKey.currentContext!.pushReplacementNamed('dashboard');

        return true; // ✅ SUCCESS
      } else {
        _dialogService.showDialog(
          title: 'Login Failed',
          description: res.message,
        );
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final error = LoginResponse.fromJson(e.response!.data);

        _dialogService.showDialog(
          title: 'Login Failed',
          description: error.message ?? 'Invalid credentials',
        );
      } else {
        _dialogService.showDialog(
          title: 'Network Error',
          description: 'Please check your internet connection',
        );
      }
      return false;
    }
  }

  Future<String?> getToken() async {
    return _loginResponse?.response?.token ??
        _sharedPreference.getString('accessToken');
  }
}
