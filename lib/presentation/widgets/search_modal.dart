import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../viewmodels/search_history_viewmodel.dart';
import '../viewmodels/recipe_book_viewmodel.dart';
import '../screens/recipe_webview_screen.dart';
import '../screens/recipe_search_results_screen.dart';

class SearchModal extends ConsumerStatefulWidget {
  const SearchModal({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: const Color(0xFF1C1917).withOpacity(0.4), // stone-900/40
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => const SearchModal(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends ConsumerState<SearchModal> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    
    // Auto focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return;

    final uri = Uri.tryParse(trimmedValue);
    final isUrl = uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;

    // Save functionality: URL not saved, Query saved.
    if (!isUrl) {
       ref.read(searchHistoryViewModelProvider.notifier).add(trimmedValue);
    }

    Navigator.pop(context); // Close modal first

    if (isUrl) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeWebViewScreen(
            url: trimmedValue,
            title: '読み込み中...',
          ),
        ),
      ).then((_) => ref.refresh(recipeBookViewModelProvider));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeSearchResultsScreen(searchQuery: trimmedValue),
        ),
      ).then((_) => ref.refresh(recipeBookViewModelProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(searchHistoryViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFA), // bg-cream
      body: SafeArea(
        child: Column(
          children: [
            // Header (Time/Status bar is system handled, just close button area)
            // Design has a specific header layout.
            // Matches design: padding top for status bar? SafeArea handles it.
            // Close button row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28, color: Color(0xFF57534E)), // stone-600
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
            
            // Search Bar Area
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 2), // amber-500
                        boxShadow: [
                           BoxShadow(color: const Color(0xFFFEF3C7), blurRadius: 2, offset: const Offset(0, 1)), // amber-100 shadow
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: _submit,
                        cursorColor: const Color(0xFFF59E0B),
                        style: const TextStyle(color: Color(0xFF292524)), // stone-800
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Color(0xFFF59E0B)), // amber-500
                          hintText: '', // Placeholder not shown in design when typed
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search Button
                  TextButton(
                    onPressed: () => _submit(_controller.text),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFD97706), // amber-600
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('検索', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                   // AI Button
                   Padding(
                     padding: const EdgeInsets.only(bottom: 24),
                     child: Container(
                       padding: const EdgeInsets.all(1), // Border width
                       decoration: BoxDecoration(
                         gradient: const LinearGradient(
                           colors: [Color(0xFFFBBF24), Color(0xFFF97316)], // amber-400 to orange-500
                         ),
                         borderRadius: BorderRadius.circular(16),
                         boxShadow: [
                           BoxShadow(color: const Color(0xFFFFEDD5).withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4)),
                         ],
                       ),
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(15),
                         ),
                         child: Material(
                           color: Colors.transparent,
                           child: InkWell(
                             onTap: () {
                               // Empty function as requested
                             },
                             borderRadius: BorderRadius.circular(15),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 16),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   const Icon(Icons.auto_awesome, color: Color(0xFFF97316), size: 24), // orange-500
                                   const SizedBox(width: 8),
                                   ShaderMask(
                                     shaderCallback: (bounds) => const LinearGradient(
                                       colors: [Color(0xFFD97706), Color(0xFFEA580C)], // amber-600 to orange-600
                                     ).createShader(bounds),
                                     child: const Text(
                                       'AIに提案してもらう',
                                       style: TextStyle(
                                         color: Colors.white, // Mask requires white usually
                                         fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),

                   // History Section
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Row(
                         children: [
                           Icon(Icons.history, color: Color(0xFFA8A29E), size: 20), // stone-400
                           SizedBox(width: 6),
                           Text(
                             '検索履歴',
                             style: TextStyle(
                               fontSize: 14,
                               fontWeight: FontWeight.bold,
                               color: Color(0xFF78716C), // stone-500
                             ),
                           ),
                         ],
                       ),
                       TextButton(
                         onPressed: () {
                           ref.read(searchHistoryViewModelProvider.notifier).deleteAll();
                         },
                         style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFA8A29E), // stone-400
                            textStyle: const TextStyle(fontSize: 12),
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                         ),
                         child: const Text('すべて削除'),
                       ),
                     ],
                   ),
                   const SizedBox(height: 8),
                   
                   // History List
                   historyAsync.when(
                     data: (historyList) {
                       if (historyList.isEmpty) return const SizedBox.shrink();
                       return Column(
                         children: historyList.map((history) {
                           return InkWell(
                             onTap: () {
                               _controller.text = history.query;
                               _controller.selection = TextSelection.fromPosition(TextPosition(offset: history.query.length));
                             },
                             child: Container(
                               padding: const EdgeInsets.symmetric(vertical: 12),
                               decoration: const BoxDecoration(
                                 border: Border(bottom: BorderSide(color: Color(0xFFF5F5F4))), // stone-100
                               ),
                               child: Row(
                                 children: [
                                   const Icon(Icons.search, color: Color(0xFFD6D3D1), size: 20), // stone-300
                                   const SizedBox(width: 12),
                                   Expanded(
                                     child: Text(
                                       history.query,
                                       style: const TextStyle(
                                         color: Color(0xFF44403C), // stone-700
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500,
                                       ),
                                     ),
                                   ),
                                   IconButton(
                                     icon: const Icon(Icons.close, color: Color(0xFFD6D3D1), size: 20),
                                     onPressed: () {
                                        ref.read(searchHistoryViewModelProvider.notifier).delete(history.id);
                                     },
                                     padding: EdgeInsets.zero,
                                     constraints: const BoxConstraints(),
                                   ),
                                 ],
                               ),
                             ),
                           );
                         }).toList(),
                       );
                     },
                     loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                     error: (err, _) => Center(child: Text('Error: $err')),
                   ),
                   const SizedBox(height: 50), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
