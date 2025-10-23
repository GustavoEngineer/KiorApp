import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/data/models/tag.dart';
import 'package:kiorapp/functions/dismissible_task_card.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart'
    as new_task_screen;
import 'package:kiorapp/presentation/screens/tags_screen.dart';
import 'package:kiorapp/presentation/widgets/all_tasks_list.dart';
import 'package:kiorapp/functions/custom_calendar_picker.dart';
import 'package:kiorapp/presentation/widgets/date_carousel_widget.dart';
import 'package:kiorapp/presentation/widgets/tag_chip.dart';

// Estado para los filtros
class FilterState {
  final int? tagId;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterState({this.tagId, this.startDate, this.endDate});

  FilterState copyWith({
    int? tagId,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return FilterState(
      tagId: tagId ?? this.tagId,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
    );
  }
}

final filterProvider = StateProvider<FilterState>((ref) => FilterState());

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<DateCarouselWidgetState> _carouselKey =
      GlobalKey<DateCarouselWidgetState>();
  DateTime _selectedDate = DateTime.now();
  DateTime _displayedMonth = DateTime.now();
  bool _isDailyViewSelected = true;
  bool _isFabExpanded = false;
  int _selectedDailyCategory = 0; // 0: Tareas, 1: Hábitos, 2: Recordatorios

  // Para la animación del delineado
  final List<GlobalKey> _categoryKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  double _underlineLeft = 0.0;
  double _underlineWidth = 0.0;
  final List<String> _categories = ['Tareas', 'Hábitos', 'Recordatorios'];
  final List<IconData> _categoryIcons = [
    Icons.checklist_rtl,
    Icons.sync,
    Icons.notifications_none,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateUnderline(animate: false),
    );
  }

  void _updateUnderline({bool animate = true}) {
    if (_categoryKeys[_selectedDailyCategory].currentContext != null) {
      final RenderBox renderBox =
          _categoryKeys[_selectedDailyCategory].currentContext!
                  .findRenderObject()
              as RenderBox;
      final newLeft = renderBox.localToGlobal(Offset.zero).dx;
      final newWidth = renderBox.size.width;
      // Obtenemos la posición del padre (el Stack) para calcular la posición relativa.
      final parentRenderBox = context.findRenderObject() as RenderBox;
      final parentOffset = parentRenderBox.localToGlobal(Offset.zero);

      setState(() {
        _underlineLeft = newLeft - parentOffset.dx;
        _underlineWidth = newWidth;
      });
    }
  }

  void _showFilterSheet() {
    final allTags = ref.read(tagProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              builder: (_, scrollController) {
                // Leemos el estado del filtro aquí para que se actualice en cada rebuild
                final currentFilters = ref.watch(filterProvider);
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filtros',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(filterProvider.notifier).state =
                                  FilterState();
                              setState(() {}); // Actualiza la UI del modal
                            },
                            child: const Text('Limpiar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Categorías',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: allTags.map((tag) {
                          return TagChip(
                            tag: tag,
                            isSelected: currentFilters.tagId == tag.id,
                            onSelected: (isSelected) {
                              final notifier = ref.read(
                                filterProvider.notifier,
                              );
                              setState(() {
                                if (notifier.state.tagId == tag.id) {
                                  notifier.state = notifier.state.copyWith(
                                    tagId: null,
                                  );
                                } else {
                                  notifier.state = notifier.state.copyWith(
                                    tagId: tag.id,
                                  );
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Fecha',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateFilterChip(
                              context: context,
                              label: 'Desde',
                              date: ref.watch(filterProvider).startDate,
                              onTap: () async {
                                await showCalendarForFilter(
                                  context: context,
                                  ref: ref,
                                  isStartDate: true,
                                );
                                setState(() {});
                              },
                              onClear: () {
                                ref.read(filterProvider.notifier).state = ref
                                    .read(filterProvider.notifier)
                                    .state
                                    .copyWith(clearStartDate: true);
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateFilterChip(
                              context: context,
                              label: 'Hasta',
                              date: ref.watch(filterProvider).endDate,
                              onTap: () async {
                                await showCalendarForFilter(
                                  context: context,
                                  ref: ref,
                                  isStartDate: false,
                                );
                                setState(() {});
                              },
                              onClear: () {
                                ref.read(filterProvider.notifier).state = ref
                                    .read(filterProvider.notifier)
                                    .state
                                    .copyWith(clearEndDate: true);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Aplicar Filtros'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDateFilterChip({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final hasValue = date != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    hasValue
                        ? DateFormat('d MMM yyyy', 'es_ES').format(date)
                        : 'Seleccionar',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: hasValue ? Colors.black : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (hasValue)
              InkWell(
                onTap: onClear,
                child: const Icon(Icons.close, size: 18, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskProvider);
    final filters = ref.watch(filterProvider);
    final textTheme = Theme.of(context).textTheme;

    final filteredAndSortedTasks = _getFilteredAndSortedTasks(
      allTasks,
      filters,
    );

    final sortedTasks = List<Task>.from(filteredAndSortedTasks)
      ..sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });

    return Scaffold(
      appBar: AppBar(
        title: _isDailyViewSelected
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCalendarAndCreateTask(
                        context: context,
                        ref: ref,
                        initialDate: _displayedMonth,
                        focusedDate: _displayedMonth,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: textTheme.titleLarge?.fontSize,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat(
                            'MMMM, yyyy',
                            'es_ES',
                          ).format(_displayedMonth),
                          style: textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : null, // Se quita el título para la vista "Ver todo"
        centerTitle: true,
        actions: _isDailyViewSelected
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterSheet,
                ),
              ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0, // Mantenemos el padding horizontal
              vertical: 20.0, // Aumentamos el padding vertical
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double horizontalPadding = 4.0 * 2;
                final double switchWidth =
                    (constraints.maxWidth - horizontalPadding) / 2;
                return Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: _isDailyViewSelected
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: switchWidth,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildSwitchOption(
                            context,
                            'Tareas del día',
                            _isDailyViewSelected,
                            () {
                              setState(() => _isDailyViewSelected = true);
                            },
                          ),
                          _buildSwitchOption(
                            context,
                            'Ver todo',
                            !_isDailyViewSelected,
                            () {
                              setState(() => _isDailyViewSelected = false);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _isDailyViewSelected
                ? _buildDailyView(allTasks)
                : AllTasksList(tasks: sortedTasks),
          ),
        ],
      ),
      floatingActionButton: _buildFabMenu(context),
    );
  }

  List<Task> _getFilteredAndSortedTasks(List<Task> tasks, FilterState filters) {
    List<Task> filtered = List.from(tasks);

    // Filtrar por tag
    if (filters.tagId != null) {
      filtered = filtered
          .where((task) => task.tagIds.contains(filters.tagId))
          .toList();
    }

    // Filtrar por fecha
    if (filters.startDate != null) {
      filtered = filtered.where((task) {
        if (task.dueDate == null) return false;
        final taskDate = DateUtils.dateOnly(task.dueDate!);
        final startDate = DateUtils.dateOnly(filters.startDate!);
        // Si hay fecha de fin, es un rango. Si no, es un día específico.
        if (filters.endDate != null) {
          final endDate = DateUtils.dateOnly(filters.endDate!);
          return (taskDate.isAfter(startDate) ||
                  taskDate.isAtSameMomentAs(startDate)) &&
              (taskDate.isBefore(endDate) ||
                  taskDate.isAtSameMomentAs(endDate));
        } else {
          return taskDate.isAtSameMomentAs(startDate);
        }
      }).toList();
    }
    return filtered;
  }

  Widget _buildFabMenu(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.end, // Corregido: Se vuelve a añadir
          children: <Widget>[
            // Botón Nueva Tarea
            _buildAnimatedMiniFab(
              isExpanded: _isFabExpanded,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              child: _buildMiniFab(
                context: context,
                icon: Icons.assignment_turned_in,
                label: 'Nueva Tarea',
                onPressed: () async {
                  setState(() => _isFabExpanded = false);
                  await Navigator.of(context).push(
                    MaterialPageRoute<bool>(
                      builder: (context) => new_task_screen.NewTaskScreen(
                        selectedDate: _isDailyViewSelected
                            ? _selectedDate
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Botón Nueva Etiqueta
            _buildAnimatedMiniFab(
              isExpanded: _isFabExpanded,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: _buildMiniFab(
                context: context,
                icon: Icons.local_offer,
                label: 'Nueva Etiqueta',
                onPressed: () {
                  setState(() => _isFabExpanded = false);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TagsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            FloatingActionButton(
              heroTag: 'mainFab',
              onPressed: () {
                setState(() {
                  _isFabExpanded = !_isFabExpanded;
                });
              },
              child: Icon(
                _isFabExpanded ? Icons.close : Icons.add,
              ), // Cambiado a un ícono de +/x
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedMiniFab({
    required bool isExpanded,
    required Duration duration,
    required Curve curve,
    required Widget child,
  }) {
    return AnimatedOpacity(
      opacity: isExpanded ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        transform: Matrix4.translationValues(
          isExpanded ? 0 : 100, // Desliza desde la derecha
          0,
          0,
        ),
        child: child,
      ),
    );
  }

  Widget _buildMiniFab({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
      heroTag: null,
    );
  }

  Widget _buildDailyView(List<Task> allTasks) {
    final tasks = allTasks.where((task) {
      return task.dueDate != null &&
          DateUtils.isSameDay(task.dueDate, _selectedDate);
    }).toList();

    return Column(
      children: [
        DateCarouselWidget(
          key: _carouselKey,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
          onMonthChanged: (date) {
            setState(() {
              _displayedMonth = date;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 16),
          child: Stack(
            children: [
              // Línea gris de base que ocupa todo el ancho
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 1, color: Colors.grey[300]),
              ),
              // Fila de categorías con su padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < _categories.length - 1 ? 24.0 : 0,
                      ),
                      child: _buildCategoryOption(
                        _categories[index],
                        _categoryIcons[index],
                        index,
                      ),
                    );
                  }),
                ),
              ),
              // Delineado azul animado
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _underlineLeft,
                bottom: 0,
                child: Container(
                  height: 2,
                  width: _underlineWidth,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildDailyCategoryView(tasks)),
      ],
    );
  }

  Widget _buildDailyCategoryView(List<Task> tasks) {
    switch (_selectedDailyCategory) {
      case 0: // Tareas
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8), // Espacio sobre la lista
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return DismissibleTaskCard(task: task);
          },
        );
      case 1: // Hábitos
        return const Center(child: Text('Próximamente: Hábitos'));
      case 2: // Recordatorios
        return const Center(child: Text('Próximamente: Recordatorios'));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryOption(String title, IconData icon, int index) {
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _selectedDailyCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedDailyCategory = index);
        _updateUnderline();
      },
      child: Container(
        color: Colors
            .transparent, // Para asegurar que el onTap funcione en toda el área
        padding: const EdgeInsets.only(
          bottom: 8.0,
        ), // Espacio para el delineado
        child: Row(
          key: _categoryKeys[index],
          children: [
            Icon(
              icon,
              size: 20, // Tamaño del ícono reducido
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                // Estilo de texto más pequeño
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(
    BuildContext context,
    String title,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40, // Coincide con la altura del indicador
          color: Colors.transparent, // For hit testing
          alignment: Alignment.center,
          child: Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : textTheme.bodySmall?.color,
            ),
          ),
        ),
      ),
    );
  }
}
