import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers/shopping_mode_provider.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShoppingMode = ref.watch(shoppingModeProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: isShoppingMode ? null : BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: AppLocalizations.of(context)!.navStock,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppLocalizations.of(context)!.navShopping,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: AppLocalizations.of(context)!.navMenuPlan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: AppLocalizations.of(context)!.navRecipe,
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/stock')) {
      return 1;
    }
    if (location.startsWith('/shopping')) {
      return 2;
    }
    if (location.startsWith('/menu_plan')) {
      return 3;
    }
    if (location.startsWith('/recipe_book')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/stock');
        break;
      case 2:
        context.go('/shopping');
        break;
      case 3:
        context.go('/menu_plan');
        break;
      case 4:
        context.go('/recipe_book');
        break;
    }
  }
}
