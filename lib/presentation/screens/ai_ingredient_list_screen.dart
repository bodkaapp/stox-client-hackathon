// This logic is mostly handled in DriftIngredientRepository and ShoppingViewModel, 
// but AiIngredientListScreen needs to manipulate local state before saving.
// Created a screen file for AiIngredientListScreen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import '../../infrastructure/repositories/drift_user_settings_repository.dart';

enum AiSelection {
  stock, // ある
  toBuy, // 買う
  ignored, // いらない
}

class _AiIngredientItem {
  final Ingredient ingredient;
  final AiSelection selection;

  const _AiIngredientItem({
    required this.ingredient,
    this.selection = AiSelection.toBuy, // Default to "toBuy" (Not at home)
  });

  _AiIngredientItem copyWith({
    Ingredient? ingredient,
    AiSelection? selection,
  }) {
    return _AiIngredientItem(
      ingredient: ingredient ?? this.ingredient,
      selection: selection ?? this.selection,
    );
  }
}


class AiIngredientListScreen extends ConsumerStatefulWidget {
  final String? initialText;
  final String? sourceUrl;
  final String? recipeTitle;
  final String? imageUrl;
  final List<Ingredient>? preCalculatedIngredients;

  const AiIngredientListScreen({
    super.key,
    this.initialText,
    this.sourceUrl,
    this.recipeTitle,
    this.imageUrl,
    this.preCalculatedIngredients,
  });

  @override
  ConsumerState<AiIngredientListScreen> createState() => _AiIngredientListScreenState();
}

class _AiIngredientListScreenState extends ConsumerState<AiIngredientListScreen> {
  final TextEditingController _inputController = TextEditingController();
  List<_AiIngredientItem> _ingredients = [];
  bool _isAnalyzing = false;
  late String _recipeTitle;

  @override
  void initState() {
    super.initState();
    _recipeTitle = widget.recipeTitle ?? '';
    if (widget.preCalculatedIngredients != null) {
      // Use pre-calculated ingredients but still check against stock
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processPreCalculatedIngredients(widget.preCalculatedIngredients!);
      });
    } else if (widget.initialText != null) {
      _inputController.text = widget.initialText!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _analyzeRecipe();
      });
    }
  }

  Future<void> _processPreCalculatedIngredients(List<Ingredient> ingredients) async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final ingredientRepository = await ref.read(ingredientRepositoryProvider.future);
      final allIngredients = await ingredientRepository.getAll();
      
      final existingNames = allIngredients
          .map((i) => i.name)
          .toSet();
      
      final uniqueResults = <String, Ingredient>{};
      for (final item in ingredients) {
        if (!uniqueResults.containsKey(item.name)) {
          uniqueResults[item.name] = item;
        }
      }
      
      if (mounted) {
        setState(() {
          _ingredients = uniqueResults.values.map((i) {
            final isExisting = existingNames.contains(i.name);
            return _AiIngredientItem(
              ingredient: i,
              selection: isExisting ? AiSelection.stock : AiSelection.toBuy,
            );
          }).toList();
          _isAnalyzing = false;
        });
      }
    } catch (e) {
       setState(() {
        _isAnalyzing = false;
      });
      // Just show what we have if check fails? Or show error?
      // If check fails, we might just default to 'toBuy'.
       if (mounted) {
        setState(() {
          _ingredients = ingredients.map((i) => _AiIngredientItem(
            ingredient: i,
            selection: AiSelection.toBuy,
          )).toList();
        });
      }
    }
  }

  Future<void> _analyzeRecipe() async {
    if (_inputController.text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final aiRepository = ref.read(aiRecipeRepositoryProvider);
      final ingredientRepository = await ref.read(ingredientRepositoryProvider.future);
      
      // Fetch current stock to check against
      final allIngredients = await ingredientRepository.getAll();
      
      // Check against ALL existing ingredients (Stock, ToBuy, InCart)
      // to avoid duplicates in shopping list.
      final existingNames = allIngredients
          .map((i) => i.name)
          .toSet();
      
      debugPrint('Existing Items Count: ${existingNames.length}');

      final results = await aiRepository.extractIngredients(_inputController.text);
      
      // Deduplicate results based on name
      final uniqueResults = <String, Ingredient>{};
      for (final item in results) {
        if (!uniqueResults.containsKey(item.name)) {
          uniqueResults[item.name] = item;
        }
      }
      
      setState(() {
        _ingredients = uniqueResults.values.map((i) {
          final isExisting = existingNames.contains(i.name);
          return _AiIngredientItem(
            ingredient: i,
            selection: isExisting ? AiSelection.stock : AiSelection.toBuy,
          );
        }).toList();
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('解析に失敗しました。もう一度お試しください。')),
        );
      }
    }
  }

  void _updateSelection(int index, AiSelection selection) {
    setState(() {
      _ingredients[index] = _ingredients[index].copyWith(selection: selection);
    });
  }

  void _addIngredient(String name, String amountStr) {
    // Parse amount string if possible, else 0
    double amount = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1.0;
    String unit = amountStr.replaceAll(RegExp(r'[0-9.]'), '').trim();
    if (unit.isEmpty) unit = '個';

    setState(() {
      _ingredients.add(_AiIngredientItem(
        ingredient: Ingredient(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name,
          standardName: name, // Default to name
          amount: amount,
          unit: unit,
          status: IngredientStatus.toBuy, // Default to "Not at home"
          category: 'その他',
        ),
        selection: AiSelection.toBuy,
      ));
    });
  }



  Future<void> _handleRegister() async {
    final userSettingsRepo = await ref.read(userSettingsRepositoryProvider.future);
    final userSettings = await userSettingsRepo.get();

    if (userSettings.hideAiIngredientRegistrationDialog) {
       // Even if first dialog is hidden, we might want to check recipe registration?
       // Current plan implies cascading. 
       // If hidden, we assume "Register ingredients" is implicit YES.
       // So we should proceed to Recipe Check if applicable.
       
       bool saveRecipe = false;
        if (mounted && (widget.sourceUrl != null || _recipeTitle.isNotEmpty)) {
           final recipeResult = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('確認'),
              content: const Text('材料の登録が終わりました！\nマイレシピ帳に登録しますか？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('いいえ'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('はい'),
                ),
              ],
            ),
          );
          saveRecipe = recipeResult ?? false;
        }
      await _saveIngredients(saveRecipe: saveRecipe);
    } else {
      if (!mounted) return;
      
      bool dontShowAgain = false;

      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('確認'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('「ある」材料は在庫へ、\n「買う」材料は買い物リストへ追加します。\n「いらない」材料は登録されません。\nよろしいですか？'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: dontShowAgain,
                          onChanged: (value) {
                            setState(() {
                              dontShowAgain = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            '今後このダイアログを非表示にする',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('登録する'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (result == true) {
        if (dontShowAgain) {
          await userSettingsRepo.save(
            userSettings.copyWith(hideAiIngredientRegistrationDialog: true),
          );
        }
        
        // Check if we should ask for recipe registration
        bool saveRecipe = false;
        if (mounted && (widget.sourceUrl != null || _recipeTitle.isNotEmpty)) {
           final recipeResult = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('確認'),
              content: const Text('材料の登録が終わりました！\nマイレシピ帳に登録しますか？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('いいえ'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('はい'),
                ),
              ],
            ),
          );
          saveRecipe = recipeResult ?? false;
        }

        await _saveIngredients(saveRecipe: saveRecipe);
      }
    }
  }

  Future<void> _saveIngredients({bool saveRecipe = false}) async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final recipeRepo = await ref.read(recipeRepositoryProvider.future);
      final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);

      String recipeId = '';
      if (saveRecipe && (widget.sourceUrl != null || _recipeTitle.isNotEmpty)) {
        recipeId = DateTime.now().microsecondsSinceEpoch.toString();
        final recipe = Recipe(
          id: recipeId,
          title: _recipeTitle,
          pageUrl: widget.sourceUrl ?? '',
          ogpImageUrl: widget.imageUrl ?? '',
          createdAt: DateTime.now(),
        );
        await recipeRepo.save(recipe);
      }

      final stockIngredients = _ingredients
          .where((i) => i.selection == AiSelection.stock)
          .map((i) => i.ingredient)
          .toList();
      final toBuyIngredients = _ingredients
          .where((i) => i.selection == AiSelection.toBuy)
          .map((i) => i.ingredient)
          .toList();

      for (final ingredient in stockIngredients) {
        await ingredientRepo.save(ingredient.copyWith(
          id: DateTime.now().microsecondsSinceEpoch.toString() + ingredient.name + '_stock',
          status: IngredientStatus.stock,
        ));
      }

      for (final ingredient in toBuyIngredients) {
        await ingredientRepo.save(ingredient.copyWith(
          id: DateTime.now().microsecondsSinceEpoch.toString() + ingredient.name + '_tobuy',
          status: IngredientStatus.toBuy,
        ));
      }

      if (mounted) {
        Navigator.pop(context, recipeId.isNotEmpty ? recipeId : true);
        
        final parts = <String>[];
        if (stockIngredients.isNotEmpty) {
          parts.add('在庫に${stockIngredients.length}件');
        }
        if (toBuyIngredients.isNotEmpty) {
          parts.add('買い物リストに${toBuyIngredients.length}件');
        }

        if (parts.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${parts.join('、')}追加しました！'
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存に失敗しました。')),
        );
      }
    }
  }

  Future<void> _handleBack() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認'),
        content: const Text('解析した材料は、在庫や買い物リストに追加されませんが、よろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('レシピに戻る'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stockCount = _ingredients.where((i) => i.selection == AiSelection.stock).length;
    final toBuyCount = _ingredients.where((i) => i.selection == AiSelection.toBuy).length;
    final relevantCount = stockCount + toBuyCount;
    final progress = relevantCount > 0 ? stockCount / relevantCount : 0.0;

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(title: const Text('材料抽出結果'), centerTitle: true),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(stockCount, relevantCount),
                Expanded(
                  child: _ingredients.isEmpty && !_isAnalyzing
                      ? _buildEmptyState()
                      : _buildIngredientList(),
                ),
                _buildFooter(progress, toBuyCount),
              ],
            ),
            if (_isAnalyzing) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int homeCount, int totalCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.stoxBackground.withOpacity(0.95),
        border: const Border(bottom: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: Column(
        children: [



          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stoxBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.stoxBannerBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: widget.imageUrl != null
                        ? Image.network(widget.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                        : const Icon(Icons.image, color: AppColors.stoxPrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _recipeTitle.isNotEmpty ? _recipeTitle : 'レシピから抽出',
                        style: const TextStyle(
                          color: AppColors.stoxText,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.sourceUrl != null)
                        Text(
                          widget.sourceUrl!,
                          style: const TextStyle(color: Color(0xFFF39C12), fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList() {
    return ListView.separated(
      itemCount: _ingredients.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.stoxBorder),
      itemBuilder: (context, index) {
        final item = _ingredients[index];
        return _buildIngredientRow(index, item);
      },
    );
  }

  Widget _buildIngredientRow(int index, _AiIngredientItem item) {
    final selection = item.selection;
    final ingredient = item.ingredient;
    
    // Dim the text if ignored
    final isIgnored = selection == AiSelection.ignored;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: isIgnored ? 0.4 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      color: AppColors.stoxText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${ingredient.amount}${ingredient.unit}',
                    style: const TextStyle(
                      color: Color(0xFFF39C12),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildToggleButton(
                label: 'ある',
                isSelected: selection == AiSelection.stock,
                activeColor: Colors.green,
                onTap: () => _updateSelection(index, AiSelection.stock),
              ),
              const SizedBox(width: 8),
               _buildToggleButton(
                label: '買う',
                isSelected: selection == AiSelection.toBuy,
                activeColor: AppColors.stoxAccent,
                onTap: () => _updateSelection(index, AiSelection.toBuy),
              ),
              const SizedBox(width: 8),
              _buildToggleButton(
                label: 'いらない',
                isSelected: selection == AiSelection.ignored,
                activeColor: Colors.grey,
                onTap: () => _updateSelection(index, AiSelection.ignored),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeColor.withOpacity(0.3) : AppColors.stoxBorder,
          ),
        ),
        child: Center(
          child: isSelected && (label == 'ある' || label == '買う' || label == 'いらない')
              ? Icon(
                  label == 'ある' ? Icons.check : 
                  label == '買う' ? Icons.shopping_cart : 
                  Icons.close, 
                  color: activeColor, size: 16
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? activeColor : AppColors.stoxSubText,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }



  Widget _buildFooter(double progress, int toBuyCount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.stoxBackground.withOpacity(0.95),
        border: const Border(top: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleBack,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.stoxText,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.stoxBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('何もしないで', style: TextStyle(fontSize: 10)),
                    SizedBox(width: 4),
                    Text('レシピに戻る', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_ingredients.isEmpty || _isAnalyzing) ? null : _handleRegister,
                icon: const Icon(Icons.check),
                label: const Text('材料を登録する'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.stoxPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('材料が見つかりませんでした'));
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
    );
  }
}
