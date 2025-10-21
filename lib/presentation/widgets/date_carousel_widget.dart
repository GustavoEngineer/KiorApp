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
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  DateTime _currentWeekSunday = DateUtils.dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    _currentWeekSunday = _getSundayOfWeek(_selectedDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(_selectedDate);
      widget.onMonthChanged(_selectedDate);
    });
  }

  /// Devuelve el domingo de la semana que contiene la [date] dada.
  DateTime _getSundayOfWeek(DateTime date) {
    // En Dart, weekday es 1 para Lunes y 7 para Domingo.
    // Hacemos `date.weekday % 7` para obtener un offset de 0 para Domingo.
    return date.subtract(Duration(days: date.weekday % 7));
  }

  /// Genera las 7 fechas para una página/semana específica.
  List<DateTime> _getDatesForCurrentWeek() {
    return List.generate(7, (i) => _currentWeekSunday.add(Duration(days: i)));
  }

  void jumpToToday() {
    // Selecciona el día de hoy
    _onDateTapped(DateUtils.dateOnly(DateTime.now()));
    setState(() {
      _currentWeekSunday = _getSundayOfWeek(DateUtils.dateOnly(DateTime.now()));
    });
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
    widget.onMonthChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ..._getDatesForCurrentWeek()
              .map(
                (date) => _DateCell(
                  date: date,
                  isSelected: DateUtils.isSameDay(date, _selectedDate),
                  onTap: () => _onDateTapped(date),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateCell({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final primaryColor = Theme.of(context).primaryColor;

    const backgroundColor = Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        padding: const EdgeInsets.fromLTRB(8.0, 7.0, 8.0, 7.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // Usamos 'es' para asegurar que tome el formato español.
              DateFormat('EEE', 'es').format(date),
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 9,
                  child: isToday && !isSelected
                      ? Column(
                          children: [
                            const SizedBox(height: 4),
                            Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
