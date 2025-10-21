import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/functions/dismissible_task_card.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/screens/new_task_screen.dart';
import 'package:kiorapp/presentation/screens/tags_screen.dart';
import 'package:kiorapp/presentation/widgets/all_tasks_list.dart';
import 'package:kiorapp/functions/full_calendar_view.dart';
import 'package:kiorapp/presentation/widgets/date_carousel_widget.dart';

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

  void _navigateToEditTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => NewTaskScreen(task: task)));
    if (result == true) {
      ref.read(taskProvider.notifier).loadTasks();
    }
  }

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

  void _showCalendar() async {
    final selectedDate = await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: FullCalendarView(
            selectedDate: _selectedDate,
            focusedDate: _displayedMonth,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutQuint),
              ),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      // Navega a la pantalla de nueva tarea con la fecha seleccionada
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => NewTaskScreen(selectedDate: selectedDate),
        ),
      );
      // Si se guardó una tarea, recargamos la lista
      if (result == true) {
        ref.read(taskProvider.notifier).loadTasks();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final textTheme = Theme.of(context).textTheme;

    final filteredTasks = selectedTag == null
        ? allTasks
        : allTasks.where((task) => task.tagIds.contains(selectedTag)).toList();

    final sortedTasks = List<Task>.from(filteredTasks)
      ..sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });

    return Scaffold(
      appBar: AppBar(
        title: _isDailyViewSelected
            ? GestureDetector(
                onTap: _showCalendar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: textTheme.titleLarge?.fontSize,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMMM, yyyy', 'es_ES').format(_displayedMonth),
                      style: textTheme.titleLarge,
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tareas', style: textTheme.titleLarge),
                  const SizedBox(width: 8),
                  Text('(${sortedTasks.length})', style: textTheme.titleLarge),
                ],
              ),
        centerTitle: true,
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
                                color: Colors.black.withOpacity(0.1),
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
                    MaterialPageRoute(
                      builder: (context) => NewTaskScreen(
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
    final textTheme = Theme.of(context).textTheme;

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
