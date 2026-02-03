import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/shopping_screen.dart';
import '../presentation/screens/stock_screen.dart';
import '../presentation/screens/recipe_book_screen.dart';
import '../presentation/screens/flyer_screen.dart';
import '../presentation/screens/scaffold_with_nav_bar.dart';
import '../presentation/screens/notification_list_screen.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/tutorial_screen.dart';
import '../presentation/screens/account_settings_screen.dart';
import '../presentation/screens/food_camera_screen.dart';
import '../presentation/screens/menu_plan_screen.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/splash_view',
        builder: (context, state) => const SplashScreen(autoNavigate: false),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/flyer',
            builder: (context, state) => const FlyerScreen(),
          ),
          GoRoute(
            path: '/shopping',
            builder: (context, state) {
              final action = state.uri.queryParameters['action'];
              return ShoppingScreen(openAddModal: action == 'add');
            },
          ),
          GoRoute(
            path: '/stock',
            builder: (context, state) => const StockScreen(),
          ),
          GoRoute(
            path: '/recipe_book',
            builder: (context, state) => const RecipeBookScreen(),
          ),
          GoRoute(
            path: '/menu_plan',
            builder: (context, state) => const MenuPlanScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationListScreen(),
      ),
    GoRoute(
        path: '/account_settings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: AccountSettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/food_camera',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FoodCameraScreen(),
      ),

    ],
  );
}
