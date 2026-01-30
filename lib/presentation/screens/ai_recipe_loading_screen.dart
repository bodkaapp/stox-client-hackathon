import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stox/presentation/screens/recipe_search_results_screen.dart';

import '../../infrastructure/repositories/ai_recipe_repository.dart';

/**
 * AIがレシピを考えています…
 * の画面のとき、Geminiのレスポンスから、材料名のリストと、Geminiがおすすめするレシピ名を受け取るようにしてください。
 * その材料名を10秒を個数分で割った間隔で表示して、10秒待つように変更してください。
 * そして、最後に、Geminiから受け取ったレシピ名をSearch engineで検索して、検索結果を表示するようにしてください。
 */
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
  String _recommendedRecipe = '';
  bool _analysisComplete = false;
  Timer? _animationTimer;

  // Minimum wait time (10 seconds)
  static const int _minWaitTimeMs = 10000;
  final int _startTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      
      // Run analysis in parallel with the minimum wait timer
      final analysisFuture = aiRepo.analyzeImageForRecipe(bytes, mimeType: widget.imageFile.mimeType);
      
      // Wait for analysis to complete
      final result = await analysisFuture;

      if (!mounted) return;

      setState(() {
        _ingredients = result.ingredients;
        _recommendedRecipe = result.recommendedRecipe;
        _analysisComplete = true; // Mark as analysis done, but animation might still be running
      });

      // Start animation of ingredients
      _startIngredientAnimation();

    } catch (e) {
      debugPrint('Analysis failed: $e');
      if (mounted) {
        // Fallback navigation after error
        _navigateToResults('冷蔵庫の残り物');
      }
    }
  }

  void _startIngredientAnimation() {
    if (_ingredients.isEmpty) {
      // No ingredients found, verify total time and navigate
      _checkTimeAndNavigate();
      return;
    }

    // Determine how much time is left to fill 10 seconds total
    final elapsed = DateTime.now().millisecondsSinceEpoch - _startTime;
    final remainingTime = _minWaitTimeMs - elapsed;
    
    // If we took too long already, just show quickly. 
    // If we have time, spread them out.
    // However, user requested: "divide 10 seconds by the number of ingredients"
    // AND "wait 10 seconds". 
    // Ideally, we want the whole process to take ~10s. 
    // If analysis took 3s, we have 7s left to show ingredients.
    // If analysis took 12s, we should probably just show them fast or process already took long enough.
    
    // Let's stick to the user's specific request: "10秒を個数分で割った間隔で表示"
    // This implies the animation duration is strictly 10s regardless of analysis time? 
    // OR, we start the 10s animation AFTER analysis? 
    // "AIがレシピを考えています…の画面のとき... 材料名を10秒を個数分で割った間隔で表示して、10秒待つ" 
    // Interpreting this as: total animation time should be 10 seconds.
    // Since we need ingredients first to display them, we effectively have to wait for analysis first.
    // But analysis takes time. 
    // Let's calculate interval based on 10 seconds total animation duration.
    
    final int intervalMs = (10000 / _ingredients.length).floor();
    
    int currentIndex = 0;
    _animationTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (currentIndex < _ingredients.length) {
        setState(() {
          _displayText = '発見: ${_ingredients[currentIndex]}';
        });
        currentIndex++;
      } else {
        timer.cancel();
        // Animation done (approx 10s passed since animation start).
        // Total time will be Analysis Time + 10s. This might be long but safe. 
        _navigateToResults(_recommendedRecipe);
      }
    });
  }
  
  void _checkTimeAndNavigate() {
     // Ensure at least 10s total passed if no animation
    final elapsed = DateTime.now().millisecondsSinceEpoch - _startTime;
    final remaining = _minWaitTimeMs - elapsed;
    
    if (remaining > 0) {
      Timer(Duration(milliseconds: remaining), () {
        if (mounted) _navigateToResults(_recommendedRecipe.isNotEmpty ? _recommendedRecipe : '冷蔵庫の残り物');
      });
    } else {
       _navigateToResults(_recommendedRecipe.isNotEmpty ? _recommendedRecipe : '冷蔵庫の残り物');
    }
  }

  void _navigateToResults(String query) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeSearchResultsScreen(
          searchQuery: query,
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
            color: Colors.black.withOpacity(0.5),
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
                const Text(
                  'AIがレシピを考えています…',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Dynamic Ingredient Text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _displayText,
                    key: ValueKey<String>(_displayText),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
}
