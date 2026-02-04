
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/photo_analysis.dart';
import '../../infrastructure/repositories/drift_photo_analysis_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    final analysisAsync = ref.watch(photoAnalysisByPathProvider(widget.filePath));
    
    // Listen for completion
    ref.listen(photoAnalysisByPathProvider(widget.filePath), (previous, next) {
      if (widget.isNewCapture && !_hasShownCompletionMessage && next.value != null) {
        // Analysis finished (data arrived)
        setState(() => _hasShownCompletionMessage = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('料理の写真の解析が終わりました。')),
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
              Share.shareXFiles([XFile(widget.filePath)], text: 'Stoxで撮影しました');
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
                      // Case 1: No data yet, but it's a new capture -> Loading
                      if (analysis == null && widget.isNewCapture) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(color: Colors.pinkAccent),
                              const SizedBox(height: 16),
                              const Text('解析中...', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      }
                      
                      // Case 2: No data and NOT a new capture (or analysis failed/timeout logic elsewhere) -> Empty
                      if (analysis == null) {
                         return Center(
                           child: ListView(
                             controller: scrollController,
                             children: const [
                               SizedBox(height: 20),
                               Center(child: Text('解析データがありません', style: TextStyle(color: Colors.grey))),
                             ],
                           ),
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
                    error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
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
