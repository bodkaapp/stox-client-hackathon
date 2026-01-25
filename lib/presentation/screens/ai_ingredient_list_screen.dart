// This logic is mostly handled in IsarIngredientRepository and ShoppingViewModel, 
// but AiIngredientListScreen needs to manipulate local state before saving.
// Created a screen file for AiIngredientListScreen.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/recipe.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../infrastructure/repositories/isar_ingredient_repository.dart';
import '../../infrastructure/repositories/isar_recipe_repository.dart';
import '../../infrastructure/repositories/isar_user_settings_repository.dart';

class AiIngredientListScreen extends ConsumerStatefulWidget {
  final String? initialText;
  final String? sourceUrl;
  final String? recipeTitle;
  final String? imageUrl;

  const AiIngredientListScreen({
    super.key,
    this.initialText,
    this.sourceUrl,
    this.recipeTitle,
    this.imageUrl,
  });

  @override
  ConsumerState<AiIngredientListScreen> createState() => _AiIngredientListScreenState();
}

class _AiIngredientListScreenState extends ConsumerState<AiIngredientListScreen> {
  final TextEditingController _inputController = TextEditingController();
  List<Ingredient> _ingredients = [];
  bool _isAnalyzing = false;
  late String _recipeTitle;

  @override
  void initState() {
    super.initState();
    _recipeTitle = widget.recipeTitle ?? '';
    if (widget.initialText != null) {
      _inputController.text = widget.initialText!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _analyzeRecipe();
      });
    }
  }

  Future<void> _analyzeRecipe() async {
    if (_inputController.text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final repository = ref.read(aiRecipeRepositoryProvider);
      final results = await repository.extractIngredients(_inputController.text);
      setState(() {
        _ingredients = results;
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

  void _toggleIngredientStatus(int index) {
    setState(() {
      final current = _ingredients[index];
      // Toggle between toBuy (買い物リスト) and stock (家にある)
      // Logic: if toBuy -> set to home (simulated as stock or just hidden/marked)
      // UI uses "ある" (Home/Stock) vs "ない" (ToBuy)
      // If status is toBuy, it means "Not at home" ("ない"). 
      // If status is stock, it means "At home" ("ある").
      
      final newStatus = current.status == IngredientStatus.toBuy 
          ? IngredientStatus.stock 
          : IngredientStatus.toBuy;

      _ingredients[index] = current.copyWith(status: newStatus);
    });
  }

  void _addIngredient(String name, String amountStr) {
    // Parse amount string if possible, else 0
    double amount = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 1.0;
    String unit = amountStr.replaceAll(RegExp(r'[0-9.]'), '').trim();
    if (unit.isEmpty) unit = '個';

    setState(() {
      _ingredients.add(Ingredient(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        standardName: name, // Default to name
        amount: amount,
        unit: unit,
        status: IngredientStatus.toBuy, // Default to "Not at home"
        category: 'その他',
      ));
    });
  }



  Future<void> _handleRegister() async {
    final userSettingsRepo = await ref.read(userSettingsRepositoryProvider.future);
    final userSettings = await userSettingsRepo.get();

    if (userSettings.hideAiIngredientRegistrationDialog) {
      await _saveIngredients();
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
                    const Text('「ある」材料は在庫へ、「ない」材料は買い物リストへ追加します。よろしいですか？'),
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
        await _saveIngredients();
      }
    }
  }

  Future<void> _saveIngredients() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final recipeRepo = await ref.read(recipeRepositoryProvider.future);
      final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);

      String recipeId = '';
      if (widget.sourceUrl != null && _recipeTitle.isNotEmpty) {
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

      final stockIngredients = _ingredients.where((i) => i.status == IngredientStatus.stock).toList();
      final toBuyIngredients = _ingredients.where((i) => i.status == IngredientStatus.toBuy).toList();

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '在庫に${stockIngredients.length}件、買い物リストに${toBuyIngredients.length}件追加しました！'
            ),
          ),
        );
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
    final homeCount = _ingredients.where((i) => i.status == IngredientStatus.stock).length;
    final totalCount = _ingredients.length;
    final progress = totalCount > 0 ? homeCount / totalCount : 0.0;
    final toBuyCount = totalCount - homeCount;

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(title: const Text('材料抽出結果'), centerTitle: true),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(homeCount, totalCount),
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
        border: const Border(bottom: BorderSide(color: Color(0xFFFFEBD5))),
      ),
      child: Column(
        children: [



          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEBD5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
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
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0E7DE)),
      itemBuilder: (context, index) {
        final item = _ingredients[index];
        return _buildIngredientRow(index, item);
      },
    );
  }

  Widget _buildIngredientRow(int index, Ingredient item) {
    // isHome means status == stock
    final isHome = item.status == IngredientStatus.stock;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isHome ? const Color(0xFFE8F5E9).withOpacity(0.3) : Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: isHome ? AppColors.stoxText.withOpacity(0.6) : AppColors.stoxText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: isHome ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.green.shade300,
                  ),
                ),
                Text(
                  '${item.amount}${item.unit}',
                  style: TextStyle(
                    color: isHome ? Colors.green : const Color(0xFFF39C12),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildToggleButton(
                label: 'ある',
                isSelected: isHome,
                activeColor: Colors.green,
                onTap: () {
                   if (!isHome) _toggleIngredientStatus(index);
                },
              ),
              const SizedBox(width: 8),
              _buildToggleButton(
                label: 'ない',
                isSelected: !isHome,
                activeColor: Colors.redAccent,
                onTap: () {
                   if (isHome) _toggleIngredientStatus(index);
                },
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
            color: isSelected ? activeColor.withOpacity(0.3) : const Color(0xFFE8DDCE),
          ),
        ),
        child: Center(
          child: isSelected && label == 'ある'
              ? Icon(Icons.check, color: activeColor, size: 18)
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
        border: const Border(top: BorderSide(color: Color(0xFFFFEBD5))),
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
                  side: const BorderSide(color: Color(0xFFE8DDCE)),
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
