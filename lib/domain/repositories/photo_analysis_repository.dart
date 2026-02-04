import '../models/photo_analysis.dart';

abstract class PhotoAnalysisRepository {
  Future<PhotoAnalysis?> getByPath(String path);
  Stream<PhotoAnalysis?> watchByPath(String path);
  Future<void> save(PhotoAnalysis analysis);
}
