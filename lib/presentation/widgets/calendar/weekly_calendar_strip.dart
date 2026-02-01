import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;
import '../../../config/app_colors.dart';

class WeeklyCalendarStrip extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final ScrollController? scrollController;

  const WeeklyCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.scrollController,
  });

  @override
  State<WeeklyCalendarStrip> createState() => _WeeklyCalendarStripState();
}

class _WeeklyCalendarStripState extends State<WeeklyCalendarStrip> {
  late ScrollController _internalScrollController;
  final int _dayRange = 30; // +/- range or total range. Implementation details below.

  @override
  void initState() {
    super.initState();
    _internalScrollController = widget.scrollController ?? ScrollController();
    
    // Auto-scroll to selected date on init if needed, similar to original implementation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_internalScrollController.hasClients) {
        // basic centering logic could go here
      }
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _internalScrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logic from menu_plan_screen.dart _buildDateStrip
    final today = DateTime.now();
    // Generating dates: 5 days before today, up to 30 days total
    final dates = List.generate(_dayRange, (index) => today.subtract(const Duration(days: 5)).add(Duration(days: index)));

    return Container(
      height: 90,
      color: const Color(0xFFFFF7ED).withOpacity(0.3), // slight tint
      child: ListView.builder(
        controller: _internalScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = widget.selectedDate != null && DateUtils.isSameDay(date, widget.selectedDate!);
          final isToday = DateUtils.isSameDay(date, today);
          final isHoliday = holiday_jp.isHoliday(date);
          
          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 50,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.stoxPrimary : (isToday ? Colors.white : Colors.transparent),
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected ? Border.all(color: AppColors.stoxPrimary) : null,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.stoxPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E('ja').format(date),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (date.weekday == 7 ? Colors.red : (date.weekday == 6 ? Colors.blue : const Color(0xFF78716C))),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (isHoliday || date.weekday == 7 ? Colors.red : (date.weekday == 6 ? Colors.blue : const Color(0xFF292524))),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
