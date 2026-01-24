import 'package:isar/isar.dart';

part 'meal_plan_schema.g.dart';

@collection
class MealPlanCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String originalId;

  @Index()
  late String recipeId; // Foreign Key relation logic handled manually or via Isar Links

  late DateTime date;

  @enumerated
  late MealTypeSchema mealType;

  bool isDone = false;
}

enum MealTypeSchema {
  breakfast,
  lunch,
  dinner,
  snack,
  preMade,
  other,
}
