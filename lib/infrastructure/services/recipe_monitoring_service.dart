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
  static String get _endpoint {
    if (kReleaseMode) {
      return 'https://stox-app-882140138724.asia-northeast1.run.app/recipes';
    }
    // デバッグモード時
    // Androidエミュレータからはホストのlocalhostに10.0.2.2でアクセス可能
    final host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
    return 'http://$host:18787/recipes';
  }

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
