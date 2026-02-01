import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';

class AiAnalyzedStockScreen extends ConsumerStatefulWidget {
  final List<Ingredient> initialIngredients;
  final String location;
  final Uint8List? imageBytes;

  const AiAnalyzedStockScreen({
    super.key,
    required this.initialIngredients,
    required this.location,
    this.imageBytes,
  });

  @override
  ConsumerState<AiAnalyzedStockScreen> createState() => _AiAnalyzedStockScreenState();
}

class _StockCandidate {
  final Ingredient ingredient;
  final bool isExcluded;

  _StockCandidate({required this.ingredient, this.isExcluded = false});

  _StockCandidate copyWith({Ingredient? ingredient, bool? isExcluded}) {
    return _StockCandidate(
      ingredient: ingredient ?? this.ingredient,
      isExcluded: isExcluded ?? this.isExcluded,
    );
  }
}



class _AiAnalyzedStockScreenState extends ConsumerState<AiAnalyzedStockScreen> {
  late List<_StockCandidate> _ingredients;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _ingredients = widget.initialIngredients
        .map((i) => _StockCandidate(ingredient: i))
        .toList();
  }

  Future<void> _saveToStock() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);

      final ingredientsToSave = _ingredients
          .where((item) => !item.isExcluded)
          .map((item) => item.ingredient)
          .toList();

      for (final ingredient in ingredientsToSave) {
        // Ensure status is stock and id is unique
        await ingredientRepo.save(ingredient.copyWith(
          id: DateTime.now().microsecondsSinceEpoch.toString() + ingredient.name,
          status: IngredientStatus.stock,
        ));
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ingredientsToSave.length}件の在庫を追加しました！')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存に失敗しました。')),
        );
      }
    }
  }

  void _toggleExclusion(int index) {
    setState(() {
      final current = _ingredients[index];
      _ingredients[index] = current.copyWith(isExcluded: !current.isExcluded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(title: const Text('解析結果'), centerTitle: true),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _ingredients.isEmpty
                      ? const Center(child: Text('商品が見つかりませんでした'))
                      : ListView.separated(
                          itemCount: _ingredients.length,
                          separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0E7DE)),
                          itemBuilder: (context, index) {
                            final item = _ingredients[index];
                            return _buildIngredientRow(index, item);
                          },
                        ),
                ),
                _buildFooter(),
              ],
            ),
             if (_isSaving) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.stoxBackground.withValues(alpha: 0.95),
        border: const Border(bottom: BorderSide(color: Color(0xFFFFEBD5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.imageBytes != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  widget.imageBytes!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '撮影場所: ${widget.location}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                ),
                const SizedBox(height: 4),
                const Text(
                  '以下の商品が見つかりました',
                  style: TextStyle(fontSize: 12, color: AppColors.stoxSubText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(int index, _StockCandidate item) {
    final ingredient = item.ingredient;
    final isExcluded = item.isExcluded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isExcluded ? Colors.grey.shade100 : Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: isExcluded ? 0.4 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: TextStyle(
                      color: AppColors.stoxText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: isExcluded ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    '${ingredient.amount}${ingredient.unit} / ${ingredient.category}',
                    style: const TextStyle(
                      color: AppColors.stoxSubText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isExcluded ? Icons.restore_from_trash : Icons.delete_outline,
              color: isExcluded ? Colors.green : Colors.grey,
            ),
            tooltip: isExcluded ? '元に戻す' : '除外する',
            onPressed: () => _toggleExclusion(index),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final activeCount = _ingredients.where((i) => !i.isExcluded).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: activeCount == 0 ? null : _saveToStock,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stoxPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                '在庫に追加する ($activeCount件)',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('やっぱり辞めた', style: TextStyle(color: AppColors.stoxSubText)),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black26,
      child: const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
    );
  }

}
