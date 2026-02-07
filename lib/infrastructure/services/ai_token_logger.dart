import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AiTokenLogger {
  /// Geminiのトークン使用量をFirestoreに記録します。
  static Future<void> logUsage({
    required String prompt,
    required String kind,
    required GenerateContentResponse response,
    String modelName = 'gemini-1.5-flash', // デフォルトモデル名
  }) async {
    try {
      final usage = response.usageMetadata;
      
      await FirebaseFirestore.instance.collection('ai_logs').add({
        'prompt': prompt,
        'kind': kind,
        'response': response.text,
        'created_at': FieldValue.serverTimestamp(),
        'usage': {
          'prompt_tokens': usage?.promptTokenCount ?? 0,
          'candidate_tokens': usage?.candidatesTokenCount ?? 0,
          'total_tokens': usage?.totalTokenCount ?? 0,
        },
        'model_name': modelName,
      });
      debugPrint('AI token usage logged successfully: $kind');
    } catch (e) {
      debugPrint('Error logging AI token usage: $e');
      // ログ保存の失敗でアプリのメイン処理を止めないよう、例外はキャッチするだけに留める
    }
  }
}
