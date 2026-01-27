import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../providers/shopping_mode_provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/shopping_viewmodel.dart'; // For real shopping count if needed, or pass via HomeState

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF8), // background-light
      body: SafeArea(
        child: stateAsync.when(
          data: (state) => CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            child: const Icon(Icons.person, color: AppColors.stoxPrimary, size: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.stoxPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'STOX',
                            style: TextStyle(
                              color: AppColors.stoxPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeaderIconButton(Icons.search, () {}),
                          const SizedBox(width: 4),
                          Stack(
                            children: [
                              _buildHeaderIconButton(Icons.notifications, () {}),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFFCFAF8), width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Today's Menu Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.restaurant, color: AppColors.stoxPrimary, size: 20),
                              SizedBox(width: 4),
                              Text(
                                '今日の献立',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                              ),
                            ],
                          ),
                          const Text(
                            '変更',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.stoxPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD6D3D1)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            Container(
                              width: 128,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF7ED), // Orange-50
                              ),
                              child: const Center(child: Icon(Icons.restaurant_menu, size: 48, color: AppColors.stoxPrimary)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '和風ハンバーグ定食',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _buildMetaTag(Icons.schedule, '20分'),
                                            const SizedBox(width: 8),
                                            _buildMetaTag(Icons.bolt, '342kcal'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 28,
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                                        label: const Text('URL/AIでレシピ登録', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.stoxPrimary,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Shopping Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF3E7), // bg-[#fdf3e7]
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.stoxPrimary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.stoxPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('買うもの', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
                                    const SizedBox(width: 4),
                                    Text('${state.shoppingList.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary, height: 1)),
                                    const Text('件', style: TextStyle(fontSize: 10, color: AppColors.stoxText)),
                                  ],
                                ),
                                const Text('近所のスーパーで特売中！', style: TextStyle(fontSize: 10, color: AppColors.stoxSubText)),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/flyer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.stoxPrimary,
                            elevation: 0,
                            side: BorderSide(color: AppColors.stoxPrimary.withOpacity(0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            minimumSize: const Size(0, 32),
                          ),
                          child: const Text('チラシを見る', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.5, // Adjust for horizontal rect shape
                    children: [
                      _buildActionCard(Icons.inventory_2, '在庫チェック', Colors.green.shade50, Colors.green.shade600, () => context.push('/stock')),
                      _buildActionCard(Icons.receipt_long, 'レシート登録', Colors.blue.shade50, Colors.blue.shade600, () {
                        // Mock Receipt Scan
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt Scanning Mock')));
                      }),
                      _buildActionCard(Icons.shopping_basket, '買い物モード', Colors.orange.shade50, Colors.orange.shade600, () {
                         // Start Shopping Mode via logic
                         ref.read(shoppingViewModelProvider.notifier).startShopping();
                         context.push('/shopping');
                      }),
                      _buildActionCard(Icons.menu_book, 'マイレシピ帳', Colors.purple.shade50, Colors.purple.shade600, () {
                         context.push('/recipe_book');
                      }),
                    ],
                  ),
                ),
              ),

              // Expiring Items
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.notification_important, color: Colors.red, size: 20),
                              SizedBox(width: 4),
                              Text(
                                '賞味期限が近いもの',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                              ),
                            ],
                          ),
                          const Text(
                            'すべて見る',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.stoxBorder),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: state.expiringIngredients.isEmpty 
                        ? const Padding(padding: EdgeInsets.all(16), child: Center(child: Text('賞味期限切れはありません')))
                        : Column(
                          children: state.expiringIngredients.map((item) {
                             // Logic to determine urgency color
                             // For now using mock/random or based on real expiry calc
                             final daysLeft = item.expiryDate?.difference(DateTime.now()).inDays ?? 0;
                             Color badgeBg = Colors.grey.shade100;
                             Color badgeText = Colors.grey;
                             String badgeLabel = '確認';
                             IconData icon = Icons.info;
                             Color iconColor = Colors.grey;

                             if (daysLeft <= 0) {
                               badgeBg = Colors.red.shade100;
                               badgeText = Colors.red;
                               badgeLabel = '緊急';
                               icon = Icons.priority_high;
                               iconColor = Colors.red;
                             } else if (daysLeft <= 3) {
                               badgeBg = Colors.orange.shade100;
                               badgeText = Colors.orange;
                               badgeLabel = '注意';
                               icon = Icons.warning;
                               iconColor = Colors.orange;
                             }

                             return Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                               decoration: const BoxDecoration(
                                 border: Border(bottom: BorderSide(color: Color(0xFFF2E9DE), width: 1)),
                               ),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     children: [
                                       Icon(icon, color: iconColor, size: 20),
                                       const SizedBox(width: 12),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
                                           Text(
                                             '${item.expiryDate?.month}/${item.expiryDate?.day} (あと${daysLeft}日)',
                                             style: const TextStyle(fontSize: 10, color: AppColors.stoxSubText),
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                   Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                     decoration: BoxDecoration(
                                       color: badgeBg,
                                       borderRadius: BorderRadius.circular(99),
                                     ),
                                     child: Text(badgeLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeText)),
                                   ),
                                 ],
                               ),
                             );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
          error: (err, stack) => Center(child: Text('Error: $err')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.transparent, // or hover color
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20, color: Colors.black54), // black/5 equivalent
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.stoxSubText),
        const SizedBox(width: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.stoxSubText)),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String label, Color bg, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.stoxBorder),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1)),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
          ],
        ),
      ),
    );
  }
}
