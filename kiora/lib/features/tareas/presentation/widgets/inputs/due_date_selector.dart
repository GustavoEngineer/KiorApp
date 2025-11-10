import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kiora/features/tareas/presentation/widgets/quick_add_form_content.dart';

class DueDateSelector extends ConsumerStatefulWidget {
  const DueDateSelector({super.key});

  @override
  DueDateSelectorState createState() => DueDateSelectorState();
}

class DueDateSelectorState extends ConsumerState<DueDateSelector> {
  bool isSelectingDate = false;

  int getDaysInMonth(int month, int year) {
    if (month == 2) {
      if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        return 29;
      }
      return 28;
    }
    if ([4, 6, 9, 11].contains(month)) {
      return 30;
    }
    return 31;
  }

  bool isDateSelectable(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(DateTime(now.year, now.month, now.day - 1));
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(quickAddFormProvider);
    final now = DateTime.now();

    // Inicializar la fecha si no está establecida o es inválida
    if (formState.fechaLimite == null ||
        !isDateSelectable(formState.fechaLimite!)) {
      Future.microtask(() {
        ref
            .read(quickAddFormProvider.notifier)
            .updateFechaLimite(DateTime(now.year, now.month, now.day));
      });
    }

    final currentDate =
        formState.fechaLimite ?? DateTime(now.year, now.month, now.day);
    final daysInMonth = getDaysInMonth(currentDate.month, currentDate.year);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de fecha límite
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha límite',
                    style: TextStyle(
                      color: isSelectingDate
                          ? KioraColors.accentKiora
                          : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelectingDate
                              ? KioraColors.accentKiora
                              : Colors.black,
                          width: isSelectingDate ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Selector de mes
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(
                              initialItem: currentDate.month - now.month,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                isSelectingDate = true;
                              });
                              final newMonth = now.month + index;
                              final daysInNewMonth = getDaysInMonth(
                                newMonth,
                                currentDate.year,
                              );
                              int newDay;
                              if (newMonth == now.month) {
                                newDay = currentDate.day < now.day
                                    ? now.day
                                    : currentDate.day;
                              } else {
                                newDay = currentDate.day > daysInNewMonth
                                    ? daysInNewMonth
                                    : currentDate.day;
                              }
                              final newDate = DateTime(
                                currentDate.year,
                                newMonth,
                                newDay,
                              );
                              if (isDateSelectable(newDate)) {
                                ref
                                    .read(quickAddFormProvider.notifier)
                                    .updateFechaLimite(newDate);
                              }
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() {
                                    isSelectingDate = false;
                                  });
                                }
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 13 - now.month,
                              builder: (context, index) {
                                final month = now.month + index;
                                return Center(
                                  child: Text(
                                    DateFormat(
                                      'MMMM',
                                      'es',
                                    ).format(DateTime(currentDate.year, month)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: month == currentDate.month
                                          ? KioraColors.accentKiora
                                          : Colors.black87,
                                      fontWeight: month == currentDate.month
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Selector de día
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            controller: FixedExtentScrollController(
                              initialItem: currentDate.month == now.month
                                  ? currentDate.day - now.day
                                  : currentDate.day - 1,
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                isSelectingDate = true;
                              });
                              final actualDay = currentDate.month == now.month
                                  ? now.day + index
                                  : index + 1;
                              final newDate = DateTime(
                                currentDate.year,
                                currentDate.month,
                                actualDay,
                              );
                              if (isDateSelectable(newDate)) {
                                ref
                                    .read(quickAddFormProvider.notifier)
                                    .updateFechaLimite(newDate);
                              }
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() {
                                    isSelectingDate = false;
                                  });
                                }
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: currentDate.month == now.month
                                  ? daysInMonth - now.day + 1
                                  : daysInMonth,
                              builder: (context, index) {
                                final day = currentDate.month == now.month
                                    ? now.day + index
                                    : index + 1;
                                return Center(
                                  child: Text(
                                    day.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: day == currentDate.day
                                          ? KioraColors.accentKiora
                                          : Colors.black87,
                                      fontWeight: day == currentDate.day
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Campo de duración
            Column(
              // ... resto del código de duración ...
            ),
            const SizedBox(height: 24),
            // Botón dinámico
            Center(
              // ... resto del código del botón ...
            ),
          ],
        ),
      ),
    );
  }
}
