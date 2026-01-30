import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;
import '../../../config/app_colors.dart';

class MonthlyCalendarView extends StatelessWidget {
  final DateTime? selectedDate;
  final DateTime focusedMonth;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onPageChanged;

  const MonthlyCalendarView({
    super.key,
    required this.selectedDate,
    required this.focusedMonth,
    required this.onDateSelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Logic from recipe_schedule_screen.dart _buildCalendar
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Calendar Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton( // Prev Month
                 onPressed: () {
                   onPageChanged(DateTime(focusedMonth.year, focusedMonth.month - 1));
                 },
                 icon: const Icon(Icons.chevron_left),
              ),
              Text(
                DateFormat('yyyy年M月').format(focusedMonth),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton( // Next Month
                 onPressed: () {
                   onPageChanged(DateTime(focusedMonth.year, focusedMonth.month + 1));
                 },
                 icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Days of Week
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].asMap().entries.map((entry) {
              final idx = entry.key;
              final label = entry.value;
              Color color = AppColors.stoxText;
              if (idx == 0) color = Colors.red; // Sunday
              if (idx == 6) color = Colors.blue; // Saturday
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          
          // Days Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final daysInMonth = DateUtils.getDaysInMonth(focusedMonth.year, focusedMonth.month);
              final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
              final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
              
              final totalCells = firstWeekday + daysInMonth;
              final totalRows = (totalCells / 7).ceil();
              
              return Column(
                children: List.generate(totalRows, (row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (col) {
                      final dayIndex = row * 7 + col;
                      if (dayIndex < firstWeekday || dayIndex >= totalCells) {
                        return const SizedBox(width: 40, height: 40);
                      }
                      
                      final day = dayIndex - firstWeekday + 1;
                      final date = DateTime(focusedMonth.year, focusedMonth.month, day);
                      final isSelected = selectedDate != null && DateUtils.isSameDay(date, selectedDate!);
                      final isHoliday = holiday_jp.isHoliday(date);
                      
                      return GestureDetector(
                        onTap: () {
                           onDateSelected(date);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.stoxPrimary : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: isSelected 
                                ? [BoxShadow(color: AppColors.stoxPrimary.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))]
                                : null,
                          ),
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color: isSelected 
                                ? Colors.white 
                                : (isHoliday || col == 0 ? Colors.red : (col == 6 ? Colors.blue : AppColors.stoxText)),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              );
            }
          ),
        ],
      ),
    );
  }
}
