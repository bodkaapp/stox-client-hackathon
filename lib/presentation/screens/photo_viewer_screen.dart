
import 'dart:io';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/photo_analysis.dart';
import '../../infrastructure/repositories/drift_photo_analysis_repository.dart';

import '../components/ai_suggestion_button.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';

part 'photo_viewer_screen.g.dart';

class PhotoViewerScreen extends ConsumerStatefulWidget {
  final String filePath;
  final bool isNewCapture;

  const PhotoViewerScreen({
    super.key, 
    required this.filePath,
    this.isNewCapture = false,
  });

  @override
  ConsumerState<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends ConsumerState<PhotoViewerScreen> {
  bool _showInfo = true;
  bool _hasShownCompletionMessage = false;
  bool _isAnalyzing = false;

  Future<void> _analyzePhoto() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final file = File(widget.filePath);
      if (!file.existsSync()) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fileNotFound))); // ファイルが見見つかりません
           setState(() => _isAnalyzing = false);
        }
        return;
      }

      final bytes = await file.readAsBytes();
      final aiRepo = ref.read(aiRecipeRepositoryProvider);
      
      // Analyze
      final analysisResult = await aiRepo.analyzeFoodImage(bytes);
      
      // Save
      final photoAnalysisRepo = await ref.read(photoAnalysisRepositoryProvider.future);
      final analysis = PhotoAnalysis(
        photoPath: widget.filePath,
        analyzedAt: DateTime.now(),
        calories: analysisResult.totalCalories,
        protein: analysisResult.protein,
        fat: analysisResult.fat,
        carbs: analysisResult.carbs,
        foodName: analysisResult.foodName,
        resultText: analysisResult.displayText,
      );

      await photoAnalysisRepo.save(analysis);
      
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _hasShownCompletionMessage = true; // Avoid double toast if we want, or show specific one
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.analysisComplete)), // 解析が完了しました
        );
      }

    } catch (e) {
      debugPrint('Error analyzing photo: $e');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.analysisFailed}: $e')), // 解析に失敗しました
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysisAsync = ref.watch(photoAnalysisByPathProvider(widget.filePath));
    
    // Listen for completion
    ref.listen(photoAnalysisByPathProvider(widget.filePath), (previous, next) {
      if (widget.isNewCapture && !_hasShownCompletionMessage && next.value != null && !_isAnalyzing) {
        // Only show if it was an auto-analysis from capture, not manual trigger (handled in _analyzePhoto)
        // But logic can be simpler: just show if data arrives.
        setState(() => _hasShownCompletionMessage = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.foodPhotoAnalysisComplete)), // 料理の写真の解析が終わりました。
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_showInfo ? Icons.info : Icons.info_outline),
            onPressed: () => setState(() => _showInfo = !_showInfo),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.shareXFiles([XFile(widget.filePath)], text: AppLocalizations.of(context)!.sharedWithStox); // STOXで撮影しました
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: InteractiveViewer(
              child: Image.file(
                File(widget.filePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (_showInfo)
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.1,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                  child: analysisAsync.when(
                    data: (analysis) {
                      // Case 1: Analyzing in progress (Manual or Auto)
                      if (_isAnalyzing || (analysis == null && widget.isNewCapture)) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(color: Colors.pinkAccent),
                              const SizedBox(height: 16),
                              Text(_isAnalyzing ? 'AIが解析中...' : '解析中...', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      }
                      
                      // Case 2: No data (Trigger Manual Analysis)
                      if (analysis == null) {
                         return Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(AppLocalizations.of(context)!.noAnalysisData, style: const TextStyle(color: Colors.grey)), // 解析データがありません
                             const SizedBox(height: 16),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 32.0),
                               child: AiSuggestionButton(
                                 label: AppLocalizations.of(context)!.actionAnalyzeNutritionWithAi, // AIで栄養価を解析する
                                 onTap: _analyzePhoto,
                               ),
                             ),
                           ],
                         );
                      }

                      // Case 3: Data exists -> Show it
                      return ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          MarkdownBody(
                            data: analysis.resultText ?? '解析結果のテキストがありません',
                            selectable: true,
                          ),
                          const SizedBox(height: 40),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
                    error: (err, stack) => Center(child: Text('${AppLocalizations.of(context)!.errorOccurred}: $err')), // エラーが発生しました
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

@riverpod
Stream<PhotoAnalysis?> photoAnalysisByPath(PhotoAnalysisByPathRef ref, String path) {
  final repo = ref.watch(photoAnalysisRepositoryProvider).requireValue; // repositoryProvider is FutureProvider, but we need synchronous access or stream?
  // Actually, photoAnalysisRepositoryProvider is `FutureProvider<PhotoAnalysisRepository>`.
  // StreamProvider builder cannot await futures easily without being async* which is supported but slightly different.
  // Better: use `ref.watch(photoAnalysisRepositoryProvider.future).asStream().flatMap(...)` OR
  // simpler: `Stream.fromFuture(repoFuture).flatMap(...)`
  // OR: Just assume repo is loaded? No.
  
  // Standard Pattern:
  return Stream.fromFuture(ref.watch(photoAnalysisRepositoryProvider.future))
      .asyncExpand((repo) => repo.watchByPath(path));
}
