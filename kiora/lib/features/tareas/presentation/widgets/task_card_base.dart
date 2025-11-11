import 'package:flutter/material.dart';

/// Un card básico para mostrar una tarea registrada.
///
/// Uso:
/// ```dart
/// TaskCardBase(
///   title: 'Comprar víveres',
///   description: 'Leche, pan, huevos',
///   dueDate: DateTime.now().add(Duration(days: 1)),
///   completed: false,
///   onEdit: () {},
///   onDelete: () {},
/// )
/// ```
class TaskCardBase extends StatelessWidget {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool completed;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCardBase({
    Key? key,
    required this.title,
    this.description,
    this.dueDate,
    this.completed = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    // Formato simple: dd/MM/yyyy
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado (check o circle)
              Container(
                margin: const EdgeInsets.only(right: 12, top: 4),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: completed
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: completed
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                  ),
                ),
                child: completed
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Icon(
                        Icons.radio_button_unchecked,
                        color: theme.iconTheme.color,
                        size: 20,
                      ),
              ),

              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        // Acciones rápidas
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit?.call();
                            } else if (value == 'delete') {
                              onDelete?.call();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Editar'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (description != null && description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 4),
                        child: Text(
                          description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Fecha de vencimiento
                    if (dueDate != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                _formatDate(dueDate!),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
