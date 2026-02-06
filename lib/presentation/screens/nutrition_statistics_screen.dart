import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';
import '../viewmodels/nutrition_viewmodel.dart';
import '../../config/app_colors.dart';

class NutritionStatisticsScreen extends ConsumerWidget {
  const NutritionStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAvg = ref.watch(averageNutritionalSummaryProvider(days: 7));
    final monthlyAvg = ref.watch(averageNutritionalSummaryProvider(days: 30));

    String getDateRange(int days) {
      final now = DateTime.now();
      final start = now.subtract(Duration(days: days - 1));
      final formatter = DateFormat('M/d');
      return '${formatter.format(start)} - ${formatter.format(now)}';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.nutritionStatistics),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, AppLocalizations.of(context)!.nutritionWeeklyAverage, getDateRange(7)),
            const SizedBox(height: 12),
            _buildAverageCard(context, weeklyAvg),
            
            const SizedBox(height: 32),
            
            _buildSectionHeader(context, AppLocalizations.of(context)!.nutritionMonthlyAverage, getDateRange(30)),
            const SizedBox(height: 12),
            _buildAverageCard(context, monthlyAvg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
          ),
          Text(
            range,
            style: const TextStyle(fontSize: 14, color: Color(0xFF78716C), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
      ),
    );
  }

  Widget _buildAverageCard(BuildContext context, AsyncValue<NutritionalSummary> asyncSummary) {
    return asyncSummary.when(
      data: (summary) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department, color: Color(0xFFF59E0B), size: 28),
                const SizedBox(width: 8),
                Text(
                  '${summary.calories} kcal',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.nutritionAverage,
              style: const TextStyle(color: Color(0xFF78716C), fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFF5F5F4)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPfcItem(context, 'P', summary.protein, const Color(0xFF3B82F6)),
                _buildPfcItem(context, 'F', summary.fat, const Color(0xFFEF4444)),
                _buildPfcItem(context, 'C', summary.carbs, const Color(0xFF10B981)),
              ],
            ),
          ],
        ),
      ),
      loading: () => Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: AppColors.stoxPrimary),
      ),
      error: (err, stack) => Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('Error: $err'),
      ),
    );
  }

  Widget _buildPfcItem(BuildContext context, String label, double value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF292524)),
            ),
            const SizedBox(width: 2),
            const Text(
              'g',
              style: TextStyle(fontSize: 12, color: Color(0xFF78716C)),
            ),
          ],
        ),
      ],
    );
  }
}
