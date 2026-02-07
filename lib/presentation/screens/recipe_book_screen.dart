import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../viewmodels/recipe_book_viewmodel.dart';
import 'recipe_webview_screen.dart';
import 'menu_plan_screen.dart';
import '../widgets/search_modal.dart';
import 'recently_viewed_recipes_screen.dart';
import 'cooking_mode_screen.dart';
import 'recipe_search_results_screen.dart';
import '../../domain/models/recipe.dart';
import 'dart:io';

import '../widgets/help_icon.dart';
import '../../domain/models/challenge_stamp.dart';
import '../viewmodels/challenge_stamp_viewmodel.dart';
import '../../l10n/generated/app_localizations.dart';

class RecipeBookScreen extends ConsumerStatefulWidget {
  const RecipeBookScreen({super.key});

  @override
  ConsumerState<RecipeBookScreen> createState() => _RecipeBookScreenState();
}

class _RecipeBookScreenState extends ConsumerState<RecipeBookScreen> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey<TooltipState> _cookNowTooltipKey = GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _sheetController.animateTo(
          0.9,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Used for potential data binding later
    final stateAsync = ref.watch(recipeBookViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.stoxBackground, // bg-white
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return _buildTabletLayout(context, ref, stateAsync);
                }
                return _buildMobileLayout(context, ref, stateAsync);
              },
            ),
            _buildSearchBottomSheet(context),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSearchIntent(SearchIntent intent) async {
    if (intent is UrlSearchIntent) {
      if (mounted) {
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => RecipeWebViewScreen(
              url: intent.url,
              title: AppLocalizations.of(context)!.menuLoading, // 読み込み中...
            ),
          ),
        );
      }
    } else if (intent is TextSearchIntent) {
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeSearchResultsScreen(
              searchQuery: intent.query,
            ),
          ),
        );
      }
    }
    
    // [NEW] Challenge 3: Search Recipe
    ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.searchRecipe.id);
  }

  Widget _buildSearchBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.9,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDFA),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7E5E4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      _sheetController.animateTo(
                        0.9,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: SearchModal(
                    showHeader: false,
                    scrollController: scrollController,
                    focusNode: _searchFocusNode,
                    onIntent: _handleSearchIntent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              _buildHeaderAndSearch(context, ref),
              _buildTodaysMenuSection(context, ref),
              _buildCategoriesSection(context),
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
                      Row(
                        children: [
                          Icon(Icons.calendar_month, color: Color(0xFFA8A29E), size: 20),

                          SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!.recipePastMenus, // 過去の献立
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
                        child: Text(
                          AppLocalizations.of(context)!.recipeViewAll, // すべて見る
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
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(AppLocalizations.of(context)!.recipeNoPastMenus, style: TextStyle(color: Color(0xFF78716C))), // 過去の献立はありません
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
                                  child: _buildHistoryItem(
                                    month, 
                                    day, 
                                    title, 
                                    menu.photos,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MenuPlanScreen(initialDate: menu.date),
                                        ),
                                      );
                                    },
                                  ),
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
        _buildHeaderAndSearch(context, ref),
        _buildTodaysMenuSection(context, ref),
        _buildCategoriesSection(context),
        ..._buildRecentlyViewedSection(context, stateAsync),
        _buildPastMenusSection(context, ref),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  // --- Components ---

  Widget _buildHeaderAndSearch(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
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
                      children: [
                        Text(
                          AppLocalizations.of(context)!.recipeBookTitle,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                        ),
                        const Text(
                          'RECIPE BOOK',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxAccent, letterSpacing: 1.0),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    HelpIcon(
                      title: AppLocalizations.of(context)!.recipeBookHelpTitle,
                      description: AppLocalizations.of(context)!.recipeBookHelpDescription,
                    ),
                  ],
                ),
              ],
            ),
            // Padding reduced and SizedBox removed to eliminate excess space
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
                // '月', '火', '水', '木', '金', '土', '日'
                final dateStr = DateFormat.MMMEd(Localizations.localeOf(context).toString()).format(now); // ${now.month}月${now.day}日 ($weekDayStr)


                return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppColors.stoxPrimary, size: 20),
                            SizedBox(width: 6),
                            Text(
                            AppLocalizations.of(context)!.recipeTodaysMenu, // 今日の献立
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                            ),
                          ],
                        ),
                        if (recipes.isNotEmpty)
                          Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  final hasUrl = recipes.any((r) => r.pageUrl.isNotEmpty);
                                  
                                  return Tooltip(
                                    key: _cookNowTooltipKey,
                                    message: AppLocalizations.of(context)!.recipeCookManualOnlyError,
                                    triggerMode: TooltipTriggerMode.manual,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (hasUrl) {
                                          Navigator.of(context, rootNavigator: true).push(
                                            MaterialPageRoute(
                                              builder: (context) => CookingModeScreen(recipes: recipes),
                                            ),
                                          );
                                        } else {
                                          _cookNowTooltipKey.currentState?.ensureTooltipVisible();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hasUrl ? AppColors.stoxPrimary : const Color(0xFFE7E5E4), // stone-200 for grey
                                        foregroundColor: hasUrl ? Colors.white : const Color(0xFF78716C), // stone-500 for text
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.restaurant_menu, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            AppLocalizations.of(context)!.recipeCookNow,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                                Text(
                                  AppLocalizations.of(context)!.recipeNoTodaysMenu, // まだ今日の献立がありません
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.recipeAdd, // 追加する
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
                              child: _buildDynamicImageGrid(recipes),
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
                                        child: Text(AppLocalizations.of(context)!.recipeItemsCount(count), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309))), // $count品
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

  Widget _buildDynamicImageGrid(List<Recipe> recipes) {
    if (recipes.isEmpty) return const SizedBox.shrink();

    Widget buildImage(Recipe r) {
      return Container(
        color: AppColors.stoxBannerBg,
        width: double.infinity,
        height: double.infinity,
        child: (r.ogpImageUrl.isNotEmpty)
            ? Image.network(
                r.ogpImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: AppColors.stoxPrimary),
              )
            : const Center(child: Icon(Icons.restaurant, color: AppColors.stoxPrimary, size: 40)),
      );
    }

    // Common spacer
    const space = SizedBox(width: 2, height: 2);

    // Case 1: Single image
    if (recipes.length == 1) {
      return SizedBox(
        height: 224,
        child: buildImage(recipes[0]),
      );
    }

    // Case 2: Two images side-by-side
    if (recipes.length == 2) {
      return SizedBox(
        height: 224, // h-56
        child: Row(
          children: [
            Expanded(child: buildImage(recipes[0])),
            space,
            Expanded(child: buildImage(recipes[1])),
          ],
        ),
      );
    }

    // Case 3: 1 large on left, 2 small on right (1:2 split)
    if (recipes.length == 3) {
      return SizedBox(
        height: 224,
        child: Row(
          children: [
            Expanded(child: buildImage(recipes[0])),
            space,
            Expanded(
              child: Column(
                children: [
                  Expanded(child: buildImage(recipes[1])),
                  space,
                  Expanded(child: buildImage(recipes[2])),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Case 4+: 2x2 Grid (Top 4 recipes)
    // We utilize the first 4 recipes.
    return SizedBox(
      height: 224,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: buildImage(recipes[0])),
                space,
                Expanded(child: buildImage(recipes[1])),
              ],
            ),
          ),
          space,
          Expanded(
            child: Row(
              children: [
                Expanded(child: buildImage(recipes[2])),
                space,
                Expanded(child: buildImage(recipes[3])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _buildCategoryItem(AppLocalizations.of(context)!.recipeCategoryMain, Icons.restaurant, AppColors.stoxBannerBg, AppColors.stoxPrimary), // 主菜
            const SizedBox(width: 12),
            _buildCategoryItem(AppLocalizations.of(context)!.recipeCategorySide, Icons.eco, const Color(0xFFF0FDF4), const Color(0xFF16A34A)), // 副菜
            const SizedBox(width: 12),
            _buildCategoryItem(AppLocalizations.of(context)!.recipeCategoryQuick, Icons.timer, const Color(0xFFEFF6FF), const Color(0xFF2563EB)), // 時短
            const SizedBox(width: 12),
            _buildCategoryItem(AppLocalizations.of(context)!.recipeCategorySnack, Icons.liquor, const Color(0xFFFAF5FF), const Color(0xFF9333EA)), // おつまみ
            const SizedBox(width: 12),
            _buildCategoryItem(AppLocalizations.of(context)!.recipeCategoryFavorite, Icons.favorite, const Color(0xFFF5F5F4), const Color(0xFF78716C)), // お気に入り
            const SizedBox(width: 12),
            _buildCategoryItem(AppLocalizations.of(context)!.recipeCategoryOther, Icons.more_horiz, const Color(0xFFF5F5F4), const Color(0xFF78716C)), // その他
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
                  Row(
                    children: [
                      Icon(Icons.history, color: AppColors.stoxPrimary, size: 20),
                      SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.recipeRecentlyViewed, // 最近見たレシピ
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
                    child: Text(
                      AppLocalizations.of(context)!.recipeViewAll, // すべて見る
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
              Row(
                children: [
                  Icon(Icons.calendar_month, color: Color(0xFFA8A29E), size: 20),
                  SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.recipePastMenus, // 過去の献立
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
                child: Text(
                  AppLocalizations.of(context)!.recipeViewAll, // すべて見る
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
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(AppLocalizations.of(context)!.recipeNoPastMenus, style: TextStyle(color: Color(0xFF78716C))), // 過去の献立はありません
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
                        child: _buildHistoryItem(
                          month, 
                          day, 
                          title, 
                          menu.photos,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuPlanScreen(initialDate: menu.date),
                              ),
                            );
                          },
                        ),
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

  Widget _buildHistoryItem(String month, String day, String title, List<String> photos, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
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
                      for (int i = 0; i < 2; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: (i < photos.length)
                              ? Image.file(
                                  File(photos[i]), 
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 16, color: Color(0xFFD6D3D1)),
                                )
                              : const Icon(Icons.image, size: 16, color: Color(0xFFD6D3D1)),
                        ),
                      ],
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

  Widget _buildRecentRecipeItem(BuildContext context, dynamic recipe) { 
    return GestureDetector(
      onTap: () {
        if (recipe.pageUrl.isNotEmpty) {
           Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => RecipeWebViewScreen(
                url: recipe.pageUrl, 
                title: recipe.title, 
                imageUrl: recipe.ogpImageUrl,
                existingRecipeId: recipe.id,
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
                color: AppColors.stoxBannerBg,
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
                          AppLocalizations.of(context)!.recipeAddedDate(DateFormat('M/d').format(recipe.createdAt)), // ${recipe.createdAt.month}/${recipe.createdAt.day} 追加
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


