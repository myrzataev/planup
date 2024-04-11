
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/page3.dart';
import 'package:planup/views/home/openservice.dart';
import 'package:planup/views/payment/main.dart';

import '../login_screen.dart';
import '../views/home/client_info.dart';
import '../views/home/closedservice.dart';
import '../views/home/connecthydra.dart';
import '../views/home/createservice.dart';
import '../views/home/home_view.dart';
import '../views/home/myservice.dart';
import '../views/home/postservice.dart';
import '../views/home/scanmac.dart';
import '../views/more/more.dart';
import '../views/more/web.dart';
import '../views/news/settings_view.dart';

import '../views/start.dart';
import '../views/wrapper/main_wrapper.dart';



class AppNavigation {
  AppNavigation._();

  static String initial = "/home";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorews =
      GlobalKey<NavigatorState>(debugLabel: 'shellNews');
  static final _shellNavigatorAdd =
      GlobalKey<NavigatorState>(debugLabel: 'shellAdd');


  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Brach Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "Главная",
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeView(),
                routes: [


                  GoRoute(
                    path: 'payment',
                    name: 'payment',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const MyApp(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  // GoRoute(
                  //   path: 'myservice',
                  //   name: 'myservice',
                  //   pageBuilder: (context, state) => CustomTransitionPage<void>(
                  //     key: state.pageKey,
                  //     child:  const OutfitScreen(),
                  //     transitionsBuilder:
                  //         (context, animation, secondaryAnimation, child) =>
                  //         FadeTransition(opacity: animation, child: child),
                  //   ),
                  // ),


                  GoRoute(
                    path: 'closedservice',
                    name: 'closedservice',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child:  const OutfitScreenOld(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path: 'createservice',
                    name: 'createservice',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child:  const Createservice(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path: 'openservice',
                    name: 'openservice',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child:  const OpenService(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: 'myservices',
                    name: "myservices",
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child:  const OutfitScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                    routes: [
                      GoRoute(
                        path: 'hydraconnect',
                        name: "hydraconnect",
                        builder: (context, state) {
                          final args = state.extra! as Map<String, dynamic>;
                          final accountNumber = args['accountNumber'] as String;
                          return HydraConnect(accountNumber: accountNumber);
                        },
                      ),
                    ],
                  ),


                  GoRoute(
                    path: 'searchclient',
                    name: 'searchclient',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child:  const Client_info(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path: 'postservice',
                    builder: (BuildContext context, GoRouterState state) {
                      final serviceId = state.extra as String?;
                      return Postservice(serviceId: serviceId);
                    },
                  ),
                  GoRoute(
                    path: 'scanmac',
                    name: 'scanmac',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child:  Scanmac(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  ),

                ],
              ),
            ],
          ),

          /// Brach Setting



          StatefulShellBranch(
            navigatorKey: _shellNavigatorAdd,
            routes: <RouteBase>[
              GoRoute(
                path: "/addd",
                name: "sdsdsd",
                builder: (BuildContext context, GoRouterState state) =>
                const SettingScreen(),

              ),
            ],
          ),

        ],
      ),


      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        name: "login",
        builder: (context, state) => LoginScreen(
          key: state.pageKey,
        ),
      ),


      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/start',
        name: "start",
        builder: (context, state) => Start(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/update',
        name: "update",
        builder: (context, state) => Update(
          key: state.pageKey,
        ),
      )
    ],
  );
}
