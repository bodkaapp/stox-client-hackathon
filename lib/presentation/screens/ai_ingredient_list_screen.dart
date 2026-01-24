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

  void _showAddIngredientSheet() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '材料を追加',
                style: TextStyle(
                  color: AppColors.stoxText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '材料名',
                  hintText: '例: じゃがいも',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.restaurant),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: '分量',
                  hintText: '例: 2個',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.scale),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      _addIngredient(nameController.text, quantityController.text);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stoxPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('追加する', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveToShoppingList() async {
    // Save only "To Buy" items (Not at home)
    final toBuyIngredients = _ingredients.where((i) => i.status == IngredientStatus.toBuy).toList();
    
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final recipeRepo = await ref.read(recipeRepositoryProvider.future);
      final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);

      if (widget.sourceUrl != null && _recipeTitle.isNotEmpty) {
        final recipe = Recipe(
          id: DateTime.now().microsecondsSinceEpoch.toString(), // Generating ID
          title: _recipeTitle,
          pageUrl: widget.sourceUrl ?? '', // Using url field for sourceUrl
          ogpImageUrl: widget.imageUrl ?? '',
          createdAt: DateTime.now(),
        );
        await recipeRepo.save(recipe);
      }

      for (final ingredient in toBuyIngredients) {
        // Create new ID for persistence or use generated one
        // Ensure status is toBuy
        await ingredientRepo.save(ingredient.copyWith(
          id: DateTime.now().microsecondsSinceEpoch.toString() + ingredient.name, // Ensure unique
          status: IngredientStatus.toBuy
        ));
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toBuyIngredients.isNotEmpty 
                ? '${toBuyIngredients.length}件の材料を買い物リストに追加しました！'
                : 'レシピを保存しました！'
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

  @override
  Widget build(BuildContext context) {
    final homeCount = _ingredients.where((i) => i.status == IngredientStatus.stock).length;
    final totalCount = _ingredients.length;
    final progress = totalCount > 0 ? homeCount / totalCount : 0.0;
    final toBuyCount = totalCount - homeCount;

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(title: const Text('AI材料抽出'), centerTitle: true),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stoxBackground.withOpacity(0.95),
        border: const Border(bottom: BorderSide(color: Color(0xFFFFEBD5))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBD5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '$homeCount / $totalCount 完了',
                      style: const TextStyle(
                        color: Color(0xFFE67E22),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
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
      itemCount: _ingredients.length + 1,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0E7DE)),
      itemBuilder: (context, index) {
        if (index == _ingredients.length) {
          return _buildAddIngredientButton();
        }
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

  Widget _buildAddIngredientButton() {
    return InkWell(
      onTap: _showAddIngredientSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color(0xFFFFF7ED).withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle, color: AppColors.stoxPrimary, size: 18),
            SizedBox(width: 6),
            Text(
              '材料を追加する',
              style: TextStyle(color: AppColors.stoxPrimary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
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
          Row(
            children: [
               Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('戻る'),
                  )
               ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: (_ingredients.isEmpty || _isAnalyzing) ? null : _saveToShoppingList,
                  icon: const Icon(Icons.shopping_basket),
                  label: Text('買い物リストへ ($toBuyCount)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stoxPrimary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
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
