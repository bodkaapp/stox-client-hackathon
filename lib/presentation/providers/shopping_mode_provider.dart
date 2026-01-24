import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shopping_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class ShoppingMode extends _$ShoppingMode {
  @override
  bool build() => false;

  void set(bool value) => state = value;
  void toggle() => state = !state;
}
