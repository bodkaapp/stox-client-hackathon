import 'package:flutter/material.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router.dart';
import 'config/theme.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  MobileAds.instance.initialize();
  await initializeDateFormatting('ja');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupQuickActions();
  }

  void _setupQuickActions() {
    const quickActions = QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'add_shopping_item') {
        // Navigate to shopping screen with action=add
        Future.delayed(const Duration(milliseconds: 500), () {
             ref.read(routerProvider).go('/shopping?action=add');
        });
      } else if (shortcutType == 'take_photo') {
        // Navigate to food camera
         Future.delayed(const Duration(milliseconds: 500), () {
             ref.read(routerProvider).go('/food_camera');
        });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'add_shopping_item',
        localizedTitle: '買い物リストに追加',
        // icon: 'ic_launcher',
      ),
      const ShortcutItem(
        type: 'take_photo',
        localizedTitle: '料理を撮影する',
        // icon: 'ic_launcher',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Stox',
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
