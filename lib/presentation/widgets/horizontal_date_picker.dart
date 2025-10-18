import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const HorizontalDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.initialDate,
  });

  @override
  State<HorizontalDatePicker> createState() => HorizontalDatePickerState();
}

class HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late ScrollController _scrollController;
  final List<DateTime> _dates = [];
  final int _daysInPast = 30;

  @override
  void initState() {
    super.initState();
    _generateDates();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToDate(DateTime.now(), animate: false);
    });
  }

  void scrollToDate(DateTime date, {bool animate = true}) {
    final targetDate = DateTime(date.year, date.month, date.day);
    final index = _dates.indexWhere(
      (d) =>
          d.year == targetDate.year &&
          d.month == targetDate.month &&
          d.day == targetDate.day,
    );

    if (index == -1 || !mounted) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final offset = (index * 70.0) - (screenWidth / 2) + 35.0;

    if (_scrollController.hasClients) {
      if (animate) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.jumpTo(offset);
      }
    }
  }

  void _generateDates() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _daysInPast));
    final endDate = now.add(const Duration(days: 90));
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      _dates.add(startDate.add(Duration(days: i)));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 80,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected =
              date.year == widget.selectedDate.year &&
              date.month == widget.selectedDate.month &&
              date.day == widget.selectedDate.day;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final isToday =
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : (isToday ? Colors.grey.shade200 : Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E('es_ES').format(date).toUpperCase(),
                    style: textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : textTheme.bodySmall?.color,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: textTheme.titleLarge?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : textTheme.titleLarge?.color,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
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