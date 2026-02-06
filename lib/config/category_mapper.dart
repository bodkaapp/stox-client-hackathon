import 'detailed_category.dart';

/// マッピング管理クラス
class CategoryMapper {
  /// 買い物リスト用：売り場大枠へのマッピング
  static String toShoppingSection(DetailedCategory detailed) {
    switch (detailed) {
      // 冷凍系をすべて「冷凍食品」に集約
      case DetailedCategory.frozenVegetables:
      case DetailedCategory.frozenMeat:
      case DetailedCategory.frozenFish:
        return '冷凍食品';
      case DetailedCategory.freshVegetables:
      case DetailedCategory.freshFruits:
        return '青果';
      case DetailedCategory.freshMeat:
      case DetailedCategory.processedMeat:
        return '精肉・ハム';
      case DetailedCategory.freshFish:
        return '鮮魚';
      case DetailedCategory.milkBeverage:
      case DetailedCategory.dairyProducts:
      case DetailedCategory.tofuNatto:
      case DetailedCategory.chilledNoodle:
        return '乳製品・豆腐・日配';
      case DetailedCategory.dryNoodle:
      case DetailedCategory.cannedFood:
      case DetailedCategory.seasoningLiquid:
      case DetailedCategory.seasoningPowder:
        return '加工食品・調味料';
      case DetailedCategory.snacks:
        return 'お菓子';
      case DetailedCategory.petBottleBeverage:
        return '飲料・お酒';
      case DetailedCategory.householdGoods:
        return '日用品';
      case DetailedCategory.unknown:
        return 'その他';
    }
  }

  /// 在庫一覧用：家庭内の保管場所へのマッピング
  static String toStorageLocation(DetailedCategory detailed) {
    switch (detailed) {
      case DetailedCategory.frozenVegetables:
      case DetailedCategory.frozenMeat:
      case DetailedCategory.frozenFish:
        return '冷凍庫';
      case DetailedCategory.freshVegetables:
        return '冷蔵庫（野菜室）';
      case DetailedCategory.milkBeverage:
      case DetailedCategory.seasoningLiquid:
        return '冷蔵庫（ドアポケット）';
      case DetailedCategory.freshMeat:
      case DetailedCategory.freshFish:
      case DetailedCategory.dairyProducts:
      case DetailedCategory.tofuNatto:
      case DetailedCategory.chilledNoodle:
      case DetailedCategory.processedMeat:
        return '冷蔵庫（棚）';
      case DetailedCategory.freshFruits:
      case DetailedCategory.dryNoodle:
      case DetailedCategory.seasoningPowder:
      case DetailedCategory.cannedFood:
      case DetailedCategory.snacks:
      case DetailedCategory.petBottleBeverage:
        return '常温（パントリー）';
      case DetailedCategory.householdGoods:
        return '日用品ストック';
      case DetailedCategory.unknown:
        return '未分類';
    }
  }
}