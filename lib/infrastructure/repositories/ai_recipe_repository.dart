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
import '../../config/ai_prompts.dart';
import '../services/ai_token_logger.dart';

part 'ai_recipe_repository.g.dart';

class AiRecipeRepository {
  final String _apiKey;

  AiRecipeRepository({required String apiKey}) : _apiKey = apiKey;

  GenerativeModel _createModel({Content? systemInstruction}) {
    return GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: _apiKey,
      systemInstruction: systemInstruction,
    );
  }

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
      debugPrint('Error fetching or parsing URL: $e');
      return _extractWithAi(url); // 失敗時はとりあえずURL自体をAIに投げてみる
    }
  }

  /// AIを使用してテキストから材料を抽出
  Future<List<Ingredient>> _extractWithAi(String text) async {
    if (text.isEmpty) return [];

    final prompt = text;

    final content = [Content.text(prompt)];
    final model = _createModel(
      systemInstruction: Content.system(AiPrompts.extractIngredientsSystem),
    );
    final response = await model.generateContent(content);
    
    // Log token usage
    await AiTokenLogger.logUsage(
      prompt: prompt,
      kind: 'extractIngredients',
      response: response,
      modelName: AppConstants.geminiModel,
    );
    
    final responseText = response.text;
    if (responseText == null) return [];

    try {
      final jsonMatch = RegExp(r'\[.*\]', dotAll: true).stringMatch(responseText);
      if (jsonMatch == null) return [];
      
      final List<dynamic> jsonList = json.decode(jsonMatch);
      return jsonList.map((e) {
         // Map JSON to Ingredient domain model
         final category = e['detailed_category'] ?? e['category'] ?? 'unknown';
         return Ingredient(
           id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), // Temporary ID
           name: e['name'] ?? '',
           amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 0.0,
           unit: e['unit'] ?? '',
           category: category,
           status: IngredientStatus.toBuy,
           storageType: StorageType.fridge, // Default
           isEssential: false,
           standardName: e['name'] ?? '', // Default to name
         );
      }).cast<Ingredient>().toList();
    } catch (e) {
      debugPrint('Error parsing ingredients from AI: $e');
      return [];
    }
  }

  /// テキスト（音声認識結果やメモ）からリスト（買い物リストや在庫リスト）を解析する
  Future<List<Ingredient>> parseShoppingList(String input) async {
    if (input.trim().isEmpty) return [];

    final prompt = input;

    final content = [Content.text(prompt)];
    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.parseShoppingListSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'parseShoppingList',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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
         final shelfLifeDays = e['shelf_life_days'] as num?;
         final now = DateTime.now();
         final expiryDate = shelfLifeDays != null 
             ? DateTime(now.year, now.month, now.day).add(Duration(days: shelfLifeDays.toInt()))
             : null;

         // Get detailed_category if present, fallback to category, then 'unknown' (internal id name)
         final category = e['detailed_category'] ?? e['category'] ?? 'unknown';

         // Create temporary Ingredient object. 
         // ID will be regenerated by the caller or repository when saving to ensure uniqueness.
         return Ingredient(
           id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''),
           name: e['name'] ?? '',
           standardName: e['name'] ?? '',
           amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
           unit: e['unit'] ?? '個',
           category: category,
           status: IngredientStatus.toBuy, // Default to toBuy
           storageType: StorageType.fridge,
           purchaseDate: now,
           expiryDate: expiryDate,
         );
      }).cast<Ingredient>().toList();

    } catch (e) {
      debugPrint('Error parsing shopping list with AI: $e');
      return [];
    }
  }


  /// 画像から在庫アイテムを解析する
  Future<List<Ingredient>> analyzeStockImage(Uint8List imageBytes, String location, {String? mimeType}) async {
    final prompt = location;

  // Determine mimeType if not provided
  // Default to jpeg if unknown, as it's most common for camera captures
  final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    final model = _createModel(
      systemInstruction: Content.system(AiPrompts.analyzeStockImageSystem),
    );
    // Let exceptions bubble up to be handled by the UI
    final response = await model.generateContent(content);

    // Log token usage
    await AiTokenLogger.logUsage(
      prompt: prompt,
      kind: 'analyzeStockImage',
      response: response,
      modelName: AppConstants.geminiModel,
    );

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
          final category = e['detailed_category'] ?? e['category'] ?? 'unknown';
          return Ingredient(
            id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), 
            name: e['name'] ?? '',
            amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
            unit: e['unit'] ?? '個',
            category: category,
            status: IngredientStatus.stock,
            storageType: StorageType.fridge, // Default
            isEssential: false,
            standardName: e['name'] ?? '', 
          );
      }).cast<Ingredient>().toList();
    } catch (e) {
      debugPrint('Error parsing ingredients from AI response: $responseText');
      throw Exception('AIの応答を解析できませんでした: $responseText');
    }
  }

  /// レシート画像から購入品を解析する
  Future<List<Ingredient>> analyzeReceiptImage(Uint8List imageBytes, {String? mimeType}) async {
    const prompt = 'Analyze this receipt image.';

  // Determine mimeType if not provided
  final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.analyzeReceiptImageSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'analyzeReceiptImage',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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
          final category = e['detailed_category'] ?? e['category'] ?? 'unknown';
          return Ingredient(
            id: DateTime.now().microsecondsSinceEpoch.toString() + (e['name'] ?? ''), 
            name: e['name'] ?? '',
            amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 1.0,
            unit: e['unit'] ?? '個',
            category: category,
            status: IngredientStatus.stock,
            storageType: StorageType.fridge, // Default
            isEssential: false,
            standardName: e['name'] ?? '', 
          );
      }).cast<Ingredient>().toList();
    } catch (e) {
      debugPrint('Error parsing receipt from AI response: $e');
      throw Exception('レシートの解析に失敗しました: $e');
    }
  }

  /// 画像からレシピ提案用の解析を行う
  Future<AiRecipeAnalysisResult> analyzeImageForRecipe(Uint8List imageBytes, {String? mimeType}) async {
    const prompt = 'Analyze this fridge image for ingredients and a recipe.';

    final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.analyzeImageForRecipeSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'analyzeImageForRecipe',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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
      debugPrint('Error parsing recipe analysis: $e');
      // Fallback
      return AiRecipeAnalysisResult(
        ingredients: ['野菜', '肉', '卵'], 
        recommendedRecipe: '冷蔵庫の残り物レシピ'
      );
    }
  }

  /// 画像からキッチンアイテムを識別する
  Future<List<String>> identifyKitchenItems(Uint8List imageBytes, {String? mimeType}) async {
    const prompt = 'Identify all kitchen items in this photo.';

    final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.identifyKitchenItemsSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'identifyKitchenItems',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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
    final prompt = 'ここにアイテムのリストがあります: ${json.encode(items)}';

    final content = [Content.text(prompt)];

    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.suggestRecipesFromItemsSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'suggestRecipesFromItems',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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

  /// 料理の画像を解析してカロリーとPFCバランスを推定する
  Future<FoodAnalysisResult> analyzeFoodImage(Uint8List imageBytes, {String? mimeType}) async {
    const prompt = 'Analyze this food photo for calories and PFC balance.';

    final finalMimeType = mimeType ?? 'image/jpeg';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(finalMimeType, imageBytes),
      ])
    ];

    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.analyzeFoodImageSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'analyzeFoodImage',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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

      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).stringMatch(cleanJson);
      if (jsonMatch != null) {
        cleanJson = jsonMatch;
      }

      final Map<String, dynamic> jsonMap = json.decode(cleanJson);
      
      final pfcMap = jsonMap['pfc'] as Map<String, dynamic>?;

      return FoodAnalysisResult(
        totalCalories: (jsonMap['total_calories'] as num?)?.toInt(),
        protein: (pfcMap?['p'] as num?)?.toDouble(),
        fat: (pfcMap?['f'] as num?)?.toDouble(),
        carbs: (pfcMap?['c'] as num?)?.toDouble(),
        foodName: jsonMap['food_name'] as String?,
        displayText: jsonMap['display_text'] as String? ?? '解析結果を取得できませんでした。',
      );

    } catch (e) {
      debugPrint('Error analyzing food image: $e');
      throw Exception('料理の解析に失敗しました: $e');
    }
  }
  /// 献立を提案する
  Future<List<AiRecipeSuggestion>> suggestMenuPlan({
    required DateTime targetDate,
    required String mealType,
    required List<String> surroundingMeals,
    required List<String> stockItems,
    required List<String> shoppingListItems,
  }) async {
    final prompt = '''
${targetDate.month}月${targetDate.day}日の「$mealType」の献立を提案してください。

【コンテキスト】
この日の前後の食事は以下の通りです。栄養バランスや味のバランス（和洋中など）を考慮してください。
$surroundingMeals

【今の状況】
- 冷蔵庫にあるもの（在庫）: ${stockItems.join(', ')}
- 買い物リストにあるもの: ${shoppingListItems.join(', ')}
''';

  final content = [Content.text(prompt)];

    try {
      final model = _createModel(
        systemInstruction: Content.system(AiPrompts.suggestMenuPlanSystem),
      );
      final response = await model.generateContent(content);

      // Log token usage
      await AiTokenLogger.logUsage(
        prompt: prompt,
        kind: 'suggestMenuPlan',
        response: response,
        modelName: AppConstants.geminiModel,
      );

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
      debugPrint('Error suggesting menu plan: $e');
      return [
        AiRecipeSuggestion(name: '旬の食材を使った定食', description: 'バランスの良い食事です', usedIngredients: ['旬の野菜', '肉または魚']),
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

class FoodAnalysisResult {
  final int? totalCalories;
  final double? protein;
  final double? fat;
  final double? carbs;
  final String? foodName;
  final String displayText;

  FoodAnalysisResult({
    this.totalCalories,
    this.protein,
    this.fat,
    this.carbs,
    this.foodName,
    required this.displayText,
  });
}

@Riverpod(keepAlive: true)
AiRecipeRepository aiRecipeRepository(AiRecipeRepositoryRef ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  return AiRecipeRepository(apiKey: apiKey);
}
