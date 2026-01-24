import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../viewmodels/stock_viewmodel.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  String _selectedCategory = 'すべて';

  @override
  Widget build(BuildContext context) {
    final stateAvg = ref.watch(stockViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterBar(),
            Expanded(
              child: stateAvg.when(
                data: (items) {
                  final filteredItems = _filterItems(items);
                  
                  return Column(
                    children: [
                      _buildListHeader(),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
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
              _buildCircleButton(Icons.search, Colors.white, AppColors.stoxSubText, border: AppColors.stoxBorder),
              const SizedBox(width: 8),
              // Updated to Orange as requested (stoxPrimary)
              _buildCircleButton(Icons.add, AppColors.stoxPrimary, Colors.white, isAdd: true), 
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, Color bg, Color contentColor, {Color? border, bool isAdd = false}) {
    final actualBg = isAdd ? AppColors.stoxPrimary : bg;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: actualBg,
        shape: BoxShape.circle,
        border: border != null ? Border.all(color: border) : null,
        boxShadow: isAdd ? [
          BoxShadow(color: actualBg.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)) 
        ] : [
          const BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1))
        ],
      ),
      child: Icon(icon, color: contentColor, size: 20),
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
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print, size: 14, color: AppColors.stoxSubText),
                label: const Text('リスト出力', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stoxSubText)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.stoxBorder),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note, size: 18, color: AppColors.stoxPrimary),
                  label: const Text('編集する', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.stoxPrimary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                  label: const Text('買い物メモへ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.stoxPrimary,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
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
}
