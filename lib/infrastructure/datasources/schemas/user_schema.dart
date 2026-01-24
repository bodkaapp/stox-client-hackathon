import 'package:isar/isar.dart';

part 'user_schema.g.dart';

@collection
class UserCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String originalId;

  int points = 0;
  int adRights = 0;
  bool contentWifiOnly = false;
}
