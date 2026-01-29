import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/app_colors.dart';
import 'recipe_webview_screen.dart';
import '../components/recipe_list_card.dart';

class RecipeSearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const RecipeSearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<RecipeSearchResultsScreen> createState() => _RecipeSearchResultsScreenState();
}

class _RecipeSearchResultsScreenState extends State<RecipeSearchResultsScreen> {
  // TODO: 本番運用時は環境変数やSecret Managerから取得する
  final String _apiKey = 'AIzaSyB3wT4qTq3bVFbetWMkUHO6Y2ie_ijU6TE';
  final String _cx = '3718d8ce8782745bf';

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
        setState(() {
          _webResults = data['items'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = '検索に失敗しました (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '通信エラーが発生しました';
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
          '「${widget.searchQuery}」の検索結果',
          style: const TextStyle(color: AppColors.stoxText, fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('レシピサイトから'),
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
                child: const Text('再試行', style: TextStyle(color: AppColors.stoxPrimary))
            ),
          ],
        ),
      );
    }

    if (_webResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('レシピサイトに結果が見つかりませんでした', style: TextStyle(color: AppColors.stoxSubText)),
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

        return RecipeListCard(
          title: title,
          imageUrl: imageUrl,
          description: snippet,
          sourceInfo: displayLink,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeWebViewScreen(
                url: link,
                title: title,
                imageUrl: imageUrl,
              ),
            ),
          ),
        );
      },
    );
  }
}
