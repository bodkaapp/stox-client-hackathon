# リリース前のTODO

- AdMobの設定
- Google Maps API Key の設定
  - `android/app/src/main/AndroidManifest.xml` の `com.google.android.geo.API_KEY` に正しいキーを設定する
  - `ios/Runner/AppDelegate.m` (または `Info.plist`) にキーを設定する
- Gemini API Key の設定
  - `lib/infrastructure/repositories/ai_recipe_repository.dart` のAPIキーを環境変数などから取得するように修正する
  - https://console.developers.google.com/apis/api/generativelanguage.googleapis.com/overview?project=882140138724 にアクセスし、「有効にする」 ボタンを押してください。 数分待つと反映され、アプリから解析ができるようになるはずです。
  - Google Cloud Consoleで Generative Language API を有効にする