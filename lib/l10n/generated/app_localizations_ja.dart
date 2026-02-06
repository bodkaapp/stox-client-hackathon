// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get helloWorld => 'こんにちは世界';

  @override
  String get navHome => 'ホーム';

  @override
  String get navStock => '在庫';

  @override
  String get navShopping => '買い物';

  @override
  String get navMenuPlan => '献立計画表';

  @override
  String get navRecipe => 'レシピ';

  @override
  String get homeHelpTitle => 'ホーム画面';

  @override
  String get homeHelpDescription =>
      'アプリのメインの画面です。この「？」アイコンをタップすると、画面の使い方が表示されます。';

  @override
  String get homeTodaysMenu => '今日の献立';

  @override
  String get homeRegisterMenu => '登録する';

  @override
  String get homeChangeMenu => '献立を変更する';

  @override
  String get homeNoMenuPlan => '今日の献立はまだありません';

  @override
  String get homeViewRecipe => 'レシピを見る';

  @override
  String get homeShoppingList => '買うもの';

  @override
  String get homeShoppingAd => '近所のスーパーで特売中！';

  @override
  String get homeViewFlyer => 'チラシを見る';

  @override
  String get unitItems => '件';

  @override
  String get homeExpiringSoon => '賞味期限が近いもの';

  @override
  String get homeViewAll => 'すべて見る';

  @override
  String get homeNoExpiringItems => '賞味期限切れはありません';

  @override
  String get actionCheckStock => '在庫チェック';

  @override
  String get actionScanReceipt => 'レシート登録';

  @override
  String get actionShoppingMode => '買い物モード';

  @override
  String get actionRecipeBook => 'マイレシピ帳';

  @override
  String get actionFoodCamera => '料理を撮影';

  @override
  String get actionPhotoGallery => '写真を見る';

  @override
  String daysRemaining(Object days) {
    return 'あと$days日';
  }

  @override
  String get statusCheck => '確認';

  @override
  String get statusUrgent => '緊急';

  @override
  String get statusWarning => '注意';

  @override
  String get shoppingAddToShoppingList => '買い物リストに追加';

  @override
  String get shoppingTitle => 'お買い物';

  @override
  String get shoppingHelpTitle => '買い物画面';

  @override
  String get shoppingHelpDescription =>
      '買いたいものを管理する画面です。\n「＋」ボタンをタップして、買うものを登録できます。\n「お買い物モード」ボタンを押すと、お買い物を便利にするモードに切り替わります。\nお買い物が終わった後はレシートを撮影して、買ったものを在庫に移動することもできます。';

  @override
  String get shoppingAction => 'アクション';

  @override
  String get shoppingEnterItem => '買うものを入力';

  @override
  String get shoppingVoiceInput => '音声で入力';

  @override
  String get shoppingReceiptScan => 'レシート撮影';

  @override
  String get shoppingModeOn => 'お買い物モード中';

  @override
  String get shoppingModeStart => 'お買い物モードを開始';

  @override
  String get shoppingCompleteAction => '買い物を完了する';

  @override
  String get shoppingAddGuide => 'ここをタップして材料を追加します';

  @override
  String get shoppingEnterItemAction => '買うものを入力する';

  @override
  String get shoppingVoiceInputAction => '声で操作する';

  @override
  String get shoppingReceiptScanAction => 'レシートを撮影する（お買い物モードを終わる）';

  @override
  String get shoppingCompleteButton => '買い物を完了';

  @override
  String get shoppingEmptyListMessage =>
      '買い物リストを登録する場所です。\n買うものを忘れないように\nメモしておきましょう。';

  @override
  String get shoppingTotalItemsLabel => 'TOTAL ITEMS';

  @override
  String shoppingTotalItemsCount(Object count) {
    return '全 $count 品目';
  }

  @override
  String get shoppingModeToggleOn => 'お買い物モード ON';

  @override
  String get shoppingModeToggleOff => 'お買い物モード OFF';

  @override
  String get shoppingCartProgress => 'カゴの進捗';

  @override
  String shoppingCartCount(Object count, Object total) {
    return '$count / $total 点';
  }

  @override
  String shoppingRemainingItems(Object remaining) {
    return 'あと$remaining点でお買い物完了です';
  }

  @override
  String get categoryUncategorized => '未分類';

  @override
  String get categoryVegetablesFruits => '野菜・果物';

  @override
  String get categoryMeatFish => '肉・魚';

  @override
  String get categorySeasoning => '調味料';

  @override
  String get voicePermissionError => 'マイクの権限が必要です';

  @override
  String get voiceAnalyzing => 'AIが解析中...';

  @override
  String get voiceListening => '聞いています...';

  @override
  String get voiceTapToStart => 'タップして開始';

  @override
  String get voiceHint => '商品名を話しかけてください\n例：「長ネギ」「豚肉とキャベツ」';

  @override
  String get voiceHistoryPlaceholder => '追加履歴がここに表示されます';

  @override
  String get voiceAdded => '追加済';

  @override
  String get voiceClose => '閉じる';

  @override
  String get voiceAiError => 'AIで解析できませんでした';

  @override
  String voiceCompleteMessage(Object count) {
    return '$count件の操作を完了しました';
  }

  @override
  String get addModalCategoryHint => 'カテゴリ (任意)';

  @override
  String get addModalNameHint => '材料名 (例: にんじん)';

  @override
  String get addModalAddButton => '追加';

  @override
  String get addModalConfirmButton => '確定';

  @override
  String get addModalEmptyList => '追加した材料がここに表示されます';

  @override
  String get addModalHeaderName => '材料名';

  @override
  String get addModalHeaderQuantity => '数量';

  @override
  String get addModalHeaderCategory => 'カテゴリ';

  @override
  String addModalAiSuccess(Object count) {
    return '$count件をリストに追加しました';
  }

  @override
  String get addModalAiError => 'AIで解析できませんでした';

  @override
  String addModalSaveError(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get stockTitle => '在庫一覧';

  @override
  String get stockHelpTitle => '在庫一覧画面';

  @override
  String get stockHelpDescription =>
      '家にある食材や日用品の在庫を確認する画面です。個数や賞味期限の確認ができます。\n「＋」ボタンをタップすると、在庫を声で追加したり、まとめて削除することができます';

  @override
  String get menuPlanTitle => '献立計画表';

  @override
  String get menuPlanHelpTitle => '献立計画表画面';

  @override
  String get menuPlanHelpDescription =>
      'これから作る料理の献立を計画したり、前に作った料理のレシピを振り返ったりする画面です。\n作った後に撮影した写真を貼っておくこともできます。';

  @override
  String get recipeBookTitle => 'マイレシピ帳';

  @override
  String get recipeBookHelpTitle => 'マイレシピ帳画面';

  @override
  String get recipeBookHelpDescription =>
      'レシピを検索したり、献立を計画したり、作った料理のレシピを記録したりする画面です。';

  @override
  String get searchPlaceholder => '在庫を検索...';

  @override
  String get categoryAll => 'すべて';

  @override
  String get categoryDairy => '乳製品';

  @override
  String get stockHeaderType => '類';

  @override
  String get stockHeaderName => '品名';

  @override
  String get stockHeaderDate => '期限';

  @override
  String get stockHeaderAmount => '残量';

  @override
  String get stockNoSearchResults => '検索結果がありません';

  @override
  String get stockEmptyDescription => '家の中にある\n「買ったもの」「もらったもの」\nを登録して見る場所です。';

  @override
  String get stockEmptyAddInstruction => 'ここをタップして在庫を追加します';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get labelDraftDesign => '仮デザイン';

  @override
  String get myAreaSetting => 'マイエリア設定';

  @override
  String get labelRecommended => 'おすすめ';

  @override
  String get labelNewItem => 'NEW ITEM';

  @override
  String get tutorialTitle => '冷蔵庫の中を\n撮影しましょう';

  @override
  String get tutorialDescription => 'AIが写真を解析して、最適なレシピを提案します';

  @override
  String get actionStartCamera => 'カメラを起動する';

  @override
  String get actionRegisterManually => '手動で登録する';

  @override
  String get titleAccountSettings => 'アカウント設定';

  @override
  String get labelDebugDeveloperOptions => 'デバッグ・開発者オプション';

  @override
  String get actionRestartFromTutorial => 'チュートリアルからやり直す';

  @override
  String get actionRestart => 'やり直す';

  @override
  String get actionReset => 'リセット';

  @override
  String get actionResetChallengeStamps => 'チャレンジスタンプをリセット';

  @override
  String get labelCheckAiResultDebug => 'AI解析結果画面確認 (Debug)';

  @override
  String get labelCheckSplashScreen => 'スプラッシュ画面確認 (Debug)';

  @override
  String get titleConfirmation => '確認';

  @override
  String get messageRestartFromTutorialConfirm =>
      '本当にチュートリアルからやり直しますか？\n現在の状態は一部リセットされる可能性があります。';

  @override
  String get messageResetChallengeStampsConfirm =>
      'チャレンジスタンプの獲得状況をすべてリセットしますか？\nこの操作は取り消せません。';

  @override
  String get messageChallengeStampsResetComplete => 'チャレンジスタンプをリセットしました';

  @override
  String get saveFailed => '保存に失敗しました';

  @override
  String get receiptAnalysisResultTitle => 'レシート解析結果';

  @override
  String get actionSetToStock => '在庫にする';

  @override
  String get receiptSectionMatchedDescription =>
      'レシートと買物リストの両方にありました。\n在庫に登録します。';

  @override
  String get actionAddNew => '新規に追加';

  @override
  String get receiptSectionNewDescription => '買い物リストにありませんでした。\n在庫に追加しますか？';

  @override
  String get statusUnpurchased => '未購入';

  @override
  String get receiptSectionUnpurchasedDescription =>
      'レシートにありませんでした。\n買い忘れていませんか？';

  @override
  String get actionKeepInList => 'リストに残す';

  @override
  String get locationFridge => '冷蔵庫';

  @override
  String get locationFreezer => '冷凍庫';

  @override
  String get locationVegetable => '野菜室';

  @override
  String get locationUnderSink => 'シンク下';

  @override
  String get locationPantry => '食品庫';

  @override
  String get locationStorageRoom => '物置';

  @override
  String get locationRoomTemp => '常温';

  @override
  String get actionShareRecipe => 'レシピをシェア';

  @override
  String get aiAnalysisRecipeIngredientsDescription =>
      'AIがレシピの材料を分析しています。\n解析が終わるまで広告をご覧ください。';

  @override
  String get actionCookThisRecipe => 'このレシピを作る！';

  @override
  String get recipeSavedToBook => 'マイレシピ帳に登録しました';

  @override
  String get recipeSaveError => '登録に失敗しました';

  @override
  String get recipeSaveTitle => 'レシピの保存';

  @override
  String get recipeSaveQuestion => 'このレシピをどうしますか？';

  @override
  String get actionRegisterToMyRecipeBook => '献立に登録する';

  @override
  String get aiAnalysisRecipeIngredientsDescriptionLong =>
      'AIがレシピの材料を分析しています。\n広告を再生している間に解析を行います。';

  @override
  String get actionWatchAdAndAnalyze => '広告を見て解析する';

  @override
  String get analysisFailedTryAgain => '解析に失敗しました。もう一度お試しください。';

  @override
  String get tabRecentlyViewed => '最近見たレシピ';

  @override
  String get tabRecentlyAdded => '最近登録したレシピ';

  @override
  String get noRecentlyAddedRecipes => '登録されたレシピはありません';

  @override
  String dateYMD(Object year, Object month, Object day) {
    return '$year年$month月$day日';
  }

  @override
  String get searchFailedMessage => '検索に失敗しました';

  @override
  String get errorNetwork => '通信エラーが発生しました';

  @override
  String recipeSearchResults(String query) {
    return '「$query」の検索結果';
  }

  @override
  String get labelFromRecipeSites => 'レシピサイトから';

  @override
  String get noRecipeSearchResults => 'レシピサイトに結果が見つかりませんでした';

  @override
  String get titleChangeMyArea => 'マイエリアの変更';

  @override
  String get statusFollowing => 'フォロー中';

  @override
  String get fileNotFound => 'ファイルが見つかりません';

  @override
  String get analysisFailed => '解析に失敗しました';

  @override
  String get foodPhotoAnalysisComplete => '料理の写真の解析が終わりました。';

  @override
  String get sharedWithStox => 'STOXで撮影しました';

  @override
  String get actionAnalyzeNutritionWithAi => 'AIで栄養価を解析する';

  @override
  String get cancelAnalysisLater => '今は解析しないのでキャンセル';

  @override
  String get analysisCancelled => '解析をキャンセルしました';

  @override
  String get mealMorning => '朝';

  @override
  String get mealNoon => '昼';

  @override
  String get mealNight => '夜';

  @override
  String get mealSnack => 'おやつ';

  @override
  String get mealPrep => '下ごしらえ';

  @override
  String get mealAppetizer => 'おつまみ';

  @override
  String get titleWhenToMake => 'いつ作りますか？';

  @override
  String get actionSetDateUndecided => '日程を未定にする';

  @override
  String get labelSelectTimeSlot => '時間帯を選択';

  @override
  String get labelMemoOptional => 'メモ（任意）';

  @override
  String get saveAction => '確定する';

  @override
  String get categoryOthers => 'その他';

  @override
  String get actionAi => 'AI';

  @override
  String get actionSearch => '検索';

  @override
  String get actionGetAiSuggestions => 'AIに提案してもらう';

  @override
  String get labelSearchHistory => '検索履歴';

  @override
  String get actionManualRecipeEntryInstead => '検索せずに、レシピを手入力する';

  @override
  String get labelManualRecipeEntry => 'レシピを手入力';

  @override
  String get actionNext => '次へ';

  @override
  String get actionDelete => '削除します';

  @override
  String get stockDeleteConfirmMessage => '本当に削除してもいいですか？';

  @override
  String stockDeletedMessage(Object count) {
    return '$count件を削除しました';
  }

  @override
  String get actionUndo => 'やっぱり元に戻す';

  @override
  String get stockRestoreConfirmMessage => '削除した商品を元に戻しますか？';

  @override
  String get actionRestore => '元に戻す';

  @override
  String get stockRestoredMessage => '商品を元に戻しました';

  @override
  String stockSelectedCount(Object count) {
    return '$count件選択中';
  }

  @override
  String get stockCategoryLabel => 'カテゴリ';

  @override
  String get stockOperationLabel => '操作';

  @override
  String stockDeleteButtonLabel(Object count) {
    return '削除する ($count)';
  }

  @override
  String get stockCancelSelection => '選択をキャンセル';

  @override
  String get stockAddToShoppingList => '買い物リストへ追加する';

  @override
  String get stockAddByTextInput => '文字入力で追加';

  @override
  String get stockAddByVoice => '音声入力で追加';

  @override
  String get stockAddByPhoto => '写真撮影で追加';

  @override
  String get stockDeleteItems => '商品を選んで削除する';

  @override
  String get dateToday => '今日';

  @override
  String get dateTomorrow => '明日';

  @override
  String stockTotalItems(Object count) {
    return '全 $count 品目';
  }

  @override
  String stockExpiredCount(Object count) {
    return '  ● $count品期限間近';
  }

  @override
  String errorOccurred(Object error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get stockDeleteActionGuide => 'ここをタップして削除します';

  @override
  String get stockAddTitle => '在庫を追加';

  @override
  String get menuBreakfast => '朝食';

  @override
  String get menuBreakfastLabel => '朝';

  @override
  String get menuLunch => '昼食';

  @override
  String get menuLunchLabel => '昼';

  @override
  String get menuDinner => '夕食';

  @override
  String get menuDinnerLabel => '夜';

  @override
  String get menuUndecided => '時間未定';

  @override
  String get menuUndecidedLabel => '未定';

  @override
  String get menuMealPrep => '作り置き';

  @override
  String get menuMealPrepLabel => '準備';

  @override
  String get menuNoMenu => '献立はありません';

  @override
  String get menuNoPlan => '予定はありません';

  @override
  String get menuAskAi => 'AIに献立を提案してもらう';

  @override
  String get aiSuggestion => 'AIに提案してもらう';

  @override
  String get menuMade => '作った';

  @override
  String get menuCook => '料理する';

  @override
  String get menuAddDish => '料理を追加する';

  @override
  String get menuAdd => '追加';

  @override
  String get menuMealPrepGuide => '週末の作り置きレシピを\n登録してみましょう';

  @override
  String menuCookedAt(Object time) {
    return '$timeに作りました';
  }

  @override
  String get menuReturnToToday => '今日に戻る';

  @override
  String get menuReturnToTodayDescription => '今日のカレンダーに戻すためのボタンです';

  @override
  String get menuAiProposalTitle => 'AI献立提案';

  @override
  String get menuAiProposalMessage =>
      '広告を視聴して、AIに献立を提案してもらいますか？\n（今の冷蔵庫の中身や前後の食事バランスを考慮します）';

  @override
  String get menuAiProposalAction => '広告を見て提案してもらう';

  @override
  String get adExecuteAction => '広告を見て実行する';

  @override
  String get adLoadError => '広告の読み込みに失敗しました。通信環境を確認して再度お試しください。';

  @override
  String get menuCookingDoneTitle => 'お料理お疲れ様でした！';

  @override
  String get menuCookingDoneMessage =>
      'もし作った料理を撮影した写真があったら、写真を貼っておくことで、後で見返すのが楽になります✨';

  @override
  String get menuAttachPhoto => '撮った写真を貼る';

  @override
  String get menuTakePhoto => '撮影する';

  @override
  String get menuCompleteWithoutPhoto => '写真を貼らずに完了する';

  @override
  String menuSaveFailed(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String menuImagesSkipped(Object count) {
    return '$count 枚の画像はすでに存在するためスキップされました';
  }

  @override
  String menuImageSaveFailed(Object error) {
    return '画像の保存に失敗しました: $error';
  }

  @override
  String get menuNoRecipe => 'レシピがありません';

  @override
  String get menuLoading => '読み込み中';

  @override
  String get recipePastMenus => '過去の献立';

  @override
  String get recipeViewAll => 'すべて見る';

  @override
  String get recipeNoPastMenus => '過去の献立はありません';

  @override
  String get recipeSearchPlaceholder => 'レシピを検索またはURLを入力';

  @override
  String get recipeTodaysMenu => '今日の献立';

  @override
  String get recipeEdit => '編集する';

  @override
  String get recipeCookNow => '今すぐ作る';

  @override
  String get recipeNoTodaysMenu => 'まだ今日の献立がありません';

  @override
  String get recipeAdd => '追加する';

  @override
  String get recipeCategoryMain => '主菜';

  @override
  String get recipeCategorySide => '副菜';

  @override
  String get recipeCategoryQuick => '時短';

  @override
  String get recipeCategorySnack => 'おつまみ';

  @override
  String get recipeCategoryFavorite => 'お気に入り';

  @override
  String get recipeCategoryOther => 'その他';

  @override
  String get recipeRecentlyViewed => '最近見たレシピ';

  @override
  String recipeAddedDate(Object date) {
    return '$date 追加';
  }

  @override
  String recipeItemsCount(Object count) {
    return '$count品';
  }

  @override
  String get receiptScanTitle => 'レシート解析を開始';

  @override
  String get receiptScanMessage =>
      'AIがレシートを読み取ります。\n広告を再生することで、この機能を無料でご利用いただけます。';

  @override
  String get receiptScanAction => '広告を見て解析する';

  @override
  String receiptAnalysisFailed(Object error) {
    return '解析に失敗しました: $error';
  }

  @override
  String get receiptScanCanceled => 'スキャンがキャンセルされました';

  @override
  String stockAddedMessage(Object count) {
    return '$count件の在庫を追加しました！';
  }

  @override
  String get stockSaveFailed => '保存に失敗しました。';

  @override
  String get aiAnalysisResult => '解析結果';

  @override
  String get aiAnalysisNoItems => '商品が見つかりませんでした';

  @override
  String aiAnalysisLocation(Object location) {
    return '撮影場所: $location';
  }

  @override
  String get aiAnalysisFoundItems => '以下の商品が見つかりました';

  @override
  String get aiAnalysisExclude => '除外する';

  @override
  String aiAnalysisAddToStock(Object count) {
    return '在庫に追加する ($count件)';
  }

  @override
  String get aiAnalysisQuit => 'やっぱり辞めた';

  @override
  String get aiIngredientAnalysisFailed => '解析に失敗しました。もう一度お試しください。';

  @override
  String get unitItem => '個';

  @override
  String get categoryOther => 'その他';

  @override
  String get dialogConfirm => '確認';

  @override
  String get dialogRegisterRecipeConfirm => '材料の登録が終わりました！\nマイレシピ帳に登録しますか？';

  @override
  String get actionNo => 'いいえ';

  @override
  String get actionYes => 'はい';

  @override
  String get dialogIngredientDestinations =>
      '「ある」材料は在庫へ、\n「買う」材料は買い物リストへ追加します。\n「いらない」材料は登録されません。\nよろしいですか？';

  @override
  String get dialogDontShowAgain => '今後このダイアログを非表示にする';

  @override
  String get actionRegister => '登録する';

  @override
  String stockCountMessage(Object count) {
    return '在庫に$count件';
  }

  @override
  String shoppingListCountMessage(Object count) {
    return '買い物リストに$count件';
  }

  @override
  String addedMessage(Object items) {
    return '$items追加しました！';
  }

  @override
  String get dialogRegistrationCancelConfirm =>
      '解析した材料は、在庫や買い物リストに追加されませんが、よろしいですか？';

  @override
  String get actionBackToRecipe => 'レシピに戻る';

  @override
  String get aiIngredientRunAnalysis => '材料抽出結果';

  @override
  String get recipeExtractedFrom => 'レシピから抽出';

  @override
  String get labelHave => 'ある';

  @override
  String get labelBuy => '買う';

  @override
  String get labelDontNeed => 'いらない';

  @override
  String get actionDoNothingAnd => '何もしないで';

  @override
  String get actionRegisterIngredients => '材料を登録する';

  @override
  String get aiIngredientNoItems => '材料が見つかりませんでした';

  @override
  String get dateYesterday => '昨日';

  @override
  String get aiMenuThinking => '献立を考えています...';

  @override
  String get aiMenuCheckingStock => '冷蔵庫の中身を確認しています...';

  @override
  String get aiMenuGenerating => 'AIが献立を考えています...';

  @override
  String get aiMenuGenerationFailed => '提案を作成できませんでした';

  @override
  String get errorOccurredTryAgain => 'エラーが発生しました。\nもう一度お試しください。';

  @override
  String get menuSnack => '間食';

  @override
  String get actionBack => '戻る';

  @override
  String aiMenuSurroundingMeal(Object day, Object type, Object title) {
    return '$dayの$type: $title';
  }

  @override
  String get shortDateFormat => 'M/d';

  @override
  String get aiRecipeAnalyzingPhoto => 'AIが写真を解析しています…';

  @override
  String aiRecipeThinkingWithIngredient(Object ingredient) {
    return 'AIがレシピを考えています…\n$ingredientがあります';
  }

  @override
  String get aiRecipeNoItemsFound => '商品が見つかりませんでした';

  @override
  String get aiRecipeNoIdentification =>
      '写真から食材を特定できませんでした。\nもう一度撮影するか、レシピを検索してください。';

  @override
  String get actionRetakePhoto => 'もう一度撮影する';

  @override
  String get actionSearchRecipe => 'レシピを検索する';

  @override
  String get actionSkip => 'スキップする';

  @override
  String get aiRecipeProposalTitle => 'こんなレシピはいかがですか？';

  @override
  String get cookingModeExitConfirm => '調理モードを終了しますか？';

  @override
  String get cookingModeExitDescription => '調理モードを終了して前の画面に戻ります。';

  @override
  String get actionFinish => '終了する';

  @override
  String get titleCookingMode => '調理モード';

  @override
  String get nearbyFlyers => '近くのお店のチラシ';

  @override
  String get newArrivals => '新着あり';

  @override
  String get newFlyers => '新着のチラシ';

  @override
  String get todaysRecommended => '今日のおすすめ商品';

  @override
  String get titleFlyer => 'チラシ';

  @override
  String get shopDetails => '店舗詳細';

  @override
  String get cameraPermissionRequired => 'カメラの権限が必要です';

  @override
  String get cameraNotFound => 'カメラが見つかりません';

  @override
  String get errorSaveFailed => '保存に失敗しました';

  @override
  String get errorEnterRecipeName => 'レシピ名を入力してください';

  @override
  String get manualRecipeEntry => 'レシピを手入力';

  @override
  String get recipeNameLabel => 'レシピ名';

  @override
  String get recipeNameHint => '例：豚肉の生姜焼き';

  @override
  String get ingredientsAmount => '材料・分量';

  @override
  String get ingredientNameHint => '例: 豚肉';

  @override
  String get amountHint => '例: 200g';

  @override
  String get actionAddIngredient => '材料を追加する';

  @override
  String get actionRegisterManualRecipe => '手入力したレシピを登録する';

  @override
  String get searchByZipCode => '郵便番号で探す';

  @override
  String get setMyAreaHere => 'マイエリアをここにする';

  @override
  String get titleNotification => '通知';

  @override
  String get actionReadAll => 'すべて既読';

  @override
  String get noNotifications => '通知はありません';

  @override
  String get actionAddDemoData => 'デモデータを追加';

  @override
  String minutesAgo(Object count) {
    return '$count分前';
  }

  @override
  String hoursAgo(Object count) {
    return '$count時間前';
  }

  @override
  String daysAgo(Object count) {
    return '$count日前';
  }

  @override
  String yesterdayAt(Object time) {
    return '昨日 $time';
  }

  @override
  String get titlePhotoGallery => '写真一覧';

  @override
  String get noPhotos => '写真がありません';

  @override
  String get titlePhotoStockLocation => 'AI解析を開始';

  @override
  String get photoStockLocationMessage =>
      'AIがあなたの冷蔵庫を分析します。\n広告を再生することで、この機能を無料でご利用いただけます。';

  @override
  String photoStockLocationAiAnalyzing(Object location) {
    return 'AIがあなたの$locationを分析しています。\n解析が終わるまで広告をご覧ください。';
  }

  @override
  String get aiAnalysisCompleteMessage => 'AIの解析がおわりました。\n広告の視聴ありがとうございました。';

  @override
  String get retake => 'やり直す';

  @override
  String get enterStorageLocation => '撮影した保管場所を入力';

  @override
  String get storageLocationHint => '例: 食品庫';

  @override
  String get selectFromCandidates => '候補から選択';

  @override
  String get actionDecide => '決定';

  @override
  String get errorFileNotFound => 'ファイルが見つかりません';

  @override
  String get analysisComplete => '解析が完了しました';

  @override
  String get foodAnalysisDoneMessage => '料理の写真の解析が終わりました。';

  @override
  String get capturedWithStox => 'STOXで撮影しました';

  @override
  String get analyzing => '解析中...';

  @override
  String get noAnalysisData => '解析データがありません';

  @override
  String get analyzeNutritionWithAi => 'AIで栄養価を解析する';

  @override
  String get noAnalysisText => '解析結果のテキストがありません';

  @override
  String get titleHistory => '履歴';

  @override
  String get recentlyAddedRecipes => '最近登録したレシピ';

  @override
  String get noRecentlyViewedRecipes => '最近見たレシピはありません';

  @override
  String get noRegisteredRecipes => '登録されたレシピはありません';

  @override
  String yearMonthDay(Object year, Object month, Object day) {
    return '$year年$month月$day日';
  }

  @override
  String get recipeScheduleBreakfast => '朝';

  @override
  String get recipeScheduleLunch => '昼';

  @override
  String get recipeScheduleDinner => '夜';

  @override
  String get recipeScheduleSnack => 'おやつ';

  @override
  String get recipeSchedulePrep => '下ごしらえ';

  @override
  String get recipeScheduleAppetizer => 'おつまみ';

  @override
  String get recipeRegisteredMessage => 'マイレシピ帳に登録しました';

  @override
  String get recipeRegisterFailed => '登録に失敗しました';

  @override
  String get whenToCook => 'いつ作りますか？';

  @override
  String get undecidedDate => '日程を未定にする';

  @override
  String get canSetFromCalendarLater => 'あとでカレンダーから設定できます';

  @override
  String get selectTimeSlot => '時間帯を選択';

  @override
  String get memoOptional => 'メモ（任意）';

  @override
  String get memoHint => 'その他（例：旦那さんの分、作り置き）';

  @override
  String get actionConfirm => '確定する';

  @override
  String get searchFailed => '検索に失敗しました';

  @override
  String get communicationError => '通信エラーが発生しました';

  @override
  String searchResultsFor(Object query) {
    return '「$query」の検索結果';
  }

  @override
  String get fromRecipeSite => 'レシピサイトから';

  @override
  String get actionRetry => '再試行';

  @override
  String get noResultsInRecipeSite => 'レシピサイトに結果が見つかりませんでした';

  @override
  String get actionOpenInBrowser => 'ブラウザで開く';

  @override
  String get actionCopyUrl => 'URLをコピー';

  @override
  String get recipeAiAnalyzingMessage =>
      'AIがレシピの材料を分析しています。\n解析が終わるまで広告をご覧ください。';

  @override
  String get cookThisRecipe => 'このレシピを作る！';

  @override
  String get urlCopied => 'URLをコピーしました';

  @override
  String get saveRecipe => 'レシピの保存';

  @override
  String get whatToDoWithRecipe => 'このレシピをどうしますか？';

  @override
  String get actionDoNothing => '何もしない';

  @override
  String get actionRegisterToRecipeBook => 'マイレシピ帳に登録する';

  @override
  String get stockUpdated => '在庫を更新しました';

  @override
  String get receiptAnalysisResult => 'レシート解析結果';

  @override
  String get receiptNoItemsFound => '商品が見つかりませんでした。';

  @override
  String get actionRetake => 'もう一回撮影する';

  @override
  String get actionToStock => '在庫にする';

  @override
  String get receiptStockConfirmMessage => 'レシートと買物リストの両方にありました。\n在庫に登録します。';

  @override
  String get sectionNewItem => '新規に追加';

  @override
  String get receiptNewItemDescription => '買い物リストにありませんでした。\n在庫に追加しますか？';

  @override
  String get sectionNotPurchased => '未購入';

  @override
  String get receiptNotPurchasedDescription => 'レシートにありませんでした。\n買い物忘れはありませんか？';

  @override
  String get actionComplete => '完了';

  @override
  String get actionViewMenuPlan => '献立計画表を見る';

  @override
  String get fullDateFormat => 'yyyy/MM/dd (E)';

  @override
  String get actionExtractIngredients => '材料を抽出する';

  @override
  String get titleExtractIngredients => '材料の解析';

  @override
  String get titleError => 'エラー';

  @override
  String get titleSearchHistory => '検索履歴';

  @override
  String get actionDeleteAll => 'すべて削除';

  @override
  String get actionManualRecipeEntryNoSearch => '検索せずに、レシピを手入力する';

  @override
  String get manualRecipeIngredientLabel => '材料名';

  @override
  String get manualRecipeAmountLabel => '分量';

  @override
  String get tutorialSkip => 'スキップ';

  @override
  String get tutorialStep1Title => '冷蔵庫の中を\n撮影しましょう';

  @override
  String get tutorialStep1Description => 'AIが写真を解析して、最適なレシピを提案します';

  @override
  String get actionLaunchCamera => 'カメラを起動する';

  @override
  String get actionManualRegister => '手動で登録する';

  @override
  String calendarYearMonth(Object year, Object month) {
    return '$year年$month月';
  }

  @override
  String get clearSteps => 'クリア手順';

  @override
  String get titleChallengeStamp => 'チャレンジスタンプ';

  @override
  String get challengeStampDescription => '全クリアでマスターを目指そう！';

  @override
  String get actionClose => 'とじる';

  @override
  String get congratsTitle => 'ぱんぱかぱーん🎉';

  @override
  String get congratsMessage => 'おめでとうございます！';

  @override
  String get congratsFirstChallenge => '１つめのチャレンジクリアです！';

  @override
  String congratsChallengeClear(Object name) {
    return 'チャレンジ「$name」\nクリアです！';
  }

  @override
  String get actionHooray => 'やったー！';

  @override
  String get challengeRefrigeratorPhoto => '冷蔵庫撮影';

  @override
  String get challengeMenuRegistration => '献立登録';

  @override
  String get challengeRecipeSearch => 'レシピ検索';

  @override
  String get challengeIngredientExtraction => '材料抽出';

  @override
  String get challengeShopping => 'お買い物';

  @override
  String get challengeReceiptRegistration => 'レシート登録';

  @override
  String get challengeCookingPhoto => '料理撮影';

  @override
  String tomorrowIs(Object event) {
    return '明日は$eventです';
  }

  @override
  String dayAfterTomorrowIs(Object event) {
    return '明後日は$eventです';
  }

  @override
  String get actionAiMenuTomorrow => 'AI明日の献立';

  @override
  String get actionAiMenuDayAfterTomorrow => 'AI明後日の献立';

  @override
  String get nutritionTotal => '合計';

  @override
  String get nutritionCalories => 'カロリー';

  @override
  String get nutritionProtein => 'タンパク質(P)';

  @override
  String get nutritionFat => '脂質(F)';

  @override
  String get nutritionCarbs => '炭水化物(C)';

  @override
  String get nutritionDailyTotal => '1日の合計栄養価';

  @override
  String get nutritionSectionTotal => 'この時間の合計';

  @override
  String get nutritionWeeklyAverage => '週平均';

  @override
  String get nutritionMonthlyAverage => '月平均';

  @override
  String get nutritionStatistics => '栄養統計';

  @override
  String get nutritionAverage => '平均';

  @override
  String get nutritionAnalysisData => '栄養価データ';

  @override
  String get nutritionPfcBalance => 'PFCバランス';

  @override
  String get actionTakeRefrigeratorPhotoAndAiSuggest => '冷蔵庫を撮影してAIが提案する';
}
