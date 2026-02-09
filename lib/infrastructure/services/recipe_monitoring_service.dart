import 'dart:convert';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_monitoring_service.g.dart';

@riverpod
RecipeMonitoringService recipeMonitoringService(RecipeMonitoringServiceRef ref) {
  return RecipeMonitoringService();
}

class RecipeMonitoringService {
  static const String _endpoint = 'http://localhost:18787/recipes';

  /// レシピ登録をトラッキングする
  Future<void> trackRecipeRegistration(String url) async {
    try {
      // Firebase Installation IDを取得
      final id = await FirebaseInstallations.instance.getId();
      
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': id,
          'url': url,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('RecipeMonitoringService: Failed to track registration. Status: ${response.statusCode}');
      } else {
        debugPrint('RecipeMonitoringService: Successfully tracked registration for $url');
      }
    } catch (e) {
      // トラッキングの失敗でアプリのメイン機能を止めないようエラーを握りつぶす
      debugPrint('RecipeMonitoringService: Error tracking registration: $e');
    }
  }
}
