import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../../infrastructure/repositories/isar_recipe_repository.dart';
import 'ai_ingredient_list_screen.dart';
import 'recipe_schedule_screen.dart';

class RecipeWebViewScreen extends ConsumerStatefulWidget {
  final String url;
  final String title;
  final String? imageUrl;

  const RecipeWebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.imageUrl,
  });

  @override
  ConsumerState<RecipeWebViewScreen> createState() => _RecipeWebViewScreenState();
}

class _RecipeWebViewScreenState extends ConsumerState<RecipeWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _currentTitle = '';
  bool _isAlreadySaved = false;
  // bool _isFavorite = false; // Isar integration for existing items logic skipped for brevity, can implement if needed

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() { _isLoading = true; });
          },
          onPageFinished: (String url) async {
            if (!mounted) return;
            setState(() { _isLoading = false; });
            final String? webPageTitle = await _controller.getTitle();
            // Check if saved (omitted for speed, can add back)
            
            if (mounted && webPageTitle != null && webPageTitle.isNotEmpty) {
              setState(() { _currentTitle = webPageTitle; });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.stoxBorder)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.stoxText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentTitle,
          style: const TextStyle(color: AppColors.stoxText, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.stoxText),
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share, color: AppColors.stoxText),
                  title: Text('レシピをシェア'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'browser',
                child: ListTile(
                  leading: Icon(Icons.open_in_browser, color: AppColors.stoxText),
                  title: Text('ブラウザで開く'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'copy',
                child: ListTile(
                  leading: Icon(Icons.copy, color: AppColors.stoxText),
                  title: Text('URLをコピー'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
        ],
      ),
      floatingActionButton: _isLoading 
          ? null 
          : FloatingActionButton.extended(
              onPressed: () {
                _showSaveConfirmDialog();
              },
              backgroundColor: AppColors.stoxPrimary,
              label: const Text(
                'このレシピを作る！', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
              icon: const Icon(Icons.restaurant, color: Colors.white),
            ),
    );
  }

  void _handleMenuAction(String value) async {
    final String? currentUrl = await _controller.currentUrl();
    final String url = currentUrl ?? widget.url;

    switch (value) {
      case 'share':
        await Share.share('$url\n\n$_currentTitle');
        break;
      case 'browser':
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
        break;
      case 'copy':
        await Clipboard.setData(ClipboardData(text: url));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URLをコピーしました')),
          );
        }
        break;
    }
  }

  Future<void> _saveRecipeOnly() async {
    final String? currentUrl = await _controller.currentUrl();
    final String urlToSave = currentUrl ?? widget.url;

    try {
      final repo = await ref.read(recipeRepositoryProvider.future);
      final recipe = Recipe(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _currentTitle,
        pageUrl: urlToSave,
        ogpImageUrl: widget.imageUrl ?? '',
        createdAt: DateTime.now(),
      );
      await repo.save(recipe);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('マイレシピ帳に登録しました')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録に失敗しました')),
        );
      }
    }
  }

  void _showSaveConfirmDialog() async {
    final String? currentUrl = await _controller.currentUrl();
    
    // Attempt to fetch OG Image via JS (optional/advanced, keeping simple for now or reusing passed image)
    final finalImageUrl = widget.imageUrl; 

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('レシピの保存'),
        content: const Text('このレシピをどうしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('何もしない', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeScheduleScreen(
                    url: currentUrl ?? widget.url,
                    title: _currentTitle,
                    imageUrl: finalImageUrl,
                  ),
                ),
              );
            },
            child: const Text('マイレシピ帳に登録する', style: TextStyle(color: AppColors.stoxText)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AiIngredientListScreen(
                    initialText: currentUrl ?? widget.url,
                    sourceUrl: currentUrl ?? widget.url,
                    recipeTitle: _currentTitle,
                    imageUrl: finalImageUrl,
                  ),
                ),
              );
              
              if (result == true && mounted) {
                // Success
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.stoxPrimary),
            child: const Text('材料を抽出する', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
