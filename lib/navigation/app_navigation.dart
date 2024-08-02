import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planup/news/data/models/news_list_model.dart';
import 'package:planup/page3.dart';
import 'package:planup/study/data/models/video_model.dart';
import 'package:planup/study/presentation/screens/videoplayer_screen.dart';
import 'package:planup/news/presentation/screens/news_page.dart';
import 'package:planup/tmc/data/models/make_multiple_trade_model.dart';
import 'package:planup/tmc/presentation/screens/all_goods_screen.dart';
import 'package:planup/tmc/presentation/screens/categories_screen.dart';
import 'package:planup/tmc/presentation/screens/choose_action.dart';
import 'package:planup/tmc/presentation/screens/create_tmc_screen.dart';
import 'package:planup/tmc/presentation/screens/deleted_goods_list_screen.dart';
import 'package:planup/tmc/presentation/screens/detailed_info.dart';
import 'package:planup/tmc/presentation/screens/edit_good_screen.dart';
import 'package:planup/tmc/presentation/screens/main_menu.dart';
import 'package:planup/tmc/presentation/screens/my_trades_screen.dart';
import 'package:planup/tmc/presentation/screens/one_category_screen.dart';
import 'package:planup/tmc/presentation/screens/trade_goods_screen.dart';
import 'package:planup/tmc/presentation/screens/trade_history_list.dart';
import 'package:planup/tmc/presentation/screens/transactions_history.dart';
import 'package:planup/views/home/detailed_screen_from_notifcation.dart';
import 'package:planup/views/home/openservice.dart';
import 'package:planup/views/payment/globals.dart';
import 'package:planup/views/payment/main.dart';
import 'package:pod_player/pod_player.dart';

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
  static final _videoPlayerNavKey =
      GlobalKey<NavigatorState>(debugLabel: 'newsKey');

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
                      child: const OutfitScreenOld(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  //    GoRoute(
                  //   path: 'localpay',
                  //   name: 'localpay',
                  //   pageBuilder: (context, state) => CustomTransitionPage<void>(
                  //     key: state.pageKey,
                  //     child: const OutfitScreenOld(),
                  //     transitionsBuilder:
                  //         (context, animation, secondaryAnimation, child) =>
                  //             FadeTransition(opacity: animation, child: child),
                  //   ),
                  // ),
                  GoRoute(
                    path: 'createservice',
                    name: 'createservice',
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const Createservice(),
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
                      child: const OpenService(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path: "workFromNotification",
                    name: "workFromNotification",
                    builder: (context, state) {
                      final String workId =
                          state.uri.queryParameters["workId"] ?? "0";
                      return GetopenserviceFromNotification(
                        workId: workId,
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: 'myservices',
                    name: "myservices",
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const OutfitScreen(),
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
                      child: const Client_info(),
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
                      child: Scanmac(),
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
      ),
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/video',
          name: 'video',
          builder: (context, state) {
            return VideoPlayerScreen(
              time: state.uri.queryParameters['time'] ?? "",
              titleOfCourse: state.uri.queryParameters['title'] ?? "",
              videoLink: state.uri.queryParameters['link'] ?? "",
              description: state.uri.queryParameters['description'] ?? "",
            );
          }),
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/news',
          name: 'news',
          builder: (context, state) {
            return NewsScreen(
              time: state.uri.queryParameters['time'] ?? "",
              newsText: state.uri.queryParameters['description'] ?? "",
              image: state.uri.queryParameters['image'] ?? "",
              newsTitle: state.uri.queryParameters['title'] ?? "",
            );
          }),
      GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/tmc',
          name: 'tmc',
          builder: (context, state) {
            return const MainMenuScreen();
          },
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "categories",
              name: "categories",
              builder: (context, state) {
                return const CategoriesScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "createTMC",
              name: "createTMC",
              builder: (context, state) {
                return const CreateTmcScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "deletedGoods",
              name: "deletedGoods",
              builder: (context, state) {
                return const DeletedGoodsListScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "trade",
              name: "trade",
              builder: (context, state) {
                return TradeGoodsScreen(
                  statusId: state.uri.queryParameters["statusId"] ?? "1",
                  goodID: state.uri.queryParameters["goodId"] ?? "",
                  isMultipleTrade: (state.uri.queryParameters["isMultipleTrade"]?.toLowerCase() == 'true'),
                  goodsList: state.extra as List<Trade>,
                );
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "myTrades",
              name: "myTrades",
              builder: (context, state) {
                return const MyTradesScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "allgoods",
              name: "allgoods",
              builder: (context, state) {
                return const AllGoodsScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: "oneCategory",
              name: "oneCategory",
              builder: (context, state) {
                return OneCategoriesContent(
                  urlRoute: state.uri.queryParameters['urlRoute'] ?? "",
                );
              },
            ),
            GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "detailedInfo",
                name: "detailedInfo",
                builder: (context, state) {
                  final photoPath = state.uri.queryParameters["photo"];
                  File? photoFile;

                  if (photoPath != null && photoPath.isNotEmpty) {
                    photoFile = File(photoPath);
                  }
                  return DetailedInfoScreen(
                    photoFromBackend: state.uri.queryParameters["photoFromBackend"],
                    manufacture: state.uri.queryParameters["manufacture"] ?? "",
                    model: state.uri.queryParameters["model"] ?? "",
                    cost: state.uri.queryParameters["cost"] ?? "",
                    id: state.uri.queryParameters["id"] ?? "",
                    photo: photoFile,
                    barcode: state.uri.queryParameters["barcode"] ?? "",
                    category: state.uri.queryParameters["category"] ?? "",
                    deleted: state.uri.queryParameters["deleted"] ?? "",
                    nazvanieID: state.uri.queryParameters["nazvanieID"] ?? "",
                    goodStatus: state.uri.queryParameters["goodStatus"] ?? "",
                    statusId:  state.uri.queryParameters["statusId"] ?? "1",
                  );
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: "history",
                    name: "history",
                    builder: (context, state) {
                      return const TransactionsHistoryScreen();
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: "editTMC",
                    name: "editTMC",
                    builder: (context, state) {
                      return EditTmcScreen(
                        id: state.uri.queryParameters["id"] ?? "",
                        nazvanieID:
                            state.uri.queryParameters["nazvanieID"] ?? "",
                        deleted: state.uri.queryParameters["deleted"] ?? "",
                      );
                    },
                  ),
                ]),
            GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                path: "chooseAction",
                name: "chooseAction",
                builder: (context, state) {
                  return const ChooseActionScreen();
                },
                routes: [
                  GoRoute(
                    path: "tradeHistory",
                    name: "tradeHistory",
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return const TradeHistoryListScreen();
                    },
                  )
                ]),
          ]),
    ],
  );
}
