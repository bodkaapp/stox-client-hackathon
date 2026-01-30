import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_recipe_loading_screen.dart';
import 'photo_stock_location_screen.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  Future<void> _setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
  }

  Future<void> _onSkip(BuildContext context) async {
    await _setFirstLaunchDone();
    if (context.mounted) {
      context.go('/');
    }
  }

  Future<void> _onRegisterManually(BuildContext context) async {
    await _setFirstLaunchDone();
    if (context.mounted) {
      context.go('/stock');
    }
  }

  Future<void> _onStartCamera(BuildContext context) async {
    await _setFirstLaunchDone();
    
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null && context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiRecipeLoadingScreen(imageFile: image),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton.icon(
                  onPressed: () => _onSkip(context),
                  label: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF8A8A8A)),
                  icon: const Text(
                    'スキップ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Illustration
                   Container(
                     width: 280,
                     height: 280,
                     decoration: const BoxDecoration(
                       shape: BoxShape.circle,
                       color: Color(0xFFFFF2E0),
                     ),
                     child: ClipOval(
                       child: Image.asset(
                         'assets/images/tutorial-illustration.png',
                         fit: BoxFit.cover,
                       ),
                     ),
                   ),
                   const SizedBox(height: 48),
                   
                   // Title
                   Text(
                     '冷蔵庫の中を\n撮影しましょう',
                     textAlign: TextAlign.center,
                     style: GoogleFonts.outfit(
                       fontSize: 24,
                       fontWeight: FontWeight.bold,
                       color: const Color(0xFF333333),
                       height: 1.4,
                     ),
                   ),
                   const SizedBox(height: 16),
                   
                   // Description
                   const Text(
                     'AIが写真を解析して、最適なレシピを提案します',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 14,
                       color: Color(0xFF8A8A8A),
                       height: 1.6,
                     ),
                   ),
                ],
              ),
            ),
            
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _onStartCamera(context),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'カメラを起動する',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF9F27),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _onRegisterManually(context),
                    child: const Text(
                      '手動で登録する',
                      style: TextStyle(
                         fontSize: 14,
                         fontWeight: FontWeight.bold,
                         color: Color(0xFF8D6E63),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
