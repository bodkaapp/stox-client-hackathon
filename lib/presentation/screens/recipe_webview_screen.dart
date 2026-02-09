import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../../infrastructure/repositories/drift_recipe_repository.dart';
import 'ai_ingredient_list_screen.dart';
import 'recipe_schedule_screen.dart';
import '../mixins/ad_manager_mixin.dart';
import '../../infrastructure/services/recipe_monitoring_service.dart';
import '../../domain/models/meal_plan.dart';
import '../../domain/models/challenge_stamp.dart'; // [NEW]
import '../viewmodels/challenge_stamp_viewmodel.dart'; // [NEW]
import 'package:go_router/go_router.dart'; // [NEW]
import '../../config/router.dart';

class RecipeWebViewScreen extends ConsumerStatefulWidget {
  final String url;
  final String title;
  final String? imageUrl;
  final DateTime? initialDate;
  final MealType? initialMealType;
  final String? existingRecipeId;
  final bool isFromFridgeAnalysis;

  const RecipeWebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.imageUrl,
    this.initialDate,
    this.initialMealType,
    this.isFromFridgeAnalysis = false,
    this.existingRecipeId,
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

            // Log View History
            try {
              final repo = await ref.read(recipeRepositoryProvider.future);
              
                if (widget.existingRecipeId != null) {
                await repo.logView(widget.existingRecipeId!);
              } else {
                // Check if already exists by URL (including temporary)
                final match = await repo.findByUrl(url) ?? await repo.findByUrl(widget.url);
                
                if (match != null) {
                   await repo.logView(match.id);
                } else {
                   // New Recipe -> Save as Temporary View History
                   final titleToSave = (webPageTitle != null && webPageTitle.isNotEmpty) ? webPageTitle : widget.title;
                   
                   final newRecipe = Recipe(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      title: titleToSave,
                      pageUrl: widget.url, 
                      ogpImageUrl: widget.imageUrl ?? '',
                      createdAt: DateTime.now(),
                      lastViewedAt: DateTime.now(),
                      isTemporary: true, // Key change: Temporary only
                   );
                   await repo.save(newRecipe);
                }
              }
            } catch (e) {
              debugPrint('Failed to log view history: $e');
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
              PopupMenuItem<String>(
                value: 'share',
                child: ListTile(
                  leading: const Icon(Icons.share, color: AppColors.stoxText),
                  title: Text(AppLocalizations.of(context)!.actionShareRecipe), // レシピをシェア
                ),
              ),
              PopupMenuItem<String>(
                value: 'browser',
                child: ListTile(
                  leading: const Icon(Icons.open_in_browser, color: AppColors.stoxText),
                  title: Text(AppLocalizations.of(context)!.actionOpenInBrowser), // ブラウザで開く
                ),
              ),
              PopupMenuItem<String>(
                value: 'copy',
                child: ListTile(
                  leading: const Icon(Icons.copy, color: AppColors.stoxText),
                  title: Text(AppLocalizations.of(context)!.actionCopyUrl), // URLをコピー
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
                children: [
                  CircularProgressIndicator(color: AppColors.stoxPrimary),
                  SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.aiAnalysisRecipeIngredientsDescription, // AIがレシピの材料を分析しています。\n解析が終わるまで広告をご覧ください。
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
              label: Text(
                AppLocalizations.of(context)!.actionCookThisRecipe, // このレシピを作る！
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
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
            SnackBar(content: Text(AppLocalizations.of(context)!.urlCopied)), // URLをコピーしました
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
      
      // Track registration
      ref.read(recipeMonitoringServiceProvider).trackRecipeRegistration(urlToSave);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.recipeSavedToBook)), // マイレシピ帳に登録しました
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.recipeSaveError)), // 登録に失敗しました (saveFailedを流用、または統一キー)
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
        title: Text(AppLocalizations.of(context)!.recipeSaveTitle), // レシピの保存
        content: Text(AppLocalizations.of(context)!.recipeSaveQuestion), // このレシピをどうしますか？
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.actionDoNothing, style: const TextStyle(color: Colors.grey)), // 何もしない
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (!mounted) return;
                if (!mounted) return;
                
                final result = await Navigator.push(
                  screenContext,
                  MaterialPageRoute(
                    builder: (context) => RecipeScheduleScreen(
                      url: currentUrl ?? widget.url,
                      title: _currentTitle,
                      imageUrl: finalImageUrl,
                      initialDate: widget.initialDate,
                      initialMealType: widget.initialMealType,
                    ),
                  ),
                );

                // [NEW] Challenge Logic
                // RecipeScheduleScreen pops with true/false or nothing?
                // Currently it pops with nothing (void) in the viewed code.
                // Wait, checking RecipeScheduleScreen code again...
                // It does `Navigator.pop(context);` without result.
                // I need to update RecipeScheduleScreen to return true on success.
                // Assuming I will do that next.
                
                if (result is Map && result['success'] == true && mounted) {
                   final selectedDate = result['date'] as DateTime?;
                   
                   // Complete challenges first
                   if (widget.isFromFridgeAnalysis) {
                      await ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.tutorial.id);
                   } else {
                      await ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.scheduleRecipe.id);
                   }

                   // Navigate based on date selection
                   if (selectedDate != null) {
                     // Close the WebView first
                     if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                     }
                     // Date decided -> Go to Menu Plan for that date using routerProvider
                     ref.read(routerProvider).go(Uri(path: '/menu_plan', queryParameters: {'date': selectedDate.toIso8601String()}).toString());
                   } else {
                     // Undecided -> Stay or maybe go to recipe book? 
                     // User request: "If date and time are decided... navigate to menu plan".
                     // If undecided, maybe just stay here (which is what pop does, but we already popped dialog).
                     // But we are in RecipeWebViewScreen.
                     // If isFromFridgeAnalysis, we used to go to /menu_plan effectively.
                     if (widget.isFromFridgeAnalysis) {
                        context.go('/menu_plan');
                     }
                     // Otherwise stay in RecipeWebViewScreen
                   }
                }
              },
            child: Text(AppLocalizations.of(context)!.actionRegisterToMyRecipeBook, style: const TextStyle(color: AppColors.stoxText)), // マイレシピ帳に登録する
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              if (!mounted) return;

              // Analysis Future
              Future<List<Ingredient>>? analysisFuture;
              final aiRepo = ref.read(aiRecipeRepositoryProvider);

               final success = await showAdAndExecute(
                context: screenContext, 
                preAdTitle: AppLocalizations.of(context)!.titleExtractIngredients, // 材料の解析
                preAdContent: AppLocalizations.of(context)!.aiAnalysisRecipeIngredientsDescriptionLong, // AIがレシピの材料を分析しています。\n広告を再生している間に解析を行います。 (既存キーまたは新規適正キー)
                confirmButtonText: AppLocalizations.of(context)!.actionWatchAdAndAnalyze, // 広告を見て解析する
                // postAdMessage will be shown ONLY if analysis is also complete? 
                // Or we handle post-ad message manually to sync with analysis.
                // Let's pass null and handle it manually.
                postAdMessage: null, 
                onConsent: () {
                  if (mounted) {
                    setState(() { _isAnalyzing = true; });
                  }
                  // Start analysis immediately
                  analysisFuture = aiRepo.extractIngredients(currentUrl ?? widget.url);
                }
               );

             if (!success) {
                // Ad cancelled or failed
                if (mounted) {
                   setState(() { _isAnalyzing = false; });
                }
                return;
             }

             // Ad finished. Now wait for analysis if not done.
             List<Ingredient>? ingredients;
             try {
                if (analysisFuture != null) {
                  ingredients = await analysisFuture;
                }
             } catch (e) {
                // Analysis failed
                if (mounted) {
                   setState(() { _isAnalyzing = false; });
                   ScaffoldMessenger.of(screenContext).showSnackBar(
                     SnackBar(content: Text(AppLocalizations.of(context)!.analysisFailedTryAgain)), // 解析に失敗しました。もう一度お試しください。
                   );
                }
                return;
             }
            
             if (!mounted) return;
             
             setState(() { _isAnalyzing = false; });

             // Show Success Dialog briefly or just Snack?
             // User plan says: "AIの解析が終わりました。広告の視聴ありがとうございました"
             await showDialog(
                context: screenContext,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       const Icon(Icons.check_circle, color: Colors.green, size: 48),
                       const SizedBox(height: 16),
                       Text(AppLocalizations.of(context)!.aiAnalysisCompleteMessage, textAlign: TextAlign.center), // AIの解析が終わりました。\n広告の視聴ありがとうございました。
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.actionNext), // 次へ
                    )
                  ],
                ),
              );

               if (!mounted) return;
               
               // [NEW] Challenge 4: Extract Ingredients
               // Calling complete here.
               await ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.extractIngredients.id);



              final result = await Navigator.push(
                screenContext,
                MaterialPageRoute(
                  builder: (context) => AiIngredientListScreen(
                    initialText: currentUrl ?? widget.url,
                    sourceUrl: currentUrl ?? widget.url,
                    recipeTitle: _currentTitle,
                    imageUrl: finalImageUrl,
                    preCalculatedIngredients: ingredients,
                  ),
                ),
              );
              
              // If result is recipeId (String), go to Schedule
              if (result is String && result.isNotEmpty && mounted) {
                 final scheduleResult = await Navigator.push(
                    screenContext,
                    MaterialPageRoute(
                      builder: (context) => RecipeScheduleScreen(
                        url: currentUrl ?? widget.url,
                        title: _currentTitle,
                        imageUrl: finalImageUrl,
                        initialDate: widget.initialDate,
                        initialMealType: widget.initialMealType,
                        existingRecipeId: result,
                      ),
                    ),
                 );

                 if (scheduleResult is Map && scheduleResult['success'] == true && mounted) {
                    final selectedDate = scheduleResult['date'] as DateTime?;
                    if (selectedDate != null) {
                       // Close the WebView first
                       if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                       }
                       // Navigate using routerProvider
                       ref.read(routerProvider).go(Uri(path: '/menu_plan', queryParameters: {'date': selectedDate.toIso8601String()}).toString());
                    }
                 }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.stoxPrimary),
            child: Text(AppLocalizations.of(context)!.actionExtractIngredients, style: const TextStyle(color: Colors.white)), // 材料を抽出する
          ),
        ],
      ),
    );
  }
}
