// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i14;
import 'package:webapp/ui/views/dash_board/dash_board_view.dart' as _i8;
import 'package:webapp/ui/views/home/home_view.dart' as _i2;
import 'package:webapp/ui/views/influencers/influencers_view.dart' as _i10;
import 'package:webapp/ui/views/login/login_view.dart' as _i4;
import 'package:webapp/ui/views/plans/plans_view.dart' as _i12;
import 'package:webapp/ui/views/requests/requests_view.dart' as _i13;
import 'package:webapp/ui/views/services/services_view.dart' as _i11;
import 'package:webapp/ui/views/startup/startup_view.dart' as _i3;
import 'package:webapp/ui/views/state/state_view.dart' as _i6;
import 'package:webapp/ui/views/sub_admin/sub_admin_view.dart' as _i5;
import 'package:webapp/ui/views/users/users_view.dart' as _i9;

class Routes {
  static const homeView = '/home';

  static const startupView = '/startup';

  static const loginView = '/login';

  static const subAdminView = '/sub-admin-view';

  static const stateView = '/state-view';

  static const all = <String>{
    homeView,
    startupView,
    loginView,
    subAdminView,
    stateView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i4.LoginView,
    ),
    _i1.RouteDef(
      Routes.subAdminView,
      page: _i5.SubAdminView,
    ),
    _i1.RouteDef(
      Routes.stateView,
      page: _i6.StateView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(nullOk: false);
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key, child: args.child),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.LoginView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.LoginView(),
        settings: data,
      );
    },
    _i5.SubAdminView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.SubAdminView(),
        settings: data,
      );
    },
    _i6.StateView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.StateView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HomeViewArguments {
  const HomeViewArguments({
    this.key,
    required this.child,
  });

  final _i7.Key? key;

  final _i7.Widget child;

  @override
  String toString() {
    return '{"key": "$key", "child": "$child"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.child == child;
  }

  @override
  int get hashCode {
    return key.hashCode ^ child.hashCode;
  }
}

class HomeViewRoutes {
  static const dashBoardView = 'dashboard';

  static const usersView = 'users';

  static const influencersView = 'influencers';

  static const servicesView = 'services';

  static const plansView = 'plans';

  static const requestsView = 'requests';

  static const all = <String>{
    dashBoardView,
    usersView,
    influencersView,
    servicesView,
    plansView,
    requestsView,
  };
}

class HomeViewRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      HomeViewRoutes.dashBoardView,
      page: _i8.DashBoardView,
    ),
    _i1.RouteDef(
      HomeViewRoutes.usersView,
      page: _i9.UsersView,
    ),
    _i1.RouteDef(
      HomeViewRoutes.influencersView,
      page: _i10.InfluencersView,
    ),
    _i1.RouteDef(
      HomeViewRoutes.servicesView,
      page: _i11.ServicesView,
    ),
    _i1.RouteDef(
      HomeViewRoutes.plansView,
      page: _i12.PlansView,
    ),
    _i1.RouteDef(
      HomeViewRoutes.requestsView,
      page: _i13.RequestsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i8.DashBoardView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.DashBoardView(),
        settings: data,
      );
    },
    _i9.UsersView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.UsersView(),
        settings: data,
      );
    },
    _i10.InfluencersView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.InfluencersView(),
        settings: data,
      );
    },
    _i11.ServicesView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.ServicesView(),
        settings: data,
      );
    },
    _i12.PlansView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.PlansView(),
        settings: data,
      );
    },
    _i13.RequestsView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.RequestsView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

extension NavigatorStateExtension on _i14.NavigationService {
  Future<dynamic> navigateToHomeView({
    _i7.Key? key,
    required _i7.Widget child,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key, child: child),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSubAdminView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.subAdminView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStateView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.stateView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedDashBoardViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewRoutes.dashBoardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedUsersViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewRoutes.usersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedInfluencersViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewRoutes.influencersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedServicesViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewRoutes.servicesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedPlansViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewRoutes.plansView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNestedRequestsViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(HomeViewRoutes.requestsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView({
    _i7.Key? key,
    required _i7.Widget child,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key, child: child),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSubAdminView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.subAdminView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStateView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.stateView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedDashBoardViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(HomeViewRoutes.dashBoardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedUsersViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(HomeViewRoutes.usersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedInfluencersViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(HomeViewRoutes.influencersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedServicesViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(HomeViewRoutes.servicesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedPlansViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(HomeViewRoutes.plansView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNestedRequestsViewInHomeViewRouter([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(HomeViewRoutes.requestsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
