import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/search_history.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../datasources/app_database.dart';
import '../datasources/drift_database_provider.dart';

part 'drift_search_history_repository.g.dart';

class DriftSearchHistoryRepository implements SearchHistoryRepository {
  final AppDatabase db;

  DriftSearchHistoryRepository(this.db);

  @override
  Future<List<SearchHistory>> getAll() async {
    final entities = await (db.select(db.searchHistories)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
    ).get();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> save(SearchHistory history) async {
    final companion = SearchHistoryDomainMapper.fromDomain(history);
    
    // Check if query exists to delete old one (deduplication)
    final existing = await (db.select(db.searchHistories)..where((t) => t.query.equals(history.query))).getSingleOrNull();
    
    await db.transaction(() async {
       if (existing != null) {
         await (db.delete(db.searchHistories)..where((t) => t.id.equals(existing.id))).go();
       }
       await db.into(db.searchHistories).insert(companion);
    });
  }

  @override
  Future<void> delete(String id) async {
    await (db.delete(db.searchHistories)..where((t) => t.originalId.equals(id))).go();
  }

  @override
  Future<void> deleteAll() async {
    await db.delete(db.searchHistories).go();
  }

  @override
  Stream<List<SearchHistory>> watchAll() {
    return (db.select(db.searchHistories)
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
    ).watch().map((entities) => entities.map((e) => e.toDomain()).toList());
  }
}

// Mappers
extension SearchHistoryEntityMapper on SearchHistoryEntity {
  SearchHistory toDomain() {
    return SearchHistory(
      id: originalId,
      query: query,
      createdAt: createdAt,
    );
  }
}

extension SearchHistoryDomainMapper on SearchHistory {
  static SearchHistoriesCompanion fromDomain(SearchHistory history) {
    return SearchHistoriesCompanion(
      originalId: Value(history.id),
      query: Value(history.query),
      createdAt: Value(history.createdAt),
    );
  }
}

@Riverpod(keepAlive: true)
Future<SearchHistoryRepository> searchHistoryRepository(SearchHistoryRepositoryRef ref) async {
  final db = ref.watch(driftDatabaseProvider);
  return DriftSearchHistoryRepository(db);
}
