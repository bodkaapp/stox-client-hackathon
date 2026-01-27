import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../datasources/recipe_parser.dart';
import '../../domain/models/ingredient.dart';

part 'ai_recipe_repository.g.dart';

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
割引や小計、合計、税金などは除外してください。商品のみを抽出してください。
出力形式は以下のJSON形式のみを返してください。Markdownのコードブロック(```json ... ```)を含まないでください。

[
  {
    "name": "商品名",
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
}

@Riverpod(keepAlive: true)
AiRecipeRepository aiRecipeRepository(AiRecipeRepositoryRef ref) {
  // TODO: 本番環境では環境変数などから取得する
  const apiKey = 'AIzaSyB3wT4qTq3bVFbetWMkUHO6Y2ie_ijU6TE'; 
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  return AiRecipeRepository(model);
}
