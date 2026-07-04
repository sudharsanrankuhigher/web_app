import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/router.dart';
import 'package:webapp/init.dart';
import 'package:webapp/services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth =
        ui.PlatformDispatcher.instance.views.first.physicalSize.width /
            ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    return ScreenUtilInit(
      designSize:
          deviceWidth < 768 ? const Size(375, 812) : const Size(1440, 1024),
      minTextAdapt: true,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: ThemeService.instance,
          builder: (context, _) {
            return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: router, // Your GoRouter instance
                themeMode: ThemeService.instance.themeMode,
                theme: ThemeData(
                  useMaterial3: true,
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF2B5CFF),
                    surface: Color(0xFFFFFFFF),
                    onSurface: Colors.black87,
                  ),
                  cardTheme: CardThemeData(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  checkboxTheme: CheckboxThemeData(
                    fillColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(
                            0xFF00BE93); // Sleek brand green when checked
                      }
                      return null;
                    }),
                    checkColor: WidgetStateProperty.all(Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: const Color(0xFF0F172A),
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFF2B5CFF),
                    surface: Color(0xFF1E293B),
                    onSurface: Colors.white,
                  ),
                  cardTheme: CardThemeData(
                    color: const Color(0xFF1E293B),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  checkboxTheme: CheckboxThemeData(
                    fillColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(
                            0xFF00BE93); // Sleek brand green when checked
                      }
                      return null;
                    }),
                    side: WidgetStateBorderSide.resolveWith((states) {
                      if (!states.contains(WidgetState.selected)) {
                        return const BorderSide(
                            color: Colors.white54,
                            width: 1.5); // high contrast border in dark mode
                      }
                      return null;
                    }),
                    checkColor: WidgetStateProperty.all(Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
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
      },
    );
  }
}

//flutter pub get
//flutter build web
//dir build
//git rm -r --cached build/
//git add -f build/web
// git add .
// git commit -m "Deploy web build"
// git push -u origin web-deploy --force
