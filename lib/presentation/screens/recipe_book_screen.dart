import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../viewmodels/recipe_book_viewmodel.dart';
import 'recipe_webview_screen.dart';
import 'menu_plan_screen.dart';
import '../widgets/search_modal.dart';
import 'recently_viewed_recipes_screen.dart';
import 'cooking_mode_screen.dart';
import '../../domain/models/recipe.dart';

class RecipeBookScreen extends ConsumerWidget {
  const RecipeBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Used for potential data binding later
    final stateAsync = ref.watch(recipeBookViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA), // bg-cream
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return _buildTabletLayout(context, ref, stateAsync);
            }
            return _buildMobileLayout(context, ref, stateAsync);
          },
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, AsyncValue<List<Recipe>> stateAsync) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Main Content
        Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              _buildHeaderAndSearch(context),
              _buildTodaysMenuSection(context, ref),
              _buildCategoriesSection(),
              ..._buildRecentlyViewedSection(context, stateAsync),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        ),
        
        // Right Column: Past Menus
        Expanded(
          flex: 2,
          child: Container(
             decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(left: BorderSide(color: AppColors.stoxBorder)),
             ),
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(20),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.calendar_month, color: Color(0xFFA8A29E), size: 20),

                          SizedBox(width: 6),
                          Text(
                            '過去の献立',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuPlanScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'すべて見る',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
                        ),
                      ),
                    ],
                  ),
                 ),
                 Expanded(
                   child: Consumer(
                      builder: (context, ref, child) {
                        final pastMenusAsync = ref.watch(pastMenusProvider);

                        return pastMenusAsync.when(
                          data: (dailyMenus) {
                            if (dailyMenus.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text('過去の献立はありません', style: TextStyle(color: Color(0xFF78716C))),
                                ),
                              );
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: dailyMenus.length,
                              itemBuilder: (context, index) {
                                final menu = dailyMenus[index];
                                // Format date M/D
                                final month = menu.date.month.toString();
                                final day = menu.date.day.toString();
                                // Join recipe titles
                                final title = menu.recipes.map((r) => r.title).join('・');
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildHistoryItem(month, day, title),
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                          error: (err, stack) => Center(child: Text('Error: $err')),
                        );
                      }
                    ),
                 ),
               ],
             ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, AsyncValue<List<Recipe>> stateAsync) {
    return CustomScrollView(
      slivers: [
        _buildHeaderAndSearch(context),
        _buildTodaysMenuSection(context, ref),
        _buildCategoriesSection(),
        ..._buildRecentlyViewedSection(context, stateAsync),
        _buildPastMenusSection(context, ref),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  // --- Components ---

  Widget _buildHeaderAndSearch(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
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
                      child: const Icon(Icons.menu_book, color: AppColors.stoxPrimary, size: 22),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'マイレシピ帳',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                        ),
                        Text(
                          'RECIPE BOOK',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary, letterSpacing: 1.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Bar
            TextField(
              readOnly: true,
              onTap: () {
                SearchModal.show(context);
              },
              decoration: InputDecoration(
                hintText: 'レシピを検索またはURLを入力',
                hintStyle: const TextStyle(color: Color(0xFF78716C), fontSize: 14), // text-stone-500
                prefixIcon: const Icon(Icons.search, color: Color(0xFFA8A29E)), // text-stone-400
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD6D3D1)), // stone-300
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD6D3D1)), // stone-300
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFD6D3D1)), // stone-300
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysMenuSection(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Consumer(
        builder: (context, ref, child) {
          final todaysMenuAsync = ref.watch(todaysMenuProvider);
          
          return todaysMenuAsync.when(
            data: (recipes) {
                final now = DateTime.now();
                final weekDays = ['月', '火', '水', '木', '金', '土', '日'];
                final weekDayStr = weekDays[now.weekday - 1];
                final dateStr = '${now.month}月${now.day}日 ($weekDayStr)';

                return Padding(
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
                        if (recipes.isNotEmpty)
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFD97706), // amber-600
                                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Row(
                                  children: [
                                    Text('編集する'),
                                    Icon(Icons.chevron_right, size: 16),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                      builder: (context) => CookingModeScreen(recipes: recipes),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.stoxPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.restaurant_menu, size: 16),
                                    SizedBox(width: 4),
                                    Text('今すぐ作る', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (recipes.isEmpty)
                      GestureDetector(
                        onTap: () {
                          // Navigate to MenuPlanScreen or add logic
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuPlanScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F4), // bg-stone-100
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.stoxBorder, style: BorderStyle.none), // specific request for gray area, maybe no border or subtle
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_circle_outline, color: Color(0xFFA8A29E), size: 32),
                              const SizedBox(height: 8),
                              const Text(
                                'まだ今日の献立がありません',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '追加する',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      Builder(
                        builder: (context) {
                          final title = recipes.map((r) => r.title).join('・');
                          final count = recipes.length;
                          return Container(
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
                                        child: Container(
                                          color: const Color(0xFFFFF7ED),
                                          child: (recipes.isNotEmpty && recipes[0].ogpImageUrl != null && recipes[0].ogpImageUrl!.isNotEmpty)
                                            ? Image.network(recipes[0].ogpImageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image, color: AppColors.stoxPrimary))
                                            : const Center(child: Icon(Icons.restaurant, color: AppColors.stoxPrimary, size: 40)),
                                        ),
                                      ),
                                      const SizedBox(width: 2), // gap-0.5 approx
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: const Color(0xFFFFF7ED),
                                                  child: (recipes.length > 1 && recipes[1].ogpImageUrl != null && recipes[1].ogpImageUrl!.isNotEmpty)
                                                    ? Image.network(recipes[1].ogpImageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image, color: AppColors.stoxPrimary))
                                                    : Center(child: Icon(Icons.restaurant, size: 24, color: AppColors.stoxPrimary.withOpacity(0.5))),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Expanded(
                                              child: Container(
                                                color: const Color(0xFFFFF7ED),
                                                  child: (recipes.length > 2 && recipes[2].ogpImageUrl != null && recipes[2].ogpImageUrl!.isNotEmpty)
                                                    ? Image.network(recipes[2].ogpImageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image, color: AppColors.stoxPrimary))
                                                    : Center(child: Icon(Icons.restaurant, size: 24, color: AppColors.stoxPrimary.withOpacity(0.5))),
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dateStr,
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              title,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF292524), height: 1.25),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7), // bg-amber-100
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text('$count品', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ]
                  ],
                ),
              );
            },
            loading: () => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => Padding(padding: const EdgeInsets.all(20), child: Text('Error: $err')),
          );
        }
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
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
    );
  }

  List<Widget> _buildRecentlyViewedSection(BuildContext context, AsyncValue<List<Recipe>> stateAsync) {
    if (!stateAsync.hasValue || stateAsync.value!.isEmpty) {
      return [const SliverToBoxAdapter(child: SizedBox.shrink())];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.history, color: AppColors.stoxPrimary, size: 20),
                      SizedBox(width: 6),
                      Text(
                        '最近見たレシピ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecentlyViewedRecipesScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'すべて見る',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final recipes = stateAsync.value!;
              // Sort by createdAt desc
              final sortedRecipes = recipes.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              final recipe = sortedRecipes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRecentRecipeItem(context, recipe),
              );
            },
            childCount: (stateAsync.value!.length > 3) ? 3 : stateAsync.value!.length,
          ),
        ),
      ),
    ];
  }

  Widget _buildPastMenusSection(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month, color: Color(0xFFA8A29E), size: 20),
                  SizedBox(width: 6),
                  Text(
                    '過去の献立',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuPlanScreen(),
                    ),
                  );
                },
                child: const Text(
                  'すべて見る',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              final pastMenusAsync = ref.watch(pastMenusProvider);

              return pastMenusAsync.when(
                data: (dailyMenus) {
                  if (dailyMenus.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('過去の献立はありません', style: TextStyle(color: Color(0xFF78716C))),
                      ),
                    );
                  }
                  return Column(
                    children: dailyMenus.map((menu) {
                      // Format date M/D
                      final month = menu.date.month.toString();
                      final day = menu.date.day.toString();
                      // Join recipe titles
                      final title = menu.recipes.map((r) => r.title).join('・');
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildHistoryItem(month, day, title),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                error: (err, stack) => Center(child: Text('Error: $err')),
              );
            }
          ),
        ]),
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

  Widget _buildRecentRecipeItem(BuildContext context, dynamic recipe) { 
    return GestureDetector(
      onTap: () {
        if (recipe.pageUrl.isNotEmpty) {
           Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => RecipeWebViewScreen(
                url: recipe.pageUrl, 
                title: recipe.title, 
                imageUrl: recipe.ogpImageUrl
              )
            )
           );
        }
      },
      child: Container(
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
             ClipRRect(
               borderRadius: BorderRadius.circular(8),
               child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFFFFF7ED),
                child: (recipe.ogpImageUrl != null && recipe.ogpImageUrl!.isNotEmpty)
                  ? Image.network(recipe.ogpImageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image, color: AppColors.stoxPrimary))
                  : const Icon(Icons.restaurant, color: AppColors.stoxPrimary),
              ),
             ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (recipe.createdAt != null)
                        Text(
                          '${recipe.createdAt.month}/${recipe.createdAt.day} 追加',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF78716C)),
                        ),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD6D3D1)),
          ],
        ),
      ),
    );
  }
}


