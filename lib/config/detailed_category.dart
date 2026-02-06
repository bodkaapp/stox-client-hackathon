/// Geminiから返ってくる「詳細カテゴリ」の定義
enum DetailedCategory {
  // 青果系
  freshVegetables,    // 生野菜
  freshFruits,        // 果物
  frozenVegetables,   // 冷凍野菜
  
  // 精肉・鮮魚系
  freshMeat,          // 生肉
  frozenMeat,         // 冷凍肉
  processedMeat,      // ハム・ソーセージ
  freshFish,          // 生魚・刺身
  frozenFish,         // 冷凍魚
  
  // 冷蔵・日配品
  milkBeverage,       // 牛乳・紙パック飲料
  dairyProducts,      // 卵・チーズ・ヨーグルト
  tofuNatto,          // 豆腐・納豆
  chilledNoodle,      // 生麺・ゆで麺
  
  // 常温・加工食品
  dryNoodle,          // 乾麺・カップ麺
  seasoningLiquid,    // 液体調味料（醤油・ドレッシング等）
  seasoningPowder,    // 粉末調味料・スパイス
  cannedFood,         // 缶詰・瓶詰
  snacks,             // お菓子
  petBottleBeverage,  // ペットボトル飲料・酒類
  
  // 日用品
  householdGoods,     // 日用品・消耗品
  
  // 不明時
  unknown;

  /// Geminiからの文字列をEnumに変換する
  static DetailedCategory fromString(String label) {
    return DetailedCategory.values.firstWhere(
      (e) => e.name == label,
      orElse: () => DetailedCategory.unknown,
    );
  }
}