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
  final ImagePicker _picker = ImagePicker();

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
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
                _buildHeader(),
                _buildFilterBar(),
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
                                    '家の中にある\n「買ったもの」「もらったもの」\nを登録して見る場所です。',
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
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 160), // Increased padding for FAB
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
                  final filteredItems = _filterItems(items);
                  if (filteredItems.isNotEmpty) return const SizedBox.shrink();
                  
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
                      ],
                    ),
                  ),
                ),
              ),

            // FAB
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

  Widget _buildHeader() {
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
                contentColor: AppColors.stoxSubText,
                borderColor: AppColors.stoxBorder,
              ),
               // Second button 'Menu' from design code.html is actually a 'Menu' icon, not search. 
               // In original code it was "search" and "add". 
               // In code.html it is "search" (left) and "menu" (right). 
               // The user request said "Remove the bottom + button" and replace with FAB. 
               // But usually we keep search? 
               // Let's look at code.html header:
               // <div class="flex gap-2">
               // <button ...> <span ...>search</span> </button>
               // <button ...> <span ...>menu</span> </button>
               // </div>
               // So I should probably add the Menu button back if I want to match design, 
               // OR just keep Search. The user didn't explicitly ask for "Menu" button, but implied "Stock Screen ... changes ... refer to code.html".
               // Let's add the Menu button to match code.html.
               const SizedBox(width: 8),
               CircleActionButton(
                 icon: Icons.menu,
                 backgroundColor: Colors.white,
                 contentColor: AppColors.stoxSubText,
                 borderColor: AppColors.stoxBorder,
               ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildFilterBar() {
    final categories = ['すべて', '野菜・果物', '肉・魚', '乳製品', '調味料'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    
    // Using stox colors. 
    // Veggies -> Green in original, now try to use stoxSubText (Brown/Neutral) or stoxPrimary (Orange)
    // Actually standard Colors.* are okay to use if strictly necessary for meaning (e.g. Red for danger), 
    // but for brands, let's stick to stoxSubText for "normal" categories and stoxPrimary for "meat/main".
    // Or just use stoxPrimary for all icons to be uniform?
    // Let's use stoxPrimary for Meat, stoxSubText for Veggies to differentiate slightly.
    
    if (item.category.contains('肉') || item.category.contains('魚')) {
      iconData = Icons.restaurant;
      iconColor = AppColors.stoxPrimary.withOpacity(0.7);
    } else if (item.category.contains('野菜')) {
      iconData = Icons.eco;
      iconColor = AppColors.stoxSubText.withOpacity(0.7); // Veggies = Earth/Brownish
    } else if (item.category.contains('乳') || item.category.contains('卵') || item.name.contains('たまご')) {
      iconData = Icons.egg; 
      iconColor = AppColors.stoxPrimary.withOpacity(0.7);
    } else if (item.category.contains('水') || item.category.contains('飲料')) {
      iconData = Icons.water_drop;
      iconColor = Colors.blue.withOpacity(0.7); // Keep blue for water as it's universal
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

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
