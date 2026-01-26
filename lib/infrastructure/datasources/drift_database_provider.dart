import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_database.dart';

part 'drift_database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase driftDatabase(DriftDatabaseRef ref) {
  return AppDatabase();
}
