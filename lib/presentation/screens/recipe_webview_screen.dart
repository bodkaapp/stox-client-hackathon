import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import 'ai_ingredient_list_screen.dart';
import 'recipe_schedule_screen.dart';
import '../mixins/ad_manager_mixin.dart';

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

class _RecipeWebViewScreenState extends ConsumerState<RecipeWebViewScreen> with AdManagerMixin {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _currentTitle = '';
  // bool _isAlreadySaved = false;
  bool _isAnalyzing = false; // Added for overlay

  @override
  void dispose() {
    disposeAd(); // Dispose ad resources
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
    loadRewardedAd(); // Preload ad
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() { _isLoading = true; });
          },
          onPageFinished: (String url) async {
            if (!mounted) return;
            setState(() { _isLoading = false; });
            final String? webPageTitle = await _controller.getTitle();
            
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
          
          // Ad/Analysis Overlay
          if (_isAnalyzing)
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: AppColors.stoxPrimary),
                  SizedBox(height: 24),
                  Text(
                    'AIがレシピの材料を分析しています。\n解析が終わるまで広告をご覧ください。',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
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
    final finalImageUrl = widget.imageUrl; 

    if (!mounted) return;

    // Capture the screen context to avoid using dialog context
    final screenContext = context;

    showDialog(
      context: screenContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('レシピの保存'),
        content: const Text('このレシピをどうしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('何もしない', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use screenContext, checking moved to ensure safety
              if (!mounted) return;
              Navigator.push(
                screenContext,
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
              Navigator.pop(dialogContext);
              
              if (!mounted) return;

               // Ad Bypass for Testing
               final success = await showAdAndExecute(
                context: screenContext, // Use VALID screen context
                preAdTitle: 'AI解析を開始',
                preAdContent: 'AIがレシピの材料を分析します。\n広告を再生することで、この機能を無料でご利用いただけます。',
                confirmButtonText: '広告を見て解析する',
                postAdMessage: 'AIの解析がおわりました。\n広告の視聴ありがとうございました。',
                onConsent: () {
                  if (mounted) {
                    setState(() { _isAnalyzing = true; });
                  }
                }
               );

             // Whether success or fail, turn off analyzing overlay
             if (mounted) {
               setState(() { _isAnalyzing = false; });
             }

             if (!success) return;
            //  final success = true; // Force success for testing

             if (!mounted) return;

              final result = await Navigator.push(
                screenContext, // Use VALID screen context
                MaterialPageRoute(
                  builder: (context) => AiIngredientListScreen(
                    initialText: currentUrl ?? widget.url,
                    sourceUrl: currentUrl ?? widget.url,
                    recipeTitle: _currentTitle,
                    imageUrl: finalImageUrl,
                  ),
                ),
              );
              
              if ((result == true || result is String) && mounted) {
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
