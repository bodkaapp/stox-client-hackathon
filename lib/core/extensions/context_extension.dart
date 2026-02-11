import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  bool get isEnglish => Localizations.localeOf(this).languageCode == 'en';
  bool get isJapanese => Localizations.localeOf(this).languageCode == 'ja';
}
