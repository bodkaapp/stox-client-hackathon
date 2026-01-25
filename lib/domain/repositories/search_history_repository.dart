import '../models/search_history.dart';

abstract class SearchHistoryRepository {
  Future<List<SearchHistory>> getAll();
  Future<void> save(SearchHistory history);
  Future<void> delete(String id);
  Future<void> deleteAll();
  Stream<List<SearchHistory>> watchAll();
}
