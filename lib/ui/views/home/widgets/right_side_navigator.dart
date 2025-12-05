// import 'package:flutter/material.dart';
// import 'package:webapp/app/app.router.dart';
// import 'package:webapp/ui/views/dash_board/dash_board_view.dart';
// import 'package:webapp/ui/views/home/home_viewmodel.dart';
// import 'package:webapp/ui/views/users/users_view.dart';
// import 'package:webapp/ui/views/influencers/influencers_view.dart';
// import 'package:webapp/ui/views/services/services_view.dart';
// import 'package:webapp/ui/views/plans/plans_view.dart';
// import 'package:webapp/ui/views/requests/requests_view.dart';

// class RightPanelNavigator extends StatefulWidget {
//   final HomeViewModel viewModel;

//   const RightPanelNavigator({Key? key, required this.viewModel})
//       : super(key: key);

//   @override
//   RightPanelNavigatorState createState() => RightPanelNavigatorState();
// }

// // Make this class public so ViewModel can reference it
// class RightPanelNavigatorState extends State<RightPanelNavigator> {
//   final GlobalKey<NavigatorState> _nestedKey = GlobalKey<NavigatorState>();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       widget.viewModel.registerRightPanel(this);
//     });
//   }

//   void navigate(String routeName) {
//     _nestedKey.currentState?.pushReplacementNamed(routeName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: _nestedKey,
//       initialRoute: Routes.dashBoardView,
//       onGenerateRoute: (settings) {
//         Widget page;
//         switch (settings.name) {
//           case Routes.dashBoardView:
//             page = const DashBoardView();
//             break;
//           case Routes.usersView:
//             page = const UsersView();
//             break;
//           case Routes.influencersView:
//             page = const InfluencersView();
//             break;
//           case Routes.servicesView:
//             page = const ServicesView();
//             break;
//           case Routes.plansView:
//             page = const PlansView();
//             break;
//           case Routes.requestsView:
//             page = const RequestsView();
//             break;
//           default:
//             page = const DashBoardView();
//         }
//         return MaterialPageRoute(builder: (_) => page, settings: settings);
//       },
//     );
//   }
// }
