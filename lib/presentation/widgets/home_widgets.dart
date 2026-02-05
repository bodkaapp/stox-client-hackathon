import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/ingredient.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/shopping_viewmodel.dart';
import '../viewmodels/recipe_book_viewmodel.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import '../screens/shopping_receipt_result_screen.dart';
import '../mixins/ad_manager_mixin.dart';
import '../mixins/receipt_scanner_mixin.dart';
import 'dart:io';
import 'help_icon.dart';
import 'challenge_stamp/challenge_stamp_dialog.dart';


// --- Home Header ---
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationStreamProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push('/account_settings'),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.stoxPrimary),
                  ),
                  child: const Icon(Icons.person, color: AppColors.stoxPrimary, size: 20),
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
              const SizedBox(width: 8),
              const SizedBox(width: 8),
              HelpIcon(
                title: AppLocalizations.of(context)!.homeHelpTitle,
                description: AppLocalizations.of(context)!.homeHelpDescription,
              ),
            ],
          ),
          Row(
            children: [
              // Challenge Stamp Icon
              _buildHeaderIconButton(
                Icons.verified, // Or custom trophy icon
                () {
                  showDialog(
                    context: context,
                    builder: (context) => const ChallengeStampDialog(),
                  );
                },
                color: AppColors.stoxPrimary,
              ),
              const SizedBox(width: 8),

                  _buildHeaderIconButton(Icons.photo_library, () => context.push('/photo_gallery')),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      _buildHeaderIconButton(Icons.notifications, () => context.push('/notifications')),
                  if (notificationsAsync.value?.any((n) => !n.isRead) ?? false)
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
    );
  }

  Widget _buildHeaderIconButton(IconData icon, VoidCallback onPressed, {Color? color}) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 24, color: color ?? Colors.black54),
        onPressed: onPressed,
      ),
    );
  }
}

// --- Today's Menu Card ---
class TodaysMenuCard extends ConsumerWidget {
  const TodaysMenuCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysMenuAsync = ref.watch(todaysMenuProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: todaysMenuAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant, color: AppColors.stoxPrimary, size: 20),
                        SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.homeTodaysMenu,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push('/recipe_book'),
                      child: Text(
                        AppLocalizations.of(context)!.homeRegisterMenu,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.stoxBorder),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.no_food, color: AppColors.stoxSubText, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.homeNoMenuPlan,
                        style: const TextStyle(fontSize: 12, color: AppColors.stoxSubText),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final recipe = recipes.first;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant, color: AppColors.stoxPrimary, size: 20),
                      SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.homeTodaysMenu,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/menu_plan'),
                    child: Text(
                      AppLocalizations.of(context)!.homeChangeMenu,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.stoxPrimary),
                    ),
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
                      child: (recipe.ogpImageUrl.isNotEmpty)
                          ? Image.network(
                              recipe.ogpImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.restaurant_menu, size: 48, color: AppColors.stoxPrimary)),
                            )
                          : const Center(child: Icon(Icons.restaurant_menu, size: 48, color: AppColors.stoxPrimary)),
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
                                Text(
                                  recipe.title,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 28,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context.push('/recipe_book'); 
                                },
                                icon: const Icon(Icons.visibility, size: 14, color: Colors.white),
                                label: Text(AppLocalizations.of(context)!.homeViewRecipe, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
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
          );
        },
        loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
        error: (err, stack) => const SizedBox.shrink(),
      ),
    );
  }
}

// --- Shopping Banner ---
class ShoppingBanner extends ConsumerWidget {
  const ShoppingBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(homeViewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: stateAsync.when(
        data: (state) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.stoxBannerBg, // Changed from hardcoded orange tint
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
                          Text(AppLocalizations.of(context)!.homeShoppingList, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
                          const SizedBox(width: 4),
                          Text('${state.shoppingList.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary, height: 1)),
                          Text(AppLocalizations.of(context)!.unitItems, style: const TextStyle(fontSize: 10, color: AppColors.stoxText)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(AppLocalizations.of(context)!.homeShoppingAd, style: const TextStyle(fontSize: 10, color: AppColors.stoxSubText)),
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
                child: Text(AppLocalizations.of(context)!.homeViewFlyer, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

// --- Home Action Grid ---
class HomeActionGrid extends ConsumerStatefulWidget {
  const HomeActionGrid({super.key});

  @override
  ConsumerState<HomeActionGrid> createState() => _HomeActionGridState();
}

class _HomeActionGridState extends ConsumerState<HomeActionGrid> with AdManagerMixin, ReceiptScannerMixin {
  
  @override
  void initState() {
    super.initState();
    loadRewardedAd();
  }

  Future<void> _handleScan() async {
     final homeState = await ref.read(homeViewModelProvider.future);
     final currentList = homeState.shoppingList;
     await startReceiptScanFlow(currentContextList: currentList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.5,
        children: [
          _buildActionCard(Icons.inventory_2, AppLocalizations.of(context)!.actionCheckStock, Colors.green.shade50, Colors.green.shade600, () => context.push('/stock')),
          _buildActionCard(Icons.receipt_long, AppLocalizations.of(context)!.actionScanReceipt, Colors.blue.shade50, Colors.blue.shade600, () => _handleScan()),
          _buildActionCard(Icons.shopping_basket, AppLocalizations.of(context)!.actionShoppingMode, Colors.orange.shade50, Colors.orange.shade600, () {
             ref.read(shoppingViewModelProvider.notifier).startShopping();
             context.push('/shopping');
          }),
          _buildActionCard(Icons.menu_book, AppLocalizations.of(context)!.actionRecipeBook, Colors.purple.shade50, Colors.purple.shade600, () {
             context.push('/recipe_book');
          }),
          _buildActionCard(Icons.camera_alt, AppLocalizations.of(context)!.actionFoodCamera, Colors.pink.shade50, Colors.pink.shade600, () {
             context.push('/food_camera');
          }),
          _buildActionCard(Icons.photo_library, AppLocalizations.of(context)!.actionPhotoGallery, Colors.cyan.shade50, Colors.cyan.shade600, () {
             context.push('/photo_gallery');
          }),
        ],
      ),
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
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
          ],
        ),
      ),
    );
  }
}

// --- Expiring Items List ---
class ExpiringItemsList extends ConsumerWidget {
  const ExpiringItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(homeViewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: stateAsync.when(
        data: (state) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notification_important, color: Colors.red, size: 20),
                    SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.homeExpiringSoon,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                    ),
                  ],
                ),
                Text(
                  AppLocalizations.of(context)!.homeViewAll,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxPrimary),
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
              ? Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(AppLocalizations.of(context)!.homeNoExpiringItems)))
              : Column(
                children: state.expiringIngredients.map((item) {
                   final daysLeft = item.expiryDate?.difference(DateTime.now()).inDays ?? 0;
                   Color badgeBg = Colors.grey.shade100;
                   Color badgeText = Colors.grey;
                   String badgeLabel = AppLocalizations.of(context)!.statusCheck;
                   IconData icon = Icons.info;
                   Color iconColor = Colors.grey;

                   if (daysLeft <= 0) {
                     badgeBg = Colors.red.shade100;
                     badgeText = Colors.red;
                     badgeLabel = AppLocalizations.of(context)!.statusUrgent;
                     icon = Icons.priority_high;
                     iconColor = Colors.red;
                   } else if (daysLeft <= 3) {
                     badgeBg = Colors.orange.shade100;
                     badgeText = Colors.orange;
                     badgeLabel = AppLocalizations.of(context)!.statusWarning;
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
                                   '${item.expiryDate?.month}/${item.expiryDate?.day} (${AppLocalizations.of(context)!.daysRemaining(daysLeft)})',
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
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
