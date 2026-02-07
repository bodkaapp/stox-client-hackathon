import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../config/app_colors.dart';
import '../providers/shopping_mode_provider.dart';

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> with TickerProviderStateMixin {
  late final AnimationController _sparkleController;
  late final AnimationController _hideController;
  final List<_Sparkle> _sparkles = [];
  final Random _random = Random();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _sparkleController.addListener(_updateSparkles);

    _hideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _updateSparkles() {
    if (_random.nextDouble() < 0.1) {
      _sparkles.add(_Sparkle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 0.4 + 0.3,
        startTime: DateTime.now(),
        duration: Duration(milliseconds: 600 + _random.nextInt(600)),
      ));
    }
    final now = DateTime.now();
    _sparkles.removeWhere((s) => now.difference(s.startTime) > s.duration);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _hideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShoppingMode = ref.watch(shoppingModeProvider);
    final String location = GoRouterState.of(context).uri.toString();
    final bool isHomeScreen = location == '/' || location == '/#';

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.scrollDelta! > 2 && _isVisible) {
            setState(() => _isVisible = false);
            _hideController.forward();
          } else if (notification.scrollDelta! < -2 && !_isVisible) {
            setState(() => _isVisible = true);
            _hideController.reverse();
          }
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            widget.child,
            if (!isShoppingMode && isHomeScreen)
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _hideController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 80 * _hideController.value),
                        child: Opacity(
                          opacity: 1.0 - (0.2 * _hideController.value),
                          child: child,
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.stoxAccent,
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: _SparklePainter(sparkles: List.from(_sparkles)),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => context.push('/food_camera'),
                                      child: Center(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            const Icon(
                                              Icons.camera_alt,
                                              color: Colors.black,
                                              size: 58,
                                            ),
                                            Positioned(
                                              top: -6,
                                              right: -4,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.stoxAccent,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2),
                                                ),
                                                child: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: isShoppingMode ? null : BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.inventory_2),
              label: AppLocalizations.of(context)!.navStock,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label: AppLocalizations.of(context)!.navShopping,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_month),
              label: AppLocalizations.of(context)!.navMenuPlan,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book),
              label: AppLocalizations.of(context)!.navRecipe,
            ),
          ],
        ),
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

class _Sparkle {
  final double x;
  final double y;
  final double size;
  final DateTime startTime;
  final Duration duration;

  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.startTime,
    required this.duration,
  });
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;

  _SparklePainter({required this.sparkles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final now = DateTime.now();

    for (var sparkle in sparkles) {
      final elapsed = now.difference(sparkle.startTime).inMilliseconds;
      final progress = elapsed / sparkle.duration.inMilliseconds;
      if (progress >= 1.0) continue;

      final fade = (progress < 0.5) ? progress * 2 : (1.0 - progress) * 2;
      double opacity = fade.clamp(0.0, 1.0);
      
      paint.color = AppColors.stoxAccent.withValues(alpha: 0.3 * opacity);
      
      final centerX = sparkle.x * size.width;
      final centerY = sparkle.y * size.height;
      final radius = 2.0 * sparkle.size;

      final path = Path();
      path.moveTo(centerX, centerY - radius * 2);
      path.quadraticBezierTo(centerX + radius / 2, centerY - radius / 2, centerX + radius * 2, centerY);
      path.quadraticBezierTo(centerX + radius / 2, centerY + radius / 2, centerX, centerY + radius * 2);
      path.quadraticBezierTo(centerX - radius / 2, centerY + radius / 2, centerX - radius * 2, centerY);
      path.quadraticBezierTo(centerX - radius / 2, centerY - radius / 2, centerX, centerY - radius * 2);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) => true;
}
