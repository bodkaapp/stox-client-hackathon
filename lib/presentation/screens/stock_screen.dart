import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../viewmodels/stock_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import 'ai_analyzed_stock_screen.dart';
import 'photo_stock_location_screen.dart';
import 'dart:typed_data';
import '../widgets/ingredient_add_modal.dart';
import '../components/circle_action_button.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  String _selectedCategory = 'すべて';
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
        title: const Text('本当に削除してもいいですか？', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除します', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
        content: Text('${idsToDelete.length}件を削除しました'),
        action: SnackBarAction(
          label: 'やっぱり元に戻す',
          onPressed: () async {
            // Confirm restore
            final shouldRestore = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('削除した商品を元に戻しますか？', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('キャンセル', style: TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('元に戻す', style: TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );

            if (shouldRestore == true) {
              await ref.read(stockViewModelProvider.notifier).restoreItems(itemsToDelete);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('商品を元に戻しました')),
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
        child: Stack(
          children: [
            Column(
              children: [
                stateAvg.when(
                  data: (items) => _buildHeader(items),
                  loading: () => _buildHeader([]), // Show header even while loading, empty items
                  error: (_, __) => _buildHeader([]),
                ),
                
                // Hide filter/search bar in selection mode to avoid clutter or confusion?
                // Or maybe keep it to allow filtering while selecting? 
                // Usually keeping it is fine.
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
                                      ? '検索結果がありません'
                                      : '家の中にある\n「買ったもの」「もらったもの」\nを登録して見る場所です。',
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
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 160), // Increased padding for FAB/Footer
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
                      color: const Color(0xB3000000), // Darker overlay like X or design
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
                  // Hide guide in selection mode
                  if (_isSelectionMode) return const SizedBox.shrink();

                  // Hide guide if menu is open
                  if (_isMenuOpen) return const SizedBox.shrink();

                  // Only show guide if total items are empty, not just filtered results
                  // But request says "If registered stock data is empty".
                  if (items.isNotEmpty) return const SizedBox.shrink();
                  
                  return Positioned(
                    bottom: 100, // Adjust position to be above FAB
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.stoxPrimary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: const Text(
                              'ここをタップして在庫を追加します',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          CustomPaint(
                            size: const Size(12, 6),
                            painter: _TrianglePainter(color: AppColors.stoxPrimary),
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
                bottom: _isMenuOpen ? 90 : 20, // Moves up when open
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
                          '買い物リストへ追加する', 
                          onTap: () {
                            print('Add to shopping list');
                            _toggleMenu();
                          }
                        ),
                        const SizedBox(height: 12),
                        _buildMenuButton(
                          Icons.edit, 
                          '文字を入力して在庫を追加', 
                          onTap: () {
                            _toggleMenu();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => IngredientAddModal(
                                title: '在庫を追加',
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
                          Icons.photo_camera, 
                          '写真を撮影して在庫を追加', 
                          onTap: () {
                             _toggleMenu();
                             _onPhotoBtnTap();
                          }
                        ),
                        const SizedBox(height: 12),
                        // New: Select and Delete
                        _buildMenuButton(
                          Icons.delete_outline,
                          '商品を選んで削除する',
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
                          color: Colors.red, // Match delete button color
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Text(
                          'ここをタップして削除します',
                          style: TextStyle(
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
                bottom: 24, // Adjust based on footer height or desired position
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
                         turns: _isMenuOpen ? 0.125 : 0, // 45 degrees rotation
                         duration: const Duration(milliseconds: 200),
                         child: const Icon(Icons.add, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(List<Ingredient> items) {
    // Disable search if no items
    final bool isEmpty = items.isEmpty;
    
    // In selection mode, header changes? 
    // Maybe show "X selected" and "Cancel" button on right.
    if (_isSelectionMode) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedItemIds.length}件選択中',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText),
            ),
            TextButton(
              onPressed: _toggleSelectionMode,
              child: const Text('キャンセル', style: TextStyle(color: AppColors.stoxPrimary, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }

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
                children: const [
                  Text(
                    '在庫一覧',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                  ),
                  Text(
                    'INVENTORY LIST',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary, letterSpacing: 1.0),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              CircleActionButton(
                icon: Icons.search,
                backgroundColor: Colors.white,
                contentColor: isEmpty ? Colors.grey : (_isSearching ? AppColors.stoxPrimary : AppColors.stoxSubText),
                borderColor: isEmpty ? Colors.grey.withOpacity(0.3) : AppColors.stoxBorder,
                onTap: isEmpty ? null : () {
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
                 onTap: _toggleMenu, // Add onTap here to make it work! The previous code didn't have onTap on menu button?
                 // Wait, previous code:
                 //  CircleActionButton(icon: Icons.menu, ...),
                 // It did not assign _toggleMenu to onTap. It was missing!
                 // The 'search' button had onTap but 'menu' button didn't in previous step?
                 // Let's check history...
                 // Yes, "CircleActionButton(icon: Icons.menu, ...)," no onTap.
                 // So the menu button wasn't working before? The user said "Next, tap the hamburger menu next to it...".
                 // Assuming I need to fix it now.
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
              autofocus: true,
              style: const TextStyle(fontSize: 14, color: AppColors.stoxText),
              decoration: const InputDecoration(
                hintText: '在庫を検索...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
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
    final categories = ['すべて', '野菜・果物', '肉・魚', '乳製品', '調味料'];
    return Padding(
      key: const ValueKey('filterBar'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = cat),
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
        children: const [
          SizedBox(width: 24, child: Text('類', textAlign: TextAlign.center, style: _headerStyle)),
          Expanded(child: Padding(padding: EdgeInsets.only(left: 8), child: Text('品名', style: _headerStyle))),
          SizedBox(width: 50, child: Text('期限', textAlign: TextAlign.right, style: _headerStyle)),
          SizedBox(width: 48, child: Text('残量', textAlign: TextAlign.right, style: _headerStyle)),
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
    if (diff == 0) return '今日';
    if (diff == 1) return '明日';

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
    // If filtering/searching, footer should maybe react?
    // Leaving as is for now.
    
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
          const Text('TOTAL ITEMS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxSubText, letterSpacing: 1.2)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '全 $total 品目', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
                if (expiredCount > 0)
                  TextSpan(text: '  ● ${expiredCount}品期限間近', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
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
    if (_selectedCategory == 'すべて') return items;
    
    return items.where((item) {
      if (_selectedCategory == '野菜・果物') return item.category.contains('野菜') || item.category.contains('果物');
      if (_selectedCategory == '肉・魚') return item.category.contains('肉') || item.category.contains('魚');
      if (_selectedCategory == '乳製品') return item.category.contains('乳') || item.category.contains('卵') || item.category.contains('ヨーグルト');
      if (_selectedCategory == '調味料') return item.category.contains('調味料') || item.category.contains('香辛料');
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
        SnackBar(content: Text('エラーが発生しました: $e')),
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
