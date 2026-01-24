import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import '../../domain/models/ingredient.dart';

/// レシピサイトごとのパーサの基底クラス
abstract class RecipeParser {
  /// URLを元にこのパーサで処理可能か判定する（ドメインやパスをチェック）
  bool canParse(Uri uri);

  /// HTMLから材料を抽出する
  Future<List<Ingredient>> parse(dom.Document document);
  
  /// Helper to create Ingredient with defaults
  Ingredient createIngredient({
    required String name, 
    required String quantityStr,
  }) {
    // Determine amount and unit from quantity string
    double amount = 0.0;
    String unit = quantityStr; // Default unit is the whole string if parsing fails
    
    // Simple regex to extract number from start of string
    final match = RegExp(r'^([0-9.]+)').firstMatch(quantityStr);
    if (match != null) {
      amount = double.tryParse(match.group(1)!) ?? 0.0;
      unit = quantityStr.substring(match.end).trim();
    }
    // If unit is empty and amount is 0, pass the whole string as unit (e.g. "少々")
    if (unit.isEmpty && amount == 0) {
      unit = quantityStr;
    }

    return Ingredient(
      id: DateTime.now().microsecondsSinceEpoch.toString() + name, // Temp ID
      name: name,
      standardName: name,
      amount: amount,
      unit: unit,
      category: 'その他',
      status: IngredientStatus.toBuy,
      storageType: StorageType.fridge,
      isEssential: false,
    );
  }
}

/// DELISH KITCHEN 用
class DelishKitchenParser extends RecipeParser {
  @override
  bool canParse(Uri uri) => uri.host.contains('delishkitchen.tv');

  @override
  Future<List<Ingredient>> parse(dom.Document document) async {
    final List<Ingredient> ingredients = [];
    final elements = document.querySelectorAll('.ingredient-list .ingredient');

    for (var element in elements) {
      final nameElement = element.querySelector('.ingredient-name');
      final quantityElement = element.querySelector('.ingredient-serving');

      if (nameElement != null && quantityElement != null) {
        ingredients.add(
          createIngredient(
            name: nameElement.text.trim(),
            quantityStr: quantityElement.text.trim(),
          ),
        );
      }
    }
    return ingredients;
  }
}

/// クラシル 用
class KurashiruParser extends RecipeParser {
  @override
  bool canParse(Uri uri) => uri.host.contains('kurashiru.com');

  @override
  Future<List<Ingredient>> parse(dom.Document document) async {
    final List<Ingredient> ingredients = [];
    final elements = document.querySelectorAll('.ingredient-list .ingredient-list-item');

    for (var element in elements) {
      if (element.classes.contains('group-title')) continue;

      final nameElement = element.querySelector('.ingredient-name');
      final quantityElement = element.querySelector('.ingredient-quantity-amount');

      if (nameElement != null && quantityElement != null) {
        final name = nameElement.nodes
            .where((node) => node.nodeType == dom.Node.TEXT_NODE)
            .map((node) => node.text?.trim())
            .where((text) => text != null && text.isNotEmpty)
            .join(' ');
        
        final finalName = name.isNotEmpty ? name : nameElement.text.trim();

        ingredients.add(
          createIngredient(
            name: finalName,
            quantityStr: quantityElement.text.trim(),
          ),
        );
      }
    }
    return ingredients;
  }
}

/// macaroni 用
class MacaroniParser extends RecipeParser {
  @override
  bool canParse(Uri uri) => uri.host.contains('macaro-ni.jp');

  @override
  Future<List<Ingredient>> parse(dom.Document document) async {
    final List<Ingredient> ingredients = [];
    final elements = document.querySelectorAll('.articleShow__contentsMateriialItem');

    for (var element in elements) {
      final nameElement = element.querySelector('.articleShow__contentsMaterialName');
      final quantityElement = element.querySelector('.articleShow__contentsMaterialAmout');

      if (nameElement != null && quantityElement != null) {
        ingredients.add(
          createIngredient(
            name: nameElement.text.trim(),
            quantityStr: quantityElement.text.trim(),
          ),
        );
      }
    }
    return ingredients;
  }
}

// TODO: Other parsers (KyouNoRyouri, OrangePage, etc.) can be implemented similarly

/// URLから適切なパーサを取得するファクトリ
class RecipeParserFactory {
  static final List<RecipeParser> _parsers = [
    DelishKitchenParser(),
    KurashiruParser(),
    MacaroniParser(),
    // Add other parsers here
  ];

  static RecipeParser? getParser(String url) {
    try {
      final uri = Uri.parse(url);
      for (final parser in _parsers) {
        if (parser.canParse(uri)) return parser;
      }
    } catch (_) {}
    return null;
  }
}
