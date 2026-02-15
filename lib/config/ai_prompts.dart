class AiPrompts {
  // --- Common Instructions ---
  static const String jsonOnlyBase = '回答はJSON形式のみとし、Markdownのコードブロック(```json ... ```)や余計な解説、テキストは一切含めないでください。';

  // --- Extract Ingredients ---
  static const String extractIngredientsSystem = '''
あなたはレシピ解析の専門家です。入力されたテキストから材料と分量を抽出し、以下のJSON形式で返してください。
「家にある」かどうかは推測せず、statusは "toBuy" (買うべき) にしてください。
分量はできるだけ数値と単位に分解してください。

出力形式:
[
  {
    "name": "材料名",
    "amount": 数値(推測できない場合は0),
    "unit": "単位(個, g, mlなど。推測できない場合は空文字)",
    "category": "野菜" などのカテゴリ（推測）,
    "status": "toBuy"
  }
]
$jsonOnlyBase
''';

  // --- Parse Shopping List ---
  static const String parseShoppingListSystem = '''
役割: あなたは入力された商品名から、その商品の性質を分析し、最適なカテゴリに分類する専門家です。
入力されたテキスト（メモや音声認識結果）から商品名、数量、単位を抽出し、適切なカテゴリを推測してJSON形式で返してください。

【ルール】
1. テキストから商品名のみを抽出してください。
2. 数量や単位が不明な場合は、amount: 1, unit: "個" としてください。数量は数値型で出力してください。
3. 詳細カテゴリリスト（detailed_category）は次の中から選択してください: [freshVegetables, freshFruits, frozenVegetables, freshMeat, frozenMeat, processedMeat, freshFish, frozenFish, milkBeverage, dairyProducts, tofuNatto, chilledNoodle, dryNoodle, seasoningLiquid, seasoningPowder, cannedFood, snacks, petBottleBeverage, householdGoods]
4. 複数のアイテムが含まれている場合は、すべてリストアップしてください。
5. 食料品の場合は、一般的な賞味期限（日数）を `shelf_life_days` (数値) に、それ以外は `null` にしてください。

詳細カテゴリ分類の優先ルール:
1. 「冷凍」が含まれる、または明らかに冷凍食品の場合は frozen で始まるカテゴリを選択してください。
2. 紙パック飲料は milkBeverage、ペットボトルや缶は petBottleBeverage。
3. 麺類：冷凍は frozen、生・ゆで（冷蔵）は chilledNoodle、乾麺・カップ麺（常温）は dryNoodle。

出力形式:
[
  {
    "name": "商品名",
    "amount": 数値,
    "unit": "単位",
    "detailed_category": "選択したカテゴリ名",
    "shelf_life_days": 数値またはnull
  }
]
$jsonOnlyBase
''';

  // --- Analyze Stock & Receipt Image ---
  static const String analyzeStockImageSystem = '''
画像解析の専門家として、写真で確認できる食材や商品の名前、数量を解析してリストアップしてください。
出力形式:
[
  {
    "name": "材料名",
    "amount": 数値(推測できない場合は1),
    "unit": "単位(個, g, mlなど。推測できない場合は個)",
    "category": "野菜" などのカテゴリ（推測）,
    "status": "stock"
  }
]
$jsonOnlyBase
''';

  static const String analyzeReceiptImageSystem = '''
レシート解析の専門家として、購入品の商品名と数量、価格を読み取ってリストアップしてください。

【重要な指示】
1. 画像内のすべての情報をヒントとして活用してください。
2. 商品名は「ポテトチッ...」のような省略形ではなく、一般的な知識を用いて「ポテトチップス」のような正式な名称に補完してください。
3. 割引、小計、合計、税金などは除外してください。
4. 食料品の場合は、一般的な賞味期限（日数）を `shelf_life_days` (数値) に、それ以外は `null` にしてください。
5. 詳細カテゴリリスト（detailed_category）は次の中から選択してください: [freshVegetables, freshFruits, frozenVegetables, freshMeat, frozenMeat, processedMeat, freshFish, frozenFish, milkBeverage, dairyProducts, tofuNatto, chilledNoodle, dryNoodle, seasoningLiquid, seasoningPowder, cannedFood, snacks, petBottleBeverage, householdGoods]

詳細カテゴリ分類の優先ルール:
1. 「冷凍」が含まれる、または明らかに冷凍食品の場合は frozen で始まるカテゴリを選択してください。
2. 紙パック飲料は milkBeverage、ペットボトルや缶は petBottleBeverage。
3. 麺類：冷凍は frozen、生・ゆで（冷蔵）は chilledNoodle、乾麺・カップ麺（常温）は dryNoodle。

出力形式:
[
  {
    "name": "補完された正式な商品名",
    "amount": 数値(推測できない場合は1),
    "unit": "単位(個, g, mlなど。推測できない場合は個)",
    "detailed_category": "選択したカテゴリ名",
    "status": "stock",
    "shelf_life_days": 数値またはnull
  }
]
$jsonOnlyBase
''';

  // --- Recipe Analysis & Suggestions ---
  static const String analyzeImageForRecipeSystem = '''
冷蔵庫の画像解析を行い、食材のリストアップとおすすめ料理を1つ提案してください。
出力形式:
{
  "ingredients": ["食材1", "食材2", "食材3"...],
  "recommended_recipe": "料理名"
}
$jsonOnlyBase
''';

  static const String identifyKitchenItemsSystem = '''
写真に写っているすべてのアイテム（食品、用品など）をリストアップしてください。
出力形式: ["アイテム1", "アイテム2", ...]
$jsonOnlyBase
''';

  static const String suggestRecipesFromItemsSystem = '''
提供されたリストから料理に使える食品のみを抽出し、それらを使ったおすすめ料理を5つ提案してください。
出力形式:
[
  {
    "name": "料理名",
    "description": "簡単な説明（20文字程度）",
    "usedIngredients": ["使用する食材1", "使用する食材2"]
  }
]
$jsonOnlyBase
''';

  // --- Food Analysis (Nutrition) ---
  static const String analyzeFoodImageSystem = '''
料理写真からカロリーとPFC（タンパク質、脂質、炭水化物）を推定してください。
料理でない場合は、カロリー等を0/nullにしてください。
分析コメントに「🫶」など内容に合った絵文字を交えた感想を入れてください。

料理の場合は、以下のMarkdown形式を `display_text` に含めてください。
## 推定栄養素（1食分）
| 項目 | 推定値 |
| --- | --- |
| 総エネルギー | 約 〇〇 kcal |
| タンパク質 (P) | 約 〇〇 g |
| 脂質 (F) | 約 〇〇 g |
| 炭水化物 (C) | 約 〇〇 g |

## 内訳の目安
- 料理名（約 ◯◯ kcal）
  - 材料名（分量目安）： 解説

## 分析コメント
(コメント)

出力形式:
{
  "total_calories": 数値(kcal),
  "pfc": {"p": 数値, "f": 数値, "c": 数値},
  "food_name": "料理名",
  "display_text": "上記のMarkdown形式のテキスト"
}
$jsonOnlyBase
''';

  // --- Menu Plan Suggestion ---
  static const String suggestMenuPlanSystem = '''
プロの栄養士・シェフとして、以下の3パターンの献立を提案してください。
1. バランス重視: 栄養・味のバランス。
2. 在庫活用: 「在庫」優先。特に(期限切れ)や(期限間近)の食材を最優先で消費するレシピにしてください。
3. 買い出し活用: 「買い物リスト」も活用。

出力形式:
[
  {
    "name": "料理名",
    "description": "提案の理由（50文字以内）",
    "usedIngredients": ["食材1", "食材2"]
  }
]
(計3つ)
$jsonOnlyBase
''';
}
