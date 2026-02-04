import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';
import 'ai_recipe_proposal_screen.dart';

class AiMenuProposalLoadingScreen extends ConsumerStatefulWidget {
  final DateTime targetDate;
  final MealType mealType;

  const AiMenuProposalLoadingScreen({
    super.key,
    required this.targetDate,
    required this.mealType,
  });

  @override
  ConsumerState<AiMenuProposalLoadingScreen> createState() => _AiMenuProposalLoadingScreenState();
}

class _AiMenuProposalLoadingScreenState extends ConsumerState<AiMenuProposalLoadingScreen> {
  String _displayText = '献立を考えています...';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      // 1. Fetch Repositories
      final mealPlanRepo = await ref.read(mealPlanRepositoryProvider.future);
      final recipeRepo = await ref.read(recipeRepositoryProvider.future);
      final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);
      final aiRepo = ref.read(aiRecipeRepositoryProvider);

      // 2. Determine surrounding dates
      final targetDate = widget.targetDate;
      final startSearch = targetDate.subtract(const Duration(days: 1)); // Yesterday
      final endSearch = targetDate.add(const Duration(days: 1)); // Tomorrow

      // 3. Fetch surrounding meals
      final mealPlans = await mealPlanRepo.getByDateRange(startSearch, endSearch);
      
      // Map to readable strings
      final surroundingMeals = <String>[];
      for (final plan in mealPlans) {
        if (plan.recipeId.isEmpty) continue;
        
        final recipe = await recipeRepo.getById(plan.recipeId);
        if (recipe == null) continue;

        String dayLabel = '';
        if (plan.date.day == targetDate.day) {
          dayLabel = '今日';
        } else if (plan.date.day == targetDate.subtract(const Duration(days: 1)).day) {
          dayLabel = '昨日';
        } else if (plan.date.day == targetDate.add(const Duration(days: 1)).day) {
          dayLabel = '明日';
        } else {
          dayLabel = DateFormat('M/d').format(plan.date);
        }

        String typeLabel = _getMealTypeLabel(plan.mealType);
        surroundingMeals.add('$dayLabelの$typeLabel: ${recipe.title}');
      }

      if (mounted) {
        setState(() {
          _displayText = '冷蔵庫の中身を確認しています...';
        });
      }

      // 4. Fetch Stock & Shopping List
      final stockIngredients = await ingredientRepo.getAll(); // Or filter by status.stock if possible?
      // Simple filter
      final stockItems = stockIngredients
          .where((i) => i.status == IngredientStatus.stock)
          .map((i) => i.name)
          .toList();
      
      final shoppingListItems = stockIngredients
          .where((i) => i.status == IngredientStatus.toBuy)
          .map((i) => i.name)
          .toList();

      if (mounted) {
        setState(() {
          _displayText = 'AIがメニューを生成しています...';
        });
      }

      // 5. Call AI
      final suggestions = await aiRepo.suggestMenuPlan(
        targetDate: widget.targetDate,
        mealType: _getMealTypeLabel(widget.mealType),
        surroundingMeals: surroundingMeals,
        stockItems: stockItems,
        shoppingListItems: shoppingListItems,
      );

      // 6. Navigate
      if (mounted) {
        if (suggestions.isEmpty) {
           throw Exception('提案を作成できませんでした');
        }
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AiRecipeProposalScreen(
              suggestions: suggestions,
            ),
          ),
        );
      }

    } catch (e) {
      debugPrint('AI Menu Proposal Error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _displayText = 'エラーが発生しました。\nもう一度お試しください。';
        });
      }
    }
  }

  String _getMealTypeLabel(MealType type) {
    switch (type) {
      case MealType.breakfast: return '朝食';
      case MealType.lunch: return '昼食';
      case MealType.dinner: return '夕食';
      case MealType.snack: return '間食';
      case MealType.preMade: return '作り置き';
      case MealType.other: return 'その他';
      case MealType.undecided: return '時間未定';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_hasError)
              const Icon(Icons.error_outline, size: 60, color: Colors.red)
            else
              const CircularProgressIndicator(color: Color(0xFFEF9F27)),
            
            const SizedBox(height: 24),
            
            Text(
              _displayText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            
            if (_hasError) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF9F27),
                  foregroundColor: Colors.white,
                ),
                child: const Text('戻る'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
