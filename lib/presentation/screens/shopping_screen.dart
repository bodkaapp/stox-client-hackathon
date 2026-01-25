import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../providers/shopping_mode_provider.dart';
import '../viewmodels/shopping_viewmodel.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShoppingMode = ref.watch(shoppingModeProvider);
    final stateAsync = ref.watch(shoppingViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: SafeArea(
        child: stateAsync.when(
          data: (state) {
            final allItems = [...state.toBuyList, ...state.inCartList];
            
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(ref, isShoppingMode)),
                SliverToBoxAdapter(child: _buildProgressBarSection(allItems)),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 80), // Space for FAB
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(_buildCategorizedItems(ref, allItems)),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
      floatingActionButton: isShoppingMode
          ? FloatingActionButton.extended(
              onPressed: () async {
                await ref.read(shoppingViewModelProvider.notifier).completeShoppingFlow();
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('お買い物を完了しました')));
                }
              },
              label: const Text('買い物を完了'),
              icon: const Icon(Icons.check),
              backgroundColor: AppColors.stoxPrimary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(WidgetRef ref, bool isShoppingMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.stoxPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_cart, color: AppColors.stoxPrimary, size: 22),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'お買い物',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                  ),
                  Text(
                    'SHOPPING LIST',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary, letterSpacing: 1.0),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              if (isShoppingMode) {
                ref.read(shoppingViewModelProvider.notifier).finishShopping();
              } else {
                ref.read(shoppingViewModelProvider.notifier).startShopping();
              }
            },
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isShoppingMode 
                    ? AppColors.stoxPrimary.withOpacity(0.1) 
                    : AppColors.stoxSubText.withOpacity(0.05),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isShoppingMode ? AppColors.stoxPrimary : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isShoppingMode ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: isShoppingMode ? AppColors.stoxPrimary : AppColors.stoxSubText,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isShoppingMode ? 'お買い物モード ON' : 'お買い物モード OFF',
                    style: TextStyle(
                      color: isShoppingMode ? AppColors.stoxPrimary : AppColors.stoxSubText,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarSection(List<Ingredient> items) {
    final inBasketCount = items.where((i) => i.status == IngredientStatus.inCart).length;
    final totalCount = items.length;
    final progress = totalCount > 0 ? inBasketCount / totalCount : 0.0;
    final remaining = totalCount - inBasketCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'カゴの進捗',
                style: TextStyle(
                  color: AppColors.stoxText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$inBasketCount',
                      style: const TextStyle(
                        color: AppColors.stoxPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' / $totalCount 点',
                      style: const TextStyle(
                        color: AppColors.stoxText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.stoxBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.stoxPrimary,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'あと$remaining点でお買い物完了です',
            style: const TextStyle(
              color: AppColors.stoxSubText,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.stoxBorder, thickness: 0.5),
        ],
      ),
    );
  }

  List<Widget> _buildCategorizedItems(WidgetRef ref, List<Ingredient> items) {
    final Map<String, List<Ingredient>> categorized = {};
    for (var item in items) {
      final cat = item.category.isNotEmpty ? item.category : '未分類';
      categorized.putIfAbsent(cat, () => []).add(item);
    }

    final List<Widget> widgets = [];
    categorized.forEach((category, catItems) {
      widgets.add(_buildCategorySection(ref, category, catItems));
    });

    // Spacer or Add button placeholder
    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: TextButton.icon(
            onPressed: null, // Disabled for now as per plan
            icon: const Icon(Icons.add, size: 16),
            label: const Text('リストに追加 (Coming Soon)'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.stoxPrimary.withOpacity(0.1),
              foregroundColor: AppColors.stoxPrimary,
              disabledForegroundColor: AppColors.stoxSubText.withOpacity(0.5),
              disabledBackgroundColor: AppColors.stoxBorder.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    return widgets;
  }

  Widget _buildCategorySection(WidgetRef ref, String title, List<Ingredient> items) {
    Color barColor;
    switch (title) {
      case '野菜・果物':
      case '野菜・フルーツ':
        barColor = Colors.green;
        break;
      case '肉・魚':
        barColor = Colors.redAccent;
        break;
      case '調味料':
        barColor = Colors.amber.shade700;
        break;
      default:
        barColor = AppColors.stoxPrimary;
    }

    final checkedCount = items.where((i) => i.status == IngredientStatus.inCart).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.stoxText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$checkedCount/${items.length} 点',
                style: const TextStyle(
                  color: AppColors.stoxSubText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: items.map((item) => _buildShoppingItemRow(ref, item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingItemRow(WidgetRef ref, Ingredient item) {
    final isChecked = item.status == IngredientStatus.inCart;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () {
          ref.read(shoppingViewModelProvider.notifier).toggleItemStatus(item);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    ref.read(shoppingViewModelProvider.notifier).toggleItemStatus(item);
                  },
                  activeColor: AppColors.stoxPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(color: AppColors.stoxBorder, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: isChecked ? AppColors.stoxText.withOpacity(0.5) : AppColors.stoxText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.stoxBackground,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.stoxBorder),
                ),
                child: Text(
                  '${item.amount}${item.unit}',
                  style: const TextStyle(
                    color: AppColors.stoxSubText,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
