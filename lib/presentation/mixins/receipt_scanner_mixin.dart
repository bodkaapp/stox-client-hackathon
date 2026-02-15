import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import '../../config/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../domain/models/ingredient.dart';
import '../../infrastructure/repositories/ai_recipe_repository.dart';
import '../screens/shopping_receipt_result_screen.dart';
import '../screens/receipt_analysis_loading_screen.dart';
import 'ad_manager_mixin.dart';

/// Mixin to handle Receipt Scanning Flow
mixin ReceiptScannerMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
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

      if (!mounted) return;

      // Navigate to Loading Screen
      // The Loading Screen will handle analysis and then replace itself with Result Screen.
      // If Result Screen returns 'retake', it will bubble up here.
      // Use rootNavigator: true to hide the BottomNavigationBar and FAB of the underlying ScaffoldWithNavBar
      final navResult = await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ReceiptAnalysisLoadingScreen(
            imageFile: imageFile,
            currentContextList: currentContextList,
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
       debugPrint('Scan Error: $e');
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.receiptScanCanceled))); // スキャンがキャンセルされました
       }
    }
  }
}
