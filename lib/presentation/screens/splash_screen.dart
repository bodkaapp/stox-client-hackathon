import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final bool autoNavigate;

  const SplashScreen({
    super.key,
    this.autoNavigate = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.autoNavigate) {
      _checkFirstLaunch();
    }
  }

  Future<void> _checkFirstLaunch() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (mounted) {
      if (isFirstLaunch) {
        context.go('/ai_recipe_intro');
      } else {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: Stack(
        children: [
          // Background subtle circle decoration (top-left)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.stoxBannerBg,
                  width: 40,
                ),
              ),
            ),
          ),
          
          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 24),
                Text(
                  'STOX',
                  style: GoogleFonts.outfit(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.stoxPrimary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.stoxAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '家事悩み無くし系アプリ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.stoxSubText,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Content
          Positioned(
             bottom: -200,
             left: 0,
             right: 0,
             child: Center(
               child: Container(
                width: 600,
                height: 600,
                 decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.stoxBannerBg,
                    width: 60,
                  ),
                ),
               ),
             ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(AppColors.stoxSubText),
                    const SizedBox(width: 8),
                    _buildDot(AppColors.stoxPrimary),
                    const SizedBox(width: 8),
                    _buildDot(AppColors.stoxAccent),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'KITCHEN MANAGEMENT AI',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: const Color(0xFFAAAAAA),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.stoxAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
          // Fridge Icon Representation
          Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.stoxPrimary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                 // Freezer door line
                 Container(
                   height: 20,
                   decoration: const BoxDecoration(
                     border: Border(
                       bottom: BorderSide(color: Colors.white, width: 2),
                     )
                   ),
                 ),
                 // Handles
                 Transform.translate(
                   offset: const Offset(-8, -12),
                   child: Container(
                     width: 4,
                     height: 8,
                     color: Colors.white,
                   ),
                 ),
                  Transform.translate(
                   offset: const Offset(-8, 0),
                   child: Container(
                     width: 4,
                     height: 12,
                     color: Colors.white,
                   ),
                 ),
              ],
            ),
          ),
          // Heart Notification
          Positioned(
            top: 20,
            right: 25,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.stoxAccent,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
