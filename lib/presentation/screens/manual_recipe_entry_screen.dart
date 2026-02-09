import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_ingredient.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import 'recipe_schedule_screen.dart';
import '../../infrastructure/services/recipe_monitoring_service.dart';

class ManualRecipeEntryScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final MealType? initialMealType;

  const ManualRecipeEntryScreen({
    super.key,
    this.initialDate,
    this.initialMealType,
  });

  @override
  ConsumerState<ManualRecipeEntryScreen> createState() => _ManualRecipeEntryScreenState();
}

class _ManualRecipeEntryScreenState extends ConsumerState<ManualRecipeEntryScreen> {
  final _titleController = TextEditingController();
  final List<Map<String, TextEditingController>> _ingredientControllers = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start with 3 empty ingredient rows
    for (int i = 0; i < 3; i++) {
      _addIngredientRow();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final controllers in _ingredientControllers) {
      controllers['name']?.dispose();
      controllers['amount']?.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredientControllers.add({
        'name': TextEditingController(),
        'amount': TextEditingController(),
      });
    });
    // Scroll to bottom after adding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _onRegister() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorEnterRecipeName)), // レシピ名を入力してください
      );
      return;
    }

    final ingredients = <RecipeIngredient>[];
    for (final controllers in _ingredientControllers) {
      final name = controllers['name']!.text.trim();
      final amount = controllers['amount']!.text.trim();
      if (name.isNotEmpty) {
        ingredients.add(RecipeIngredient(name: name, amount: amount));
      }
    }

    final repo = await ref.read(recipeRepositoryProvider.future);
    final recipeId = DateTime.now().microsecondsSinceEpoch.toString();
    
    // Create new recipe
    final recipe = Recipe(
      id: recipeId,
      title: title,
      pageUrl: '', // Manual entry
      ogpImageUrl: '',
      createdAt: DateTime.now(),
      ingredients: ingredients,
    );

    try {
      await repo.save(recipe);

      // Track registration (Manual entry has no URL, but we track the event)
      ref.read(recipeMonitoringServiceProvider).trackRecipeRegistration('manual');

      if (mounted) {
        // Navigate to Schedule Screen with saved recipe details (or just basics)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScheduleScreen(
              title: title,
              url: '', // Empty or identifier
              initialDate: widget.initialDate,
              initialMealType: widget.initialMealType,
              initialMemo: ingredients.map((e) => '・${e.name}: ${e.amount}').join('\n'), // Fallback for display/memo
              existingRecipeId: recipeId, // Pass the new recipe ID
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorSaveFailed}: $e')), // 保存に失敗しました
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(
        backgroundColor: AppColors.stoxBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.stoxText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.manualRecipeEntry, // レシピを手入力
          style: const TextStyle(color: AppColors.stoxText, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.stoxBorder, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.recipeNameLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stoxText)), // レシピ名 // レシピ名
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.recipeNameHint, // 例：豚肉の生姜焼き
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.stoxBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.stoxBorder),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(AppLocalizations.of(context)!.ingredientsAmount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stoxText)), // 材料・分量 // 材料・分量
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ingredientControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _ingredientControllers[index]['name'],
                                  decoration: InputDecoration(
                                    hintText: index == 0 ? AppLocalizations.of(context)!.ingredientNameHint 
                                            : AppLocalizations.of(context)!.manualRecipeIngredientLabel, // 材料名 (例: 豚肉) : 材料名 // 材料名 (例: 豚肉) : 材料名
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.stoxBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.stoxBorder),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _ingredientControllers[index]['amount'],
                                  decoration: InputDecoration(
                                    hintText: index == 0 ? AppLocalizations.of(context)!.amountHint 
                                            : AppLocalizations.of(context)!.manualRecipeAmountLabel, // 分量 (例: 200g) : 分量 // 分量 (例: 200g) : 分量
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.stoxBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppColors.stoxBorder),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      onPressed: _addIngredientRow,
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.stoxPrimary),
                      label: Text(AppLocalizations.of(context)!.actionAddIngredient, style: const TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold)), // 材料を追加する
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: AppColors.stoxBorder)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stoxPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.actionRegisterManualRecipe, // 手入力したレシピを登録する
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
