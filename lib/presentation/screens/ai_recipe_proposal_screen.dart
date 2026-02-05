import 'package:flutter/material.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_search_results_screen.dart';
import '../../l10n/generated/app_localizations.dart';

class AiRecipeProposalScreen extends StatelessWidget {
  final List<dynamic> suggestions; // Using dynamic to avoid import circles, or move DTO to domain

  const AiRecipeProposalScreen({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    // Cast suggestions to List<AiRecipeSuggestion>
    final recipeSuggestions = suggestions.cast<AiRecipeSuggestion>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.aiRecipeProposalTitle, // こんなレシピはいかがですか？
          style: GoogleFonts.outfit(
            color: const Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipeSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = recipeSuggestions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeSearchResultsScreen(
                      searchQuery: suggestion.name,
                      isFromFridgeAnalysis: true,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      suggestion.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: suggestion.usedIngredients.map((ingredient) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF2E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            ingredient,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCC8500),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
