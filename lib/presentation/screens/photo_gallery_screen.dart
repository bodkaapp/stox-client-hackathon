import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/meal_plan.dart';
import '../../infrastructure/repositories/drift_meal_plan_repository.dart';
import 'dart:io';
import 'photo_viewer_screen.dart';

final photoGalleryProvider = FutureProvider.autoDispose<List<MealPlan>>((ref) async {
  final repo = await ref.watch(mealPlanRepositoryProvider.future);
  return repo.getWithPhotos(limit: 100);
});

class PhotoGalleryScreen extends ConsumerWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(photoGalleryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('写真一覧', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: plansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text('写真がありません'));
          }

          // Group by Date
          final grouped = <DateTime, List<String>>{};
          for (final plan in plans) {
            final dateKey = DateTime(plan.date.year, plan.date.month, plan.date.day);
            if (!grouped.containsKey(dateKey)) {
              grouped[dateKey] = [];
            }
            grouped[dateKey]!.addAll(plan.photos);
          }
          
          final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final photos = grouped[date]!;
              return _buildDateSection(context, date, photos);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, DateTime date, List<String> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy/MM/dd (E)', 'ja').format(date),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                   context.go(Uri(path: '/menu_plan', queryParameters: {
                     'date': date.toIso8601String(),
                     'from_gallery': 'true',
                   }).toString());
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('献立計画表を見る', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return _buildPhotoItem(context, photos[index]);
          },
        ),
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, String path) {
    return GestureDetector(
       onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
               builder: (_) => PhotoViewerScreen(filePath: path),
            ),
          );
       },
       child: Hero(
         tag: path,
         child: ClipRRect(
           borderRadius: BorderRadius.circular(8),
           child: Image.file(
             File(path),
             fit: BoxFit.cover,
             errorBuilder: (context, error, stackTrace) {
               return Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey));
             },
           ),
         ),
       ),
    );
  }
}

