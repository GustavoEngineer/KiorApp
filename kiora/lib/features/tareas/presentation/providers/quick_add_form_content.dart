import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';

final quickAddFormProvider =
    StateNotifierProvider<QuickAddFormNotifier, QuickAddFormState>((ref) {
      return QuickAddFormNotifier();
    });

class QuickAddFormState {
  final String titulo;
  final String categoria;
  final DateTime? fechaLimite;
  final double duracionEstimada;
  final bool isDuracionEnHoras;

  QuickAddFormState({
    this.titulo = '',
    this.categoria = '',
    this.fechaLimite,
    this.duracionEstimada = 1.0,
    this.isDuracionEnHoras = true,
  });

  QuickAddFormState copyWith({
    String? titulo,
    String? categoria,
    DateTime? fechaLimite,
    double? duracionEstimada,
    bool? isDuracionEnHoras,
  }) {
    return QuickAddFormState(
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      duracionEstimada: duracionEstimada ?? this.duracionEstimada,
      isDuracionEnHoras: isDuracionEnHoras ?? this.isDuracionEnHoras,
    );
  }
}

class QuickAddFormNotifier extends StateNotifier<QuickAddFormState> {
  QuickAddFormNotifier() : super(QuickAddFormState());

  void updateTitulo(String titulo) {
    state = state.copyWith(titulo: titulo);
  }

  void updateCategoria(String categoria) {
    state = state.copyWith(categoria: categoria);
  }

  void updateFechaLimite(DateTime fecha) {
    state = state.copyWith(fechaLimite: fecha);
  }

  void updateDuracionEstimada(double duracion) {
    state = state.copyWith(duracionEstimada: duracion);
  }

  void resetForm() {
    state = QuickAddFormState();
  }

  void toggleUnidadTiempo() {
    final newValue = !state.isDuracionEnHoras;
    // Ajustar la duración si es necesario
    double newDuracion = state.duracionEstimada;
    if (newValue && newDuracion > 24) {
      // Si cambia a horas y excede 24
      newDuracion = 24;
    } else if (!newValue && newDuracion > 31) {
      // Si cambia a días y excede 31
      newDuracion = 31;
    }
    state = state.copyWith(
      isDuracionEnHoras: newValue,
      duracionEstimada: newDuracion,
    );
  }
}

class QuickAddFormContent extends ConsumerStatefulWidget {
  const QuickAddFormContent({super.key});

  @override
  QuickAddFormContentState createState() => QuickAddFormContentState();
}

class QuickAddFormContentState extends ConsumerState<QuickAddFormContent> {
  bool isSelectingDate = false;
  final titleFocus = FocusNode();
  final categoryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    titleFocus.addListener(_onFocusChange);
    categoryFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    titleFocus.removeListener(_onFocusChange);
    categoryFocus.removeListener(_onFocusChange);
    titleFocus.dispose();
    categoryFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        // El cambio de foco actualizará el estado
      });
    }
  }

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título
            TextField(
              focusNode: titleFocus,
              decoration: InputDecoration(
                labelText: 'Título',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: KioraColors.accentKiora,
                    width: 2,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelStyle: TextStyle(
                  color: titleFocus.hasFocus
                      ? KioraColors.accentKiora
                      : Colors.grey.shade600,
                ),
                floatingLabelStyle: TextStyle(
                  color: titleFocus.hasFocus
                      ? KioraColors.accentKiora
                      : Colors.black,
                ),
              ),
              onChanged: (value) =>
                  ref.read(quickAddFormProvider.notifier).updateTitulo(value),
            ),
            const SizedBox(height: 32),
            // Campo de categoría
            TextField(
              focusNode: categoryFocus,
              decoration: InputDecoration(
                labelText: 'Categoría',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: KioraColors.accentKiora,
                    width: 2,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelStyle: TextStyle(
                  color: categoryFocus.hasFocus
                      ? KioraColors.accentKiora
                      : Colors.grey.shade600,
                ),
                floatingLabelStyle: TextStyle(
                  color: categoryFocus.hasFocus
                      ? KioraColors.accentKiora
                      : Colors.black,
                ),
              ),
              onChanged: (value) => ref
                  .read(quickAddFormProvider.notifier)
                  .updateCategoria(value),
            ),
            const SizedBox(height: 32),
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
                              initialItem:
                                  currentDate.month -
                                  now.month, // Ajustar al mes seleccionado
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
                              // Si estamos en el mes actual, asegurarnos de que el día sea válido
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
                              // Después de un breve retraso, desactivar el estado de selección
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() {
                                    isSelectingDate = false;
                                  });
                                }
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount:
                                  13 -
                                  now.month, // Solo meses desde el actual hasta fin de año
                              builder: (context, index) {
                                final month = now.month + index;
                                return Center(
                                  child: Text(
                                    DateFormat(
                                      'MMM',
                                    ).format(DateTime(currentDate.year, month)),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
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
                                  ? currentDate.day -
                                        now
                                            .day // Ajustar al día seleccionado en el mes actual
                                  : currentDate.day -
                                        1, // Ajustar al día seleccionado en otros meses
                            ),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                isSelectingDate = true;
                              });
                              final actualDay = currentDate.month == now.month
                                  ? now.day +
                                        index // En el mes actual, empezar desde hoy
                                  : index +
                                        1; // En otros meses, mostrar todos los días
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
                              // Después de un breve retraso, desactivar el estado de selección
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
                                  ? daysInMonth -
                                        now.day +
                                        1 // En el mes actual, solo días desde hoy
                                  : daysInMonth, // En otros meses, todos los días
                              builder: (context, index) {
                                final day = currentDate.month == now.month
                                    ? now.day +
                                          index // En el mes actual, empezar desde hoy
                                    : index +
                                          1; // En otros meses, mostrar todos los días
                                return Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: currentDate.day == day
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duración: ${formState.duracionEstimada.toStringAsFixed(1)} ${formState.isDuracionEnHoras ? "hrs" : "días"}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(quickAddFormProvider.notifier)
                          .toggleUnidadTiempo(),
                      child: Text(
                        formState.isDuracionEnHoras
                            ? "Cambiar a días"
                            : "Cambiar a horas",
                        style: TextStyle(color: KioraColors.accentKiora),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: formState.duracionEstimada,
                  min: 0.5,
                  max: formState.isDuracionEnHoras ? 24.0 : 31.0,
                  divisions: formState.isDuracionEnHoras
                      ? 47
                      : 61, // Para incrementos de 0.5
                  activeColor: KioraColors.accentKiora,
                  label:
                      '${formState.duracionEstimada.toStringAsFixed(1)} ${formState.isDuracionEnHoras ? "hrs" : "días"}',
                  onChanged: (value) => ref
                      .read(quickAddFormProvider.notifier)
                      .updateDuracionEstimada(value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Botón de cancelar
            Center(
              child: SizedBox(
                width: 200, // Hacer el botón más largo
                child: TextButton(
                  onPressed: () {
                    ref.read(quickAddFormProvider.notifier).resetForm();
                    ref.read(quickAddFormVisibilityProvider.notifier).hide();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Más redondeado
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
