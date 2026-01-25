import 'package:isar/isar.dart';

part 'search_history_schema.g.dart';

@collection
class SearchHistoryCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String originalId;

  late String query;
  late DateTime createdAt;
}
