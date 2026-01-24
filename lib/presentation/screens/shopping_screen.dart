import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../providers/shopping_mode_provider.dart';
import '../viewmodels/shopping_viewmodel.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShoppingMode = ref.watch(shoppingModeProvider);
    final stateAsync = ref.watch(shoppingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isShoppingMode ? 'Shopping Mode' : 'Shopping List'),
        automaticallyImplyLeading: false,
        actions: [
          if (!isShoppingMode)
            IconButton(
              icon: const Icon(Icons.play_circle_fill, color: AppColors.stoxPrimary),
              onPressed: () {
                ref.read(shoppingViewModelProvider.notifier).startShopping();
              },
            ),
        ],
      ),
      body: stateAsync.when(
        data: (state) {
          if (state.toBuyList.isEmpty && state.inCartList.isEmpty) {
             return const Center(child: Text('Nothing to buy!'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.toBuyList.isNotEmpty) ...[
                const Text('To Buy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ...state.toBuyList.map((item) => Card(
                  child: CheckboxListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.amount}${item.unit}'),
                    value: false,
                    onChanged: (val) {
                      ref.read(shoppingViewModelProvider.notifier).toggleItemStatus(item);
                    },
                  ),
                )),
              ],
              
              if (state.inCartList.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('In Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.stoxSubText)),
                ...state.inCartList.map((item) => Card(
                  color: AppColors.stoxBorder.withOpacity(0.3),
                  child: CheckboxListTile(
                    title: Text(item.name, style: const TextStyle(decoration: TextDecoration.lineThrough, color: AppColors.stoxSubText)),
                    subtitle: Text('${item.amount}${item.unit}'),
                    value: true,
                    onChanged: (val) {
                      ref.read(shoppingViewModelProvider.notifier).toggleItemStatus(item);
                    },
                  ),
                )),
              ],
            ],
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: isShoppingMode
          ? FloatingActionButton.extended(
              onPressed: () async {
                // Show confirmation or camera
                // For MVP, just finish
                await ref.read(shoppingViewModelProvider.notifier).completeShoppingFlow();
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shopping Finished! Inventory Updated.')));
                }
              },
              label: const Text('Finish Shopping'),
              icon: const Icon(Icons.check),
              backgroundColor: AppColors.stoxPrimary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
