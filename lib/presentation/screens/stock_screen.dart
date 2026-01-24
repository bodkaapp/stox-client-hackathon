import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../viewmodels/stock_viewmodel.dart';

class StockScreen extends ConsumerWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAvg = ref.watch(stockViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: stateAvg.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No inventory'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.amount}${item.unit} ${item.expiryDate != null ? '(Exp: ${item.expiryDate.toString().split(' ')[0]})' : ''}'),
                trailing: Chip(
                  label: Text(item.status.name),
                  backgroundColor: _getStatusColor(item.status),
                ),
              );
            },
          );
        },
        error: (err, st) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Color _getStatusColor(status) {
    // Basic mapping
    return AppColors.stoxBorder;
  }
}
