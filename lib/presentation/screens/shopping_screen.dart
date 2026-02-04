import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../providers/shopping_mode_provider.dart';
import '../viewmodels/shopping_viewmodel.dart';
import '../widgets/ingredient_add_modal.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../mixins/ad_manager_mixin.dart';
import 'shopping_receipt_result_screen.dart';
import '../widgets/voice_shopping_modal.dart';
import '../mixins/receipt_scanner_mixin.dart';
import '../widgets/help_icon.dart';
import '../../domain/models/challenge_stamp.dart'; // [NEW]
import '../viewmodels/challenge_stamp_viewmodel.dart'; // [NEW]

class ShoppingScreen extends ConsumerStatefulWidget {
  final bool openAddModal;

  const ShoppingScreen({super.key, this.openAddModal = false});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> with AdManagerMixin, ReceiptScannerMixin {
  bool _isMenuOpen = false;
  bool _isAnalyzing = false;
  // final ImagePicker _picker = ImagePicker(); // Removed

  @override
  void initState() {
    super.initState();
    loadRewardedAd();
    
    if (widget.openAddModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddIngredientModal();
      });
    }
  }

  @override
  void didUpdateWidget(ShoppingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openAddModal && !oldWidget.openAddModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddIngredientModal();
      });
    }
  }

  Future<void> _showAddIngredientModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IngredientAddModal(
        title: '買い物リストに追加',
        targetStatus: IngredientStatus.toBuy,
        onSaved: () {
          ref.invalidate(shoppingViewModelProvider);
        },
      ),
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Future<void> _onReceiptBtnTap() async {
    // Close menu if open
    if (_isMenuOpen) {
      _toggleMenu();
    }
    
    try {
      // 1. Get current shopping list
      final shoppingState = await ref.read(shoppingViewModelProvider.future);
      final currentList = [...shoppingState.toBuyList, ...shoppingState.inCartList];

      // 2. Start Scan Flow
      await startReceiptScanFlow(currentContextList: currentList);
      
      // Note: We might want to ensure Shopping Mode is OFF? 
      // The button text says "お買い物モードを終わる" implies it should finish shopping mode?
      // But the logic before didn't explicitly finish checking out, it just did analysis.
      // If we want to finish shopping mode, we should do it.
      // Ref Code: "レシートを撮影する（お買い物モードを終わる）"
      // Let's ensure we are not in shopping mode? Or user manually toggles?
      // The UI says "(お買い物モードを終わる)". 
      // The previous implementation didn't seem to enforce it in _onReceiptBtnTap explicitly, 
      // but let's check. It seems it just did analysis.
      // I will leave it as is for now (just scanning logic).

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }

  // _analyzeReceipt removed as it is replaced by ReceiptScannerMixin

  @override
  Widget build(BuildContext context) {
    final isShoppingMode = ref.watch(shoppingModeProvider);
    final stateAsync = ref.watch(shoppingViewModelProvider);

    return PopScope(
      canPop: !isShoppingMode,
      child: Scaffold(
        backgroundColor: AppColors.stoxBackground,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 600) {
                return _buildTabletLayout(context, ref, stateAsync, isShoppingMode);
              }
              return _buildMobileLayout(context, ref, stateAsync, isShoppingMode);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, AsyncValue<ShoppingState> stateAsync, bool isShoppingMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Operations
        Container(
          width: 320, // Fixed width sidebar
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: AppColors.stoxBorder)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.stoxPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shopping_cart, color: AppColors.stoxPrimary, size: 22),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'お買い物',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                    ),
                    const SizedBox(width: 8),
                    const HelpIcon(
                      title: '買い物画面',
                      description: '買いたいものを管理する画面です。\n「＋」ボタンをタップして、買うものを登録できます。\n「お買い物モード」ボタンを押すと、お買い物を便利にするモードに切り替わります。\nお買い物が終わった後はレシートを撮影して、買ったものを在庫に移動することもできます。',
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Actions List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    const Text('アクション', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stoxSubText)),
                    const SizedBox(height: 8),
                    
                    ListTile(
                      leading: const Icon(Icons.edit, color: AppColors.stoxText),
                      title: const Text('買うものを入力', style: TextStyle(fontSize: 14)),
                      enabled: !isShoppingMode,
                      onTap: () {
                         _showAddIngredientModal();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.mic, color: AppColors.stoxText),
                      title: const Text('音声で入力', style: TextStyle(fontSize: 14)),
                      enabled: !isShoppingMode,
                      onTap: () async {
                         await showModalBottomSheet(
                           context: context, 
                           isScrollControlled: true,
                           backgroundColor: Colors.transparent,
                           builder: (context) => const VoiceShoppingModal(),
                         );
                         ref.invalidate(shoppingViewModelProvider);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt, color: AppColors.stoxText),
                      title: const Text('レシート撮影', style: TextStyle(fontSize: 14)),
                      enabled: !isShoppingMode,
                      onTap: _onReceiptBtnTap,
                    ),

                    const Divider(height: 32),

                    // Shopping Mode Toggle
                    InkWell(
                      onTap: () {
                        if (isShoppingMode) {
                          ref.read(shoppingViewModelProvider.notifier).finishShopping();
                        } else {
                          ref.read(shoppingViewModelProvider.notifier).startShopping();
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isShoppingMode ? AppColors.stoxPrimary.withOpacity(0.1) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isShoppingMode ? AppColors.stoxPrimary : Colors.transparent),
                        ),
                        child: Row(
                          children: [
                            Icon(isShoppingMode ? Icons.shopping_cart_checkout : Icons.shopping_basket, 
                                 color: isShoppingMode ? AppColors.stoxPrimary : AppColors.stoxText),
                            const SizedBox(width: 12),
                            Expanded(child: Text(
                              isShoppingMode ? 'お買い物モード中' : 'お買い物モードを開始',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isShoppingMode ? AppColors.stoxPrimary : AppColors.stoxText,
                              ),
                            )),
                            Switch(
                              value: isShoppingMode, 
                              onChanged: (val) {
                                if (val) {
                                  ref.read(shoppingViewModelProvider.notifier).startShopping();
                                } else {
                                  ref.read(shoppingViewModelProvider.notifier).finishShopping();
                                }
                              },
                              activeColor: AppColors.stoxPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    if (isShoppingMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await ref.read(shoppingViewModelProvider.notifier).completeShoppingFlow();
                            if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('お買い物を完了しました')));
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('買い物を完了する'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.stoxPrimary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Right Column: List
        Expanded(
          child: _buildCommonListArea(stateAsync, isShoppingMode),
        ),
        
        if (_isAnalyzing)
           const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, AsyncValue<ShoppingState> stateAsync, bool isShoppingMode) {
     // Check if list is empty for Bubble visibility (data might be loading but we use valueOrNull/maybeWhen)
    final allItems = stateAsync.valueOrNull != null 
        ? [...stateAsync.value!.toBuyList, ...stateAsync.value!.inCartList] 
        : <Ingredient>[];
    
    // Bubble should only show if loaded and empty (and not shopping mode)
    final showBubble = stateAsync.hasValue && allItems.isEmpty && !isShoppingMode && !_isMenuOpen;

    return Stack(
          children: [
            Column(
              children: [
                _buildHeader(ref, isShoppingMode),
                Expanded(
                  child: _buildCommonListArea(stateAsync, isShoppingMode),
                ),
              ],
            ),
            
            // Dimmed Background Overlay (Only when menu is open)
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
            if (showBubble)
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
                        child: const Text(
                          'ここをタップして材料を追加します',
                          style: TextStyle(
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
              ),

            // Menu Items (Only visible when !isShoppingMode and menu is open)
            if (!isShoppingMode)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                bottom: _isMenuOpen ? 100 : 20,
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
                          Icons.edit, 
                          '買うものを入力する', 
                          onTap: () {
                            _toggleMenu();
                            _showAddIngredientModal();
                          }
                        ),
                        const SizedBox(height: 12),
                        _buildMenuButton(
                          Icons.mic, 
                          '声で操作する', 
                          onTap: () async {
                             _toggleMenu();
                             await showModalBottomSheet(
                               context: context, 
                               isScrollControlled: true,
                               backgroundColor: Colors.transparent,
                               builder: (context) => const VoiceShoppingModal(),
                             );
                             // Refresh list after modal closes to show new items
                             ref.invalidate(shoppingViewModelProvider);
                          }
                        ),
                        const SizedBox(height: 12),
                        _buildMenuButton(
                          Icons.camera_alt, 
                          'レシートを撮影する（お買い物モードを終わる）', 
                          onTap: () {
                             _onReceiptBtnTap(); // Starts camera -> ad -> analysis
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // FAB or Complete Button
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: isShoppingMode
                  ? FloatingActionButton.extended(
                      onPressed: () async {
                        await ref.read(shoppingViewModelProvider.notifier).completeShoppingFlow();
                         if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('お買い物を完了しました')));
                            // [NEW] Challenge 5: Shopping Complete
                            ref.read(challengeStampViewModelProvider.notifier).complete(ChallengeType.shoppingComplete.id);
                         }
                      },
                      label: const Text('買い物を完了'),
                      icon: const Icon(Icons.check),
                      backgroundColor: AppColors.stoxPrimary,
                    )
                  : GestureDetector(
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

  Widget _buildCommonListArea(AsyncValue<ShoppingState> stateAsync, bool isShoppingMode) {
    return stateAsync.when(
      data: (state) {
        final currentItems = [...state.toBuyList, ...state.inCartList];
        
        return Column(
          children: [
            if (isShoppingMode && currentItems.isNotEmpty) _buildProgressBarSection(currentItems),
            Expanded(
              child: currentItems.isEmpty 
                ? Center(
                    child: Text(
                      '買い物リストを登録する場所です。\n買うものを忘れないように\nメモしておきましょう。',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.stoxText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 100), // Space for FAB
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(_buildCategorizedItems(ref, currentItems)),
                        ),
                      ),
                    ],
                  ),
            ),
            _buildFooter(currentItems),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
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

  Widget _buildFooter(List<Ingredient> allItems) {
    final total = allItems.length;

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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref, bool isShoppingMode) {
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
                child: const Icon(Icons.shopping_cart, color: AppColors.stoxPrimary, size: 22),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'お買い物',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.stoxText, height: 1.0),
                  ),
                  Text(
                    'SHOPPING LIST',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxAccent, letterSpacing: 1.0),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const HelpIcon(
                title: '買い物画面',
                description: '買いたいものを管理する画面です。\n「＋」ボタンをタップして、買うものを登録できます。\n「お買い物モード」ボタンを押すと、お買い物を便利にするモードに切り替わります。\nお買い物が終わった後はレシートを撮影して、買ったものを在庫に移動することもできます。',
              ),
            ],
          ),
          InkWell(
            onTap: () {
              if (isShoppingMode) {
                ref.read(shoppingViewModelProvider.notifier).finishShopping();
              } else {
                ref.read(shoppingViewModelProvider.notifier).startShopping();
              }
            },
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isShoppingMode 
                    ? AppColors.stoxPrimary.withOpacity(0.1) 
                    : AppColors.stoxSubText.withOpacity(0.05),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isShoppingMode ? AppColors.stoxPrimary : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isShoppingMode ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: isShoppingMode ? AppColors.stoxPrimary : AppColors.stoxSubText,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isShoppingMode ? 'お買い物モード ON' : 'お買い物モード OFF',
                    style: TextStyle(
                      color: isShoppingMode ? AppColors.stoxPrimary : AppColors.stoxSubText,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarSection(List<Ingredient> items) {
    final inBasketCount = items.where((i) => i.status == IngredientStatus.inCart).length;
    final totalCount = items.length;
    final progress = totalCount > 0 ? inBasketCount / totalCount : 0.0;
    final remaining = totalCount - inBasketCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'カゴの進捗',
                style: TextStyle(
                  color: AppColors.stoxText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$inBasketCount',
                      style: const TextStyle(
                        color: AppColors.stoxPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' / $totalCount 点',
                      style: const TextStyle(
                        color: AppColors.stoxText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.stoxBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.stoxPrimary,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'あと$remaining点でお買い物完了です',
            style: const TextStyle(
              color: AppColors.stoxSubText,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.stoxBorder, thickness: 0.5),
        ],
      ),
    );
  }

  List<Widget> _buildCategorizedItems(WidgetRef ref, List<Ingredient> items) {
    final Map<String, List<Ingredient>> categorized = {};
    for (var item in items) {
      final cat = item.category.isNotEmpty ? item.category : '未分類';
      categorized.putIfAbsent(cat, () => []).add(item);
    }

    final List<Widget> widgets = [];
    categorized.forEach((category, catItems) {
      widgets.add(_buildCategorySection(ref, category, catItems));
    });
    
    return widgets;
  }

  Widget _buildCategorySection(WidgetRef ref, String title, List<Ingredient> items) {
    Color barColor;
    switch (title) {
      case '野菜・果物':
      case '野菜・フルーツ':
        barColor = Colors.green;
        break;
      case '肉・魚':
        barColor = Colors.redAccent;
        break;
      case '調味料':
        barColor = Colors.amber.shade700;
        break;
      default:
        barColor = AppColors.stoxPrimary;
    }

    final checkedCount = items.where((i) => i.status == IngredientStatus.inCart).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.stoxText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$checkedCount/${items.length} 点',
                style: const TextStyle(
                  color: AppColors.stoxSubText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: items.map((item) => _buildShoppingItemRow(ref, item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingItemRow(WidgetRef ref, Ingredient item) {
    final isShoppingMode = ref.watch(shoppingModeProvider);
    final isChecked = item.status == IngredientStatus.inCart;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: isShoppingMode
            ? () {
                ref.read(shoppingViewModelProvider.notifier).toggleItemStatus(item);
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (isShoppingMode) ...[
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      ref.read(shoppingViewModelProvider.notifier).toggleItemStatus(item);
                    },
                    activeColor: AppColors.stoxPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(color: AppColors.stoxBorder, width: 2),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: isChecked ? AppColors.stoxText.withOpacity(0.5) : AppColors.stoxText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.stoxBackground,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.stoxBorder),
                ),
                child: Text(
                  '${item.amount % 1 == 0 ? item.amount.toInt() : item.amount}${item.unit}',
                  style: const TextStyle(
                    color: AppColors.stoxSubText,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
