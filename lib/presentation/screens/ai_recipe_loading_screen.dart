import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ai_recipe_proposal_screen.dart';
import '../widgets/search_modal.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';

class AiRecipeLoadingScreen extends ConsumerStatefulWidget {
  final XFile imageFile;

  const AiRecipeLoadingScreen({
    super.key,
    required this.imageFile,
  });

  @override
  ConsumerState<AiRecipeLoadingScreen> createState() => _AiRecipeLoadingScreenState();
}

class _AiRecipeLoadingScreenState extends ConsumerState<AiRecipeLoadingScreen> {
  String _displayText = '';
  List<String> _ingredients = [];
  List<AiRecipeSuggestion> _recipeSuggestions = [];
  bool _analysisComplete = false;
  bool _hasError = false;
  Timer? _animationTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_displayText.isEmpty && !_hasError) {
      _displayText = AppLocalizations.of(context)!.aiRecipeAnalyzingPhoto; // AIが写真を解析しています…
    }
  }

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      
      // Step 1: Identify items
      final items = await aiRepo.identifyKitchenItems(bytes, mimeType: widget.imageFile.mimeType);
      
      if (!mounted) return;

      if (items.isEmpty) {
        setState(() {
          _hasError = true;
        });
        return;
      }

      setState(() {
        _ingredients = items;
      });

      // Start Animation
      final int intervalMs = (10000 / _ingredients.length).floor();
      _startIngredientAnimation(intervalMs);
      
      // Step 3: Suggest Recipes (Parallel)
      final suggestions = await aiRepo.suggestRecipesFromItems(_ingredients);
      
      if (mounted) {
        setState(() {
          _recipeSuggestions = suggestions;
        });
        _checkAndNavigate();
      }

    } catch (e) {
      debugPrint('Analysis failed: $e');
      if (mounted) {
         setState(() {
          _hasError = true;
        });
      }
    }
  }

  Future<void> _onErrorRetake() async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AiRecipeLoadingScreen(imageFile: image),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error retaking image: $e');
    }
  }

  Future<void> _markTutorialDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
  }

  Future<void> _onErrorSkip() async {
    await _markTutorialDone();
    if (mounted) {
      context.go('/');
    }
  }
  
  Future<void> _onErrorSearchAction() async {
    await _markTutorialDone();
    if (mounted) {
       // Navigate to home first
       context.go('/');
       // Wait a bit for navigation
       await Future.delayed(const Duration(milliseconds: 300));
       if (mounted) {
          SearchModal.show(context);
       }
    }
  }


  void _startIngredientAnimation(int intervalMs) {
    // Change text when animation starts (or slightly before/after)
    if (mounted) {
       setState(() {
         _displayText = AppLocalizations.of(context)!.aiRecipeThinkingWithIngredient(_ingredients.first); // AIがレシピを考えています…\n${_ingredients.first}があります
       });
    }

    int currentIndex = 0;
    _animationTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (currentIndex < _ingredients.length) {
        setState(() {
           // Keep the main message, update the ingredient part
          _displayText = AppLocalizations.of(context)!.aiRecipeThinkingWithIngredient(_ingredients[currentIndex]); // AIがレシピを考えています…\n${_ingredients[currentIndex]}があります
        });
        currentIndex++;
      } else {
        timer.cancel();
        _analysisComplete = true; 
        _checkAndNavigate();
      }
    });
  }
  
  void _checkAndNavigate() {
    if (_analysisComplete && _recipeSuggestions.isNotEmpty) {
      _navigateToProposal();
    }
  }

  void _navigateToProposal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AiRecipeProposalScreen(
          suggestions: _recipeSuggestions,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorView();
    }
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.file(
            File(widget.imageFile.path),
            fit: BoxFit.cover,
          ),
          
          // Semi-transparent overlay
          Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
          
          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                // Dynamic Text (Main Message + Ingredient)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _displayText,
                    key: ValueKey<String>(_displayText),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               const Icon(Icons.error_outline, size: 64, color: Color(0xFFFF007F)),
               const SizedBox(height: 24),
               Text(
                 AppLocalizations.of(context)!.aiRecipeNoItemsFound, // 商品が見つかりませんでした
                 textAlign: TextAlign.center,
                 style: GoogleFonts.outfit(
                   fontSize: 22,
                   fontWeight: FontWeight.bold,
                   color: Colors.black,
                 ),
               ),
               const SizedBox(height: 16),
               Text(
                 AppLocalizations.of(context)!.aiRecipeNoIdentification, // 写真から食材を特定できませんでした。\nもう一度撮影するか、レシピを検索してください。
                 textAlign: TextAlign.center,
                 style: const TextStyle(
                   color: Color(0xFF8A8A8A),
                   height: 1.5,
                 ),
               ),
               const SizedBox(height: 48),
               
               // Retake Button
               ElevatedButton.icon(
                  onPressed: _onErrorRetake,
                   icon: const Icon(Icons.camera_alt, color: Colors.white),
                   label: Text(AppLocalizations.of(context)!.actionRetakePhoto, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // もう一度撮影する
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF007F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
               ),
               const SizedBox(height: 16),
               
               // Search Button
               OutlinedButton.icon(
                  onPressed: _onErrorSearchAction,
                   icon: const Icon(Icons.search, color: Color(0xFFFF007F)),
                   label: Text(AppLocalizations.of(context)!.actionSearchRecipe, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF007F))), // レシピを検索する
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFFF007F)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
               ),
               const SizedBox(height: 16),
               
               // Skip Button
               TextButton(
                onPressed: _onErrorSkip,
                 child: Text(AppLocalizations.of(context)!.actionSkip, style: const TextStyle(color: Color(0xFF8A8A8A))), // スキップする
               ),
            ],
          ),
        ),
      ),
    );
  }
}
