import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../../config/app_constants.dart';
import '../datasources/recipe_parser.dart';
import '../../domain/models/ingredient.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

part 'ai_recipe_repository.g.dart';

// final String _apiKey = 'AIzaSyAioUT4nuQ8KXOdt2TfXODP0ALBPWlON-s'; // Removed hardcoded key

class AiRecipeRepository {
  final GenerativeModel _model;

  AiRecipeRepository(this._model);

  /// URLまたはテキストから材料を抽出する
  Future<List<Ingredient>> extractIngredients(String input) async {
    // 1. URLかどうか判定
    final uri = Uri.tryParse(input);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return _extractFromUrl(input);
    }
    
    // 2. テキストの場合は直接AIで解析
    return _extractWithAi(input);
  }

  /// URLから材料を抽出
  Future<List<Ingredient>> _extractFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return _extractWithAi(url);

      final document = html_parser.parse(response.body);
      
      // Try static parsing first
      final parser = RecipeParserFactory.getParser(url);
      if (parser != null) {
        final ingredients = await parser.parse(document);
        if (ingredients.isNotEmpty) {
           return ingredients;
        }
      }
      
      // Fallback to AI
      final bodyText = document.body?.text ?? '';
      
      // テキストが空ならURL自体を投げる
      if (bodyText.trim().isEmpty) return _extractWithAi(url);

      // AIに投げる（コンテキストとしてURLも含める）
      return _extractWithAi('$url\n\n$bodyText');
    } catch (e) {
      print('Error fetching or parsing URL: $e');
      return _extractWithAi(url); // 失敗時はとりあえずURL自体をAIに投げてみる
    }
  }

  /// AIを使用してテキストから材料を抽出
  Future<List<Ingredient>> _extractWithAi(String text) async {
    if (text.isEmpty) return [];

    final prompt = '''
以下のレシピ情報のテキストから材料と分量を抽出して、JSON形式で返してください。
「家にある」かどうかは推測せず、statusは "toBuy" (買うべき) にしてください。
分量はできるだけ数値と単位に分解したいですが、難しい場合は文字列のままでも構いません。

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

テキスト:
$text
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    
    final responseText = response.text;
    if (responseText == null) return [];

    try {
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(responseText);
      if (jsonMatch == null) return [];
      
      final List<dynamic> jsonList = json.decode(jsonMatch);
      return jsonList.map((e) {
         // Map JSON to Ingredient domain model
         return Ingredient(
           id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), // Temporary ID
           name: e['name'] ?? '',
           amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 0.0,
           unit: e['unit'] ?? '',
           category: e['category'] ?? 'その他',
           status: IngredientStatus.toBuy,
           storageType: StorageType.fridge, // Default
           isEssential: false,
           standardName: e['name'] ?? '', // Default to name
         );
      }).cast<Ingredient>().toList();
    } catch (e) {
      print('Error parsing ingredients from AI: $e');
      return [];
    }
  }

  /// テキスト（音声認識結果やメモ）からリスト（買い物リストや在庫リスト）を解析する
  Future<List<Ingredient>> parseShoppingList(String input) async {
    if (input.trim().isEmpty) return [];

    final prompt = '''
以下のテキストは、アプリのリスト（買い物リストまたは在庫リスト）に追加したいアイテムのメモ、または音声認識の結果です。
ここから商品名、数量、単位を抽出し、適切なカテゴリを推測してJSON形式で返してください。

【ルール】
1. テキストには「〜を追加して」「〜も買う」「〜がある」などの余計な言葉が含まれる場合がありますが、商品名のみを抽出してください。
2. 数量や単位が明示されていない場合は、amount: 1, unit: "個" としてください。
3. カテゴリは以下のいずれかから推測してください:
   - 野菜・果物
   - 肉・魚
   - 加工品
   - 調味料
   - 飲料
   - 日用品
   - その他
4. 複数のアイテムが含まれている場合は、すべてリストアップしてください（例：「豚肉とキャベツ」→ リスト2件）。

出力形式:
[
  {
    "name": "商品名",
    "amount": 数値,
    "unit": "単位",
    "category": "カテゴリ"
  }
]

テキスト:
$input
''';

    final content = [Content.text(prompt)];
    try {
      final response = await _model.generateContent(content);
      final responseText = response.text;
      
      if (responseText == null) return [];

      String cleanJson = responseText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replaceFirst('```json', '').replaceFirst('```', '').trim();
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceFirst('```', '').replaceFirst('```', '').trim();
      }

      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(cleanJson);
      if (jsonMatch != null) {
        cleanJson = jsonMatch;
      }

      final List<dynamic> jsonList = json.decode(cleanJson);
      
      return jsonList.map((e) {
         // Create temporary Ingredient object. 
         // ID will be regenerated by the caller or repository when saving to ensure uniqueness.
         return Ingredient(
           id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''),
           name: e['name'] ?? '',
           standardName: e['name'] ?? '',
           amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
           unit: e['unit'] ?? '個',
           category: e['category'] ?? 'その他',
           status: IngredientStatus.toBuy, // Default to toBuy
           storageType: StorageType.fridge,
           purchaseDate: DateTime.now(),
           expiryDate: DateTime.now().add(const Duration(days: 7)),
         );
      }).cast<Ingredient>().toList();

    } catch (e) {
      debugPrint('Error parsing shopping list with AI: $e');
      return [];
    }
  }


  /// 画像から在庫アイテムを解析する
  Future<List<Ingredient>> analyzeStockImage(Uint8List imageBytes, String location, {String? mimeType}) async {
    final prompt = '''
$locationを撮影した画像です。写真で確認できる食材や商品の名前を解析してリストアップしてください。
出力形式は以下のJSON形式のみを返してください。Markdownのコードブロック(```json ... ```)を含まないでください。

[
  {
    "name": "材料名",
    "amount": 数値(推測できない場合は1),
    "unit": "単位(個, g, mlなど。推測できない場合は個)",
    "category": "野菜" などのカテゴリ（推測）,
    "status": "stock"
  }
]
''';

  // Determine mimeType if not provided
  // Default to jpeg if unknown, as it's most common for camera captures
  final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    // Let exceptions bubble up to be handled by the UI
    final response = await _model.generateContent(content);
    final responseText = response.text;
    
    if (responseText == null) {
      throw Exception('AIからの応答が空でした。');
    }

    // Clean up potential markdown code blocks
    String cleanJson = responseText.trim();
    if (cleanJson.startsWith('```json')) {
      cleanJson = cleanJson.replaceFirst('```json', '').replaceFirst('```', '').trim();
    } else if (cleanJson.startsWith('```')) {
      cleanJson = cleanJson.replaceFirst('```', '').replaceFirst('```', '').trim();
    }

    // Attempt to extract JSON array if there's extra text
    final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(cleanJson);
    if (jsonMatch != null) {
      cleanJson = jsonMatch;
    }

    try {
      final List<dynamic> jsonList = json.decode(cleanJson);
      return jsonList.map((e) {
          return Ingredient(
            id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), 
            name: e['name'] ?? '',
            amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
            unit: e['unit'] ?? '個',
            category: e['category'] ?? 'その他',
            status: IngredientStatus.stock,
            storageType: StorageType.fridge, // Default
            isEssential: false,
            standardName: e['name'] ?? '', 
          );
      }).cast<Ingredient>().toList();
    } catch (e) {
      print('Error parsing ingredients from AI response: $responseText');
      throw Exception('AIの応答を解析できませんでした: $responseText');
    }
  }

  /// レシート画像から購入品を解析する
  Future<List<Ingredient>> analyzeReceiptImage(Uint8List imageBytes, {String? mimeType}) async {
    final prompt = '''
レシートを撮影した画像です。レシートに記載されている購入品の商品名と数量、価格を読み取ってリストアップしてください。

【重要な指示】
1. 画像内のすべての情報（商品名の前後の記号、棚番、カテゴリコード、価格など）をヒントとして活用してください。
2. レシートの商品名は省略されていることが多いです（例：「ポテトチッ...」「ギュウニュウ 1L」など）。
   これらをそのまま出力せず、前後のコンテキストや一般的な商品知識を用いて、**ユーザーにとって分かりやすい正式な名称**に推測・補完してください。
   （例：「ポテトチッ...」→「ポテトチップス」、「ギュウニュウ」→「牛乳」）
3. 割引や小計、合計、税金などは除外してください。商品のみを抽出してください。

出力形式は以下のJSON形式のみを返してください。Markdownのコードブロック(```json ... ```)を含まないでください。

[
  {
    "name": "補完された正式な商品名",
    "amount": 数値(推測できない場合は1),
    "unit": "単位(個, g, mlなど。推測できない場合は個)",
    "category": "野菜" などのカテゴリ（推測）,
    "status": "stock"
  }
]
''';

  // Determine mimeType if not provided
  final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final response = await _model.generateContent(content);
      final responseText = response.text;
      
      if (responseText == null) {
        throw Exception('AIからの応答が空でした。');
      }

      // Clean up potential markdown code blocks
      String cleanJson = responseText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replaceFirst('```json', '').replaceFirst('```', '').trim();
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceFirst('```', '').replaceFirst('```', '').trim();
      }

      // Attempt to extract JSON array if there's extra text
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(cleanJson);
      if (jsonMatch != null) {
        cleanJson = jsonMatch;
      }

      final List<dynamic> jsonList = json.decode(cleanJson);
      return jsonList.map((e) {
          return Ingredient(
            id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), 
            name: e['name'] ?? '',
            amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
            unit: e['unit'] ?? '個',
            category: e['category'] ?? 'その他',
            status: IngredientStatus.stock,
            storageType: StorageType.fridge, // Default
            isEssential: false,
            standardName: e['name'] ?? '', 
          );
      }).cast<Ingredient>().toList();
    } catch (e) {
      print('Error parsing receipt from AI response: $e');
      throw Exception('レシートの解析に失敗しました: $e');
    }
  }

  /// 画像からレシピ提案用の解析を行う
  Future<AiRecipeAnalysisResult> analyzeImageForRecipe(Uint8List imageBytes, {String? mimeType}) async {
    final prompt = '''
冷蔵庫の中身を撮影した画像です。
1. 画像に写っている食材をリストアップしてください（最大10個程度）。
2. それらの食材を使って作れるおすすめの料理名を1つだけ提案してください。

出力形式は以下のJSON形式のみを返してください。Markdownのコードブロック(```json ... ```)を含まないでください。

{
  "ingredients": ["食材1", "食材2", "食材3"...],
  "recommended_recipe": "料理名"
}
''';

    final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final response = await _model.generateContent(content);
      final responseText = response.text;

      if (responseText == null) {
        throw Exception('AIからの応答が空でした。');
      }

      String cleanJson = responseText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replaceFirst('```json', '').replaceFirst('```', '').trim();
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceFirst('```', '').replaceFirst('```', '').trim();
      }
      
      // Extract JSON object
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).stringMatch(cleanJson);
      if (jsonMatch != null) {
        cleanJson = jsonMatch;
      }

      final Map<String, dynamic> jsonMap = json.decode(cleanJson);
      final List<String> ingredients = (jsonMap['ingredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final String recommendedRecipe = jsonMap['recommended_recipe'] ?? 'おすすめレシピ';

      return AiRecipeAnalysisResult(
        ingredients: ingredients,
        recommendedRecipe: recommendedRecipe,
      );
    } catch (e) {
      print('Error parsing recipe analysis: $e');
      // Fallback
      return AiRecipeAnalysisResult(
        ingredients: ['野菜', '肉', '卵'], 
        recommendedRecipe: '冷蔵庫の残り物レシピ'
      );
    }
  }

  /// 画像からキッチンアイテムを識別する
  Future<List<String>> identifyKitchenItems(Uint8List imageBytes, {String? mimeType}) async {
    final prompt = '''
この写真に写っているすべてのアイテム（食品、調味料、キッチン用品など）をリストアップしてください。
出力は文字列のJSON配列 `["アイテム1", "アイテム2", ...]` のみで返してください。
Markdownのコードブロックを含めないでください。
''';

    final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final response = await _model.generateContent(content);
      final responseText = response.text;

      if (responseText == null) return [];

      String cleanJson = responseText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replaceFirst('```json', '').replaceFirst('```', '').trim();
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceFirst('```', '').replaceFirst('```', '').trim();
      }

      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(cleanJson);
      if (jsonMatch != null) {
        cleanJson = jsonMatch;
      }

      final List<dynamic> jsonList = json.decode(cleanJson);
      return jsonList.map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint('Error identifying kitchen items: $e');
      return [];
    }
  }

  /// アイテムリストから複数のレシピを提案する
  Future<List<AiRecipeSuggestion>> suggestRecipesFromItems(List<String> items) async {
    final prompt = '''
ここにアイテムのリストがあります: ${json.encode(items)}
このリストから料理に使える**食品のみ**を正確にフィルタリングしてください（洗剤やスポンジなどは除外）。
その後、それらの食品を主に使用して作れるおすすめの料理を**5つ**提案してください。
出力は以下のJSON形式のみを返してください。Markdownのコードブロックを含めないでください。

[
  {
    "name": "料理名",
    "description": "簡単な説明（20文字程度）",
    "usedIngredients": ["使用する食材1", "使用する食材2"]
  }
]
''';

    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      final responseText = response.text;

      if (responseText == null) return [];

      String cleanJson = responseText.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.replaceFirst('```json', '').replaceFirst('```', '').trim();
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceFirst('```', '').replaceFirst('```', '').trim();
      }

      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(cleanJson);
      if (jsonMatch != null) {
        cleanJson = jsonMatch;
      }

      final List<dynamic> jsonList = json.decode(cleanJson);
      return jsonList.map((e) {
        return AiRecipeSuggestion(
          name: e['name'] ?? '',
          description: e['description'] ?? '',
          usedIngredients: (e['usedIngredients'] as List<dynamic>?)?.map((i) => i.toString()).toList() ?? [],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error suggesting recipes from items: $e');
      return [
        AiRecipeSuggestion(name: '冷蔵庫の残り物レシピ', description: 'あるもので作れる簡単レシピ', usedIngredients: items),
      ];
    }
  }
}

class AiRecipeAnalysisResult {
  final List<String> ingredients;
  final String recommendedRecipe;

  AiRecipeAnalysisResult({required this.ingredients, required this.recommendedRecipe});
}

class AiRecipeSuggestion {
  final String name;
  final String description;
  final List<String> usedIngredients;

  AiRecipeSuggestion({
    required this.name,
    required this.description,
    required this.usedIngredients,
  });
}

@Riverpod(keepAlive: true)
AiRecipeRepository aiRecipeRepository(AiRecipeRepositoryRef ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final model = GenerativeModel(model: AppConstants.geminiModel, apiKey: apiKey);
  return AiRecipeRepository(model);
}
