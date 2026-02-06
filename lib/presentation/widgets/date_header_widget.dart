import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;
import 'package:intl/intl.dart';
import '../../config/food_events.dart';
import '../../config/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../components/ai_suggestion_button.dart';

class DateHeaderWidget extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime)? onAiButtonTap; // If null, AI button logic is skipped (e.g. for MenuPlanScreen)
  final String? aiButtonLabel; // Label for the AI button
  final DateTime? aiTargetDate; // Target date for AI analysis
  final bool showRelativeDate; // Whether to show (today), (tomorrow) etc.
  final EdgeInsetsGeometry? padding;

  const DateHeaderWidget({
    super.key,
    required this.date,
    this.onAiButtonTap,
    this.aiButtonLabel,
    this.aiTargetDate,
    this.showRelativeDate = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // ... (existing variable setups)
    final now = date;
    
    // 1. Current Date Events
    final holidays = holiday_jp.getHoliday(now);
    final foodEvent = FoodEvents.getEvent(now);
    
    // 2. Format Relative Date
    String? relativeDate;
    if (showRelativeDate) {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final targetDate = DateTime(now.year, now.month, now.day);
        final diff = targetDate.difference(todayDate).inDays;
        
        if (diff == 0) relativeDate = AppLocalizations.of(context)!.dateToday;
        else if (diff == 1) relativeDate = AppLocalizations.of(context)!.dateYesterday; // Check if these keys are correct mappings (yesterday/tomorrow might be swapped in previous edits but logical here: +1 is tomorrow usually, but difference is target - today. If target is tomorrow, diff is 1. so diff=1 -> tomorrow)
        // Wait, difference = target - today.
        // If target is tomorrow, diff = 1.
        // My previous logic: 
        // if (diff == 1) relativeDate = AppLocalizations.of(context)!.dateYesterday; 
        // That seems WRONG if diff is target - today. 
        // Let's re-verify: target(tomorrow) - today = 1. So diff 1 should be TOMORROW.
        // target(yesterday) - today = -1. So diff -1 should be YESTERDAY.
        // Let's fix this logic too while we are at it.

        if (diff == 0) relativeDate = '(${AppLocalizations.of(context)!.dateToday})';
        else if (diff == 1) relativeDate = '(${AppLocalizations.of(context)!.dateTomorrow})';
        else if (diff == -1) relativeDate = '(${AppLocalizations.of(context)!.dateYesterday})';
        else if (diff >= 2 && diff <= 6) relativeDate = '(${AppLocalizations.of(context)!.daysAgo(diff)})'; 
        // Adjusted to use parenthesis and correct keys
    }

    // ... (rest of logic) ...



    // 3. Logic for Next Days (Only if we are likely on Home Screen / onAiButtonTap is provided)
    //    Ideally, we should determine this outside, but the requirement says "add to date header".
    //    We'll do a check for upcoming events here if `onAiButtonTap` is not null (assuming Home context).
    String? upcomingEventText;
    bool showAiButton = false;
    
    // Default label if not provided but button is requested
    String buttonLabel = aiButtonLabel ?? '';
    DateTime? targetActionDate;
    
    if (onAiButtonTap != null) {
      final tomorrow = now.add(const Duration(days: 1));
      final dayAfter = now.add(const Duration(days: 2));
      
      final tomorrowHoliday = holiday_jp.getHoliday(tomorrow);
      final tomorrowFood = FoodEvents.getEvent(tomorrow);
      
      final resultTomorrow = _getEventName(tomorrowHoliday, tomorrowFood);
      
      if (resultTomorrow != null) {
        upcomingEventText = AppLocalizations.of(context)!.tomorrowIs(resultTomorrow);
        buttonLabel = AppLocalizations.of(context)!.actionAiMenuTomorrow;
        targetActionDate = tomorrow;
      } else {
        final dayAfterHoliday = holiday_jp.getHoliday(dayAfter);
        final dayAfterFood = FoodEvents.getEvent(dayAfter);
        final resultDayAfter = _getEventName(dayAfterHoliday, dayAfterFood);
        
        if (resultDayAfter != null) {
           upcomingEventText = AppLocalizations.of(context)!.dayAfterTomorrowIs(resultDayAfter);
           buttonLabel = AppLocalizations.of(context)!.actionAiMenuDayAfterTomorrow;
           targetActionDate = dayAfter;
        }
      }
    }

    final List<Widget> eventWidgets = [];
    if (holidays != null) {
        eventWidgets.add(Text(
          holidays.name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEF4444), // Red-500
          ),
        ));
    }
    if (foodEvent != null) {
      if (eventWidgets.isNotEmpty) eventWidgets.add(const SizedBox(height: 2));
      eventWidgets.add(Text(
        foodEvent,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD97706), // Amber-600
        ),
      ));
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Default if not provided
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Row: Date and Today's Events
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left: Date and Relative Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Color(0xFF292524), fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: '${date.year}年',
                          style: const TextStyle(fontSize: 14),
                        ),
                        TextSpan(
                          text: ' ${date.month}月${date.day}日 (${DateFormat('E', 'ja').format(date)})',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  if (relativeDate != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      relativeDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF78716C),
                      ),
                    ),
                  ],
                ],
              ),
              
              // Right: Events (stacked vertical)
              if (eventWidgets.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: eventWidgets,
                ),
            ],
          ),

          // Sub-Row: Upcoming Events & AI Button (Home Only)
          if (upcomingEventText != null && onAiButtonTap != null) ...[
             const SizedBox(height: 8),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Expanded(
                   child: Row(
                     children: [
                       const Icon(Icons.info_outline, size: 16, color: AppColors.stoxPrimary),
                       const SizedBox(width: 4),
                       Flexible(
                         child: Text(
                           upcomingEventText,
                           style: const TextStyle(
                             fontSize: 12, 
                             fontWeight: FontWeight.bold,
                             color: AppColors.stoxText
                           ),
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                     ],
                   ),
                 ),
                 AiSuggestionButton.small(
                   onTap: () => onAiButtonTap!(targetActionDate!),
                   label: buttonLabel,
                 ),
               ],
             )
          ]
        ],
      ),
    );
  }

  String? _getEventName(holiday_jp.Holiday? holiday, String? foodEvent) {
    if (holiday != null) return holiday.name;
    if (foodEvent != null) return foodEvent;
    return null;
  }
}
