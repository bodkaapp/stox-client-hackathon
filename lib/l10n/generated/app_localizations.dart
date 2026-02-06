import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In ja, this message translates to:
  /// **'こんにちは世界'**
  String get helloWorld;

  /// No description provided for @navHome.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get navHome;

  /// No description provided for @navStock.
  ///
  /// In ja, this message translates to:
  /// **'在庫'**
  String get navStock;

  /// No description provided for @navShopping.
  ///
  /// In ja, this message translates to:
  /// **'買い物'**
  String get navShopping;

  /// No description provided for @navMenuPlan.
  ///
  /// In ja, this message translates to:
  /// **'献立計画表'**
  String get navMenuPlan;

  /// No description provided for @navRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピ'**
  String get navRecipe;

  /// No description provided for @homeHelpTitle.
  ///
  /// In ja, this message translates to:
  /// **'ホーム画面'**
  String get homeHelpTitle;

  /// No description provided for @homeHelpDescription.
  ///
  /// In ja, this message translates to:
  /// **'アプリのメインの画面です。この「？」アイコンをタップすると、画面の使い方が表示されます。'**
  String get homeHelpDescription;

  /// No description provided for @homeTodaysMenu.
  ///
  /// In ja, this message translates to:
  /// **'今日の献立'**
  String get homeTodaysMenu;

  /// No description provided for @homeRegisterMenu.
  ///
  /// In ja, this message translates to:
  /// **'登録する'**
  String get homeRegisterMenu;

  /// No description provided for @homeChangeMenu.
  ///
  /// In ja, this message translates to:
  /// **'献立を変更する'**
  String get homeChangeMenu;

  /// No description provided for @homeNoMenuPlan.
  ///
  /// In ja, this message translates to:
  /// **'今日の献立はまだありません'**
  String get homeNoMenuPlan;

  /// No description provided for @homeViewRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピを見る'**
  String get homeViewRecipe;

  /// No description provided for @homeShoppingList.
  ///
  /// In ja, this message translates to:
  /// **'買うもの'**
  String get homeShoppingList;

  /// No description provided for @homeShoppingAd.
  ///
  /// In ja, this message translates to:
  /// **'近所のスーパーで特売中！'**
  String get homeShoppingAd;

  /// No description provided for @homeViewFlyer.
  ///
  /// In ja, this message translates to:
  /// **'チラシを見る'**
  String get homeViewFlyer;

  /// No description provided for @unitItems.
  ///
  /// In ja, this message translates to:
  /// **'件'**
  String get unitItems;

  /// No description provided for @homeExpiringSoon.
  ///
  /// In ja, this message translates to:
  /// **'賞味期限が近いもの'**
  String get homeExpiringSoon;

  /// No description provided for @homeViewAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて見る'**
  String get homeViewAll;

  /// No description provided for @homeNoExpiringItems.
  ///
  /// In ja, this message translates to:
  /// **'賞味期限切れはありません'**
  String get homeNoExpiringItems;

  /// No description provided for @actionCheckStock.
  ///
  /// In ja, this message translates to:
  /// **'在庫チェック'**
  String get actionCheckStock;

  /// No description provided for @actionScanReceipt.
  ///
  /// In ja, this message translates to:
  /// **'レシート登録'**
  String get actionScanReceipt;

  /// No description provided for @actionShoppingMode.
  ///
  /// In ja, this message translates to:
  /// **'買い物モード'**
  String get actionShoppingMode;

  /// No description provided for @actionRecipeBook.
  ///
  /// In ja, this message translates to:
  /// **'マイレシピ帳'**
  String get actionRecipeBook;

  /// No description provided for @actionFoodCamera.
  ///
  /// In ja, this message translates to:
  /// **'料理を撮影'**
  String get actionFoodCamera;

  /// No description provided for @actionPhotoGallery.
  ///
  /// In ja, this message translates to:
  /// **'写真を見る'**
  String get actionPhotoGallery;

  /// No description provided for @daysRemaining.
  ///
  /// In ja, this message translates to:
  /// **'あと{days}日'**
  String daysRemaining(Object days);

  /// No description provided for @statusCheck.
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get statusCheck;

  /// No description provided for @statusUrgent.
  ///
  /// In ja, this message translates to:
  /// **'緊急'**
  String get statusUrgent;

  /// No description provided for @statusWarning.
  ///
  /// In ja, this message translates to:
  /// **'注意'**
  String get statusWarning;

  /// No description provided for @shoppingAddToShoppingList.
  ///
  /// In ja, this message translates to:
  /// **'買い物リストに追加'**
  String get shoppingAddToShoppingList;

  /// No description provided for @shoppingTitle.
  ///
  /// In ja, this message translates to:
  /// **'お買い物'**
  String get shoppingTitle;

  /// No description provided for @shoppingHelpTitle.
  ///
  /// In ja, this message translates to:
  /// **'買い物画面'**
  String get shoppingHelpTitle;

  /// No description provided for @shoppingHelpDescription.
  ///
  /// In ja, this message translates to:
  /// **'買いたいものを管理する画面です。\n「＋」ボタンをタップして、買うものを登録できます。\n「お買い物モード」ボタンを押すと、お買い物を便利にするモードに切り替わります。\nお買い物が終わった後はレシートを撮影して、買ったものを在庫に移動することもできます。'**
  String get shoppingHelpDescription;

  /// No description provided for @shoppingAction.
  ///
  /// In ja, this message translates to:
  /// **'アクション'**
  String get shoppingAction;

  /// No description provided for @shoppingEnterItem.
  ///
  /// In ja, this message translates to:
  /// **'買うものを入力'**
  String get shoppingEnterItem;

  /// No description provided for @shoppingVoiceInput.
  ///
  /// In ja, this message translates to:
  /// **'音声で入力'**
  String get shoppingVoiceInput;

  /// No description provided for @shoppingReceiptScan.
  ///
  /// In ja, this message translates to:
  /// **'レシート撮影'**
  String get shoppingReceiptScan;

  /// No description provided for @shoppingModeOn.
  ///
  /// In ja, this message translates to:
  /// **'お買い物モード中'**
  String get shoppingModeOn;

  /// No description provided for @shoppingModeStart.
  ///
  /// In ja, this message translates to:
  /// **'お買い物モードを開始'**
  String get shoppingModeStart;

  /// No description provided for @shoppingCompleteAction.
  ///
  /// In ja, this message translates to:
  /// **'買い物を完了する'**
  String get shoppingCompleteAction;

  /// No description provided for @shoppingAddGuide.
  ///
  /// In ja, this message translates to:
  /// **'ここをタップして材料を追加します'**
  String get shoppingAddGuide;

  /// No description provided for @shoppingEnterItemAction.
  ///
  /// In ja, this message translates to:
  /// **'買うものを入力する'**
  String get shoppingEnterItemAction;

  /// No description provided for @shoppingVoiceInputAction.
  ///
  /// In ja, this message translates to:
  /// **'声で操作する'**
  String get shoppingVoiceInputAction;

  /// No description provided for @shoppingReceiptScanAction.
  ///
  /// In ja, this message translates to:
  /// **'レシートを撮影する（お買い物モードを終わる）'**
  String get shoppingReceiptScanAction;

  /// No description provided for @shoppingCompleteButton.
  ///
  /// In ja, this message translates to:
  /// **'買い物を完了'**
  String get shoppingCompleteButton;

  /// No description provided for @shoppingEmptyListMessage.
  ///
  /// In ja, this message translates to:
  /// **'買い物リストを登録する場所です。\n買うものを忘れないように\nメモしておきましょう。'**
  String get shoppingEmptyListMessage;

  /// No description provided for @shoppingTotalItemsLabel.
  ///
  /// In ja, this message translates to:
  /// **'TOTAL ITEMS'**
  String get shoppingTotalItemsLabel;

  /// No description provided for @shoppingTotalItemsCount.
  ///
  /// In ja, this message translates to:
  /// **'全 {count} 品目'**
  String shoppingTotalItemsCount(Object count);

  /// No description provided for @shoppingModeToggleOn.
  ///
  /// In ja, this message translates to:
  /// **'お買い物モード ON'**
  String get shoppingModeToggleOn;

  /// No description provided for @shoppingModeToggleOff.
  ///
  /// In ja, this message translates to:
  /// **'お買い物モード OFF'**
  String get shoppingModeToggleOff;

  /// No description provided for @shoppingCartProgress.
  ///
  /// In ja, this message translates to:
  /// **'カゴの進捗'**
  String get shoppingCartProgress;

  /// No description provided for @shoppingCartCount.
  ///
  /// In ja, this message translates to:
  /// **'{count} / {total} 点'**
  String shoppingCartCount(Object count, Object total);

  /// No description provided for @shoppingRemainingItems.
  ///
  /// In ja, this message translates to:
  /// **'あと{remaining}点でお買い物完了です'**
  String shoppingRemainingItems(Object remaining);

  /// No description provided for @categoryUncategorized.
  ///
  /// In ja, this message translates to:
  /// **'未分類'**
  String get categoryUncategorized;

  /// No description provided for @categoryVegetablesFruits.
  ///
  /// In ja, this message translates to:
  /// **'野菜・果物'**
  String get categoryVegetablesFruits;

  /// No description provided for @categoryMeatFish.
  ///
  /// In ja, this message translates to:
  /// **'肉・魚'**
  String get categoryMeatFish;

  /// No description provided for @categorySeasoning.
  ///
  /// In ja, this message translates to:
  /// **'調味料'**
  String get categorySeasoning;

  /// No description provided for @voicePermissionError.
  ///
  /// In ja, this message translates to:
  /// **'マイクの権限が必要です'**
  String get voicePermissionError;

  /// No description provided for @voiceAnalyzing.
  ///
  /// In ja, this message translates to:
  /// **'AIが解析中...'**
  String get voiceAnalyzing;

  /// No description provided for @voiceListening.
  ///
  /// In ja, this message translates to:
  /// **'聞いています...'**
  String get voiceListening;

  /// No description provided for @voiceTapToStart.
  ///
  /// In ja, this message translates to:
  /// **'タップして開始'**
  String get voiceTapToStart;

  /// No description provided for @voiceHint.
  ///
  /// In ja, this message translates to:
  /// **'商品名を話しかけてください\n例：「長ネギ」「豚肉とキャベツ」'**
  String get voiceHint;

  /// No description provided for @voiceHistoryPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'追加履歴がここに表示されます'**
  String get voiceHistoryPlaceholder;

  /// No description provided for @voiceAdded.
  ///
  /// In ja, this message translates to:
  /// **'追加済'**
  String get voiceAdded;

  /// No description provided for @voiceClose.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get voiceClose;

  /// No description provided for @voiceAiError.
  ///
  /// In ja, this message translates to:
  /// **'AIで解析できませんでした'**
  String get voiceAiError;

  /// No description provided for @voiceCompleteMessage.
  ///
  /// In ja, this message translates to:
  /// **'{count}件の操作を完了しました'**
  String voiceCompleteMessage(Object count);

  /// No description provided for @addModalCategoryHint.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ (任意)'**
  String get addModalCategoryHint;

  /// No description provided for @addModalNameHint.
  ///
  /// In ja, this message translates to:
  /// **'材料名 (例: にんじん)'**
  String get addModalNameHint;

  /// No description provided for @addModalAddButton.
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get addModalAddButton;

  /// No description provided for @addModalConfirmButton.
  ///
  /// In ja, this message translates to:
  /// **'確定'**
  String get addModalConfirmButton;

  /// No description provided for @addModalEmptyList.
  ///
  /// In ja, this message translates to:
  /// **'追加した材料がここに表示されます'**
  String get addModalEmptyList;

  /// No description provided for @addModalHeaderName.
  ///
  /// In ja, this message translates to:
  /// **'材料名'**
  String get addModalHeaderName;

  /// No description provided for @addModalHeaderQuantity.
  ///
  /// In ja, this message translates to:
  /// **'数量'**
  String get addModalHeaderQuantity;

  /// No description provided for @addModalHeaderCategory.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ'**
  String get addModalHeaderCategory;

  /// No description provided for @addModalAiSuccess.
  ///
  /// In ja, this message translates to:
  /// **'{count}件をリストに追加しました'**
  String addModalAiSuccess(Object count);

  /// No description provided for @addModalAiError.
  ///
  /// In ja, this message translates to:
  /// **'AIで解析できませんでした'**
  String get addModalAiError;

  /// No description provided for @addModalSaveError.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました: {error}'**
  String addModalSaveError(Object error);

  /// No description provided for @stockTitle.
  ///
  /// In ja, this message translates to:
  /// **'在庫一覧'**
  String get stockTitle;

  /// No description provided for @stockHelpTitle.
  ///
  /// In ja, this message translates to:
  /// **'在庫一覧画面'**
  String get stockHelpTitle;

  /// No description provided for @stockHelpDescription.
  ///
  /// In ja, this message translates to:
  /// **'家にある食材や日用品の在庫を確認する画面です。個数や賞味期限の確認ができます。\n「＋」ボタンをタップすると、在庫を声で追加したり、まとめて削除することができます'**
  String get stockHelpDescription;

  /// No description provided for @menuPlanTitle.
  ///
  /// In ja, this message translates to:
  /// **'献立計画表'**
  String get menuPlanTitle;

  /// No description provided for @menuPlanHelpTitle.
  ///
  /// In ja, this message translates to:
  /// **'献立計画表画面'**
  String get menuPlanHelpTitle;

  /// No description provided for @menuPlanHelpDescription.
  ///
  /// In ja, this message translates to:
  /// **'これから作る料理の献立を計画したり、前に作った料理のレシピを振り返ったりする画面です。\n作った後に撮影した写真を貼っておくこともできます。'**
  String get menuPlanHelpDescription;

  /// No description provided for @recipeBookTitle.
  ///
  /// In ja, this message translates to:
  /// **'マイレシピ帳'**
  String get recipeBookTitle;

  /// No description provided for @recipeBookHelpTitle.
  ///
  /// In ja, this message translates to:
  /// **'マイレシピ帳画面'**
  String get recipeBookHelpTitle;

  /// No description provided for @recipeBookHelpDescription.
  ///
  /// In ja, this message translates to:
  /// **'レシピを検索したり、献立を計画したり、作った料理のレシピを記録したりする画面です。'**
  String get recipeBookHelpDescription;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'在庫を検索...'**
  String get searchPlaceholder;

  /// No description provided for @categoryAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get categoryAll;

  /// No description provided for @categoryDairy.
  ///
  /// In ja, this message translates to:
  /// **'乳製品'**
  String get categoryDairy;

  /// No description provided for @stockHeaderType.
  ///
  /// In ja, this message translates to:
  /// **'類'**
  String get stockHeaderType;

  /// No description provided for @stockHeaderName.
  ///
  /// In ja, this message translates to:
  /// **'品名'**
  String get stockHeaderName;

  /// No description provided for @stockHeaderDate.
  ///
  /// In ja, this message translates to:
  /// **'期限'**
  String get stockHeaderDate;

  /// No description provided for @stockHeaderAmount.
  ///
  /// In ja, this message translates to:
  /// **'残量'**
  String get stockHeaderAmount;

  /// No description provided for @stockNoSearchResults.
  ///
  /// In ja, this message translates to:
  /// **'検索結果がありません'**
  String get stockNoSearchResults;

  /// No description provided for @stockEmptyDescription.
  ///
  /// In ja, this message translates to:
  /// **'家の中にある\n「買ったもの」「もらったもの」\nを登録して見る場所です。'**
  String get stockEmptyDescription;

  /// No description provided for @stockEmptyAddInstruction.
  ///
  /// In ja, this message translates to:
  /// **'ここをタップして在庫を追加します'**
  String get stockEmptyAddInstruction;

  /// No description provided for @actionCancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get actionCancel;

  /// No description provided for @labelDraftDesign.
  ///
  /// In ja, this message translates to:
  /// **'仮デザイン'**
  String get labelDraftDesign;

  /// No description provided for @myAreaSetting.
  ///
  /// In ja, this message translates to:
  /// **'マイエリア設定'**
  String get myAreaSetting;

  /// No description provided for @labelRecommended.
  ///
  /// In ja, this message translates to:
  /// **'おすすめ'**
  String get labelRecommended;

  /// No description provided for @labelNewItem.
  ///
  /// In ja, this message translates to:
  /// **'NEW ITEM'**
  String get labelNewItem;

  /// No description provided for @tutorialTitle.
  ///
  /// In ja, this message translates to:
  /// **'冷蔵庫の中を\n撮影しましょう'**
  String get tutorialTitle;

  /// No description provided for @tutorialDescription.
  ///
  /// In ja, this message translates to:
  /// **'AIが写真を解析して、最適なレシピを提案します'**
  String get tutorialDescription;

  /// No description provided for @actionStartCamera.
  ///
  /// In ja, this message translates to:
  /// **'カメラを起動する'**
  String get actionStartCamera;

  /// No description provided for @actionRegisterManually.
  ///
  /// In ja, this message translates to:
  /// **'手動で登録する'**
  String get actionRegisterManually;

  /// No description provided for @titleAccountSettings.
  ///
  /// In ja, this message translates to:
  /// **'アカウント設定'**
  String get titleAccountSettings;

  /// No description provided for @labelDebugDeveloperOptions.
  ///
  /// In ja, this message translates to:
  /// **'デバッグ・開発者オプション'**
  String get labelDebugDeveloperOptions;

  /// No description provided for @actionRestartFromTutorial.
  ///
  /// In ja, this message translates to:
  /// **'チュートリアルからやり直す'**
  String get actionRestartFromTutorial;

  /// No description provided for @actionRestart.
  ///
  /// In ja, this message translates to:
  /// **'やり直す'**
  String get actionRestart;

  /// No description provided for @actionReset.
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get actionReset;

  /// No description provided for @actionResetChallengeStamps.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジスタンプをリセット'**
  String get actionResetChallengeStamps;

  /// No description provided for @labelCheckAiResultDebug.
  ///
  /// In ja, this message translates to:
  /// **'AI解析結果画面確認 (Debug)'**
  String get labelCheckAiResultDebug;

  /// No description provided for @labelCheckSplashScreen.
  ///
  /// In ja, this message translates to:
  /// **'スプラッシュ画面確認 (Debug)'**
  String get labelCheckSplashScreen;

  /// No description provided for @titleConfirmation.
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get titleConfirmation;

  /// No description provided for @messageRestartFromTutorialConfirm.
  ///
  /// In ja, this message translates to:
  /// **'本当にチュートリアルからやり直しますか？\n現在の状態は一部リセットされる可能性があります。'**
  String get messageRestartFromTutorialConfirm;

  /// No description provided for @messageResetChallengeStampsConfirm.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジスタンプの獲得状況をすべてリセットしますか？\nこの操作は取り消せません。'**
  String get messageResetChallengeStampsConfirm;

  /// No description provided for @messageChallengeStampsResetComplete.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジスタンプをリセットしました'**
  String get messageChallengeStampsResetComplete;

  /// No description provided for @saveFailed.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました'**
  String get saveFailed;

  /// No description provided for @receiptAnalysisResultTitle.
  ///
  /// In ja, this message translates to:
  /// **'レシート解析結果'**
  String get receiptAnalysisResultTitle;

  /// No description provided for @actionSetToStock.
  ///
  /// In ja, this message translates to:
  /// **'在庫にする'**
  String get actionSetToStock;

  /// No description provided for @receiptSectionMatchedDescription.
  ///
  /// In ja, this message translates to:
  /// **'レシートと買物リストの両方にありました。\n在庫に登録します。'**
  String get receiptSectionMatchedDescription;

  /// No description provided for @actionAddNew.
  ///
  /// In ja, this message translates to:
  /// **'新規に追加'**
  String get actionAddNew;

  /// No description provided for @receiptSectionNewDescription.
  ///
  /// In ja, this message translates to:
  /// **'買い物リストにありませんでした。\n在庫に追加しますか？'**
  String get receiptSectionNewDescription;

  /// No description provided for @statusUnpurchased.
  ///
  /// In ja, this message translates to:
  /// **'未購入'**
  String get statusUnpurchased;

  /// No description provided for @receiptSectionUnpurchasedDescription.
  ///
  /// In ja, this message translates to:
  /// **'レシートにありませんでした。\n買い忘れていませんか？'**
  String get receiptSectionUnpurchasedDescription;

  /// No description provided for @actionKeepInList.
  ///
  /// In ja, this message translates to:
  /// **'リストに残す'**
  String get actionKeepInList;

  /// No description provided for @locationFridge.
  ///
  /// In ja, this message translates to:
  /// **'冷蔵庫'**
  String get locationFridge;

  /// No description provided for @locationFreezer.
  ///
  /// In ja, this message translates to:
  /// **'冷凍庫'**
  String get locationFreezer;

  /// No description provided for @locationVegetable.
  ///
  /// In ja, this message translates to:
  /// **'野菜室'**
  String get locationVegetable;

  /// No description provided for @locationUnderSink.
  ///
  /// In ja, this message translates to:
  /// **'シンク下'**
  String get locationUnderSink;

  /// No description provided for @locationPantry.
  ///
  /// In ja, this message translates to:
  /// **'食品庫'**
  String get locationPantry;

  /// No description provided for @locationStorageRoom.
  ///
  /// In ja, this message translates to:
  /// **'物置'**
  String get locationStorageRoom;

  /// No description provided for @locationRoomTemp.
  ///
  /// In ja, this message translates to:
  /// **'常温'**
  String get locationRoomTemp;

  /// No description provided for @actionShareRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピをシェア'**
  String get actionShareRecipe;

  /// No description provided for @aiAnalysisRecipeIngredientsDescription.
  ///
  /// In ja, this message translates to:
  /// **'AIがレシピの材料を分析しています。\n解析が終わるまで広告をご覧ください。'**
  String get aiAnalysisRecipeIngredientsDescription;

  /// No description provided for @actionCookThisRecipe.
  ///
  /// In ja, this message translates to:
  /// **'このレシピを作る！'**
  String get actionCookThisRecipe;

  /// No description provided for @recipeSavedToBook.
  ///
  /// In ja, this message translates to:
  /// **'マイレシピ帳に登録しました'**
  String get recipeSavedToBook;

  /// No description provided for @recipeSaveError.
  ///
  /// In ja, this message translates to:
  /// **'登録に失敗しました'**
  String get recipeSaveError;

  /// No description provided for @recipeSaveTitle.
  ///
  /// In ja, this message translates to:
  /// **'レシピの保存'**
  String get recipeSaveTitle;

  /// No description provided for @recipeSaveQuestion.
  ///
  /// In ja, this message translates to:
  /// **'このレシピをどうしますか？'**
  String get recipeSaveQuestion;

  /// No description provided for @actionRegisterToMyRecipeBook.
  ///
  /// In ja, this message translates to:
  /// **'献立に登録する'**
  String get actionRegisterToMyRecipeBook;

  /// No description provided for @aiAnalysisRecipeIngredientsDescriptionLong.
  ///
  /// In ja, this message translates to:
  /// **'AIがレシピの材料を分析しています。\n広告を再生している間に解析を行います。'**
  String get aiAnalysisRecipeIngredientsDescriptionLong;

  /// No description provided for @actionWatchAdAndAnalyze.
  ///
  /// In ja, this message translates to:
  /// **'広告を見て解析する'**
  String get actionWatchAdAndAnalyze;

  /// No description provided for @analysisFailedTryAgain.
  ///
  /// In ja, this message translates to:
  /// **'解析に失敗しました。もう一度お試しください。'**
  String get analysisFailedTryAgain;

  /// No description provided for @tabRecentlyViewed.
  ///
  /// In ja, this message translates to:
  /// **'最近見たレシピ'**
  String get tabRecentlyViewed;

  /// No description provided for @tabRecentlyAdded.
  ///
  /// In ja, this message translates to:
  /// **'最近登録したレシピ'**
  String get tabRecentlyAdded;

  /// No description provided for @noRecentlyAddedRecipes.
  ///
  /// In ja, this message translates to:
  /// **'登録されたレシピはありません'**
  String get noRecentlyAddedRecipes;

  /// No description provided for @dateYMD.
  ///
  /// In ja, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String dateYMD(Object year, Object month, Object day);

  /// No description provided for @searchFailedMessage.
  ///
  /// In ja, this message translates to:
  /// **'検索に失敗しました'**
  String get searchFailedMessage;

  /// No description provided for @errorNetwork.
  ///
  /// In ja, this message translates to:
  /// **'通信エラーが発生しました'**
  String get errorNetwork;

  /// No description provided for @recipeSearchResults.
  ///
  /// In ja, this message translates to:
  /// **'「{query}」の検索結果'**
  String recipeSearchResults(String query);

  /// No description provided for @labelFromRecipeSites.
  ///
  /// In ja, this message translates to:
  /// **'レシピサイトから'**
  String get labelFromRecipeSites;

  /// No description provided for @noRecipeSearchResults.
  ///
  /// In ja, this message translates to:
  /// **'レシピサイトに結果が見つかりませんでした'**
  String get noRecipeSearchResults;

  /// No description provided for @titleChangeMyArea.
  ///
  /// In ja, this message translates to:
  /// **'マイエリアの変更'**
  String get titleChangeMyArea;

  /// No description provided for @statusFollowing.
  ///
  /// In ja, this message translates to:
  /// **'フォロー中'**
  String get statusFollowing;

  /// No description provided for @fileNotFound.
  ///
  /// In ja, this message translates to:
  /// **'ファイルが見つかりません'**
  String get fileNotFound;

  /// No description provided for @analysisFailed.
  ///
  /// In ja, this message translates to:
  /// **'解析に失敗しました'**
  String get analysisFailed;

  /// No description provided for @foodPhotoAnalysisComplete.
  ///
  /// In ja, this message translates to:
  /// **'料理の写真の解析が終わりました。'**
  String get foodPhotoAnalysisComplete;

  /// No description provided for @sharedWithStox.
  ///
  /// In ja, this message translates to:
  /// **'STOXで撮影しました'**
  String get sharedWithStox;

  /// No description provided for @actionAnalyzeNutritionWithAi.
  ///
  /// In ja, this message translates to:
  /// **'AIで栄養価を解析する'**
  String get actionAnalyzeNutritionWithAi;

  /// No description provided for @cancelAnalysisLater.
  ///
  /// In ja, this message translates to:
  /// **'今は解析しないのでキャンセル'**
  String get cancelAnalysisLater;

  /// No description provided for @analysisCancelled.
  ///
  /// In ja, this message translates to:
  /// **'解析をキャンセルしました'**
  String get analysisCancelled;

  /// No description provided for @mealMorning.
  ///
  /// In ja, this message translates to:
  /// **'朝'**
  String get mealMorning;

  /// No description provided for @mealNoon.
  ///
  /// In ja, this message translates to:
  /// **'昼'**
  String get mealNoon;

  /// No description provided for @mealNight.
  ///
  /// In ja, this message translates to:
  /// **'夜'**
  String get mealNight;

  /// No description provided for @mealSnack.
  ///
  /// In ja, this message translates to:
  /// **'おやつ'**
  String get mealSnack;

  /// No description provided for @mealPrep.
  ///
  /// In ja, this message translates to:
  /// **'下ごしらえ'**
  String get mealPrep;

  /// No description provided for @mealAppetizer.
  ///
  /// In ja, this message translates to:
  /// **'おつまみ'**
  String get mealAppetizer;

  /// No description provided for @titleWhenToMake.
  ///
  /// In ja, this message translates to:
  /// **'いつ作りますか？'**
  String get titleWhenToMake;

  /// No description provided for @actionSetDateUndecided.
  ///
  /// In ja, this message translates to:
  /// **'日程を未定にする'**
  String get actionSetDateUndecided;

  /// No description provided for @labelSelectTimeSlot.
  ///
  /// In ja, this message translates to:
  /// **'時間帯を選択'**
  String get labelSelectTimeSlot;

  /// No description provided for @labelMemoOptional.
  ///
  /// In ja, this message translates to:
  /// **'メモ（任意）'**
  String get labelMemoOptional;

  /// No description provided for @saveAction.
  ///
  /// In ja, this message translates to:
  /// **'確定する'**
  String get saveAction;

  /// No description provided for @categoryOthers.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get categoryOthers;

  /// No description provided for @actionAi.
  ///
  /// In ja, this message translates to:
  /// **'AI'**
  String get actionAi;

  /// No description provided for @actionSearch.
  ///
  /// In ja, this message translates to:
  /// **'検索'**
  String get actionSearch;

  /// No description provided for @actionGetAiSuggestions.
  ///
  /// In ja, this message translates to:
  /// **'AIに提案してもらう'**
  String get actionGetAiSuggestions;

  /// No description provided for @labelSearchHistory.
  ///
  /// In ja, this message translates to:
  /// **'検索履歴'**
  String get labelSearchHistory;

  /// No description provided for @actionManualRecipeEntryInstead.
  ///
  /// In ja, this message translates to:
  /// **'検索せずに、レシピを手入力する'**
  String get actionManualRecipeEntryInstead;

  /// No description provided for @labelManualRecipeEntry.
  ///
  /// In ja, this message translates to:
  /// **'レシピを手入力'**
  String get labelManualRecipeEntry;

  /// No description provided for @actionNext.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get actionNext;

  /// No description provided for @actionDelete.
  ///
  /// In ja, this message translates to:
  /// **'削除します'**
  String get actionDelete;

  /// No description provided for @stockDeleteConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'本当に削除してもいいですか？'**
  String get stockDeleteConfirmMessage;

  /// No description provided for @stockDeletedMessage.
  ///
  /// In ja, this message translates to:
  /// **'{count}件を削除しました'**
  String stockDeletedMessage(Object count);

  /// No description provided for @actionUndo.
  ///
  /// In ja, this message translates to:
  /// **'やっぱり元に戻す'**
  String get actionUndo;

  /// No description provided for @stockRestoreConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'削除した商品を元に戻しますか？'**
  String get stockRestoreConfirmMessage;

  /// No description provided for @actionRestore.
  ///
  /// In ja, this message translates to:
  /// **'元に戻す'**
  String get actionRestore;

  /// No description provided for @stockRestoredMessage.
  ///
  /// In ja, this message translates to:
  /// **'商品を元に戻しました'**
  String get stockRestoredMessage;

  /// No description provided for @stockSelectedCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}件選択中'**
  String stockSelectedCount(Object count);

  /// No description provided for @stockCategoryLabel.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ'**
  String get stockCategoryLabel;

  /// No description provided for @stockOperationLabel.
  ///
  /// In ja, this message translates to:
  /// **'操作'**
  String get stockOperationLabel;

  /// No description provided for @stockDeleteButtonLabel.
  ///
  /// In ja, this message translates to:
  /// **'削除する ({count})'**
  String stockDeleteButtonLabel(Object count);

  /// No description provided for @stockCancelSelection.
  ///
  /// In ja, this message translates to:
  /// **'選択をキャンセル'**
  String get stockCancelSelection;

  /// No description provided for @stockAddToShoppingList.
  ///
  /// In ja, this message translates to:
  /// **'買い物リストへ追加する'**
  String get stockAddToShoppingList;

  /// No description provided for @stockAddByTextInput.
  ///
  /// In ja, this message translates to:
  /// **'文字入力で追加'**
  String get stockAddByTextInput;

  /// No description provided for @stockAddByVoice.
  ///
  /// In ja, this message translates to:
  /// **'音声入力で追加'**
  String get stockAddByVoice;

  /// No description provided for @stockAddByPhoto.
  ///
  /// In ja, this message translates to:
  /// **'写真撮影で追加'**
  String get stockAddByPhoto;

  /// No description provided for @stockDeleteItems.
  ///
  /// In ja, this message translates to:
  /// **'商品を選んで削除する'**
  String get stockDeleteItems;

  /// No description provided for @dateToday.
  ///
  /// In ja, this message translates to:
  /// **'今日'**
  String get dateToday;

  /// No description provided for @dateTomorrow.
  ///
  /// In ja, this message translates to:
  /// **'明日'**
  String get dateTomorrow;

  /// No description provided for @stockTotalItems.
  ///
  /// In ja, this message translates to:
  /// **'全 {count} 品目'**
  String stockTotalItems(Object count);

  /// No description provided for @stockExpiredCount.
  ///
  /// In ja, this message translates to:
  /// **'  ● {count}品期限間近'**
  String stockExpiredCount(Object count);

  /// No description provided for @errorOccurred.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @stockDeleteActionGuide.
  ///
  /// In ja, this message translates to:
  /// **'ここをタップして削除します'**
  String get stockDeleteActionGuide;

  /// No description provided for @stockAddTitle.
  ///
  /// In ja, this message translates to:
  /// **'在庫を追加'**
  String get stockAddTitle;

  /// No description provided for @menuBreakfast.
  ///
  /// In ja, this message translates to:
  /// **'朝食'**
  String get menuBreakfast;

  /// No description provided for @menuBreakfastLabel.
  ///
  /// In ja, this message translates to:
  /// **'朝'**
  String get menuBreakfastLabel;

  /// No description provided for @menuLunch.
  ///
  /// In ja, this message translates to:
  /// **'昼食'**
  String get menuLunch;

  /// No description provided for @menuLunchLabel.
  ///
  /// In ja, this message translates to:
  /// **'昼'**
  String get menuLunchLabel;

  /// No description provided for @menuDinner.
  ///
  /// In ja, this message translates to:
  /// **'夕食'**
  String get menuDinner;

  /// No description provided for @menuDinnerLabel.
  ///
  /// In ja, this message translates to:
  /// **'夜'**
  String get menuDinnerLabel;

  /// No description provided for @menuUndecided.
  ///
  /// In ja, this message translates to:
  /// **'時間未定'**
  String get menuUndecided;

  /// No description provided for @menuUndecidedLabel.
  ///
  /// In ja, this message translates to:
  /// **'未定'**
  String get menuUndecidedLabel;

  /// No description provided for @menuMealPrep.
  ///
  /// In ja, this message translates to:
  /// **'作り置き'**
  String get menuMealPrep;

  /// No description provided for @menuMealPrepLabel.
  ///
  /// In ja, this message translates to:
  /// **'準備'**
  String get menuMealPrepLabel;

  /// No description provided for @menuNoMenu.
  ///
  /// In ja, this message translates to:
  /// **'献立はありません'**
  String get menuNoMenu;

  /// No description provided for @menuNoPlan.
  ///
  /// In ja, this message translates to:
  /// **'予定はありません'**
  String get menuNoPlan;

  /// No description provided for @menuAskAi.
  ///
  /// In ja, this message translates to:
  /// **'AIに献立を提案してもらう'**
  String get menuAskAi;

  /// No description provided for @aiSuggestion.
  ///
  /// In ja, this message translates to:
  /// **'AIに提案してもらう'**
  String get aiSuggestion;

  /// No description provided for @menuMade.
  ///
  /// In ja, this message translates to:
  /// **'作った'**
  String get menuMade;

  /// No description provided for @menuCook.
  ///
  /// In ja, this message translates to:
  /// **'料理する'**
  String get menuCook;

  /// No description provided for @menuAddDish.
  ///
  /// In ja, this message translates to:
  /// **'料理を追加する'**
  String get menuAddDish;

  /// No description provided for @menuAdd.
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get menuAdd;

  /// No description provided for @menuMealPrepGuide.
  ///
  /// In ja, this message translates to:
  /// **'週末の作り置きレシピを\n登録してみましょう'**
  String get menuMealPrepGuide;

  /// No description provided for @menuCookedAt.
  ///
  /// In ja, this message translates to:
  /// **'{time}に作りました'**
  String menuCookedAt(Object time);

  /// No description provided for @menuReturnToToday.
  ///
  /// In ja, this message translates to:
  /// **'今日に戻る'**
  String get menuReturnToToday;

  /// No description provided for @menuReturnToTodayDescription.
  ///
  /// In ja, this message translates to:
  /// **'今日のカレンダーに戻すためのボタンです'**
  String get menuReturnToTodayDescription;

  /// No description provided for @menuAiProposalTitle.
  ///
  /// In ja, this message translates to:
  /// **'AI献立提案'**
  String get menuAiProposalTitle;

  /// No description provided for @menuAiProposalMessage.
  ///
  /// In ja, this message translates to:
  /// **'広告を視聴して、AIに献立を提案してもらいますか？\n（今の冷蔵庫の中身や前後の食事バランスを考慮します）'**
  String get menuAiProposalMessage;

  /// No description provided for @menuAiProposalAction.
  ///
  /// In ja, this message translates to:
  /// **'広告を見て提案してもらう'**
  String get menuAiProposalAction;

  /// No description provided for @adExecuteAction.
  ///
  /// In ja, this message translates to:
  /// **'広告を見て実行する'**
  String get adExecuteAction;

  /// No description provided for @adLoadError.
  ///
  /// In ja, this message translates to:
  /// **'広告の読み込みに失敗しました。通信環境を確認して再度お試しください。'**
  String get adLoadError;

  /// No description provided for @menuCookingDoneTitle.
  ///
  /// In ja, this message translates to:
  /// **'お料理お疲れ様でした！'**
  String get menuCookingDoneTitle;

  /// No description provided for @menuCookingDoneMessage.
  ///
  /// In ja, this message translates to:
  /// **'もし作った料理を撮影した写真があったら、写真を貼っておくことで、後で見返すのが楽になります✨'**
  String get menuCookingDoneMessage;

  /// No description provided for @menuAttachPhoto.
  ///
  /// In ja, this message translates to:
  /// **'撮った写真を貼る'**
  String get menuAttachPhoto;

  /// No description provided for @menuTakePhoto.
  ///
  /// In ja, this message translates to:
  /// **'撮影する'**
  String get menuTakePhoto;

  /// No description provided for @menuCompleteWithoutPhoto.
  ///
  /// In ja, this message translates to:
  /// **'写真を貼らずに完了する'**
  String get menuCompleteWithoutPhoto;

  /// No description provided for @menuSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました: {error}'**
  String menuSaveFailed(Object error);

  /// No description provided for @menuImagesSkipped.
  ///
  /// In ja, this message translates to:
  /// **'{count} 枚の画像はすでに存在するためスキップされました'**
  String menuImagesSkipped(Object count);

  /// No description provided for @menuImageSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'画像の保存に失敗しました: {error}'**
  String menuImageSaveFailed(Object error);

  /// No description provided for @menuNoRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピがありません'**
  String get menuNoRecipe;

  /// No description provided for @menuLoading.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中'**
  String get menuLoading;

  /// No description provided for @recipePastMenus.
  ///
  /// In ja, this message translates to:
  /// **'過去の献立'**
  String get recipePastMenus;

  /// No description provided for @recipeViewAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて見る'**
  String get recipeViewAll;

  /// No description provided for @recipeNoPastMenus.
  ///
  /// In ja, this message translates to:
  /// **'過去の献立はありません'**
  String get recipeNoPastMenus;

  /// No description provided for @recipeSearchPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'レシピを検索またはURLを入力'**
  String get recipeSearchPlaceholder;

  /// No description provided for @recipeTodaysMenu.
  ///
  /// In ja, this message translates to:
  /// **'今日の献立'**
  String get recipeTodaysMenu;

  /// No description provided for @recipeEdit.
  ///
  /// In ja, this message translates to:
  /// **'編集する'**
  String get recipeEdit;

  /// No description provided for @recipeCookNow.
  ///
  /// In ja, this message translates to:
  /// **'今すぐ作る'**
  String get recipeCookNow;

  /// No description provided for @recipeNoTodaysMenu.
  ///
  /// In ja, this message translates to:
  /// **'まだ今日の献立がありません'**
  String get recipeNoTodaysMenu;

  /// No description provided for @recipeAdd.
  ///
  /// In ja, this message translates to:
  /// **'追加する'**
  String get recipeAdd;

  /// No description provided for @recipeCategoryMain.
  ///
  /// In ja, this message translates to:
  /// **'主菜'**
  String get recipeCategoryMain;

  /// No description provided for @recipeCategorySide.
  ///
  /// In ja, this message translates to:
  /// **'副菜'**
  String get recipeCategorySide;

  /// No description provided for @recipeCategoryQuick.
  ///
  /// In ja, this message translates to:
  /// **'時短'**
  String get recipeCategoryQuick;

  /// No description provided for @recipeCategorySnack.
  ///
  /// In ja, this message translates to:
  /// **'おつまみ'**
  String get recipeCategorySnack;

  /// No description provided for @recipeCategoryFavorite.
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get recipeCategoryFavorite;

  /// No description provided for @recipeCategoryOther.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get recipeCategoryOther;

  /// No description provided for @recipeRecentlyViewed.
  ///
  /// In ja, this message translates to:
  /// **'最近見たレシピ'**
  String get recipeRecentlyViewed;

  /// No description provided for @recipeAddedDate.
  ///
  /// In ja, this message translates to:
  /// **'{date} 追加'**
  String recipeAddedDate(Object date);

  /// No description provided for @recipeItemsCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}品'**
  String recipeItemsCount(Object count);

  /// No description provided for @receiptScanTitle.
  ///
  /// In ja, this message translates to:
  /// **'レシート解析を開始'**
  String get receiptScanTitle;

  /// No description provided for @receiptScanMessage.
  ///
  /// In ja, this message translates to:
  /// **'AIがレシートを読み取ります。\n広告を再生することで、この機能を無料でご利用いただけます。'**
  String get receiptScanMessage;

  /// No description provided for @receiptScanAction.
  ///
  /// In ja, this message translates to:
  /// **'広告を見て解析する'**
  String get receiptScanAction;

  /// No description provided for @receiptAnalysisFailed.
  ///
  /// In ja, this message translates to:
  /// **'解析に失敗しました: {error}'**
  String receiptAnalysisFailed(Object error);

  /// No description provided for @receiptScanCanceled.
  ///
  /// In ja, this message translates to:
  /// **'スキャンがキャンセルされました'**
  String get receiptScanCanceled;

  /// No description provided for @stockAddedMessage.
  ///
  /// In ja, this message translates to:
  /// **'{count}件の在庫を追加しました！'**
  String stockAddedMessage(Object count);

  /// No description provided for @stockSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました。'**
  String get stockSaveFailed;

  /// No description provided for @aiAnalysisResult.
  ///
  /// In ja, this message translates to:
  /// **'解析結果'**
  String get aiAnalysisResult;

  /// No description provided for @aiAnalysisNoItems.
  ///
  /// In ja, this message translates to:
  /// **'商品が見つかりませんでした'**
  String get aiAnalysisNoItems;

  /// No description provided for @aiAnalysisLocation.
  ///
  /// In ja, this message translates to:
  /// **'撮影場所: {location}'**
  String aiAnalysisLocation(Object location);

  /// No description provided for @aiAnalysisFoundItems.
  ///
  /// In ja, this message translates to:
  /// **'以下の商品が見つかりました'**
  String get aiAnalysisFoundItems;

  /// No description provided for @aiAnalysisExclude.
  ///
  /// In ja, this message translates to:
  /// **'除外する'**
  String get aiAnalysisExclude;

  /// No description provided for @aiAnalysisAddToStock.
  ///
  /// In ja, this message translates to:
  /// **'在庫に追加する ({count}件)'**
  String aiAnalysisAddToStock(Object count);

  /// No description provided for @aiAnalysisQuit.
  ///
  /// In ja, this message translates to:
  /// **'やっぱり辞めた'**
  String get aiAnalysisQuit;

  /// No description provided for @aiIngredientAnalysisFailed.
  ///
  /// In ja, this message translates to:
  /// **'解析に失敗しました。もう一度お試しください。'**
  String get aiIngredientAnalysisFailed;

  /// No description provided for @unitItem.
  ///
  /// In ja, this message translates to:
  /// **'個'**
  String get unitItem;

  /// No description provided for @categoryOther.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get categoryOther;

  /// No description provided for @dialogConfirm.
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get dialogConfirm;

  /// No description provided for @dialogRegisterRecipeConfirm.
  ///
  /// In ja, this message translates to:
  /// **'材料の登録が終わりました！\nマイレシピ帳に登録しますか？'**
  String get dialogRegisterRecipeConfirm;

  /// No description provided for @actionNo.
  ///
  /// In ja, this message translates to:
  /// **'いいえ'**
  String get actionNo;

  /// No description provided for @actionYes.
  ///
  /// In ja, this message translates to:
  /// **'はい'**
  String get actionYes;

  /// No description provided for @dialogIngredientDestinations.
  ///
  /// In ja, this message translates to:
  /// **'「ある」材料は在庫へ、\n「買う」材料は買い物リストへ追加します。\n「いらない」材料は登録されません。\nよろしいですか？'**
  String get dialogIngredientDestinations;

  /// No description provided for @dialogDontShowAgain.
  ///
  /// In ja, this message translates to:
  /// **'今後このダイアログを非表示にする'**
  String get dialogDontShowAgain;

  /// No description provided for @actionRegister.
  ///
  /// In ja, this message translates to:
  /// **'登録する'**
  String get actionRegister;

  /// No description provided for @stockCountMessage.
  ///
  /// In ja, this message translates to:
  /// **'在庫に{count}件'**
  String stockCountMessage(Object count);

  /// No description provided for @shoppingListCountMessage.
  ///
  /// In ja, this message translates to:
  /// **'買い物リストに{count}件'**
  String shoppingListCountMessage(Object count);

  /// No description provided for @addedMessage.
  ///
  /// In ja, this message translates to:
  /// **'{items}追加しました！'**
  String addedMessage(Object items);

  /// No description provided for @dialogRegistrationCancelConfirm.
  ///
  /// In ja, this message translates to:
  /// **'解析した材料は、在庫や買い物リストに追加されませんが、よろしいですか？'**
  String get dialogRegistrationCancelConfirm;

  /// No description provided for @actionBackToRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピに戻る'**
  String get actionBackToRecipe;

  /// No description provided for @aiIngredientRunAnalysis.
  ///
  /// In ja, this message translates to:
  /// **'材料抽出結果'**
  String get aiIngredientRunAnalysis;

  /// No description provided for @recipeExtractedFrom.
  ///
  /// In ja, this message translates to:
  /// **'レシピから抽出'**
  String get recipeExtractedFrom;

  /// No description provided for @labelHave.
  ///
  /// In ja, this message translates to:
  /// **'ある'**
  String get labelHave;

  /// No description provided for @labelBuy.
  ///
  /// In ja, this message translates to:
  /// **'買う'**
  String get labelBuy;

  /// No description provided for @labelDontNeed.
  ///
  /// In ja, this message translates to:
  /// **'いらない'**
  String get labelDontNeed;

  /// No description provided for @actionDoNothingAnd.
  ///
  /// In ja, this message translates to:
  /// **'何もしないで'**
  String get actionDoNothingAnd;

  /// No description provided for @actionRegisterIngredients.
  ///
  /// In ja, this message translates to:
  /// **'材料を登録する'**
  String get actionRegisterIngredients;

  /// No description provided for @aiIngredientNoItems.
  ///
  /// In ja, this message translates to:
  /// **'材料が見つかりませんでした'**
  String get aiIngredientNoItems;

  /// No description provided for @dateYesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日'**
  String get dateYesterday;

  /// No description provided for @aiMenuThinking.
  ///
  /// In ja, this message translates to:
  /// **'献立を考えています...'**
  String get aiMenuThinking;

  /// No description provided for @aiMenuCheckingStock.
  ///
  /// In ja, this message translates to:
  /// **'冷蔵庫の中身を確認しています...'**
  String get aiMenuCheckingStock;

  /// No description provided for @aiMenuGenerating.
  ///
  /// In ja, this message translates to:
  /// **'AIがメニューを生成しています...'**
  String get aiMenuGenerating;

  /// No description provided for @aiMenuGenerationFailed.
  ///
  /// In ja, this message translates to:
  /// **'提案を作成できませんでした'**
  String get aiMenuGenerationFailed;

  /// No description provided for @errorOccurredTryAgain.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました。\nもう一度お試しください。'**
  String get errorOccurredTryAgain;

  /// No description provided for @menuSnack.
  ///
  /// In ja, this message translates to:
  /// **'間食'**
  String get menuSnack;

  /// No description provided for @actionBack.
  ///
  /// In ja, this message translates to:
  /// **'戻る'**
  String get actionBack;

  /// No description provided for @aiMenuSurroundingMeal.
  ///
  /// In ja, this message translates to:
  /// **'{day}の{type}: {title}'**
  String aiMenuSurroundingMeal(Object day, Object type, Object title);

  /// No description provided for @shortDateFormat.
  ///
  /// In ja, this message translates to:
  /// **'M/d'**
  String get shortDateFormat;

  /// No description provided for @aiRecipeAnalyzingPhoto.
  ///
  /// In ja, this message translates to:
  /// **'AIが写真を解析しています…'**
  String get aiRecipeAnalyzingPhoto;

  /// AI thinking message with current ingredient
  ///
  /// In ja, this message translates to:
  /// **'AIがレシピを考えています…\n{ingredient}があります'**
  String aiRecipeThinkingWithIngredient(Object ingredient);

  /// No description provided for @aiRecipeNoItemsFound.
  ///
  /// In ja, this message translates to:
  /// **'商品が見つかりませんでした'**
  String get aiRecipeNoItemsFound;

  /// No description provided for @aiRecipeNoIdentification.
  ///
  /// In ja, this message translates to:
  /// **'写真から食材を特定できませんでした。\nもう一度撮影するか、レシピを検索してください。'**
  String get aiRecipeNoIdentification;

  /// No description provided for @actionRetakePhoto.
  ///
  /// In ja, this message translates to:
  /// **'もう一度撮影する'**
  String get actionRetakePhoto;

  /// No description provided for @actionSearchRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピを検索する'**
  String get actionSearchRecipe;

  /// No description provided for @actionSkip.
  ///
  /// In ja, this message translates to:
  /// **'スキップする'**
  String get actionSkip;

  /// No description provided for @aiRecipeProposalTitle.
  ///
  /// In ja, this message translates to:
  /// **'こんなレシピはいかがですか？'**
  String get aiRecipeProposalTitle;

  /// No description provided for @cookingModeExitConfirm.
  ///
  /// In ja, this message translates to:
  /// **'調理モードを終了しますか？'**
  String get cookingModeExitConfirm;

  /// No description provided for @cookingModeExitDescription.
  ///
  /// In ja, this message translates to:
  /// **'調理モードを終了して前の画面に戻ります。'**
  String get cookingModeExitDescription;

  /// No description provided for @actionFinish.
  ///
  /// In ja, this message translates to:
  /// **'終了する'**
  String get actionFinish;

  /// No description provided for @titleCookingMode.
  ///
  /// In ja, this message translates to:
  /// **'調理モード'**
  String get titleCookingMode;

  /// No description provided for @nearbyFlyers.
  ///
  /// In ja, this message translates to:
  /// **'近くのお店のチラシ'**
  String get nearbyFlyers;

  /// No description provided for @newArrivals.
  ///
  /// In ja, this message translates to:
  /// **'新着あり'**
  String get newArrivals;

  /// No description provided for @newFlyers.
  ///
  /// In ja, this message translates to:
  /// **'新着のチラシ'**
  String get newFlyers;

  /// No description provided for @todaysRecommended.
  ///
  /// In ja, this message translates to:
  /// **'今日のおすすめ商品'**
  String get todaysRecommended;

  /// No description provided for @titleFlyer.
  ///
  /// In ja, this message translates to:
  /// **'チラシ'**
  String get titleFlyer;

  /// No description provided for @shopDetails.
  ///
  /// In ja, this message translates to:
  /// **'店舗詳細'**
  String get shopDetails;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In ja, this message translates to:
  /// **'カメラの権限が必要です'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraNotFound.
  ///
  /// In ja, this message translates to:
  /// **'カメラが見つかりません'**
  String get cameraNotFound;

  /// No description provided for @errorSaveFailed.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました'**
  String get errorSaveFailed;

  /// No description provided for @errorEnterRecipeName.
  ///
  /// In ja, this message translates to:
  /// **'レシピ名を入力してください'**
  String get errorEnterRecipeName;

  /// No description provided for @manualRecipeEntry.
  ///
  /// In ja, this message translates to:
  /// **'レシピを手入力'**
  String get manualRecipeEntry;

  /// No description provided for @recipeNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'レシピ名'**
  String get recipeNameLabel;

  /// No description provided for @recipeNameHint.
  ///
  /// In ja, this message translates to:
  /// **'例：豚肉の生姜焼き'**
  String get recipeNameHint;

  /// No description provided for @ingredientsAmount.
  ///
  /// In ja, this message translates to:
  /// **'材料・分量'**
  String get ingredientsAmount;

  /// No description provided for @ingredientNameHint.
  ///
  /// In ja, this message translates to:
  /// **'例: 豚肉'**
  String get ingredientNameHint;

  /// No description provided for @amountHint.
  ///
  /// In ja, this message translates to:
  /// **'例: 200g'**
  String get amountHint;

  /// No description provided for @actionAddIngredient.
  ///
  /// In ja, this message translates to:
  /// **'材料を追加する'**
  String get actionAddIngredient;

  /// No description provided for @actionRegisterManualRecipe.
  ///
  /// In ja, this message translates to:
  /// **'手入力したレシピを登録する'**
  String get actionRegisterManualRecipe;

  /// No description provided for @searchByZipCode.
  ///
  /// In ja, this message translates to:
  /// **'郵便番号で探す'**
  String get searchByZipCode;

  /// No description provided for @setMyAreaHere.
  ///
  /// In ja, this message translates to:
  /// **'マイエリアをここにする'**
  String get setMyAreaHere;

  /// No description provided for @titleNotification.
  ///
  /// In ja, this message translates to:
  /// **'通知'**
  String get titleNotification;

  /// No description provided for @actionReadAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて既読'**
  String get actionReadAll;

  /// No description provided for @noNotifications.
  ///
  /// In ja, this message translates to:
  /// **'通知はありません'**
  String get noNotifications;

  /// No description provided for @actionAddDemoData.
  ///
  /// In ja, this message translates to:
  /// **'デモデータを追加'**
  String get actionAddDemoData;

  /// No description provided for @minutesAgo.
  ///
  /// In ja, this message translates to:
  /// **'{count}分前'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In ja, this message translates to:
  /// **'{count}時間前'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In ja, this message translates to:
  /// **'{count}日前'**
  String daysAgo(Object count);

  /// No description provided for @yesterdayAt.
  ///
  /// In ja, this message translates to:
  /// **'昨日 {time}'**
  String yesterdayAt(Object time);

  /// No description provided for @titlePhotoGallery.
  ///
  /// In ja, this message translates to:
  /// **'写真一覧'**
  String get titlePhotoGallery;

  /// No description provided for @noPhotos.
  ///
  /// In ja, this message translates to:
  /// **'写真がありません'**
  String get noPhotos;

  /// No description provided for @titlePhotoStockLocation.
  ///
  /// In ja, this message translates to:
  /// **'AI解析を開始'**
  String get titlePhotoStockLocation;

  /// No description provided for @photoStockLocationMessage.
  ///
  /// In ja, this message translates to:
  /// **'AIがあなたの冷蔵庫を分析します。\n広告を再生することで、この機能を無料でご利用いただけます。'**
  String get photoStockLocationMessage;

  /// No description provided for @photoStockLocationAiAnalyzing.
  ///
  /// In ja, this message translates to:
  /// **'AIがあなたの{location}を分析しています。\n解析が終わるまで広告をご覧ください。'**
  String photoStockLocationAiAnalyzing(Object location);

  /// No description provided for @aiAnalysisCompleteMessage.
  ///
  /// In ja, this message translates to:
  /// **'AIの解析がおわりました。\n広告の視聴ありがとうございました。'**
  String get aiAnalysisCompleteMessage;

  /// No description provided for @retake.
  ///
  /// In ja, this message translates to:
  /// **'やり直す'**
  String get retake;

  /// No description provided for @enterStorageLocation.
  ///
  /// In ja, this message translates to:
  /// **'撮影した保管場所を入力'**
  String get enterStorageLocation;

  /// No description provided for @storageLocationHint.
  ///
  /// In ja, this message translates to:
  /// **'例: 食品庫'**
  String get storageLocationHint;

  /// No description provided for @selectFromCandidates.
  ///
  /// In ja, this message translates to:
  /// **'候補から選択'**
  String get selectFromCandidates;

  /// No description provided for @actionDecide.
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get actionDecide;

  /// No description provided for @errorFileNotFound.
  ///
  /// In ja, this message translates to:
  /// **'ファイルが見つかりません'**
  String get errorFileNotFound;

  /// No description provided for @analysisComplete.
  ///
  /// In ja, this message translates to:
  /// **'解析が完了しました'**
  String get analysisComplete;

  /// No description provided for @foodAnalysisDoneMessage.
  ///
  /// In ja, this message translates to:
  /// **'料理の写真の解析が終わりました。'**
  String get foodAnalysisDoneMessage;

  /// No description provided for @capturedWithStox.
  ///
  /// In ja, this message translates to:
  /// **'STOXで撮影しました'**
  String get capturedWithStox;

  /// No description provided for @analyzing.
  ///
  /// In ja, this message translates to:
  /// **'解析中...'**
  String get analyzing;

  /// No description provided for @noAnalysisData.
  ///
  /// In ja, this message translates to:
  /// **'解析データがありません'**
  String get noAnalysisData;

  /// No description provided for @analyzeNutritionWithAi.
  ///
  /// In ja, this message translates to:
  /// **'AIで栄養価を解析する'**
  String get analyzeNutritionWithAi;

  /// No description provided for @noAnalysisText.
  ///
  /// In ja, this message translates to:
  /// **'解析結果のテキストがありません'**
  String get noAnalysisText;

  /// No description provided for @titleHistory.
  ///
  /// In ja, this message translates to:
  /// **'履歴'**
  String get titleHistory;

  /// No description provided for @recentlyAddedRecipes.
  ///
  /// In ja, this message translates to:
  /// **'最近登録したレシピ'**
  String get recentlyAddedRecipes;

  /// No description provided for @noRecentlyViewedRecipes.
  ///
  /// In ja, this message translates to:
  /// **'最近見たレシピはありません'**
  String get noRecentlyViewedRecipes;

  /// No description provided for @noRegisteredRecipes.
  ///
  /// In ja, this message translates to:
  /// **'登録されたレシピはありません'**
  String get noRegisteredRecipes;

  /// No description provided for @yearMonthDay.
  ///
  /// In ja, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String yearMonthDay(Object year, Object month, Object day);

  /// No description provided for @recipeScheduleBreakfast.
  ///
  /// In ja, this message translates to:
  /// **'朝'**
  String get recipeScheduleBreakfast;

  /// No description provided for @recipeScheduleLunch.
  ///
  /// In ja, this message translates to:
  /// **'昼'**
  String get recipeScheduleLunch;

  /// No description provided for @recipeScheduleDinner.
  ///
  /// In ja, this message translates to:
  /// **'夜'**
  String get recipeScheduleDinner;

  /// No description provided for @recipeScheduleSnack.
  ///
  /// In ja, this message translates to:
  /// **'おやつ'**
  String get recipeScheduleSnack;

  /// No description provided for @recipeSchedulePrep.
  ///
  /// In ja, this message translates to:
  /// **'下ごしらえ'**
  String get recipeSchedulePrep;

  /// No description provided for @recipeScheduleAppetizer.
  ///
  /// In ja, this message translates to:
  /// **'おつまみ'**
  String get recipeScheduleAppetizer;

  /// No description provided for @recipeRegisteredMessage.
  ///
  /// In ja, this message translates to:
  /// **'マイレシピ帳に登録しました'**
  String get recipeRegisteredMessage;

  /// No description provided for @recipeRegisterFailed.
  ///
  /// In ja, this message translates to:
  /// **'登録に失敗しました'**
  String get recipeRegisterFailed;

  /// No description provided for @whenToCook.
  ///
  /// In ja, this message translates to:
  /// **'いつ作りますか？'**
  String get whenToCook;

  /// No description provided for @undecidedDate.
  ///
  /// In ja, this message translates to:
  /// **'日程を未定にする'**
  String get undecidedDate;

  /// No description provided for @canSetFromCalendarLater.
  ///
  /// In ja, this message translates to:
  /// **'あとでカレンダーから設定できます'**
  String get canSetFromCalendarLater;

  /// No description provided for @selectTimeSlot.
  ///
  /// In ja, this message translates to:
  /// **'時間帯を選択'**
  String get selectTimeSlot;

  /// No description provided for @memoOptional.
  ///
  /// In ja, this message translates to:
  /// **'メモ（任意）'**
  String get memoOptional;

  /// No description provided for @memoHint.
  ///
  /// In ja, this message translates to:
  /// **'その他（例：旦那さんの分、作り置き）'**
  String get memoHint;

  /// No description provided for @actionConfirm.
  ///
  /// In ja, this message translates to:
  /// **'確定する'**
  String get actionConfirm;

  /// No description provided for @searchFailed.
  ///
  /// In ja, this message translates to:
  /// **'検索に失敗しました'**
  String get searchFailed;

  /// No description provided for @communicationError.
  ///
  /// In ja, this message translates to:
  /// **'通信エラーが発生しました'**
  String get communicationError;

  /// No description provided for @searchResultsFor.
  ///
  /// In ja, this message translates to:
  /// **'「{query}」の検索結果'**
  String searchResultsFor(Object query);

  /// No description provided for @fromRecipeSite.
  ///
  /// In ja, this message translates to:
  /// **'レシピサイトから'**
  String get fromRecipeSite;

  /// No description provided for @actionRetry.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get actionRetry;

  /// No description provided for @noResultsInRecipeSite.
  ///
  /// In ja, this message translates to:
  /// **'レシピサイトに結果が見つかりませんでした'**
  String get noResultsInRecipeSite;

  /// No description provided for @actionOpenInBrowser.
  ///
  /// In ja, this message translates to:
  /// **'ブラウザで開く'**
  String get actionOpenInBrowser;

  /// No description provided for @actionCopyUrl.
  ///
  /// In ja, this message translates to:
  /// **'URLをコピー'**
  String get actionCopyUrl;

  /// No description provided for @recipeAiAnalyzingMessage.
  ///
  /// In ja, this message translates to:
  /// **'AIがレシピの材料を分析しています。\n解析が終わるまで広告をご覧ください。'**
  String get recipeAiAnalyzingMessage;

  /// No description provided for @cookThisRecipe.
  ///
  /// In ja, this message translates to:
  /// **'このレシピを作る！'**
  String get cookThisRecipe;

  /// No description provided for @urlCopied.
  ///
  /// In ja, this message translates to:
  /// **'URLをコピーしました'**
  String get urlCopied;

  /// No description provided for @saveRecipe.
  ///
  /// In ja, this message translates to:
  /// **'レシピの保存'**
  String get saveRecipe;

  /// No description provided for @whatToDoWithRecipe.
  ///
  /// In ja, this message translates to:
  /// **'このレシピをどうしますか？'**
  String get whatToDoWithRecipe;

  /// No description provided for @actionDoNothing.
  ///
  /// In ja, this message translates to:
  /// **'何もしない'**
  String get actionDoNothing;

  /// No description provided for @actionRegisterToRecipeBook.
  ///
  /// In ja, this message translates to:
  /// **'マイレシピ帳に登録する'**
  String get actionRegisterToRecipeBook;

  /// No description provided for @stockUpdated.
  ///
  /// In ja, this message translates to:
  /// **'在庫を更新しました'**
  String get stockUpdated;

  /// No description provided for @receiptAnalysisResult.
  ///
  /// In ja, this message translates to:
  /// **'レシート解析結果'**
  String get receiptAnalysisResult;

  /// No description provided for @receiptNoItemsFound.
  ///
  /// In ja, this message translates to:
  /// **'商品が見つかりませんでした。'**
  String get receiptNoItemsFound;

  /// No description provided for @actionRetake.
  ///
  /// In ja, this message translates to:
  /// **'もう一回撮影する'**
  String get actionRetake;

  /// No description provided for @actionToStock.
  ///
  /// In ja, this message translates to:
  /// **'在庫にする'**
  String get actionToStock;

  /// No description provided for @receiptStockConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'レシートと買物リストの両方にありました。\n在庫に登録します。'**
  String get receiptStockConfirmMessage;

  /// No description provided for @sectionNewItem.
  ///
  /// In ja, this message translates to:
  /// **'新規に追加'**
  String get sectionNewItem;

  /// No description provided for @receiptNewItemDescription.
  ///
  /// In ja, this message translates to:
  /// **'買い物リストにありませんでした。\n在庫に追加しますか？'**
  String get receiptNewItemDescription;

  /// No description provided for @sectionNotPurchased.
  ///
  /// In ja, this message translates to:
  /// **'未購入'**
  String get sectionNotPurchased;

  /// No description provided for @receiptNotPurchasedDescription.
  ///
  /// In ja, this message translates to:
  /// **'レシートにありませんでした。\n買い物忘れはありませんか？'**
  String get receiptNotPurchasedDescription;

  /// No description provided for @actionComplete.
  ///
  /// In ja, this message translates to:
  /// **'完了'**
  String get actionComplete;

  /// No description provided for @actionViewMenuPlan.
  ///
  /// In ja, this message translates to:
  /// **'献立計画表を見る'**
  String get actionViewMenuPlan;

  /// No description provided for @fullDateFormat.
  ///
  /// In ja, this message translates to:
  /// **'yyyy/MM/dd (E)'**
  String get fullDateFormat;

  /// No description provided for @actionExtractIngredients.
  ///
  /// In ja, this message translates to:
  /// **'材料を抽出する'**
  String get actionExtractIngredients;

  /// No description provided for @titleExtractIngredients.
  ///
  /// In ja, this message translates to:
  /// **'材料の解析'**
  String get titleExtractIngredients;

  /// No description provided for @titleError.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get titleError;

  /// No description provided for @titleSearchHistory.
  ///
  /// In ja, this message translates to:
  /// **'検索履歴'**
  String get titleSearchHistory;

  /// No description provided for @actionDeleteAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて削除'**
  String get actionDeleteAll;

  /// No description provided for @actionManualRecipeEntryNoSearch.
  ///
  /// In ja, this message translates to:
  /// **'検索せずに、レシピを手入力する'**
  String get actionManualRecipeEntryNoSearch;

  /// No description provided for @manualRecipeIngredientLabel.
  ///
  /// In ja, this message translates to:
  /// **'材料名'**
  String get manualRecipeIngredientLabel;

  /// No description provided for @manualRecipeAmountLabel.
  ///
  /// In ja, this message translates to:
  /// **'分量'**
  String get manualRecipeAmountLabel;

  /// No description provided for @tutorialSkip.
  ///
  /// In ja, this message translates to:
  /// **'スキップ'**
  String get tutorialSkip;

  /// No description provided for @tutorialStep1Title.
  ///
  /// In ja, this message translates to:
  /// **'冷蔵庫の中を\n撮影しましょう'**
  String get tutorialStep1Title;

  /// No description provided for @tutorialStep1Description.
  ///
  /// In ja, this message translates to:
  /// **'AIが写真を解析して、最適なレシピを提案します'**
  String get tutorialStep1Description;

  /// No description provided for @actionLaunchCamera.
  ///
  /// In ja, this message translates to:
  /// **'カメラを起動する'**
  String get actionLaunchCamera;

  /// No description provided for @actionManualRegister.
  ///
  /// In ja, this message translates to:
  /// **'手動で登録する'**
  String get actionManualRegister;

  /// No description provided for @calendarYearMonth.
  ///
  /// In ja, this message translates to:
  /// **'{year}年{month}月'**
  String calendarYearMonth(Object year, Object month);

  /// No description provided for @clearSteps.
  ///
  /// In ja, this message translates to:
  /// **'クリア手順'**
  String get clearSteps;

  /// No description provided for @titleChallengeStamp.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジスタンプ'**
  String get titleChallengeStamp;

  /// No description provided for @challengeStampDescription.
  ///
  /// In ja, this message translates to:
  /// **'全クリアでマスターを目指そう！'**
  String get challengeStampDescription;

  /// No description provided for @actionClose.
  ///
  /// In ja, this message translates to:
  /// **'とじる'**
  String get actionClose;

  /// No description provided for @congratsTitle.
  ///
  /// In ja, this message translates to:
  /// **'ぱんぱかぱーん🎉'**
  String get congratsTitle;

  /// No description provided for @congratsMessage.
  ///
  /// In ja, this message translates to:
  /// **'おめでとうございます！'**
  String get congratsMessage;

  /// No description provided for @congratsFirstChallenge.
  ///
  /// In ja, this message translates to:
  /// **'１つめのチャレンジクリアです！'**
  String get congratsFirstChallenge;

  /// No description provided for @congratsChallengeClear.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ「{name}」\nクリアです！'**
  String congratsChallengeClear(Object name);

  /// No description provided for @actionHooray.
  ///
  /// In ja, this message translates to:
  /// **'やったー！'**
  String get actionHooray;

  /// No description provided for @challengeRefrigeratorPhoto.
  ///
  /// In ja, this message translates to:
  /// **'冷蔵庫撮影'**
  String get challengeRefrigeratorPhoto;

  /// No description provided for @challengeMenuRegistration.
  ///
  /// In ja, this message translates to:
  /// **'献立登録'**
  String get challengeMenuRegistration;

  /// No description provided for @challengeRecipeSearch.
  ///
  /// In ja, this message translates to:
  /// **'レシピ検索'**
  String get challengeRecipeSearch;

  /// No description provided for @challengeIngredientExtraction.
  ///
  /// In ja, this message translates to:
  /// **'材料抽出'**
  String get challengeIngredientExtraction;

  /// No description provided for @challengeShopping.
  ///
  /// In ja, this message translates to:
  /// **'お買い物'**
  String get challengeShopping;

  /// No description provided for @challengeReceiptRegistration.
  ///
  /// In ja, this message translates to:
  /// **'レシート登録'**
  String get challengeReceiptRegistration;

  /// No description provided for @challengeCookingPhoto.
  ///
  /// In ja, this message translates to:
  /// **'料理撮影'**
  String get challengeCookingPhoto;

  /// No description provided for @tomorrowIs.
  ///
  /// In ja, this message translates to:
  /// **'明日は{event}です'**
  String tomorrowIs(Object event);

  /// No description provided for @dayAfterTomorrowIs.
  ///
  /// In ja, this message translates to:
  /// **'明後日は{event}です'**
  String dayAfterTomorrowIs(Object event);

  /// No description provided for @actionAiMenuTomorrow.
  ///
  /// In ja, this message translates to:
  /// **'AI明日の献立'**
  String get actionAiMenuTomorrow;

  /// No description provided for @actionAiMenuDayAfterTomorrow.
  ///
  /// In ja, this message translates to:
  /// **'AI明後日の献立'**
  String get actionAiMenuDayAfterTomorrow;

  /// No description provided for @nutritionTotal.
  ///
  /// In ja, this message translates to:
  /// **'合計'**
  String get nutritionTotal;

  /// No description provided for @nutritionCalories.
  ///
  /// In ja, this message translates to:
  /// **'カロリー'**
  String get nutritionCalories;

  /// No description provided for @nutritionProtein.
  ///
  /// In ja, this message translates to:
  /// **'タンパク質(P)'**
  String get nutritionProtein;

  /// No description provided for @nutritionFat.
  ///
  /// In ja, this message translates to:
  /// **'脂質(F)'**
  String get nutritionFat;

  /// No description provided for @nutritionCarbs.
  ///
  /// In ja, this message translates to:
  /// **'炭水化物(C)'**
  String get nutritionCarbs;

  /// No description provided for @nutritionDailyTotal.
  ///
  /// In ja, this message translates to:
  /// **'1日の合計栄養価'**
  String get nutritionDailyTotal;

  /// No description provided for @nutritionSectionTotal.
  ///
  /// In ja, this message translates to:
  /// **'この時間の合計'**
  String get nutritionSectionTotal;

  /// No description provided for @nutritionWeeklyAverage.
  ///
  /// In ja, this message translates to:
  /// **'週平均'**
  String get nutritionWeeklyAverage;

  /// No description provided for @nutritionMonthlyAverage.
  ///
  /// In ja, this message translates to:
  /// **'月平均'**
  String get nutritionMonthlyAverage;

  /// No description provided for @nutritionStatistics.
  ///
  /// In ja, this message translates to:
  /// **'栄養統計'**
  String get nutritionStatistics;

  /// No description provided for @nutritionAverage.
  ///
  /// In ja, this message translates to:
  /// **'平均'**
  String get nutritionAverage;

  /// No description provided for @nutritionAnalysisData.
  ///
  /// In ja, this message translates to:
  /// **'栄養価データ'**
  String get nutritionAnalysisData;

  /// No description provided for @nutritionPfcBalance.
  ///
  /// In ja, this message translates to:
  /// **'PFCバランス'**
  String get nutritionPfcBalance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
