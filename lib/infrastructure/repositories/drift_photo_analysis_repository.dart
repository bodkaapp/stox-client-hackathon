import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/photo_analysis.dart';
import '../../domain/repositories/photo_analysis_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_photo_analysis_repository.g.dart';

class DriftPhotoAnalysisRepository implements PhotoAnalysisRepository {
  final AppDatabase db;

  DriftPhotoAnalysisRepository(this.db);

  @override
  Future<PhotoAnalysis?> getByPath(String path) async {
    final entity = await (db.select(db.photoAnalyses)
      ..where((t) => t.photoPath.equals(path))
    ).getSingleOrNull();

    if (entity == null) return null;
    return entity.toDomain();
  }

  @override
  Stream<PhotoAnalysis?> watchByPath(String path) {
    return (db.select(db.photoAnalyses)..where((t) => t.photoPath.equals(path)))
        .watchSingleOrNull()
        .map((entity) => entity?.toDomain());
  }

  @override
  Future<void> save(PhotoAnalysis analysis) async {
    final companion = PhotoAnalysisDomainMapper.fromDomain(analysis);
    
    // Upsert
    await db.into(db.photoAnalyses).insertOnConflictUpdate(companion);
  }
}

// Mappers
extension PhotoAnalysisEntityMapper on PhotoAnalysisEntity {
  PhotoAnalysis toDomain() {
    return PhotoAnalysis(
      photoPath: photoPath,
      analyzedAt: analyzedAt,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      foodName: foodName,
      resultText: resultText,
    );
  }
}

extension PhotoAnalysisDomainMapper on PhotoAnalysis {
  static PhotoAnalysesCompanion fromDomain(PhotoAnalysis analysis) {
    return PhotoAnalysesCompanion(
      photoPath: Value(analysis.photoPath),
      analyzedAt: Value(analysis.analyzedAt),
      calories: Value(analysis.calories),
      protein: Value(analysis.protein),
      fat: Value(analysis.fat),
      carbs: Value(analysis.carbs),
      foodName: Value(analysis.foodName),
      resultText: Value(analysis.resultText),
    );
  }
}

@Riverpod(keepAlive: true)
Future<PhotoAnalysisRepository> photoAnalysisRepository(PhotoAnalysisRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftPhotoAnalysisRepository(db);
}
