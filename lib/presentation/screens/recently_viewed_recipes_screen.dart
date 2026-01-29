import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../components/recipe_list_card.dart';
import '../viewmodels/recipe_book_viewmodel.dart';
import 'recipe_webview_screen.dart';

class RecentlyViewedRecipesScreen extends ConsumerWidget {
  const RecentlyViewedRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(recipeBookViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.stoxBorder)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.stoxText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '最近見たレシピ',
          style: TextStyle(
              color: AppColors.stoxText,
              fontSize: 18,
              fontWeight: FontWeight.normal),
        ),
      ),
      body: stateAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                '最近見たレシピはありません',
                style: TextStyle(color: AppColors.stoxSubText),
              ),
            );
          }

          // Sort by createdAt desc
          final sortedRecipes = recipes.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 24),
            itemCount: sortedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = sortedRecipes[index];
              
              String domain = '';
              try {
                final uri = Uri.parse(recipe.pageUrl);
                domain = uri.host;
              } catch (e) {
                // ignore invalid url
              }

              return RecipeListCard(
                title: recipe.title,
                imageUrl: recipe.ogpImageUrl,
                description: '${recipe.createdAt.month}/${recipe.createdAt.day} 追加',
                sourceInfo: domain,
                onTap: () {
                  if (recipe.pageUrl.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeWebViewScreen(
                          url: recipe.pageUrl,
                          title: recipe.title,
                          imageUrl: recipe.ogpImageUrl,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
