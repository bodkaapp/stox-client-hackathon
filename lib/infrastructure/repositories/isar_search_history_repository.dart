import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/search_history.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../datasources/isar_database.dart';
import '../datasources/schemas/search_history_schema.dart';

part 'isar_search_history_repository.g.dart';

class IsarSearchHistoryRepository implements SearchHistoryRepository {
  final Isar isar;

  IsarSearchHistoryRepository(this.isar);

  @override
  Future<List<SearchHistory>> getAll() async {
    final collections = await isar.searchHistoryCollections.where().sortByCreatedAtDesc().findAll();
    return collections.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> save(SearchHistory history) async {
    final collection = SearchHistoryDomainMapper.fromDomain(history);
    await isar.writeTxn(() async {
      // Check if same query exists, if so delete it (to move it to top/update time)
      // or we can just update existing one.
      // Usually search history deduplicates.
      // Let's find by query to verify.
      final existing = await isar.searchHistoryCollections.filter().queryEqualTo(history.query).findFirst();
      if (existing != null) {
        // Update createdAt or delete and re-insert.
        // Re-insert is easier to ensure ID doesn't mess up if we want new ID, 
        // but keeping ID is better if we rely on it.
        // However, standard history usually bumps to top.
        // We can just delete the old one.
        await isar.searchHistoryCollections.delete(existing.id);
      }
      
      await isar.searchHistoryCollections.put(collection);
    });
  }

  @override
  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      await isar.searchHistoryCollections.filter().originalIdEqualTo(id).deleteAll();
    });
  }

  @override
  Future<void> deleteAll() async {
    await isar.writeTxn(() async {
      await isar.searchHistoryCollections.clear();
    });
  }

  @override
  Stream<List<SearchHistory>> watchAll() {
    return isar.searchHistoryCollections.where().sortByCreatedAtDesc().watch(fireImmediately: true).map((events) {
      return events.map((e) => e.toDomain()).toList();
    });
  }
}

// Mappers
extension SearchHistoryMapper on SearchHistoryCollection {
  SearchHistory toDomain() {
    return SearchHistory(
      id: originalId,
      query: query,
      createdAt: createdAt,
    );
  }
}

extension SearchHistoryDomainMapper on SearchHistory {
  static SearchHistoryCollection fromDomain(SearchHistory history) {
    return SearchHistoryCollection()
      ..originalId = history.id
      ..query = history.query
      ..createdAt = history.createdAt;
  }
}

@Riverpod(keepAlive: true)
Future<SearchHistoryRepository> searchHistoryRepository(SearchHistoryRepositoryRef ref) async {
  final isar = await ref.watch(isarDatabaseProvider.future);
  return IsarSearchHistoryRepository(isar);
}
