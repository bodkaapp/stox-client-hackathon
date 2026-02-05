// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World';

  @override
  String get navHome => 'Home';

  @override
  String get navStock => 'Stock';

  @override
  String get navShopping => 'Shopping';

  @override
  String get navMenuPlan => 'Menu Plan';

  @override
  String get navRecipe => 'Recipes';

  @override
  String get homeHelpTitle => 'Home Screen';

  @override
  String get homeHelpDescription =>
      'This is the main screen of the application. Tap this \"?\" icon to see how to use the screen.';

  @override
  String get homeTodaysMenu => 'Today\'s Menu';

  @override
  String get homeRegisterMenu => 'Register';

  @override
  String get homeChangeMenu => 'Change';

  @override
  String get homeNoMenuPlan => 'No menu planned for today';

  @override
  String get homeViewRecipe => 'View Recipe';

  @override
  String get homeShoppingList => 'Shopping List';

  @override
  String get homeShoppingAd => 'Sale at nearby supermarkets!';

  @override
  String get homeViewFlyer => 'View Flyers';

  @override
  String get unitItems => 'items';

  @override
  String get homeExpiringSoon => 'Expiring Soon';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeNoExpiringItems => 'No expiring items';

  @override
  String get actionCheckStock => 'Check Stock';

  @override
  String get actionScanReceipt => 'Scan Receipt';

  @override
  String get actionShoppingMode => 'Shopping Mode';

  @override
  String get actionRecipeBook => 'Recipe Book';

  @override
  String get actionFoodCamera => 'Food Camera';

  @override
  String get actionPhotoGallery => 'Photo Gallery';

  @override
  String daysRemaining(Object days) {
    return '$days days left';
  }

  @override
  String get statusCheck => 'Check';

  @override
  String get statusUrgent => 'Urgent';

  @override
  String get statusWarning => 'Warning';

  @override
  String get shoppingAddToShoppingList => 'Add to Shopping List';

  @override
  String get shoppingTitle => 'Shopping';

  @override
  String get shoppingHelpTitle => 'Shopping Screen';

  @override
  String get shoppingHelpDescription =>
      'Currently managing items to buy.\nTap the \"+\" button to add items to buy.\nPress the \"Shopping Mode\" button to switch to a mode that makes shopping more convenient.\nAfter shopping, you can scan the receipt to move bought items to stock.';

  @override
  String get shoppingAction => 'Actions';

  @override
  String get shoppingEnterItem => 'Enter Item';

  @override
  String get shoppingVoiceInput => 'Voice Input';

  @override
  String get shoppingReceiptScan => 'Scan Receipt';

  @override
  String get shoppingModeOn => 'Shopping Mode ON';

  @override
  String get shoppingModeStart => 'Start Shopping Mode';

  @override
  String get shoppingCompleteAction => 'Complete Shopping';

  @override
  String get shoppingAddGuide => 'Tap here to add items';

  @override
  String get shoppingEnterItemAction => 'Enter item manually';

  @override
  String get shoppingVoiceInputAction => 'Use voice commands';

  @override
  String get shoppingReceiptScanAction => 'Scan receipt (End Shopping Mode)';

  @override
  String get shoppingCompleteButton => 'Complete';

  @override
  String get shoppingEmptyListMessage =>
      'This is where you register your shopping list.\nMake a note so you don\'t forget what to buy.';

  @override
  String get shoppingTotalItemsLabel => 'TOTAL ITEMS';

  @override
  String shoppingTotalItemsCount(Object count) {
    return 'Total $count items';
  }

  @override
  String get shoppingModeToggleOn => 'Shopping Mode ON';

  @override
  String get shoppingModeToggleOff => 'Shopping Mode OFF';

  @override
  String get shoppingCartProgress => 'Cart Progress';

  @override
  String shoppingCartCount(Object count, Object total) {
    return '$count / $total items';
  }

  @override
  String shoppingRemainingItems(Object remaining) {
    return '$remaining items left to complete';
  }

  @override
  String get categoryUncategorized => 'Uncategorized';

  @override
  String get categoryVegetablesFruits => 'Vegetables & Fruits';

  @override
  String get categoryMeatFish => 'Meat & Fish';

  @override
  String get categorySeasoning => 'Seasonings';

  @override
  String get voicePermissionError => 'Microphone permission required';

  @override
  String get voiceAnalyzing => 'Analyzing...';

  @override
  String get voiceListening => 'Listening...';

  @override
  String get voiceTapToStart => 'Tap to start';

  @override
  String get voiceHint =>
      'Speak item names\\ne.g. \"Onions\", \"Pork and Cabbage\"';

  @override
  String get voiceHistoryPlaceholder => 'History will appear here';

  @override
  String get voiceAdded => 'Added';

  @override
  String get voiceClose => 'Close';

  @override
  String get voiceAiError => 'AI could not analyze audio';

  @override
  String voiceCompleteMessage(Object count) {
    return 'Completed $count operations';
  }

  @override
  String get addModalCategoryHint => 'Category (optional)';

  @override
  String get addModalNameHint => 'Item name (e.g. Carrot)';

  @override
  String get addModalAddButton => 'Add';

  @override
  String get addModalConfirmButton => 'Confirm';

  @override
  String get addModalEmptyList => 'Added items will appear here';

  @override
  String get addModalHeaderName => 'Name';

  @override
  String get addModalHeaderQuantity => 'Qty';

  @override
  String get addModalHeaderCategory => 'Category';

  @override
  String addModalAiSuccess(Object count) {
    return 'Added $count items to list';
  }

  @override
  String get addModalAiError => 'AI could not parse text';

  @override
  String addModalSaveError(Object error) {
    return 'Failed to save: $error';
  }

  @override
  String get stockTitle => 'Inventory List';

  @override
  String get stockHelpTitle => 'Inventory Screen';

  @override
  String get stockHelpDescription =>
      'Screen to check inventory of food and daily necessities. You can check quantity and expiration dates.';

  @override
  String get menuPlanTitle => 'Menu Plan';

  @override
  String get menuPlanHelpTitle => 'Menu Plan Screen';

  @override
  String get menuPlanHelpDescription =>
      'Screen to plan upcoming meals or review past recipes.';

  @override
  String get recipeBookTitle => 'My Recipe Book';

  @override
  String get recipeBookHelpTitle => 'Recipe Book Screen';

  @override
  String get recipeBookHelpDescription =>
      'Screen to search recipes, plan meals, or record cooked dishes.';

  @override
  String get searchPlaceholder => 'Search stock...';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryDairy => 'Dairy';

  @override
  String get stockHeaderType => 'Type';

  @override
  String get stockHeaderName => 'Name';

  @override
  String get stockHeaderDate => 'Exp';

  @override
  String get stockHeaderAmount => 'Rem';

  @override
  String get stockNoSearchResults => 'No results found';

  @override
  String get stockEmptyDescription =>
      'This is where you register and view items\nyou bought or received.';

  @override
  String get stockEmptyAddInstruction => 'Tap here to add stock';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get labelDraftDesign => 'Draft Design';

  @override
  String get myAreaSetting => 'My Area Setting';

  @override
  String get labelRecommended => 'Recommended';

  @override
  String get labelNewItem => 'NEW ITEM';

  @override
  String get tutorialTitle => 'Take a photo of\nyour fridge';

  @override
  String get tutorialDescription =>
      'AI analyzes photos and suggests the best recipes.';

  @override
  String get actionStartCamera => 'Start Camera';

  @override
  String get actionRegisterManually => 'Register Manually';

  @override
  String get titleAccountSettings => 'Account Settings';

  @override
  String get labelDebugDeveloperOptions => 'Debug & Developer Options';

  @override
  String get actionRestartFromTutorial => 'Restart from Tutorial';

  @override
  String get actionRestart => 'Restart';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionResetChallengeStamps => 'Reset Challenge Stamps';

  @override
  String get labelCheckAiResultDebug => 'Check AI Result (Debug)';

  @override
  String get labelCheckSplashScreen => 'Check Splash Screen (Debug)';

  @override
  String get titleConfirmation => 'Confirmation';

  @override
  String get messageRestartFromTutorialConfirm =>
      'Are you sure you want to restart from the tutorial?\nCurrent state might be partially reset.';

  @override
  String get messageResetChallengeStampsConfirm =>
      'Are you sure you want to reset all challenge stamps?\nThis action cannot be undone.';

  @override
  String get messageChallengeStampsResetComplete =>
      'Challenge stamps have been reset';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get receiptAnalysisResultTitle => 'Receipt Analysis Result';

  @override
  String get actionSetToStock => 'Add to Stock';

  @override
  String get receiptSectionMatchedDescription =>
      'Found in both receipt and shopping list.\nRegistering to stock.';

  @override
  String get actionAddNew => 'Add New';

  @override
  String get receiptSectionNewDescription =>
      'Not found in shopping list.\nAdd to stock?';

  @override
  String get statusUnpurchased => 'Unpurchased';

  @override
  String get receiptSectionUnpurchasedDescription =>
      'Not found in receipt.\nDid you forget to buy it?';

  @override
  String get actionKeepInList => 'Keep in List';

  @override
  String get locationFridge => 'Fridge';

  @override
  String get locationFreezer => 'Freezer';

  @override
  String get locationVegetable => 'Vegetable Drawer';

  @override
  String get locationUnderSink => 'Under Sink';

  @override
  String get locationPantry => 'Pantry';

  @override
  String get locationStorageRoom => 'Storage Room';

  @override
  String get locationRoomTemp => 'Room Temp';

  @override
  String get actionShareRecipe => 'Share recipe';

  @override
  String get aiAnalysisRecipeIngredientsDescription =>
      'AI is analyzing recipe ingredients.\nPlease watch the ad while it finishes.';

  @override
  String get actionCookThisRecipe => 'Cook This Recipe!';

  @override
  String get recipeSavedToBook => 'Recipe saved to My Recipe Book';

  @override
  String get recipeSaveError => 'Failed to register recipe';

  @override
  String get recipeSaveTitle => 'Save Recipe';

  @override
  String get recipeSaveQuestion =>
      'What would you like to do with this recipe?';

  @override
  String get actionRegisterToMyRecipeBook => 'Register to My Recipe Book';

  @override
  String get aiAnalysisRecipeIngredientsDescriptionLong =>
      'AI is analyzing recipe ingredients.\nAnalysis will be performed while you watch the ad.';

  @override
  String get actionWatchAdAndAnalyze => 'Watch Ad & Analyze';

  @override
  String get analysisFailedTryAgain => 'Analysis failed. Please try again.';

  @override
  String get tabRecentlyViewed => 'Recently Viewed';

  @override
  String get tabRecentlyAdded => 'Recently Added';

  @override
  String get noRecentlyAddedRecipes => 'No recipes registered yet';

  @override
  String dateYMD(Object year, Object month, Object day) {
    return '$year/$month/$day';
  }

  @override
  String get searchFailedMessage => 'Search failed';

  @override
  String get errorNetwork => 'Network error occurred';

  @override
  String recipeSearchResults(String query) {
    return 'Search results for \"$query\"';
  }

  @override
  String get labelFromRecipeSites => 'From Recipe Sites';

  @override
  String get noRecipeSearchResults => 'No results found on recipe sites';

  @override
  String get titleChangeMyArea => 'Change My Area';

  @override
  String get statusFollowing => 'Following';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get analysisFailed => 'Analysis failed';

  @override
  String get foodPhotoAnalysisComplete => 'Food photo analysis complete.';

  @override
  String get sharedWithStox => 'Captured with STOX';

  @override
  String get actionAnalyzeNutritionWithAi => 'Analyze Nutrition with AI';

  @override
  String get mealMorning => 'Morning';

  @override
  String get mealNoon => 'Noon';

  @override
  String get mealNight => 'Night';

  @override
  String get mealSnack => 'Snack';

  @override
  String get mealPrep => 'Prep';

  @override
  String get mealAppetizer => 'Appetizer';

  @override
  String get titleWhenToMake => 'When will you make it?';

  @override
  String get actionSetDateUndecided => 'Set Date Undecided';

  @override
  String get labelSelectTimeSlot => 'Select Time Slot';

  @override
  String get labelMemoOptional => 'Memo (Optional)';

  @override
  String get saveAction => 'Save';

  @override
  String get categoryOthers => 'Others';

  @override
  String get actionAi => 'AI';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionGetAiSuggestions => 'Get AI Suggestions';

  @override
  String get labelSearchHistory => 'Search History';

  @override
  String get actionManualRecipeEntryInstead =>
      'Enter recipe manually without searching';

  @override
  String get labelManualRecipeEntry => 'Enter recipe manually';

  @override
  String get actionNext => 'Next';

  @override
  String get actionDelete => 'Delete';

  @override
  String get stockDeleteConfirmMessage => 'Are you sure you want to delete?';

  @override
  String stockDeletedMessage(Object count) {
    return 'Deleted $count items';
  }

  @override
  String get actionUndo => 'Undo';

  @override
  String get stockRestoreConfirmMessage => 'Restore deleted items?';

  @override
  String get actionRestore => 'Restore';

  @override
  String get stockRestoredMessage => 'Restored items';

  @override
  String stockSelectedCount(Object count) {
    return '$count items selected';
  }

  @override
  String get stockCategoryLabel => 'Category';

  @override
  String get stockOperationLabel => 'Action';

  @override
  String stockDeleteButtonLabel(Object count) {
    return 'Delete ($count)';
  }

  @override
  String get stockCancelSelection => 'Cancel Selection';

  @override
  String get stockAddToShoppingList => 'Add to Shopping List';

  @override
  String get stockAddByTextInput => 'Add by text input';

  @override
  String get stockAddByVoice => 'Add by voice input';

  @override
  String get stockAddByPhoto => 'Add by photo';

  @override
  String get stockDeleteItems => 'Select items to delete';

  @override
  String get dateToday => 'Today';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String stockTotalItems(Object count) {
    return 'Total $count items';
  }

  @override
  String stockExpiredCount(Object count) {
    return '  ● $count expiring soon';
  }

  @override
  String errorOccurred(Object error) {
    return 'Error occurred: $error';
  }

  @override
  String get stockDeleteActionGuide => 'Tap here to delete';

  @override
  String get stockAddTitle => 'Add Stock';

  @override
  String get menuBreakfast => 'Breakfast';

  @override
  String get menuBreakfastLabel => 'Breakfast';

  @override
  String get menuLunch => 'Lunch';

  @override
  String get menuLunchLabel => 'Lunch';

  @override
  String get menuDinner => 'Dinner';

  @override
  String get menuDinnerLabel => 'Dinner';

  @override
  String get menuUndecided => 'Undecided';

  @override
  String get menuUndecidedLabel => 'TBD';

  @override
  String get menuMealPrep => 'Meal Prep';

  @override
  String get menuMealPrepLabel => 'Prep';

  @override
  String get menuNoMenu => 'No menu planned';

  @override
  String get menuNoPlan => 'No plans';

  @override
  String get menuAskAi => 'Ask AI for menu suggestions';

  @override
  String get aiSuggestion => 'Ask AI';

  @override
  String get menuMade => 'Made';

  @override
  String get menuCook => 'Cook';

  @override
  String get menuAddDish => 'Add dish';

  @override
  String get menuAdd => 'Add';

  @override
  String get menuMealPrepGuide => 'Register weekend meal prep recipes';

  @override
  String menuCookedAt(Object time) {
    return 'Cooked at $time';
  }

  @override
  String get menuAiProposalTitle => 'AI Menu Proposal';

  @override
  String get menuAiProposalMessage =>
      'Watch an ad to get a menu suggestion from AI?\n(Consider current fridge inventory and nutritional balance)';

  @override
  String get menuAiProposalAction => 'Watch ad and get suggestion';

  @override
  String get adExecuteAction => 'Watch Ad & Execute';

  @override
  String get adLoadError => 'Failed to load ad. Please check your connection.';

  @override
  String get menuCookingDoneTitle => 'Great job cooking!';

  @override
  String get menuCookingDoneMessage =>
      'If you have a photo of the dish, attach it to make it easier to look back later!';

  @override
  String get menuAttachPhoto => 'Attach taken photo';

  @override
  String get menuTakePhoto => 'Take photo';

  @override
  String get menuCompleteWithoutPhoto => 'Finish without photo';

  @override
  String menuSaveFailed(Object error) {
    return 'Failed to save: $error';
  }

  @override
  String menuImagesSkipped(Object count) {
    return '$count images skipped as they already exist';
  }

  @override
  String menuImageSaveFailed(Object error) {
    return 'Failed to save image: $error';
  }

  @override
  String get menuNoRecipe => 'No recipe';

  @override
  String get menuLoading => 'Loading...';

  @override
  String get recipePastMenus => 'Past Menus';

  @override
  String get recipeViewAll => 'View All';

  @override
  String get recipeNoPastMenus => 'No past menus';

  @override
  String get recipeSearchPlaceholder => 'Search recipe or enter URL';

  @override
  String get recipeTodaysMenu => 'Today\'s Menu';

  @override
  String get recipeEdit => 'Edit';

  @override
  String get recipeCookNow => 'Cook Now';

  @override
  String get recipeNoTodaysMenu => 'No menu for today yet';

  @override
  String get recipeAdd => 'Add';

  @override
  String get recipeCategoryMain => 'Main Dish';

  @override
  String get recipeCategorySide => 'Side Dish';

  @override
  String get recipeCategoryQuick => 'Quick';

  @override
  String get recipeCategorySnack => 'Snack';

  @override
  String get recipeCategoryFavorite => 'Favorites';

  @override
  String get recipeCategoryOther => 'Others';

  @override
  String get recipeRecentlyViewed => 'Recently Viewed';

  @override
  String recipeAddedDate(Object date) {
    return 'Added on $date';
  }

  @override
  String recipeItemsCount(Object count) {
    return '$count items';
  }

  @override
  String get receiptScanTitle => 'Start Receipt Scan';

  @override
  String get receiptScanMessage =>
      'AI will analyze your receipt.\nWatch an ad to use this feature for free.';

  @override
  String get receiptScanAction => 'Watch Ad & Scan';

  @override
  String receiptAnalysisFailed(Object error) {
    return 'Analysis failed: $error';
  }

  @override
  String get receiptScanCanceled => 'Scan canceled';

  @override
  String stockAddedMessage(Object count) {
    return 'Added $count items to stock!';
  }

  @override
  String get stockSaveFailed => 'Failed to save.';

  @override
  String get aiAnalysisResult => 'Analysis Results';

  @override
  String get aiAnalysisNoItems => 'No items found';

  @override
  String aiAnalysisLocation(Object location) {
    return 'Location: $location';
  }

  @override
  String get aiAnalysisFoundItems => 'Found the following items';

  @override
  String get aiAnalysisExclude => 'Exclude';

  @override
  String aiAnalysisAddToStock(Object count) {
    return 'Add to Stock ($count items)';
  }

  @override
  String get aiAnalysisQuit => 'Cancel';

  @override
  String get aiIngredientAnalysisFailed => 'Analysis failed. Please try again.';

  @override
  String get unitItem => 'pcs';

  @override
  String get categoryOther => 'Others';

  @override
  String get dialogConfirm => 'Confirmation';

  @override
  String get dialogRegisterRecipeConfirm =>
      'Finished registering ingredients! Do you want to add to My Recipe Book?';

  @override
  String get actionNo => 'No';

  @override
  String get actionYes => 'Yes';

  @override
  String get dialogIngredientDestinations =>
      '\'Have\' items go to Stock,\n\'Buy\' items go to Shopping List.\n\'Don\'t need\' items are ignored.\nProceed?';

  @override
  String get dialogDontShowAgain => 'Don\'t show this again';

  @override
  String get actionRegister => 'Register';

  @override
  String stockCountMessage(Object count) {
    return '$count items to Stock';
  }

  @override
  String shoppingListCountMessage(Object count) {
    return '$count items to Shopping List';
  }

  @override
  String addedMessage(Object items) {
    return 'Added $items!';
  }

  @override
  String get dialogRegistrationCancelConfirm =>
      'Analyzed ingredients will not be added to Stock or Shopping List. Are you sure?';

  @override
  String get actionBackToRecipe => 'Back to Recipe';

  @override
  String get aiIngredientRunAnalysis => 'Ingredient Analysis Result';

  @override
  String get recipeExtractedFrom => 'Extracted from Recipe';

  @override
  String get labelHave => 'Have';

  @override
  String get labelBuy => 'Buy';

  @override
  String get labelDontNeed => 'Don\'t Need';

  @override
  String get actionDoNothingAnd => 'Do nothing and';

  @override
  String get actionRegisterIngredients => 'Register Ingredients';

  @override
  String get aiIngredientNoItems => 'No ingredients found';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get aiMenuThinking => 'Thinking about the menu...';

  @override
  String get aiMenuCheckingStock => 'Checking the refrigerator contents...';

  @override
  String get aiMenuGenerating => 'AI is generating the menu...';

  @override
  String get aiMenuGenerationFailed => 'Could not create a proposal';

  @override
  String get errorOccurredTryAgain => 'An error occurred.\nPlease try again.';

  @override
  String get menuSnack => 'Snack';

  @override
  String get actionBack => 'Back';

  @override
  String aiMenuSurroundingMeal(Object day, Object type, Object title) {
    return '$day $type: $title';
  }

  @override
  String get shortDateFormat => 'M/d';

  @override
  String get aiRecipeAnalyzingPhoto => 'AI is analyzing the photo...';

  @override
  String aiRecipeThinkingWithIngredient(Object ingredient) {
    return 'AI is thinking about recipes...\nFound: $ingredient';
  }

  @override
  String get aiRecipeNoItemsFound => 'No items found';

  @override
  String get aiRecipeNoIdentification =>
      'Could not identify ingredients from the photo.\nPlease take a photo again or search for a recipe.';

  @override
  String get actionRetakePhoto => 'Take photo again';

  @override
  String get actionSearchRecipe => 'Search for recipes';

  @override
  String get actionSkip => 'Skip';

  @override
  String get aiRecipeProposalTitle => 'How about these recipes?';

  @override
  String get cookingModeExitConfirm => 'Exit cooking mode?';

  @override
  String get cookingModeExitDescription =>
      'Exit cooking mode and return to the previous screen.';

  @override
  String get actionFinish => 'Finish';

  @override
  String get titleCookingMode => 'Cooking Mode';

  @override
  String get nearbyFlyers => 'Flyers for nearby shops';

  @override
  String get newArrivals => 'New arrivals';

  @override
  String get newFlyers => 'New flyers';

  @override
  String get todaysRecommended => 'Today\'s recommended items';

  @override
  String get titleFlyer => 'Flyer';

  @override
  String get shopDetails => 'Shop Details';

  @override
  String get cameraPermissionRequired => 'Camera permission is required';

  @override
  String get cameraNotFound => 'Camera not found';

  @override
  String get errorSaveFailed => 'Failed to save';

  @override
  String get errorEnterRecipeName => 'Please enter a recipe name';

  @override
  String get manualRecipeEntry => 'Manual Recipe Entry';

  @override
  String get recipeNameLabel => 'Recipe Name';

  @override
  String get recipeNameHint => 'e.g., Ginger Pork';

  @override
  String get ingredientsAmount => 'Ingredients & Amounts';

  @override
  String get ingredientNameHint => 'e.g., Pork';

  @override
  String get amountHint => 'e.g., 200g';

  @override
  String get actionAddIngredient => 'Add Ingredient';

  @override
  String get actionRegisterManualRecipe => 'Register manually entered recipe';

  @override
  String get searchByZipCode => 'Search by zip code';

  @override
  String get setMyAreaHere => 'Set my area here';

  @override
  String get titleNotification => 'Notification';

  @override
  String get actionReadAll => 'Read all';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get actionAddDemoData => 'Add demo data';

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String yesterdayAt(Object time) {
    return 'Yesterday $time';
  }

  @override
  String get titlePhotoGallery => 'Photo Gallery';

  @override
  String get noPhotos => 'No photos';

  @override
  String get titlePhotoStockLocation => 'Start AI Analysis';

  @override
  String get photoStockLocationMessage =>
      'AI will analyze your refrigerator.\nYou can use this feature for free by playing an ad.';

  @override
  String photoStockLocationAiAnalyzing(Object location) {
    return 'AI is analyzing your $location.\nPlease watch the ad until the analysis is finished.';
  }

  @override
  String get aiAnalysisCompleteMessage =>
      'AI analysis is finished.\nThank you for watching the ad.';

  @override
  String get retake => 'Retake';

  @override
  String get enterStorageLocation => 'Enter the storage location';

  @override
  String get storageLocationHint => 'e.g., Pantry';

  @override
  String get selectFromCandidates => 'Select from candidates';

  @override
  String get actionDecide => 'Decide';

  @override
  String get errorFileNotFound => 'File not found';

  @override
  String get analysisComplete => 'Analysis complete';

  @override
  String get foodAnalysisDoneMessage => 'Food photo analysis is finished.';

  @override
  String get capturedWithStox => 'Captured with STOX';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get noAnalysisData => 'No analysis data';

  @override
  String get analyzeNutritionWithAi => 'Analyze nutrition with AI';

  @override
  String get noAnalysisText => 'No analysis text available';

  @override
  String get titleHistory => 'History';

  @override
  String get recentlyAddedRecipes => 'Recently added recipes';

  @override
  String get noRecentlyViewedRecipes => 'No recently viewed recipes';

  @override
  String get noRegisteredRecipes => 'No registered recipes';

  @override
  String yearMonthDay(Object year, Object month, Object day) {
    return '$month/$day/$year';
  }

  @override
  String get recipeScheduleBreakfast => 'Breakfast';

  @override
  String get recipeScheduleLunch => 'Lunch';

  @override
  String get recipeScheduleDinner => 'Dinner';

  @override
  String get recipeScheduleSnack => 'Snack';

  @override
  String get recipeSchedulePrep => 'Prep';

  @override
  String get recipeScheduleAppetizer => 'Appetizer';

  @override
  String get recipeRegisteredMessage => 'Registered to My Recipe Book';

  @override
  String get recipeRegisterFailed => 'Failed to register';

  @override
  String get whenToCook => 'When will you cook?';

  @override
  String get undecidedDate => 'Undecided date';

  @override
  String get canSetFromCalendarLater =>
      'You can set it from the calendar later';

  @override
  String get selectTimeSlot => 'Select time slot';

  @override
  String get memoOptional => 'Memo (optional)';

  @override
  String get memoHint => 'Others (e.g., for husband, meal prep)';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get searchFailed => 'Search failed';

  @override
  String get communicationError => 'Communication error occurred';

  @override
  String searchResultsFor(Object query) {
    return 'Search results for \"$query\"';
  }

  @override
  String get fromRecipeSite => 'From recipe sites';

  @override
  String get actionRetry => 'Retry';

  @override
  String get noResultsInRecipeSite => 'No results found in recipe sites';

  @override
  String get actionOpenInBrowser => 'Open in browser';

  @override
  String get actionCopyUrl => 'Copy URL';

  @override
  String get recipeAiAnalyzingMessage =>
      'AI is analyzing recipe ingredients.\nPlease watch the ad until the analysis is finished.';

  @override
  String get cookThisRecipe => 'Cook this recipe!';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get saveRecipe => 'Save Recipe';

  @override
  String get whatToDoWithRecipe => 'What do you want to do with this recipe?';

  @override
  String get actionDoNothing => 'Do nothing';

  @override
  String get actionRegisterToRecipeBook => 'Register to My Recipe Book';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get receiptAnalysisResult => 'Receipt Analysis Result';

  @override
  String get receiptNoItemsFound => 'No items found.';

  @override
  String get actionRetake => 'Retake';

  @override
  String get actionToStock => 'Add to stock';

  @override
  String get receiptStockConfirmMessage =>
      'Found in both receipt and shopping list.\nRegistering to stock.';

  @override
  String get sectionNewItem => 'Add New';

  @override
  String get receiptNewItemDescription =>
      'Not in the shopping list.\nAdd to stock?';

  @override
  String get sectionNotPurchased => 'Not Purchased';

  @override
  String get receiptNotPurchasedDescription =>
      'Not in the receipt.\nDid you forget to buy something?';

  @override
  String get actionComplete => 'Complete';

  @override
  String get actionViewMenuPlan => 'View Menu Plan';

  @override
  String get fullDateFormat => 'MM/dd/yyyy (E)';

  @override
  String get actionExtractIngredients => 'Extract Ingredients';

  @override
  String get titleExtractIngredients => 'Extract Ingredients';

  @override
  String get titleError => 'Error';

  @override
  String get titleSearchHistory => 'Search History';

  @override
  String get actionDeleteAll => 'Delete All';

  @override
  String get actionManualRecipeEntryNoSearch =>
      'Manual Recipe Entry (No Search)';

  @override
  String get manualRecipeIngredientLabel => 'Ingredient';

  @override
  String get manualRecipeAmountLabel => 'Amount';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialStep1Title => 'Take a photo of\nyour refrigerator';

  @override
  String get tutorialStep1Description =>
      'AI analyzes the photo and suggests the best recipes';

  @override
  String get actionLaunchCamera => 'Launch Camera';

  @override
  String get actionManualRegister => 'Manual Register';

  @override
  String calendarYearMonth(Object year, Object month) {
    return '$month $year';
  }

  @override
  String get clearSteps => 'Clear steps';

  @override
  String get titleChallengeStamp => 'Challenge Stamp';

  @override
  String get challengeStampDescription =>
      'Aim to become a master by clearing all!';

  @override
  String get actionClose => 'Close';

  @override
  String get congratsTitle => 'Ta-da! 🎉';

  @override
  String get congratsMessage => 'Congratulations!';

  @override
  String get congratsFirstChallenge => 'You cleared your first challenge!';

  @override
  String congratsChallengeClear(Object name) {
    return 'Challenge \"$name\" cleared!';
  }

  @override
  String get actionHooray => 'Hooray!';

  @override
  String get challengeRefrigeratorPhoto => 'Refrigerator Photo';

  @override
  String get challengeMenuRegistration => 'Menu Registration';

  @override
  String get challengeRecipeSearch => 'Recipe Search';

  @override
  String get challengeIngredientExtraction => 'Ingredient Extraction';

  @override
  String get challengeShopping => 'Shopping';

  @override
  String get challengeReceiptRegistration => 'Receipt Registration';

  @override
  String get challengeCookingPhoto => 'Cooking Photo';
}
