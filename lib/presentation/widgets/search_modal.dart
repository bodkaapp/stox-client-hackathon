import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../viewmodels/search_history_viewmodel.dart';
import '../viewmodels/recipe_book_viewmodel.dart';
import '../screens/recipe_webview_screen.dart';
import '../screens/recipe_search_results_screen.dart';
import '../screens/manual_recipe_entry_screen.dart';

import '../../domain/models/meal_plan.dart'; // Added import
import '../components/ai_suggestion_button.dart';

class SearchModal extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final MealType? initialMealType;

  const SearchModal({super.key, this.initialDate, this.initialMealType});

  static Future<SearchIntent?> show(BuildContext context, {DateTime? initialDate, MealType? initialMealType}) {
    return showGeneralDialog<SearchIntent>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: const Color(0xFF1C1917).withOpacity(0.4), // stone-900/40
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => SearchModal(initialDate: initialDate, initialMealType: initialMealType),
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

// Define specific intents for clarity
abstract class SearchIntent {}

class UrlSearchIntent extends SearchIntent {
  final String url;
  UrlSearchIntent(this.url);
}

class TextSearchIntent extends SearchIntent {
  final String query;
  TextSearchIntent(this.query);
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

    // Return the intent
    if (isUrl) {
      Navigator.pop(context, UrlSearchIntent(trimmedValue));
    } else {
      Navigator.pop(context, TextSearchIntent(trimmedValue));
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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text(
                     'レシピを検索する',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF292524), // stone-800
                     ),
                   ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28, color: Color(0xFF57534E)), // stone-600
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
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
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: _submit,
                        cursorColor: const Color(0xFFF59E0B),
                        style: const TextStyle(color: Color(0xFF292524)), // stone-800
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: AppColors.stoxSubText),
                          hintText: '', // Placeholder not shown in design when typed
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.stoxBorder, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.stoxBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.stoxPrimary, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search Button
                  TextButton(
                    onPressed: () => _submit(_controller.text),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.stoxPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('検索', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
            ),


            // ... (Header and Search Bar code remains above) ...
            // Use Expanded for list view but leave space for footer
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                children: [
                   // ... (Existing AI, History content) ... 
                   // AI Button
                   Padding(
                     padding: const EdgeInsets.only(bottom: 24),
                     child: AiSuggestionButton(
                       onTap: () {
                         // Empty function as requested
                       },
                       label: 'AIに提案してもらう',
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
                   const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
            
            // Manual Entry Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE7E5E4))), // stone-200
              ),
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to Manual Recipe Entry
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ManualRecipeEntryScreen(
                        initialDate: widget.initialDate,
                        initialMealType: widget.initialMealType,
                      )),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF57534E), // stone-600
                    side: const BorderSide(color: Color(0xFFD6D3D1)), // stone-300
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '検索せずに、レシピを手入力する',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
