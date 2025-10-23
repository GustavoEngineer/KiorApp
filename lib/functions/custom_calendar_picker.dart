import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kiorapp/presentation/screens/home_screen.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart' as new_task;

/// Muestra un selector de calendario personalizado como un diálogo desplegable.
///
/// [context]: El BuildContext actual.
/// [initialDate]: La fecha inicialmente seleccionada en el calendario.
/// [focusedDate]: El mes que se mostrará inicialmente.
/// [allowPastDates]: Si es `true`, permite seleccionar fechas pasadas. Útil para filtros.
Future<DateTime?> showCustomCalendarPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime focusedDate,
  bool allowPastDates = false,
}) {
  return showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.topCenter,
        child: _CustomCalendar(
          selectedDate: initialDate,
          focusedDate: focusedDate,
          allowPastDates: allowPastDates,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuint),
            ),
        child: child,
      );
    },
  );
}

/// Muestra el calendario para crear una nueva tarea en la fecha seleccionada.
Future<void> showCalendarAndCreateTask({
  required BuildContext context,
  required WidgetRef ref,
  required DateTime initialDate,
  required DateTime focusedDate,
}) async {
  final selectedDate = await showCustomCalendarPicker(
    context: context,
    initialDate: initialDate,
    focusedDate: focusedDate,
    allowPastDates: false,
  );

  if (selectedDate != null && context.mounted) {
    // selectedDate es UTC
    // Convertimos la fecha UTC a una fecha local para evitar problemas de zona horaria.
    final localSelectedDate = DateUtils.dateOnly(selectedDate);
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            new_task.NewTaskScreen(selectedDate: localSelectedDate),
      ),
    );
    if (result == true) {
      ref.read(taskProvider.notifier).loadTasks();
    }
  }
}

/// Muestra el calendario para seleccionar una fecha para los filtros.
Future<void> showCalendarForFilter({
  required BuildContext context,
  required WidgetRef ref,
  required bool isStartDate,
}) async {
  final now = DateTime.now();
  final currentFilters = ref.read(filterProvider);
  final initialDate =
      (isStartDate ? currentFilters.startDate : currentFilters.endDate) ?? now;

  final pickedDate = await showCustomCalendarPicker(
    context: context,
    initialDate: initialDate,
    focusedDate: initialDate,
    allowPastDates: true,
  );

  if (pickedDate != null) {
    final notifier = ref.read(filterProvider.notifier);
    notifier.state = isStartDate
        ? notifier.state.copyWith(startDate: pickedDate)
        : notifier.state.copyWith(endDate: pickedDate);
  }
}

/// Widget interno que renderiza el calendario.
/// Reemplaza al antiguo FullCalendarView.
class _CustomCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final bool allowPastDates;

  const _CustomCalendar({
    required this.selectedDate,
    required this.focusedDate,
    this.allowPastDates = false,
  });

  @override
  State<_CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<_CustomCalendar> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
    _focusedDay = widget.focusedDate;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  locale: 'es_ES',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  enabledDayPredicate: (day) {
                    if (widget.allowPastDates) {
                      return true;
                    }
                    final today = DateUtils.dateOnly(DateTime.now());
                    return !day.isBefore(today);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    Navigator.of(context).pop(selectedDay);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle:
                        textTheme.titleLarge?.copyWith(color: Colors.white) ??
                        const TextStyle(color: Colors.white),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Colors.white),
                    disabledTextStyle: TextStyle(color: Colors.grey[400]),
                    selectedTextStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    todayTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = DateFormat.E('es_ES').format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
