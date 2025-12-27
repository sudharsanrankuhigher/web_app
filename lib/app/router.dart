import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:webapp/ui/views/city/city_view.dart';
import 'package:webapp/ui/views/contact_support/contact_support_view.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/ui/views/dash_board/dash_board_view.dart';
import 'package:webapp/ui/views/permissions/permissions_view.dart';
import 'package:webapp/ui/views/promote_projects/promote_projects_view.dart';
import 'package:webapp/ui/views/report/report_view.dart';
import 'package:webapp/ui/views/roles/roles_view.dart';
import 'package:webapp/ui/views/state/state_view.dart';
import 'package:webapp/ui/views/sub_admin/sub_admin_view.dart';
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
          builder: (context, state) => const DashBoardView(),
        ),
        GoRoute(
          path: '/home/users',
          name: 'users',
          builder: (context, state) => const UsersView(),
        ),
        GoRoute(
          path: '/home/influencers',
          name: 'influencers',
          builder: (context, state) => const InfluencersView(),
        ),
        GoRoute(
          path: '/home/services',
          name: 'services',
          builder: (context, state) => const ServicesView(),
        ),
        GoRoute(
          path: '/home/plans',
          name: 'plans',
          builder: (context, state) => const PlansView(),
        ),
        GoRoute(
          path: '/home/requests',
          name: 'requests',
          builder: (context, state) => const RequestsView(),
        ),
        GoRoute(
          path: '/home/city',
          name: 'city',
          builder: (context, state) => CityView(),
        ),
        GoRoute(
            path: '/home/state',
            name: 'state',
            builder: (context, state) => StateView()),
        GoRoute(
          path: '/home/promotion-projects',
          name: 'promotion-projects',
          builder: (context, state) => PromoteProjectsView(),
        ),
        GoRoute(
          path: '/home/contact-support',
          name: 'contact-support',
          builder: (context, state) => ContactSupportView(),
        ),
        GoRoute(
          path: '/home/sub-admin',
          name: 'sub-admin',
          builder: (context, state) => const SubAdminView(),
        ),
        GoRoute(
          path: '/home/report',
          name: 'report',
          builder: (context, state) => const ReportView(),
        ),
        GoRoute(
          path: '/home/roles',
          name: 'roles',
          builder: (context, state) => const RolesView(),
        ),
        GoRoute(
          path: '/home/permissions',
          name: 'permissions',
          builder: (context, state) => const PermissionsView(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/startup',
      builder: (context, state) => const StartupView(),
    ),
  ],
);
