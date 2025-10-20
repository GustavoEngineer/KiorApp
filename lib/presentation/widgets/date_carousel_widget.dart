import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCarouselWidget extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged;

  const DateCarouselWidget({
    super.key,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  State<DateCarouselWidget> createState() => DateCarouselWidgetState();
}

class DateCarouselWidgetState extends State<DateCarouselWidget> {
  late final PageController _pageController;
  late DateTime _selectedDate;
  final List<DateTime> _dates = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateDates();
    _pageController = PageController(
      initialPage: _dates.indexWhere(
        (date) => DateUtils.isSameDay(date, _selectedDate),
      ),
      viewportFraction: 1 / 7,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(_selectedDate);
      widget.onMonthChanged(_selectedDate);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _generateDates() {
    final today = DateTime.now();
    // Generamos fechas para un año antes y un año después de hoy.
    final startDate = DateTime(today.year - 1, today.month, today.day);
    final endDate = DateTime(today.year + 1, today.month, today.day);
    final days = endDate.difference(startDate).inDays;
    for (int i = 0; i <= days; i++) {
      _dates.add(startDate.add(Duration(days: i)));
    }
  }

  void jumpToToday() {
    final today = DateTime.now();
    final index = _dates.indexWhere(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
    if (index != -1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void jumpToPreviousMonth() {
    final currentPage =
        _pageController.page?.round() ??
        _dates.indexWhere((d) => DateUtils.isSameDay(d, _selectedDate));
    if (currentPage == -1) return;

    final currentVisibleDate = _dates[currentPage];
    final targetDate = DateTime(
      currentVisibleDate.year,
      currentVisibleDate.month - 1,
      1,
    );

    final targetIndex = _dates.indexWhere(
      (date) => date.year == targetDate.year && date.month == targetDate.month,
    );

    if (targetIndex != -1) {
      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void jumpToNextMonth() {
    final currentPage =
        _pageController.page?.round() ??
        _dates.indexWhere((d) => DateUtils.isSameDay(d, _selectedDate));
    if (currentPage == -1) return;

    final currentVisibleDate = _dates[currentPage];
    final targetDate = DateTime(
      currentVisibleDate.year,
      currentVisibleDate.month + 1,
      1,
    );
    final targetIndex = _dates.indexWhere(
      (date) => date.year == targetDate.year && date.month == targetDate.month,
    );
    if (targetIndex != -1) {
      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 90,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _dates.length,
            onPageChanged: (index) {
              widget.onMonthChanged(_dates[index]);
            },
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isSelected = DateUtils.isSameDay(date, _selectedDate);
              final today = DateTime.now();
              final isToday = DateUtils.isSameDay(date, today);

              final textColor = isSelected ? Colors.white : Colors.black;

              Color? backgroundColor;
              if (isSelected) {
                backgroundColor = Theme.of(context).primaryColor;
              } else if (isToday) {
                backgroundColor = Colors.grey.shade300;
              } else {
                backgroundColor = Colors.transparent;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                  widget.onDateSelected(date);
                  widget.onMonthChanged(date);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
