class FoodEvent {
  final int month;
  final int day;
  final String name;
  final List<String> keywords;

  const FoodEvent({
    required this.month,
    required this.day,
    required this.name,
    required this.keywords,
  });
}

class FoodEvents {
  static String? getEvent(DateTime date) {
    final event = kFoodEvents.where((e) => e.month == date.month && e.day == date.day).firstOrNull;
    return event?.name;
  }
}

const List<FoodEvent> kFoodEvents = [
  FoodEvent(month: 1, day: 7, name: "七草粥の日", keywords: ["春の七草", "胃に優しい", "無病息災"]),
  FoodEvent(month: 1, day: 11, name: "鏡開き", keywords: ["お餅", "おしるこ", "雑煮"]),
  FoodEvent(month: 1, day: 15, name: "いちごの日", keywords: ["いちご", "ケーキ", "スイーツ"]),
  FoodEvent(month: 2, day: 3, name: "節分", keywords: ["恵方巻", "豆料理", "イワシ"]),
  FoodEvent(month: 2, day: 9, name: "肉の日", keywords: ["牛肉", "豚肉", "ステーキ", "焼肉"]),
  FoodEvent(month: 2, day: 14, name: "バレンタインデー", keywords: ["チョコレート", "スイーツ", "デザート"]),
  FoodEvent(month: 3, day: 3, name: "ひな祭り", keywords: ["ちらし寿司", "はまぐり", "ひなあられ"]),
  FoodEvent(month: 3, day: 14, name: "ホワイトデー", keywords: ["クッキー", "キャンディ", "マシュマロ"]),
  FoodEvent(month: 4, day: 4, name: "あんぱんの日", keywords: ["パン", "小豆", "和菓子"]),
  FoodEvent(month: 5, day: 5, name: "こどもの日", keywords: ["柏餅", "ちまき", "寿司"]),
  FoodEvent(month: 6, day: 16, name: "和菓子の日", keywords: ["団子", "餅", "伝統菓子"]),
  FoodEvent(month: 7, day: 2, name: "うどんの日", keywords: ["半夏生", "うどん", "小麦"]),
  FoodEvent(month: 7, day: 7, name: "そうめんの日", keywords: ["七夕", "麺料理", "夏野菜"]),
  FoodEvent(month: 7, day: 24, name: "土用の丑の日", keywords: ["うなぎ", "梅干し", "うどん"]), // Note: Date changes yearly, fixed for simplicity or needs dynamic logic
  FoodEvent(month: 8, day: 3, name: "はちみつの日", keywords: ["ハチミツ", "甘味", "トースト"]),
  FoodEvent(month: 8, day: 29, name: "焼肉の日", keywords: ["焼肉", "バーベキュー", "カルビ"]),
  FoodEvent(month: 8, day: 31, name: "野菜の日", keywords: ["サラダ", "旬の野菜", "ベジタブル"]),
  FoodEvent(month: 10, day: 10, name: "まぐろの日", keywords: ["刺身", "寿司", "魚料理"]),
  FoodEvent(month: 10, day: 13, name: "さつまいもの日", keywords: ["焼き芋", "スイートポテト", "秋野菜"]),
  FoodEvent(month: 10, day: 30, name: "卵かけご飯の日", keywords: ["卵", "醤油", "朝食"]),
  FoodEvent(month: 11, day: 1, name: "本格焼酎の日", keywords: ["おつまみ", "晩酌", "発酵食品"]),
  FoodEvent(month: 11, day: 11, name: "チーズの日", keywords: ["乳製品", "ピザ", "ワイン"]),
  FoodEvent(month: 11, day: 24, name: "和食の日", keywords: ["出汁", "味噌汁", "煮物"]),
  FoodEvent(month: 11, day: 29, name: "いい肉の日", keywords: ["高級肉", "和牛", "肉料理"]),
  FoodEvent(month: 12, day: 22, name: "冬至", keywords: ["かぼちゃ", "ゆず", "根菜"]),
  FoodEvent(month: 12, day: 24, name: "クリスマスイブ", keywords: ["チキン", "ケーキ", "ディナー"]),
  FoodEvent(month: 12, day: 25, name: "クリスマス", keywords: ["チキン", "ケーキ", "パーティー料理"]),
  FoodEvent(month: 12, day: 31, name: "大晦日", keywords: ["年越しそば", "天ぷら", "お寿司"]),
];
