# 開発ガイドライン

## ローカライゼーション (Localization)
- 機能の追加・修正を行う際は、必ずローカライゼーション（日・英対応）も合わせて行うこと。
- 文字列をハードコーディングせず、`AppLocalizations.of(context)!` を使用して `lib/l10n/app_ja.arb` 等で定義されたリソースを参照すること。
- **重要**: `AppLocalizations.of(context)` は定数ではないため、これを使用するWidgetやその親Widgetには `const` を付けないこと。
- `gen-l10n` の設定変更に伴い、生成ファイルは `lib/l10n/generated/` に出力されます。インポートは相対パス等でそこから行うこと。
- 新しい文言を追加した際は、必ず `flutter gen-l10n` を実行してコードを再生成すること。
