import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/shopping_screen.dart';
import '../presentation/screens/stock_screen.dart';
import '../presentation/screens/recipe_book_screen.dart';
import '../presentation/screens/flyer_screen.dart';
import '../presentation/screens/scaffold_with_nav_bar.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
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
            builder: (context, state) => const ShoppingScreen(),
          ),
          GoRoute(
            path: '/stock',
            builder: (context, state) => const StockScreen(),
          ),
          GoRoute(
            path: '/recipe_book',
            builder: (context, state) => const RecipeBookScreen(),
          ),
        ],
      ),
    ],
  );
}
