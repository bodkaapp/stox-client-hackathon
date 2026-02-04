class PhotoAnalysis {
  final String photoPath;
  final DateTime analyzedAt;
  final int? calories;
  final double? protein;
  final double? fat;
  final double? carbs;
  final String? foodName;
  final String? resultText;

  PhotoAnalysis({
    required this.photoPath,
    required this.analyzedAt,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
    this.foodName,
    this.resultText,
  });
}
