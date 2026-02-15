import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import 'shopping_receipt_result_screen.dart';

class ReceiptAnalysisLoadingScreen extends ConsumerStatefulWidget {
  final File imageFile;
  final List<Ingredient> currentContextList;

  const ReceiptAnalysisLoadingScreen({
    super.key,
    required this.imageFile,
    required this.currentContextList,
  });

  @override
  ConsumerState<ReceiptAnalysisLoadingScreen> createState() => _ReceiptAnalysisLoadingScreenState();
}

class _ReceiptAnalysisLoadingScreenState extends ConsumerState<ReceiptAnalysisLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      final imageBytes = await widget.imageFile.readAsBytes();
      
      // Artificial delay for better UX if analysis is too fast (optional, but good for "feeling" of processing)
      // await Future.delayed(const Duration(seconds: 1)); // Removed for now to be fast

      if (!mounted) return;

      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      final ingredients = await aiRepo.analyzeReceiptImage(imageBytes, mimeType: 'image/jpeg');

      if (!mounted) return;

      // Navigate to Result Screen (Replacement to avoid going back to loading)
      final navResult = await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShoppingReceiptResultScreen(
            receiptItems: ingredients,
            currentShoppingList: widget.currentContextList,
          ),
        ),
      );

       // If 'retake' is returned, we need to handle it. 
       // Since we replaced the route, we can't easily "return" to the previous caller with 'retake'.
       // However, the caller (ReceiptScannerMixin) pushed THIS screen. 
       // If we pop this screen, we go back to the caller's previous screen (e.g. ShoppingList).
       // If ShoppingReceiptResultScreen pops with 'retake', it returns to... nowhere because we replaced logic?
       // Actually user wants to retake. 
       // Let's reconsider navigation.
       
       // If we use pushReplacement, we lost the stack.
       // The mixin pushed this LoadingScreen.
       // LoadingScreen pushes Replacement ResultScreen.
       // ResultScreen pops. -> Goes back to Shopping List (Mixin caller).
       // So we can pass the result back to Mixin caller? 
       // No, pushReplacement returns a Future that completes when the REPLACED route completes? No.
       // pushReplacement returns a Future that completes when the *new* route completes.
       // So if ResultScreen pops with 'retake', `navResult` here will be 'retake'.
       // BUT, this widget is already unmounted/replaced?
       // Wait, pushReplacement *removes* the current route. So `await` here might not work as expected if this widget is disposed.
       // Actually, `Navigator.pushReplacement` returns the result of the pushed route.
       // But since this widget is removed, where does the code execution go?
       // The `await` resumes, but `mounted` will be false.

       // Alternative: Don't use pushReplacement. Use push.
       // Then we have: Mixin -> Loading -> Result.
       // If Back from Result -> Loading (Bad).
       // We want Back from Result -> Mixin (Shopping List).
       
       // So pushReplacement is correct for UX.
       // But how to handle 'retake'?
       // If ResultScreen returns 'retake', we are back at... Shopping List?
       // Yes, because LoadingScreen is gone.
       // So Shopping List needs to handle the result from the pushed LoadingScreen (which was replaced by ResultScreen).
       // The Future returned by a pushed route that is replaced... 
       // "The Future returned by pushReplacement completes when the pushed route completes".
       // So the caller of `Navigator.push(LoadingScreen)` will get the result of `ResultScreen`.
       // perfect.
       
    } catch (e) {
      debugPrint('Analysis Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.receiptAnalysisFailed(e))),
        );
        Navigator.pop(context); // Fail back to previous screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.file(
            widget.imageFile,
            fit: BoxFit.cover,
          ),
          // Dark Overlay
          Container(
            color: Colors.black54,
          ),
          // Loading Indicator & Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.voiceAnalyzing, // "AIが解析中..." (Reuse existing string or similar)
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.receiptWaitSeconds,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Cancel/Back Button (Optional, if user wants to abort)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
