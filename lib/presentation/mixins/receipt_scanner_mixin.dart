import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import '../../config/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../screens/shopping_receipt_result_screen.dart';
import 'ad_manager_mixin.dart';

/// Mixin to handle Receipt Scanning Flow
/// Requires [AdManagerMixin] to be mixed in as well.
mixin ReceiptScannerMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // Use the AdManagerMixin's method. 
  // Since we can't easily enforce "on ConsumerState with AdManagerMixin" in Dart type system for mixins
  // without defining another base class or interface, we assume the host has it.
  // Ideally, ReceiptScannerMixin implements AdManagerMixin or they are composed.
  // For simplicity, let's assume methods are available or re-declare abstractly.
  
  Future<bool> showAdAndExecute({
    required BuildContext context,
    required String preAdTitle,
    required String preAdContent,
    String? confirmButtonText,
    String? postAdMessage,
    VoidCallback? onConsent,
  });


  Future<void> startReceiptScanFlow({
    required List<Ingredient> currentContextList,
  }) async {
    try {
      final options = DocumentScannerOptions(
        documentFormat: DocumentFormat.jpeg,
        mode: ScannerMode.full,
        pageLimit: 1,
        isGalleryImport: true,
      );

      final scanner = DocumentScanner(options: options);
      final result = await scanner.scanDocument();
      
      if (result.images.isEmpty) return;

      // Wait for scanner UI to close completely and app to regain focus
      await Future.delayed(const Duration(milliseconds: 500));

      final imageFile = File(result.images.first);
      final imageBytes = await imageFile.readAsBytes();

      if (!mounted) return;

      // Show Ad
      final success = await showAdAndExecute(
        context: context,
        preAdTitle: AppLocalizations.of(context)!.receiptScanTitle, // レシート解析を開始
        preAdContent: AppLocalizations.of(context)!.receiptScanMessage, // AIがレシートを読み取ります。\n広告を再生することで、この機能を無料でご利用いただけます。
        confirmButtonText: AppLocalizations.of(context)!.receiptScanAction, // 広告を見て解析する
        postAdMessage: null, 
      );

      if (!success) return;

      // Show Loading
      if (!mounted) return;
      
      // Use a local variable to manage dialog state explicitly
      bool isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.stoxPrimary)),
      ).then((_) {
         isDialogShowing = false;
      });

      // Analyze
      try {
        final aiRepo = ref.read(aiRecipeRepositoryProvider);
        
        final ingredients = await aiRepo.analyzeReceiptImage(imageBytes, mimeType: 'image/jpeg');
        
        if (!mounted) return;
        
        // Close loading dialog if it's still showing
        if (isDialogShowing) {
           Navigator.of(context, rootNavigator: true).pop();
        }

        // Navigate to Result Screen
        final navResult = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShoppingReceiptResultScreen(
               receiptItems: ingredients,
               currentShoppingList: currentContextList,
            ),
          ),
        );
        
        // Handle retake
        if (navResult == 'retake' && mounted) {
           // Small delay to ensure smooth transition
           await Future.delayed(const Duration(milliseconds: 300));
           startReceiptScanFlow(currentContextList: currentContextList);
        }

      } catch (e) {
        if (mounted) {
           if (isDialogShowing) {
             Navigator.of(context, rootNavigator: true).pop();
           }
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.receiptAnalysisFailed(e)))); // 解析に失敗しました
        }
      }

    } catch (e) {
       debugPrint('Scan Error: $e');
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.receiptScanCanceled))); // スキャンがキャンセルされました
       }
    }
  }
}
