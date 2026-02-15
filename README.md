# STOX (ストックス)

[**🌐 Web版の提供について (Hackathon Submission)**](docs/hackathon_web_alternative.md)
> 本アプリはオンデバイスML等のネイティブ機能に依存しておりWeb版の提供が困難なため、ハッカソン審査用としてこちらのドキュメントにて代えさせていただきます。

AIが「在庫」と「献立」をいい感じに管理する、ありそうでなかった買い物・料理エージェントアプリです。
食材の自動認識、レシート解析、献立提案などを Gemini API を活用して行います。

## 特徴

- **冷蔵庫内の食材認識**: 写真から食材を自動解析
- **レシート解析 & 在庫連携**: 購入履歴から在庫を自動更新
- **インテリジェント・レシピ解析**: Webレシピを構造化データとして取り込み
- **お料理モード**: 料理中に便利な表示モード
- **AI活用**: Gemini 1.5 Flash を全面的に採用

## 必要要件

- Flutter SDK: `3.0.0` 以上 `4.0.0` 未満
- Firebase プロジェクト設定
- Google Gemini API Key
- Programmable Search Engine ID & API Key

## セットアップ

このプロジェクトは Flutter で開発されています。

### 1. 依存関係のインストール

アプリケーションのルートディレクトリで実行します。

```bash
flutter pub get
```

### 2. 環境変数の設定

ルートディレクトリに `.env` ファイルを作成し、以下のキーを設定してください。
`.env.template` を参考にしてください。

```ini
GOOGLE_SEARCH_API_KEY=YOUR_SEARCH_API_KEY
PROGRAMMABLE_SEARCH_ENGINE_ID=YOUR_ENGINE_ID
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

### 3. コード生成

Riverpod, Freezed, Drift などのコード生成を行います。

```bash
dart run build_runner build -d
```

開発中は `watch` モードを利用すると変更を検知して自動で再生成されます。

```bash
dart run build_runner watch -d
```

### 4. 実行

```bash
flutter run
```

### 5. Firebase App Distribution

Firebase App Distribution でアプリを配信できます。

```bash
cd android
./gradlew assembleRelease appDistributionUploadRelease
```

### 6. 多言語対応

多言語対応のコードを生成します。
現在は日本語と英語のみ対応しています。
lib/l10n/app_en.arb と lib/l10n/app_ja.arb を編集した後、以下のコマンドを実行してください。

```bash
flutter gen-l10n
```

## アーキテクチャ

- **Frontend**: Flutter (Riverpod, GoRouter)
- **Local DB**: Drift (SQLite) - オフラインファースト
- **Backend / AI**:
  - Google Gemini API (1.5 Flash)
  - Firebase (Auth, Firestore, App Distribution)
  - Cloud Run (Hono/Next.js) + Cloud SQL (PostgreSQL) ※ログ収集・分析用
