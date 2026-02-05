import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_photo.freezed.dart';
part 'food_photo.g.dart';

@freezed
class FoodPhoto with _$FoodPhoto {
  const factory FoodPhoto({
    required int id,
    required String path,
    required DateTime createdAt,
    String? mealPlanId,
  }) = _FoodPhoto;

  factory FoodPhoto.fromJson(Map<String, dynamic> json) => _$FoodPhotoFromJson(json);
}
