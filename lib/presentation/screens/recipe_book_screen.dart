import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../viewmodels/recipe_book_viewmodel.dart';

class RecipeBookScreen extends ConsumerWidget {
  const RecipeBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Used for potential data binding later
    final stateAsync = ref.watch(recipeBookViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA), // bg-cream
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header & Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'マイレシピ帳',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF292524), // text-stone-800
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.settings, color: Color(0xFF57534E)), // text-stone-600
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent, 
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF7ED), // bg-orange-50
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // Add recipe logic
                                  ref.read(recipeBookViewModelProvider.notifier).addSampleRecipe();
                                },
                                icon: const Icon(Icons.add, color: Color(0xFFEA580C)), // text-orange-600
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F4), // bg-stone-100
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'レシピを検索またはURLを入力',
                          hintStyle: const TextStyle(color: Color(0xFF78716C), fontSize: 14), // text-stone-500
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFA8A29E)), // text-stone-400
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Today's Menu Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppColors.stoxPrimary, size: 20),
                            SizedBox(width: 6),
                            Text(
                              '今日の献立',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFD97706), // amber-600
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          child: const Row(
                            children: [
                              Text('編集する'),
                              Icon(Icons.chevron_right, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  // Main Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.stoxBorder), // border-orange-100 -> stoxBorder
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 224, // h-56
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.network(
                                    'https://via.placeholder.com/300?text=Main',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                ),
                                const SizedBox(width: 2), // gap-0.5 approx
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          'https://via.placeholder.com/300?text=Side1',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Expanded(
                                        child: Image.network(
                                          'https://via.placeholder.com/300?text=Side2',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '10月24日 (木)',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '特製カツ丼・無限キャベツ・ぶり大根',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF292524), height: 1.25),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7), // bg-amber-100
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('3品', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategoryItem('主菜', Icons.restaurant, const Color(0xFFFFEDD5), const Color(0xFFEA580C)),
                    const SizedBox(width: 12),
                    _buildCategoryItem('副菜', Icons.eco, const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
                    const SizedBox(width: 12),
                    _buildCategoryItem('時短', Icons.timer, const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
                    const SizedBox(width: 12),
                    _buildCategoryItem('おつまみ', Icons.liquor, const Color(0xFFFAF5FF), const Color(0xFF9333EA)),
                    const SizedBox(width: 12),
                    _buildCategoryItem('お気に入り', Icons.favorite, const Color(0xFFF5F5F4), const Color(0xFF78716C)),
                    const SizedBox(width: 12),
                    _buildCategoryItem('その他', Icons.more_horiz, const Color(0xFFF5F5F4), const Color(0xFF78716C)),
                  ],
                ),
              ),
            ),

            // Past Menus Section
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history, color: Color(0xFFA8A29E), size: 20),
                          SizedBox(width: 6),
                          Text(
                            '過去の献立',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'すべて見る',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Mock Items
                  _buildHistoryItem('Oct', '23', '豚肉の生姜焼き・ほうれん草のナムル'),
                  const SizedBox(height: 12),
                  _buildHistoryItem('Oct', '22', '秋鮭のホイル焼き・きんぴらごぼう'),
                  const SizedBox(height: 12),
                  _buildHistoryItem('Oct', '21', 'カレーライス・ポテトサラダ'),
                ]),
              ),
            ),
             const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String label, IconData icon, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF292524)),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String month, String day, String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stoxBorder),
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.stoxBorder)),
            ),
            child: Column(
              children: [
                Text(month, style: const TextStyle(fontSize: 10,  color: Color(0xFF78716C))),
                Text(day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                       decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, size: 16, color: Color(0xFFD6D3D1)),
                    ),
                     const SizedBox(width: 6),
                     Container(
                      width: 40,
                      height: 40,
                       decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, size: 16, color: Color(0xFFD6D3D1)),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFD6D3D1)),
        ],
      ),
    );
  }
}
