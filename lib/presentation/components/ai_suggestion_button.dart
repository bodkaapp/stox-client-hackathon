import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';

class AiSuggestionButton extends StatefulWidget {
  final VoidCallback onTap;
  final String? label;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? iconSize;
  final double borderWidth;
  final double shadowBlurRadius;
  final Offset shadowOffset;

  const AiSuggestionButton({
    super.key,
    required this.onTap,
    this.label,
    this.height,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.fontSize = 14,
    this.iconSize = 24,
    this.borderWidth = 2,
    this.shadowBlurRadius = 10,
    this.shadowOffset = const Offset(0, 4),
  });

  const AiSuggestionButton.small({
    super.key,
    required this.onTap,
    this.label,
    this.height,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
    this.fontSize = 11,
    this.iconSize = 14,
    this.borderWidth = 1,
    this.shadowBlurRadius = 0,
    this.shadowOffset = Offset.zero,
  });

  @override
  State<AiSuggestionButton> createState() => _AiSuggestionButtonState();
}

class _AiSuggestionButtonState extends State<AiSuggestionButton> with TickerProviderStateMixin {
  late final AnimationController _gradientController;
  late final AnimationController _sparkleController;
  final List<_Sparkle> _bodySparkles = [];
  final List<_Sparkle> _borderSparkles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _sparkleController.addListener(_updateSparkles);
  }

  void _updateSparkles() {
    // Body Sparkles (Faint, inside)
    if (_random.nextDouble() < 0.1) { // 10% chance
      _bodySparkles.add(_Sparkle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 0.4 + 0.3,
        startTime: DateTime.now(),
        duration: Duration(milliseconds: 600 + _random.nextInt(600)),
        isBorder: false,
      ));
    }

    // Border Sparkles (Vivid, on edge)
    if (_random.nextDouble() < 0.15) { // 15% chance
      // Simple edge distribution logic
      double bx, by;
      if (_random.nextBool()) {
        // Horizontal edge
        bx = _random.nextDouble();
        by = _random.nextBool() ? 0.0 : 1.0;
      } else {
        // Vertical edge
        bx = _random.nextBool() ? 0.0 : 1.0;
        by = _random.nextDouble();
      }
      
      _borderSparkles.add(_Sparkle(
        x: bx,
        y: by,
        size: _random.nextDouble() * 0.5 + 0.4,
        startTime: DateTime.now(),
        duration: Duration(milliseconds: 500 + _random.nextInt(500)),
        isBorder: true,
      ));
    }

    final now = DateTime.now();
    _bodySparkles.removeWhere((s) => now.difference(s.startTime) > s.duration);
    _borderSparkles.removeWhere((s) => now.difference(s.startTime) > s.duration);
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        // Outer Container (Border + Shadow)
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
            gradient: LinearGradient(
              colors: const [
                AppColors.stoxAccent,
                Color(0xFFFF5252),
                AppColors.stoxAccent,
              ],
              begin: Alignment(-1.0 + _gradientController.value * 2, -1.0),
              end: Alignment(1.0 + _gradientController.value * 2, 1.0),
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.mirror,
            ),
            boxShadow: widget.shadowBlurRadius > 0
                ? [
                    BoxShadow(
                      color: AppColors.stoxAccent.withOpacity(0.3),
                      blurRadius: widget.shadowBlurRadius,
                      offset: widget.shadowOffset,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
            child: Stack(
              children: [
                 // Border Sparkles Layer (Behind body)
                 Positioned.fill(
                   child: CustomPaint(
                     painter: _SparklePainter(sparkles: List.from(_borderSparkles), isBorder: true),
                   ),
                 ),
                 
                 // Inner Body Container (Sizing child)
                 Padding(
                  padding: EdgeInsets.all(widget.borderWidth),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular((widget.borderRadius ?? 16) - widget.borderWidth),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onTap,
                        borderRadius: BorderRadius.circular((widget.borderRadius ?? 16) - widget.borderWidth),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                             // Content
                            Padding(
                              padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.auto_awesome, color: AppColors.stoxAccent, size: widget.iconSize),
                                  const SizedBox(width: 8),
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [AppColors.stoxAccent, Color(0xFFFF5252)],
                                    ).createShader(bounds),
                                    child: Text(
                                      widget.label ?? (AppLocalizations.of(context)?.aiSuggestion ?? 'AI'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Body Sparkles Layer
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _SparklePainter(sparkles: List.from(_bodySparkles), isBorder: false),
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
          ),
        );
      },
    );
  }
}

class _Sparkle {
  final double x; // 0.0 to 1.0
  final double y; // 0.0 to 1.0
  final double size;
  final DateTime startTime;
  final Duration duration;
  final bool isBorder;

  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.startTime,
    required this.duration,
    required this.isBorder,
  });
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final bool isBorder;

  _SparklePainter({required this.sparkles, required this.isBorder});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final now = DateTime.now();

    for (var sparkle in sparkles) {
      final elapsed = now.difference(sparkle.startTime).inMilliseconds;
      final progress = elapsed / sparkle.duration.inMilliseconds;
      if (progress >= 1.0) continue;

      // Fade in and out
      final fade = (progress < 0.5) ? progress * 2 : (1.0 - progress) * 2;
      double opacity = fade.clamp(0.0, 1.0);
      
      if (isBorder) {
         // Vivid border sparkle
         paint.color = AppColors.stoxAccent.withOpacity(opacity);
      } else {
         // Faint body sparkle
         paint.color = AppColors.stoxAccent.withValues(alpha: 0.2 * opacity); // Max 0.2 opacity
      }
      
      final centerX = sparkle.x * size.width;
      final centerY = sparkle.y * size.height;
      final radius = 2.0 * sparkle.size;

      // Draw star shape (diamond)
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
