import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/drift_ingredient_repository.dart';

// Local model for added items in this session
class AddedIngredientItem {
  final String name;
  final double quantity;
  final String category;

  AddedIngredientItem({required this.name, required this.quantity, required this.category});
}

class IngredientAddModal extends ConsumerStatefulWidget {
  final String title;
  final IngredientStatus targetStatus;
  final VoidCallback onSaved;

  const IngredientAddModal({
    super.key,
    required this.title,
    required this.targetStatus,
    required this.onSaved,
  });

  @override
  ConsumerState<IngredientAddModal> createState() => _IngredientAddModalState();
}

class _IngredientAddModalState extends ConsumerState<IngredientAddModal> {
  final List<AddedIngredientItem> _addedItems = [];
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  double _quantity = 1.0;

  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    // Auto-focus the name field when the modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _nameFocusNode.requestFocus();
    });
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      final repo = await ref.read(ingredientRepositoryProvider.future);
      final suggestions = await repo.getTopSuggestions(limit: 20);
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
        });
      }
    } catch (e) {
      debugPrint('Error loading suggestions: $e');
    }
  }


  void _addItem() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _addedItems.add(AddedIngredientItem(
        name: name,
        quantity: _quantity,
        category: _categoryController.text.trim(),
      ));
      // Reset inputs
      _nameController.clear();
      _categoryController.clear();
      _quantity = 1.0;
    });
  }

  void _onSuggestionTap(String suggestion) {
    _nameController.text = suggestion;
    // Optional: Auto-fill category if known? For now just set name.
  }

  Future<void> _saveItems() async {
    if (_addedItems.isEmpty) return;

    try {
      final repo = await ref.read(ingredientRepositoryProvider.future);
      
      final newIngredients = _addedItems.map((item) {
        // Simple ID generation using timestamp + random suffix/index to avoid collision
        final id = '${DateTime.now().millisecondsSinceEpoch}_${_addedItems.indexOf(item)}';
        
        return Ingredient(
          id: id,
          name: item.name,
          standardName: item.name, // Use same for now
          category: item.category.isNotEmpty ? item.category : 'その他',
          unit: '個', // Default unit
          amount: item.quantity,
          status: widget.targetStatus, 
          storageType: StorageType.fridge, // Default to fridge
          purchaseDate: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 7)), // Default +7 days
        );
      }).toList();

      await repo.saveAll(newIngredients);
      
      // Update usage history
      for (final item in _addedItems) {
        await repo.incrementInfoUsageCount(item.name);
      }
      
      // Execute callback (e.g. invalidate providers)
      widget.onSaved();
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fixed height: 50% of screen as requested to ensure it fits above keyboard
    final fixedHeight = MediaQuery.of(context).size.height * 0.5;

    return Container(
      height: fixedHeight,
      decoration: const BoxDecoration(
        color: AppColors.stoxBackground, // bg-cream approximation
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
           BoxShadow(color: Colors.black12, blurRadius: 40, offset: Offset(0, -8))
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          
          // List Area - Expanded to take up remaining space in the fixed 30% height
          Expanded(
            child: _addedItems.isEmpty 
              ? _buildEmptyState() 
              : _buildAddedList(),
          ),

          // Input Form - pinned at bottom
          _buildInputForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: Colors.transparent, // Or slight grey?
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: AppColors.stoxSubText, size: 24),
            ),
          ),
          
          // Title
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.stoxText),
              ),
              const SizedBox(height: 4),
              Container(
                width: 48, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.stoxPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          
          // Confirm Button
          InkWell(
            onTap: _saveItems,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.stoxPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '確定',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: const Text(
        '追加した材料がここに表示されます',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.stoxSubText, 
        ),
      ),
    );
  }

  Widget _buildAddedList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          color: AppColors.stoxBackground, // Sticky header look
          child: Row(
            children: const [
              Expanded(child: Text('材料名', style: _tableHeaderStyle)),
              SizedBox(width: 80, child: Text('数量', style: _tableHeaderStyle)),
              SizedBox(width: 80, child: Text('カテゴリ', textAlign: TextAlign.right, style: _tableHeaderStyle)),
            ],
          ),
        ),
        
        // List Item
        Flexible(
          child: ListView.separated(
            shrinkWrap: true, // Allow mainAxisSize min to work
            physics: const ClampingScrollPhysics(), // Scrollable when max height reached
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: _addedItems.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.stoxBorder),
            itemBuilder: (context, index) {
              final item = _addedItems[index];
              return Container(
                decoration: const BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxText)),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text('${item.quantity.toInt()}個', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))), 
                    ),
                    SizedBox(
                      width: 80,
                       // Mock logic for icon, consistent with stock_screen
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildCategoryIcon(item.category),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static const _tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.stoxSubText);

  Widget _buildCategoryIcon(String category) {
    IconData iconData = Icons.kitchen;
    Color iconColor = AppColors.stoxSubText;

    if (category.contains('肉') || category.contains('魚')) {
      iconData = Icons.restaurant;
      iconColor = AppColors.stoxPrimary;
    } else if (category.contains('野菜')) {
      iconData = Icons.eco;
      iconColor = AppColors.stoxGreen; 
    } else if (category.contains('水')) {
      iconData = Icons.water_drop;
      iconColor = Colors.blue;
    }

    return Icon(iconData, size: 18, color: iconColor.withOpacity(0.7));
  }


  Widget _buildInputForm() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.stoxBorder)),
        boxShadow: [
          BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Category & Quantity (simplified layout from design)
          Row(
            children: [
              // Category Input
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC), // slate-50
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'カテゴリ (任意)',
                      hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0x66948B7E)), // warmGray/40
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Quantity Stepper
              Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.stoxBorder),
                ),
                child: Row(
                  children: [
                     _buildStepperBtn(Icons.remove, () {
                       if (_quantity > 1) setState(() => _quantity--);
                     }),
                     SizedBox(
                       width: 32,
                       child: Text(
                         _quantity.toInt().toString(), 
                         textAlign: TextAlign.center,
                         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                       )
                     ),
                     _buildStepperBtn(Icons.add, () {
                       setState(() => _quantity++);
                     }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Name Input & Add Button
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC), 
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    textInputAction: TextInputAction.done, // Or 'go'
                    onEditingComplete: () {
                      _addItem();
                      // Keeping focus explicitly just in case, though overriding this callback usually prevents close.
                      _nameFocusNode.requestFocus(); 
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '材料名 (例: にんじん)',
                      hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0x66948B7E)),
                    ),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stoxText),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Add Button
              GestureDetector(
                onTap: _addItem,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: AppColors.stoxPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: AppColors.stoxPrimary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '追加',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Row 3: Suggestions
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _onSuggestionTap(s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), // slate-100
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      s,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stoxSubText),
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 4), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildStepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.stoxBorder),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Icon(icon, size: 20, color: AppColors.stoxSubText),
      ),
    );
  }
}
