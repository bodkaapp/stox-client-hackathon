import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:http/http.dart' as http;
import '../../config/app_colors.dart';
import 'recipe_webview_screen.dart';
import '../components/recipe_list_card.dart';
import '../components/large_recipe_list_card.dart';

import '../../domain/models/meal_plan.dart';

class RecipeSearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  final DateTime? initialDate;
  final MealType? initialMealType;
  final bool isFromFridgeAnalysis;

  const RecipeSearchResultsScreen({
    super.key,
    required this.searchQuery,
    this.initialDate,
    this.initialMealType,
    this.isFromFridgeAnalysis = false,
  });

  @override
  State<RecipeSearchResultsScreen> createState() => _RecipeSearchResultsScreenState();
}

class _RecipeSearchResultsScreenState extends State<RecipeSearchResultsScreen> {
  // TODO: 本番運用時は環境変数やSecret Managerから取得する
  final String _apiKey = dotenv.env['GOOGLE_SEARCH_API_KEY'] ?? '';
  final String _cx = dotenv.env['GOOGLE_SEARCH_CX'] ?? '';

  bool _isLoading = true;
  List<dynamic> _webResults = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWebRecipes();
  }

  Future<void> _fetchWebRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fullQuery = widget.searchQuery;
      final url = Uri.parse(
        'https://www.googleapis.com/customsearch/v1?key=$_apiKey&cx=$_cx&q=${Uri.encodeComponent(fullQuery)}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];
        debugPrint('Search: "$fullQuery" - ${items.length} recipes found.');
        
        setState(() {
          _webResults = items;
          _isLoading = false;
        });
      } else {
        debugPrint('Search Failed: code ${response.statusCode}');
        setState(() {
          _errorMessage = '${AppLocalizations.of(context)!.searchFailedMessage} (${response.statusCode})'; // 検索に失敗しました
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Search Error: $e');
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.errorNetwork; // 通信エラーが発生しました
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          AppLocalizations.of(context)!.recipeSearchResults(widget.searchQuery), // 「${widget.searchQuery}」の検索結果
          style: const TextStyle(color: AppColors.stoxText, fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(AppLocalizations.of(context)!.labelFromRecipeSites), // レシピサイトから
            _buildWebResultsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.stoxPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.stoxText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebResultsSection() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: AppColors.stoxPrimary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            TextButton(
                onPressed: _fetchWebRecipes, 
                child: Text(AppLocalizations.of(context)!.retake, style: const TextStyle(color: AppColors.stoxPrimary)) // 再試行 (やり直す)
            ),
          ],
        ),
      );
    }

    if (_webResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(AppLocalizations.of(context)!.noRecipeSearchResults, style: const TextStyle(color: AppColors.stoxSubText)), // レシピサイトに結果が見つかりませんでした
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _webResults.length,
      itemBuilder: (context, index) {
        final item = _webResults[index];
        final title = item['title'] ?? '';
        final link = item['link'] ?? '';
        final displayLink = item['displayLink'] ?? '';
        final snippet = item['snippet'] ?? '';
        
        String? imageUrl;
        if (item['pagemap'] != null && item['pagemap']['cse_image'] != null) {
          imageUrl = item['pagemap']['cse_image'][0]['src'];
        }

        if (index == 0) {
          return LargeRecipeListCard(
            title: title,
            imageUrl: imageUrl,
            description: snippet,
            sourceInfo: displayLink,
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => RecipeWebViewScreen(
                  url: link,
                  title: title,
                  imageUrl: imageUrl,
                  initialDate: widget.initialDate,
                  initialMealType: widget.initialMealType,
                  isFromFridgeAnalysis: widget.isFromFridgeAnalysis,
                ),
              ),
            ),
          );
        }

        return RecipeListCard(
          title: title,
          imageUrl: imageUrl,
          description: snippet,
          sourceInfo: displayLink,
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => RecipeWebViewScreen(
                url: link,
                title: title,
                imageUrl: imageUrl,
                initialDate: widget.initialDate,
                initialMealType: widget.initialMealType,
                isFromFridgeAnalysis: widget.isFromFridgeAnalysis,
              ),
            ),
          ),
        );
      },
    );
  }
}
