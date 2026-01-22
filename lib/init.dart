import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/app/app.bottomsheets.dart';
import 'package:webapp/app/app.dialogs.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> init() async {
  await setupLocator();
  setupDialogUi();
  initPermissions();
  setupBottomSheetUi();
  setUrlStrategy(PathUrlStrategy()); // <-- removes the #
}

Future<void> initPermissions() async {
  final _sharedPreference = locator<SharedPreferences>();

  final accessList = _sharedPreference.getStringList('access') ?? [];

  PermissionHelper.init(accessList.toSet());
  print('initcompleted: $accessList');
}
