import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/ui/views/dash_board/dash_board_view.dart';
import 'package:webapp/ui/views/users/users_view.dart';
import 'package:webapp/ui/views/influencers/influencers_view.dart';
import 'package:webapp/ui/views/services/services_view.dart';
import 'package:webapp/ui/views/plans/plans_view.dart';
import 'package:webapp/ui/views/requests/requests_view.dart';
import 'package:webapp/ui/views/login/login_view.dart';
import 'package:webapp/ui/views/startup/startup_view.dart';

final goRouterKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: goRouterKey,
  initialLocation: '/startup',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // child = current right-side page
        return HomeView(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home/dashboard',
          name: 'dashboard',
          builder: (context, state) => DashBoardView(),
        ),
        GoRoute(
          path: '/home/users',
          name: 'users',
          builder: (context, state) => UsersView(),
        ),
        GoRoute(
          path: '/home/influencers',
          name: 'influencers',
          builder: (context, state) => InfluencersView(),
        ),
        GoRoute(
          path: '/home/services',
          name: 'services',
          builder: (context, state) => ServicesView(),
        ),
        GoRoute(
          path: '/home/plans',
          name: 'plans',
          builder: (context, state) => PlansView(),
        ),
        GoRoute(
          path: '/home/requests',
          name: 'requests',
          builder: (context, state) => RequestsView(),
        ),
        GoRoute(
          path: '/home/city',
          name: 'city',
          builder: (context, state) => Container(
            child: Center(
              child: Text('city'),
            ),
          ),
        ),
        GoRoute(
          path: '/home/state',
          name: 'state',
          builder: (context, state) => Container(
            child: Center(
              child: Text('state'),
            ),
          ),
        ),
        GoRoute(
          path: '/home/promotion-projects',
          name: 'promotion-projects',
          builder: (context, state) => Container(
            child: Center(
              child: Text('promotion-projects'),
            ),
          ),
        ),
        GoRoute(
          path: '/home/contact-support',
          name: 'contact-support',
          builder: (context, state) => Container(
            child: Center(
              child: Text('contact-support'),
            ),
          ),
        ),
        GoRoute(
          path: '/home/sub-admin',
          name: 'sub-admin',
          builder: (context, state) => Container(
            child: Center(
              child: Text('sub-admin'),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/startup',
      builder: (context, state) => StartupView(),
    ),
  ],
);
