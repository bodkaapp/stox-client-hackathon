import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../config/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../components/recipe_list_card.dart';
import '../viewmodels/recently_viewed_recipes_viewmodel.dart';
import 'recipe_webview_screen.dart';

class RecentlyViewedRecipesScreen extends ConsumerWidget {
  const RecentlyViewedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.stoxBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const Border(bottom: BorderSide(color: AppColors.stoxBorder)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.stoxText),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppLocalizations.of(context)!.titleHistory, // 履歴
            style: const TextStyle(
                color: AppColors.stoxText,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
          bottom: TabBar(
            labelColor: AppColors.stoxPrimary,
            unselectedLabelColor: AppColors.stoxText,
            indicatorColor: AppColors.stoxPrimary,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.tabRecentlyViewed), // 最近見たレシピ
              Tab(text: AppLocalizations.of(context)!.tabRecentlyAdded), // 最近登録したレシピ
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _RecipeList(type: _ListType.viewed),
            _RecipeList(type: _ListType.added),
          ],
        ),
      ),
    );
  }
}

enum _ListType { viewed, added }

class _RecipeList extends ConsumerWidget {
  final _ListType type;
  const _RecipeList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = type == _ListType.viewed 
        ? recentlyViewedRecipesProvider 
        : recentlyAddedRecipesProvider;
    
    final asyncValue = ref.watch(provider);
    
    return asyncValue.when(
      skipLoadingOnReload: true,
      data: (recipes) {
        if (recipes.isEmpty) {
          return Center(
            child: Text(
              type == _ListType.viewed ? AppLocalizations.of(context)!.noRecentlyViewedRecipes : AppLocalizations.of(context)!.noRecentlyAddedRecipes, // 最近見たレシピはありません : 登録されたレシピはありません
              style: const TextStyle(color: AppColors.stoxSubText),
            ),
          );
        }

        final isLoadingMore = asyncValue.isLoading;
        
        // Grouping Logic
        final groupedItems = <dynamic>[]; // String (header) or Recipe (item)
        String? lastDateStr;

        for (final recipe in recipes) {
          final date = type == _ListType.viewed 
              ? (recipe.lastViewedAt ?? DateTime.now()) 
              : recipe.createdAt;
          final dateStr = '${date.year}/${date.month}/${date.day}';

          if (lastDateStr != dateStr) {
             // Create Header
             // Format: "YYYY年MM月DD日" or "MM/DD"? Photo gallery creates sections.
             // User said: "日付ごとにグループ化... 見た日付と登録した日付を認識したい"
             // Simple header like "2024/02/05"
             groupedItems.add(dateStr); 
             lastDateStr = dateStr;
          }
          groupedItems.add(recipe);
        }
        
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
             if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200 &&
                 !isLoadingMore) {
                final notifier = type == _ListType.viewed 
                  ? ref.read(recentlyViewedRecipesProvider.notifier)
                  : ref.read(recentlyAddedRecipesProvider.notifier);
                  
                if (type == _ListType.viewed) {
                   if (ref.read(recentlyViewedRecipesProvider.notifier).hasMore) {
                      Future.microtask(() => ref.read(recentlyViewedRecipesProvider.notifier).loadMore());
                   }
                } else {
                   if (ref.read(recentlyAddedRecipesProvider.notifier).hasMore) {
                      Future.microtask(() => ref.read(recentlyAddedRecipesProvider.notifier).loadMore());
                   }
                }
             }
             return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24),
            itemCount: groupedItems.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == groupedItems.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = groupedItems[index];

              if (item is String) {
                // Header
                // Parse back to DateTime for better formatting if needed, or just display
                // "2026/02/05" -> "2026年2月5日"
                final parts = item.split('/').map(int.parse).toList();
                final dateLabel = AppLocalizations.of(context)!.dateYMD(parts[0], parts[1], parts[2]); // ${parts[0]}年${parts[1]}月${parts[2]}日
                
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.stoxText,
                    ),
                  ),
                );
              } else if (item is Recipe) {
                 // Recipe Item
                 final recipe = item;
                 String domain = '';
                 try {
                   final uri = Uri.parse(recipe.pageUrl);
                   domain = uri.host;
                 } catch (e) { /* ignore */ }

                 // Don't need date label inside the card anymore?
                 // User: "見た日付と登録した日付を認識したい"
                 // Header already shows date. Maybe show time inside card?
                 // Or keep simple. Let's keep card minimal as header handles date.
                 
                 String description = '';
                 if (type == _ListType.viewed && recipe.lastViewedAt != null) {
                    final t = recipe.lastViewedAt!;
                    description = '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
                 } 
                 
                 return RecipeListCard(
                    title: recipe.title,
                    imageUrl: recipe.ogpImageUrl,
                    description: description, // Show time if viewed
                    sourceInfo: domain,
                    onTap: () {
                      if (recipe.pageUrl.isNotEmpty) {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => RecipeWebViewScreen(
                              url: recipe.pageUrl,
                              title: recipe.title,
                              imageUrl: recipe.ogpImageUrl,
                              existingRecipeId: recipe.id,
                            ),
                          ),
                        );
                      }
                    },
                  );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
