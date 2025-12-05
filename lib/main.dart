import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webapp/app/app.bottomsheets.dart';
import 'package:webapp/app/app.dialogs.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Your design reference size
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router, // Your GoRouter instance
            builder: (context, child) {
              return Navigator(
                key: StackedService.navigatorKey,
                observers: [StackedService.routeObserver],
                onGenerateRoute: (_) =>
                    MaterialPageRoute(builder: (_) => child!),
              );
            });
      },
    );
  }
}
