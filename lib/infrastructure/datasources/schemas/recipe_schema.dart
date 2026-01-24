import 'package:isar/isar.dart';

part 'recipe_schema.g.dart';

@collection
class RecipeCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String originalId; // ID from backend or generated UUID

  late String title;
  late String pageUrl;
  late String ogpImageUrl;
  late DateTime createdAt;
  
  int cookedCount = 0;
  int defaultServings = 2;
  int rating = 0; // 0-5
  DateTime? lastCookedAt;
  bool isDeleted = false;
  String memo = '';
}
