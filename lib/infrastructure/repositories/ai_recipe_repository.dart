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
  Future<List<Ingredient>> analyzeStockImage(Uint8List imageBytes, String location) async {
    final prompt = '''
$locationを撮影した画像です。写真で確認できる食材や商品の名前を解析してリストアップしてください。
出力形式はjsonで商品名はname, 商品の種類はcategoryのオブジェクトを作り、配列で複数の商品を返してください。
分量(amount)や単位(unit)も推測できる場合は入れてください。
statusは "stock" (在庫あり) にしてください。

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
''';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    try {
      final response = await _model.generateContent(content);
      final responseText = response.text;
      
      if (responseText == null) return [];

      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(responseText);
      if (jsonMatch == null) return [];
      
      final List<dynamic> jsonList = json.decode(jsonMatch);
      return jsonList.map((e) {
         return Ingredient(
           id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), 
           name: e['name'] ?? '',
           amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
           unit: e['unit'] ?? '個',
           category: e['category'] ?? 'その他',
           status: IngredientStatus.stock,
           storageType: StorageType.fridge, // Default, logic could be improved based on location
           isEssential: false,
           standardName: e['name'] ?? '', 
         );
      }).cast<Ingredient>().toList();
    } catch (e) {
      print('Error analyzing stock image: $e');
      return [];
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
