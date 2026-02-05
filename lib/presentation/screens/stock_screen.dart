import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../viewmodels/stock_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'photo_stock_location_screen.dart';
import '../widgets/ingredient_add_modal.dart';
import '../widgets/voice_shopping_modal.dart';
import '../components/circle_action_button.dart';
import '../widgets/help_icon.dart';
import '../../l10n/generated/app_localizations.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  int _selectedCategoryIndex = 0;
  bool _isMenuOpen = false;
  bool _isAnalyzing = false;
  
  // Search state
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Selection/Delete mode state
  bool _isSelectionMode = false;
  final Set<String> _selectedItemIds = {};

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedItemIds.clear();
      _isMenuOpen = false; // Close menu if open
    });
  }

  void _toggleItemSelection(String id) {
    setState(() {
      if (_selectedItemIds.contains(id)) {
        _selectedItemIds.remove(id);
      } else {
        _selectedItemIds.add(id);
      }
    });
  }

  Future<void> _deleteSelectedItems() async {
    if (_selectedItemIds.isEmpty) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.stockDeleteConfirmMessage, style: const TextStyle(fontWeight: FontWeight.bold)), // 本当に削除してもいいですか？
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.actionCancel, style: const TextStyle(color: Colors.grey)), // キャンセル
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.actionDelete, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), // 削除します
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Capture items before deletion for Undo
    final allItems = ref.read(stockViewModelProvider).value ?? [];
    final itemsToDelete = allItems.where((item) => _selectedItemIds.contains(item.id)).toList();

    final idsToDelete = _selectedItemIds.toList();
    await ref.read(stockViewModelProvider.notifier).deleteItems(idsToDelete);
    
    if (!mounted) return;

    setState(() {
      _isSelectionMode = false;
      _selectedItemIds.clear();
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.stockDeletedMessage(_selectedItemIds.length.toInt())), // {count}件を削除しました
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.actionUndo, // やっぱり元に戻す
          onPressed: () async {
            // Confirm restore
            final shouldRestore = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.stockRestoreConfirmMessage, style: const TextStyle(fontWeight: FontWeight.bold)), // 削除した商品を元に戻しますか？
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(AppLocalizations.of(context)!.actionCancel, style: const TextStyle(color: Colors.grey)), // キャンセル
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(AppLocalizations.of(context)!.actionRestore, style: const TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold)), // 元に戻す
                  ),
                ],
              ),
            );

            if (shouldRestore == true) {
              await ref.read(stockViewModelProvider.notifier).restoreItems(itemsToDelete);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.stockRestoredMessage)), // 商品を元に戻しました
                );
              }
            }
          },
        ),
        duration: const Duration(seconds: 6),
      ),
    );

    // Force close after 10 seconds in case accessibility settings keep it open indefinitely
    Future.delayed(const Duration(seconds: 6), () {
      try {
        controller.close(); 
      } catch (_) {
        // Ignore if already closed
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final stateAvg = ref.watch(stockViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            String layout = 'mobile';
            if (constraints.maxWidth >= 600) {
              layout = 'tablet';
            }

            if (layout == 'tablet') {
              return _buildTabletLayout(stateAvg);
            }
            return _buildMobileLayout(stateAvg);
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(AsyncValue<List<Ingredient>> stateAvg) {
    return Stack(
      children: [
        Column(
          children: [
            stateAvg.when(
              data: (items) => _buildHeader(items),
              loading: () => _buildHeader([]),
              error: (_, __) => _buildHeader([]),
            ),
            
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isSearching 
                ? _buildSearchBar()
                : _buildFilterBar(),
            ),

            Expanded(
              child: stateAvg.when(
                data: (items) {
                  final filteredItems = _filterItems(items);
                  
                  return Column(
                    children: [
                      if (filteredItems.isNotEmpty) _buildListHeader(),
                      Expanded(
                        child: filteredItems.isEmpty
                          ? Center(
                                child: Text(
                                _isSearching
                                  ? AppLocalizations.of(context)!.stockNoSearchResults // 検索結果がありません
                                  : AppLocalizations.of(context)!.stockEmptyDescription, // 家の中にある\n「買ったもの」「もらったもの」\nを登録して見る場所です。
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.stoxText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.6,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 160),
                              itemCount: filteredItems.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.stoxBorder),
                              itemBuilder: (context, index) {
                                return _buildListItem(filteredItems[index]);
                              },
                            ),
                      ),
                      _buildFooter(items),
                    ],
                  );
                },
                error: (err, st) => Center(child: Text('Error: $err')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
        
        // Dimmed Background Overlay
        if (_isMenuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleMenu,
              child: AnimatedOpacity(
                opacity: _isMenuOpen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: const Color(0xB3000000),
                ),
              ),
            ),
          ),

        if (_isAnalyzing)
           Positioned.fill(
             child: Container(
               color: Colors.black45,
               child: const Center(
                 child: CircularProgressIndicator(color: AppColors.stoxPrimary),
               ),
             ),
           ),

        // Guide Bubble
        stateAvg.when(
            data: (items) {
              if (_isSelectionMode) return const SizedBox.shrink();
              if (_isMenuOpen) return const SizedBox.shrink();
              if (items.isNotEmpty) return const SizedBox.shrink();
              
              return Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.stoxAccent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.stockEmptyAddInstruction, // ここをタップして在庫を追加します
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(12, 6),
                        painter: _TrianglePainter(color: AppColors.stoxAccent),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
        ),

         // Menu Items
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            bottom: _isMenuOpen ? 90 : 20,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _isMenuOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !_isMenuOpen,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      _buildMenuButton(
                      Icons.shopping_cart, 
                      AppLocalizations.of(context)!.stockAddToShoppingList, // 買い物リストへ追加する
                      onTap: () {
                        _toggleMenu();
                      }
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      Icons.edit, 
                      AppLocalizations.of(context)!.stockAddByTextInput, // 文字入力で追加
                      onTap: () {
                        _toggleMenu();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => IngredientAddModal(
                            title: AppLocalizations.of(context)!.stockAddTitle, // 在庫を追加
                            targetStatus: IngredientStatus.stock,
                            onSaved: () {
                              ref.invalidate(stockViewModelProvider);
                            },
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      Icons.mic, 
                      AppLocalizations.of(context)!.stockAddByVoice, // 音声入力で追加
                      onTap: () async {
                         _toggleMenu();
                         await showModalBottomSheet(
                           context: context, 
                           isScrollControlled: true,
                           backgroundColor: Colors.transparent,
                           builder: (context) => const VoiceShoppingModal(targetStatus: IngredientStatus.stock),
                         );
                         ref.invalidate(stockViewModelProvider);
                      }
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      Icons.photo_camera, 
                      AppLocalizations.of(context)!.stockAddByPhoto, // 写真撮影で追加
                      onTap: () {
                         _toggleMenu();
                         _onPhotoBtnTap();
                      }
                    ),
                    const SizedBox(height: 12),
                    _buildMenuButton(
                      Icons.delete_outline,
                      AppLocalizations.of(context)!.stockDeleteItems, // 商品を選んで削除する
                      onTap: _toggleSelectionMode,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Guide Bubble for Delete
        if (_isSelectionMode && _selectedItemIds.isNotEmpty)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.stockDeleteActionGuide, // ここをタップして削除します
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(12, 6),
                    painter: _TrianglePainter(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),

        // FAB / Delete Button
        if (_isSelectionMode)
           Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _selectedItemIds.isEmpty ? null : _deleteSelectedItems,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _selectedItemIds.isEmpty ? Colors.grey : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_selectedItemIds.isEmpty ? Colors.grey : Colors.red).withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
                ),
              ),
            ),
          )
        else
          Positioned(
            bottom: 24, 
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.stoxPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.stoxPrimary.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: AnimatedRotation(
                     turns: _isMenuOpen ? 0.125 : 0,
                     duration: const Duration(milliseconds: 200),
                     child: const Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabletLayout(AsyncValue<List<Ingredient>> stateAvg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Operations
        Container(
          width: 320,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.stoxPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.inventory_2, color: AppColors.stoxPrimary, size: 22),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.stockTitle, // 在庫一覧
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                    ),
                    const SizedBox(width: 8),
                    HelpIcon(
                      title: AppLocalizations.of(context)!.stockHelpTitle, // 在庫一覧画面
                      description: AppLocalizations.of(context)!.stockHelpDescription, // 家にある食材や日用品の在庫を確認する画面です。個数や賞味期限の確認ができます
                    ),
                  ],
                ),
              ),
              
              // Search
              _buildSearchBar(),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(AppLocalizations.of(context)!.stockCategoryLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxSubText)), // カテゴリ
                    ),
                    // Vertical Categories
                    ...List.generate(5, (index) {
                      final labels = [
                          AppLocalizations.of(context)!.categoryAll, // すべて
                          AppLocalizations.of(context)!.categoryVegetablesFruits, // 野菜・果物
                          AppLocalizations.of(context)!.categoryMeatFish, // 肉・魚
                          AppLocalizations.of(context)!.categoryDairy, // 乳製品
                          AppLocalizations.of(context)!.categorySeasoning, // 調味料
                      ];
                      final cat = labels[index];
                      final isSelected = _selectedCategoryIndex == index;
                      return ListTile(
                        title: Text(cat, style: TextStyle(
                            fontSize: 14, 
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.stoxPrimary : AppColors.stoxText
                        )),
                        selected: isSelected,
                        selectedTileColor: AppColors.stoxPrimary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        dense: true,
                        onTap: () => setState(() => _selectedCategoryIndex = index),
                      );
                    }).toList(),
                    
                    const Divider(height: 32),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(AppLocalizations.of(context)!.stockOperationLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxSubText)), // 操作
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.edit, size: 20, color: AppColors.stoxText),
                      title: Text(AppLocalizations.of(context)!.stockAddByTextInput, style: const TextStyle(fontSize: 14)), // 文字入力で追加
                      dense: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => IngredientAddModal(
                            title: AppLocalizations.of(context)!.stockAddTitle, // 在庫を追加
                            targetStatus: IngredientStatus.stock,
                            onSaved: () {
                              ref.invalidate(stockViewModelProvider);
                            },
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.mic, size: 20, color: AppColors.stoxText),
                      title: Text(AppLocalizations.of(context)!.stockAddByVoice, style: const TextStyle(fontSize: 14)), // 音声入力で追加
                      dense: true,
                      onTap: () async {
                         await showModalBottomSheet(
                           context: context, 
                           isScrollControlled: true,
                           backgroundColor: Colors.transparent,
                           builder: (context) => const VoiceShoppingModal(targetStatus: IngredientStatus.stock),
                         );
                         ref.invalidate(stockViewModelProvider);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera, size: 20, color: AppColors.stoxText),
                      title: Text(AppLocalizations.of(context)!.stockAddByPhoto, style: const TextStyle(fontSize: 14)), // 写真撮影で追加
                      dense: true,
                      onTap: _onPhotoBtnTap,
                    ),
                    
                    const Divider(height: 32),

                    // Selection Mode Toggle
                    ListTile(
                      leading: Icon(_isSelectionMode ? Icons.close : Icons.delete_outline, 
                          size: 20, color: _isSelectionMode ? AppColors.stoxText : Colors.red),
                      title: Text(_isSelectionMode ? AppLocalizations.of(context)!.stockCancelSelection : AppLocalizations.of(context)!.stockDeleteItems, // 選択をキャンセル : 商品を選んで削除する
                          style: TextStyle(fontSize: 14, color: _isSelectionMode ? AppColors.stoxText : Colors.red)),
                      dense: true,
                      onTap: _toggleSelectionMode,
                    ),
                    
                    if (_isSelectionMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: _selectedItemIds.isEmpty ? null : _deleteSelectedItems,
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: Text(AppLocalizations.of(context)!.stockDeleteButtonLabel(_selectedItemIds.length)), // 削除する ({count})
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Right Column: Content
        Expanded(
          child: stateAvg.when(
            data: (items) {
              final filteredItems = _filterItems(items);
              
              return Column(
                children: [
                  if (filteredItems.isNotEmpty) _buildListHeader(),
                  Expanded(
                    child: filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            _isSearching
                              ? AppLocalizations.of(context)!.stockNoSearchResults // 検索結果がありません
                              : AppLocalizations.of(context)!.stockEmptyDescription, // 家の中にある\n「買ったもの」「もらったもの」\nを登録して見る場所です。
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.stoxText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.6,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredItems.length,
                          separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.stoxBorder),
                          itemBuilder: (context, index) {
                            return _buildListItem(filteredItems[index]);
                          },
                        ),
                  ),
                  _buildFooter(items),
                ],
              );
            },
            error: (err, st) => Center(child: Text('Error: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
        
        if (_isAnalyzing)
           const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildHeader(List<Ingredient> items) {
    if (_isSelectionMode) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.stockSelectedCount(_selectedItemIds.length), // {count}件選択中
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText),
            ),
            TextButton(
              onPressed: _toggleSelectionMode,
              child: Text(AppLocalizations.of(context)!.actionCancel, style: const TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold)), // キャンセル
            )
          ],
        ),
      );
    }

    // Mobile Header
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.stoxPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2, color: AppColors.stoxPrimary, size: 22),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.stockTitle, // 在庫一覧
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                  ),
                  const Text(
                    'INVENTORY LIST',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxAccent, letterSpacing: 1.0),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              HelpIcon(
                title: AppLocalizations.of(context)!.stockHelpTitle, // 在庫一覧画面
                description: AppLocalizations.of(context)!.stockHelpDescription, // 家にある食材や日用品の在庫を確認する画面です。個数や賞味期限の確認ができます
              ),
            ],
          ),
          Row(
            children: [
              CircleActionButton(
                icon: Icons.search,
                backgroundColor: Colors.white,
                contentColor: items.isEmpty ? Colors.grey : (_isSearching ? AppColors.stoxPrimary : AppColors.stoxSubText),
                borderColor: items.isEmpty ? Colors.grey.withOpacity(0.3) : AppColors.stoxBorder,
                onTap: items.isEmpty ? null : () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchQuery = '';
                      _searchController.clear();
                    }
                  });
                },
              ),
               
               const SizedBox(width: 8),
               CircleActionButton(
                 icon: Icons.menu,
                 backgroundColor: Colors.white,
                 contentColor: AppColors.stoxSubText,
                 borderColor: AppColors.stoxBorder,
                 onTap: _toggleMenu, 
               ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      key: const ValueKey('searchBar'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 44, // Match approx height of filter bars
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.stoxBorder),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.stoxSubText, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: false, // Don't autofocus in tablet split view to avoid keyboard popup immediately
              style: const TextStyle(fontSize: 14, color: AppColors.stoxText),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchPlaceholder,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Icon(Icons.close, color: Colors.grey, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final categories = [
      AppLocalizations.of(context)!.categoryAll,
      AppLocalizations.of(context)!.categoryVegetablesFruits,
      AppLocalizations.of(context)!.categoryMeatFish,
      AppLocalizations.of(context)!.categoryDairy,
      AppLocalizations.of(context)!.categorySeasoning,
    ];
    return Padding(
      key: const ValueKey('filterBar'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(categories.length, (index) {
            final cat = categories[index];
            final isSelected = _selectedCategoryIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => setState(() => _selectedCategoryIndex = index),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.stoxPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? null : Border.all(color: AppColors.stoxBorder),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)],
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.stoxSubText,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.stoxBackground.withOpacity(0.9), // or stoxBannerBg
      child: Row(
        children: [
          SizedBox(width: 24, child: Text(AppLocalizations.of(context)!.stockHeaderType, textAlign: TextAlign.center, style: _headerStyle)),
          Expanded(child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(AppLocalizations.of(context)!.stockHeaderName, style: _headerStyle))),
          SizedBox(width: 50, child: Text(AppLocalizations.of(context)!.stockHeaderDate, textAlign: TextAlign.right, style: _headerStyle)),
          SizedBox(width: 48, child: Text(AppLocalizations.of(context)!.stockHeaderAmount, textAlign: TextAlign.right, style: _headerStyle)),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxSubText); 

  Widget _buildListItem(Ingredient item) {
    // Icon mapping logic
    IconData iconData;
    Color iconColor;
    
    if (item.category.contains('肉') || item.category.contains('魚')) {
      iconData = Icons.restaurant;
      iconColor = AppColors.stoxPrimary.withOpacity(0.7);
    } else if (item.category.contains('野菜')) {
      iconData = Icons.eco;
      iconColor = AppColors.stoxSubText.withOpacity(0.7); 
    } else if (item.category.contains('乳') || item.category.contains('卵') || item.name.contains('たまご')) {
      iconData = Icons.egg; 
      iconColor = AppColors.stoxPrimary.withOpacity(0.7);
    } else if (item.category.contains('水') || item.category.contains('飲料')) {
      iconData = Icons.water_drop;
      iconColor = Colors.blue.withOpacity(0.7); 
    } else {
      iconData = Icons.kitchen;
      iconColor = AppColors.stoxSubText.withOpacity(0.7);
    }

    // Amount color
    // Normal = stoxSubText, Low = stoxPrimary (Orange)
    Color amountColor = AppColors.stoxSubText;
    if (item.amount <= 0.3) { 
      amountColor = AppColors.stoxPrimary;
    }

    final isSelected = _selectedItemIds.contains(item.id);

    return InkWell( // Make whole row tapable for selection?
      onTap: _isSelectionMode ? () => _toggleItemSelection(item.id) : null,
      child: Container(
        color: _isSelectionMode && isSelected ? AppColors.stoxPrimary.withOpacity(0.1) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (_isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (val) => _toggleItemSelection(item.id),
                    activeColor: AppColors.stoxPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),

            SizedBox(
              width: 24, 
              child: Icon(iconData, size: 18, color: iconColor),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  item.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                _formatDate(item.expiryDate),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _isExpiredOrClose(item.expiryDate) ? Colors.red : AppColors.stoxSubText, // Red for expiry is standard
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: Text(
                '${_formatAmount(item.amount)}${item.unit}',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: amountColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    }
    return amount.toString();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    
    final diff = target.difference(today).inDays;
    if (diff == 0) return AppLocalizations.of(context)!.dateToday;
    if (diff == 1) return AppLocalizations.of(context)!.dateTomorrow;

    return DateFormat('MM.dd').format(date);
  }

  bool _isExpiredOrClose(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays <= 3;
  }

  Widget _buildFooter(List<Ingredient> allItems) {
    final total = allItems.length;
    final expiredCount = allItems.where((i) => _isExpiredOrClose(i.expiryDate)).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.shoppingTotalItemsLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxSubText, letterSpacing: 1.2)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: AppLocalizations.of(context)!.stockTotalItems(total.toInt()), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
                if (expiredCount > 0)
                  TextSpan(text: AppLocalizations.of(context)!.stockExpiredCount(expiredCount), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Ingredient> _filterItems(List<Ingredient> items) {
    // Filter by search query if searching
    if (_isSearching) {
      if (_searchQuery.isEmpty) return items;
      return items.where((item) => item.name.contains(_searchQuery)).toList();
    }

    // Otherwise filter by category
    // Otherwise filter by category
    if (_selectedCategoryIndex == 0) return items;
    
    return items.where((item) {
      if (_selectedCategoryIndex == 1) return item.category.contains('野菜') || item.category.contains('果物');
      if (_selectedCategoryIndex == 2) return item.category.contains('肉') || item.category.contains('魚');
      if (_selectedCategoryIndex == 3) return item.category.contains('乳') || item.category.contains('卵') || item.category.contains('ヨーグルト');
      if (_selectedCategoryIndex == 4) return item.category.contains('調味料') || item.category.contains('香辛料');
      return false; 
    }).toList();
  }

  Widget _buildMenuButton(IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.stoxBorder),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.stoxPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155), // slate-700
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _onPhotoBtnTap() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024);
      if (photo == null) return;

      if (!mounted) return;

      // Navigate to location selection screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoStockLocationScreen(imageFile: photo),
        ),
      );
      
      if (result == true) {
        // Refresh? StockViewModel usually watches stream so it might auto-refresh if repo saves to DB.
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorOccurred(e))),
      );
    }
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
