import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';
import '../viewmodels/shopping_viewmodel.dart';
import '../../domain/models/challenge_stamp.dart'; // [NEW]
import '../viewmodels/challenge_stamp_viewmodel.dart'; // [NEW]

class ShoppingReceiptResultScreen extends ConsumerStatefulWidget {
  final List<Ingredient> receiptItems;
  final List<Ingredient> currentShoppingList;

  const ShoppingReceiptResultScreen({
    super.key,
    required this.receiptItems,
    required this.currentShoppingList,
  });

  @override
  ConsumerState<ShoppingReceiptResultScreen> createState() => _ShoppingReceiptResultScreenState();
}

class _ShoppingReceiptResultScreenState extends ConsumerState<ShoppingReceiptResultScreen> {
  // Sets to track checked items in each section
  final Set<String> _matchedItemsToCheck = {}; // Items in both receipt and list -> default checked (to be stock)
  final Set<String> _newItemsToCheck = {};     // Items in receipt only -> default checked (to be added to stock)
  final Set<String> _ignoredItemsToCheck = {}; // Items in list only -> default unchecked (stay in list)

  late List<Ingredient> _matchedItems;
  late List<Ingredient> _newDetailItems;
  late List<Ingredient> _unpurchasedItems;
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _categorizeItems();
  }

  void _categorizeItems() {
    _matchedItems = [];
    _newDetailItems = [];
    _unpurchasedItems = [];

    // Create a mutable copy of receipt items to track what's been matched
    final List<Ingredient> remainingReceiptItems = List.from(widget.receiptItems);

    for (final shoppingItem in widget.currentShoppingList) {
      // Simple matching logic: check if name contains or is contained by receipt item name
      // This is a basic approach. 
      int matchIndex = -1;
      for (int i = 0; i < remainingReceiptItems.length; i++) {
        final receiptItem = remainingReceiptItems[i];
        if (_isMatch(shoppingItem.name, receiptItem.name)) {
          matchIndex = i;
          break;
        }
      }

      if (matchIndex != -1) {
        // Match found
        final receiptItem = remainingReceiptItems.removeAt(matchIndex);
        // Use shopping item as base but maybe update amount from receipt? 
        // For now, let's keep shopping item ID to easily update it, but update status to stock later.
        _matchedItems.add(shoppingItem.copyWith(status: IngredientStatus.stock));
        _matchedItemsToCheck.add(shoppingItem.id);
      } else {
        // No match in receipt -> Unpurchased
        _unpurchasedItems.add(shoppingItem);
      }
    }

    // Remaining receipt items are new
    _newDetailItems = remainingReceiptItems;
    for (final item in _newDetailItems) {
      _newItemsToCheck.add(item.id);
    }
  }

  // Basic string matching
  bool _isMatch(String a, String b) {
    final normA = a.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    final normB = b.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return normA.contains(normB) || normB.contains(normA);
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final ingredientRepo = await ref.read(ingredientRepositoryProvider.future);

      // 1. Matched Items: Update status to Stock if checked
      for (final item in _matchedItems) {
        if (_matchedItemsToCheck.contains(item.id)) {
           await ingredientRepo.save(item.copyWith(status: IngredientStatus.stock));
        } else {
           // If unchecked, maybe keep as toBuy? Or do nothing? 
           // If it's a "matched" item but user unchecked "Stock", it implies they didn't buy it or it wasn't that item.
           // However based on UI "在庫にする", if unchecked, it stays in shopping list (toBuy).
           // Since we haven't changed the original item in DB yet, doing nothing keeps it as toBuy.
        }
      }

      // 2. New Items: Add to Stock if checked
      for (final item in _newDetailItems) {
         if (_newItemsToCheck.contains(item.id)) {
           await ingredientRepo.save(item.copyWith(status: IngredientStatus.stock));
         }
      }

      // 3. Unpurchased Items: 
      // If checked "在庫にする" (maybe user bought it but receipt missed it), update to Stock.
      // If unchecked, stay in list (toBuy).
      for (final item in _unpurchasedItems) {
        if (_ignoredItemsToCheck.contains(item.id)) {
          await ingredientRepo.save(item.copyWith(status: IngredientStatus.stock));
        }
      }

      // 4. Force refresh shopping list provider
      ref.invalidate(shoppingViewModelProvider);
      
      // [NEW] Challenge 6: Scan Receipt
      await ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.scanReceipt.id);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('在庫を更新しました')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('保存に失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receiptItems.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.stoxBackground,
        appBar: AppBar(title: const Text('レシート解析結果'), centerTitle: true),
        body: SafeArea(
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.warning_amber_rounded, size: 48, color: AppColors.stoxSubText),
                       SizedBox(height: 16),
                       Text('商品が見つかりませんでした。', style: TextStyle(color: AppColors.stoxSubText, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'retake'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stoxPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('もう一回撮影する', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(title: const Text('レシート解析結果'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSection(
                    title: '在庫にする',
                    description: 'レシートと買物リストの両方にありました。\n在庫に登録します。',
                    items: _matchedItems,
                    checkedSet: _matchedItemsToCheck,
                    icon: Icons.check_circle,
                    iconColor: AppColors.stoxPrimary,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: '新規に追加',
                    description: '買物リストにありませんでした。\n在庫に追加しますか？',
                    items: _newDetailItems,
                    checkedSet: _newItemsToCheck,
                    icon: Icons.add_circle,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: '未購入',
                    description: 'レシートにありませんでした。\n買い忘れていませんか？',
                    items: _unpurchasedItems,
                    checkedSet: _ignoredItemsToCheck,
                    icon: Icons.help,
                    iconColor: Colors.grey,
                    isUnpurchased: true,
                  ),
                ],
              ),
            ),
            _buildFooter(),
            if (_isSaving) 
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Ingredient> items,
    required Set<String> checkedSet,
    required IconData icon,
    required Color iconColor,
    bool isUnpurchased = false,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, bottom: 8),
          child: Text(description, style: const TextStyle(fontSize: 12, color: AppColors.stoxSubText)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.stoxBorder),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              final isChecked = checkedSet.contains(item.id);

              return Column(
                children: [
                  CheckboxListTile(
                    value: isChecked,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          checkedSet.add(item.id);
                        } else {
                          checkedSet.remove(item.id);
                        }
                      });
                    },
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.amount}${item.unit}'),
                    activeColor: AppColors.stoxPrimary,
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: isUnpurchased 
                        ? (isChecked ? const Text('在庫にする', style: TextStyle(fontSize: 10, color: AppColors.stoxPrimary)) : const Text('リストに残す', style: TextStyle(fontSize: 10, color: Colors.grey)))
                        : null,
                  ),
                  if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stoxPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('完了', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
