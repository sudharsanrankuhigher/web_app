import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/core/model/get_profile_model.dart';

class ProfileService extends ChangeNotifier {
  static final ProfileService instance = ProfileService._internal();

  ProfileService._internal() {
    _loadFromLocalStorage();
  }

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _profileImage;
  String? get profileImage => _profileImage;

  String? _roleId;
  String? get roleId => _roleId;

  bool _isProfileFetched = false;
  bool get isProfileFetched => _isProfileFetched;

  void _loadFromLocalStorage() {
    try {
      final prefs = locator<SharedPreferences>();
      _name = prefs.getString('profile_name') ?? _name;
      _email = prefs.getString('profile_email') ?? _email;
      _profileImage = prefs.getString('profile_image') ?? _profileImage;
      _roleId = prefs.getString('role_id') ?? _roleId;
    } catch (e) {
      debugPrint('Error loading profile from local storage: $e');
    }
  }

  Future<void> fetchProfile() async {
    try {
      final responseData = await locator<ApiService>().getProfile();
      final res = GetAdminProfileResponse.fromJson(responseData);

      if (res.status == 200) {
        _isProfileFetched = true;
        _name = res.data?.name;
        _email = res.data?.email;
        _profileImage = res.data?.profilePic;
        _roleId = res.data?.roleId.toString();

        final prefs = locator<SharedPreferences>();
        await prefs.setString('profile_name', _name ?? '');
        await prefs.setString('profile_email', _email ?? '');
        await prefs.setString('profile_image', _profileImage ?? '');
        await prefs.setString('role_id', _roleId ?? '');

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> clearProfile() async {
    _name = null;
    _email = null;
    _profileImage = null;
    _roleId = null;
    _isProfileFetched = false;
    notifyListeners();
  }
}
