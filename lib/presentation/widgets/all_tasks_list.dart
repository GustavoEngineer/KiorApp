import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/functions/dismissible_task_card.dart';

class AllTasksList extends ConsumerWidget {
  final List<Task> tasks;
  const AllTasksList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Text(
                    'No hay tareas para el filtro aplicado.',
                    style: textTheme.bodyLarge,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final previousTask = index > 0 ? tasks[index - 1] : null;

                    // Determinar si se debe mostrar el encabezado de la fecha
                    final bool showHeader =
                        index == 0 ||
                        !DateUtils.isSameDay(
                          task.dueDate,
                          previousTask?.dueDate,
                        );

                    if (showHeader) {
                      final date = task.dueDate;
                      Widget header;
                      if (date == null) {
                        header = Text(
                          'Sin Fecha',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        );
                      } else {
                        String dayOfWeekAndNumber = DateFormat(
                          'EEEE d',
                          'es_ES',
                        ).format(date);
                        dayOfWeekAndNumber =
                            dayOfWeekAndNumber[0].toUpperCase() +
                            dayOfWeekAndNumber.substring(1);
                        String year = DateFormat('yyyy', 'es_ES').format(date);
                        header = Row(
                          children: [
                            Text(
                              dayOfWeekAndNumber,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              year,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                            child: header,
                          ),
                          DismissibleTaskCard(task: task, showDate: false),
                        ],
                      );
                    }
                    return DismissibleTaskCard(task: task, showDate: false);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                ),
        ),
      ],
    );
  }
}
