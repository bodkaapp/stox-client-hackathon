import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/search_history.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../../infrastructure/repositories/isar_search_history_repository.dart';

part 'search_history_viewmodel.g.dart';

@riverpod
class SearchHistoryViewModel extends _$SearchHistoryViewModel {
  @override
  Stream<List<SearchHistory>> build() async* {
    final repo = await ref.watch(searchHistoryRepositoryProvider.future);
    yield* repo.watchAll();
  }

  Future<void> add(String query) async {
    if (query.trim().isEmpty) return;
    final repo = await ref.read(searchHistoryRepositoryProvider.future);
    final history = SearchHistory(
       id: DateTime.now().toIso8601String(),
       query: query.trim(),
       createdAt: DateTime.now(),
    );
    await repo.save(history);
  }

  Future<void> delete(String id) async {
    final repo = await ref.read(searchHistoryRepositoryProvider.future);
    await repo.delete(id);
  }

  Future<void> deleteAll() async {
    final repo = await ref.read(searchHistoryRepositoryProvider.future);
    await repo.deleteAll();
  }
}
