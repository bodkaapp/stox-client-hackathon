import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../widgets/home_widgets.dart';
import '../widgets/date_header_widget.dart';
import 'ai_menu_proposal_loading_screen.dart';
import '../../domain/models/meal_plan.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return _buildTabletLayout(context, ref);
            }
            return _buildMobileLayout(context, ref);
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeHeader()),
        if (context.isEnglish)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'This app helps you search for Japanese recipe websites and suggests Japanese dishes you can make with ingredients in your fridge.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.stoxText,
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: DateHeaderWidget(
            date: DateTime.now(),
            showRelativeDate: false,
            onAiButtonTap: (date) => _navigateToAiProposal(context, date),
          ),
        ),
        const SliverToBoxAdapter(child: TodaysMenuCard()),
        const SliverToBoxAdapter(child: ShoppingBanner()),
        const SliverToBoxAdapter(child: HomeActionGrid()),
        const SliverToBoxAdapter(child: ExpiringItemsList()),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const HomeHeader(),
        if (context.isEnglish)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'This app helps you search for Japanese recipe websites and suggests Japanese dishes you can make with ingredients in your fridge.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.stoxText,
              ),
            ),
          ),
        DateHeaderWidget(
          date: DateTime.now(),
          showRelativeDate: false,
          onAiButtonTap: (date) => _navigateToAiProposal(context, date),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Operations and Menu
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const TodaysMenuCard(),
                      const ShoppingBanner(),
                      const HomeActionGrid(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              // Right Column: Expiring Items
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0, top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.stoxBorder),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.homeExpiringSoon,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.stoxText,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ExpiringItemsList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  void _navigateToAiProposal(BuildContext context, DateTime targetDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiMenuProposalLoadingScreen(
          targetDate: targetDate,
          mealType: MealType.dinner,
        ),
      ),
    );
  }
}
