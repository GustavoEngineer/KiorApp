import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/core/di/core_providers.dart';
import 'package:kiora/core/data_sources/app_database.dart' as db;
import 'package:drift/drift.dart' show Value;

/// Category model holding name and numeric priority (1..5).
class Category {
  final String name;
  final int priority;

  Category({required this.name, required this.priority});
}

/// Simple categories state holder using Riverpod.
/// Provider that keeps categories in sync with the local Drift DB.
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
      (ref) => CategoriesNotifier(ref),
    );

class CategoriesNotifier extends StateNotifier<List<Category>> {
  final Ref ref;
  StreamSubscription<List<db.Categoria>>? _sub;

  CategoriesNotifier(this.ref) : super(<Category>[]) {
    // Subscribe to DB changes and mirror them into the notifier state.
    final dbRef = ref.read(appDatabaseProvider);
    _sub = dbRef.select(dbRef.categorias).watch().listen((rows) {
      // Map Drift model to local lightweight Category model
      final mapped = rows
          .map((r) => Category(name: r.nombre, priority: r.importancia))
          .toList(growable: false);
      state = mapped;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Inserts a new category into the DB. The DB stream will update `state`.
  Future<void> add(String name, int priority) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    // avoid duplicates by name
    if (state.any((c) => c.name == trimmed)) return;
    final dbRef = ref.read(appDatabaseProvider);
    await dbRef
        .into(dbRef.categorias)
        .insert(
          db.CategoriasCompanion.insert(
            nombre: trimmed,
            importancia: Value(priority),
            needsSync: Value(true),
          ),
        );
  }

  /// Remove by index mapped from current state. This will delete rows matching the name.
  Future<void> removeAt(int index) async {
    if (index < 0 || index >= state.length) return;
    final cat = state[index];
    final dbRef = ref.read(appDatabaseProvider);
    await (dbRef.delete(
      dbRef.categorias,
    )..where((t) => t.nombre.equals(cat.name))).go();
  }
}

/// A compact, centered dialog that acts like a small "bottom screen" but
/// appears centered and constrained so it doesn't take too much space.
class CategoryCenteredDialog extends ConsumerStatefulWidget {
  const CategoryCenteredDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoryCenteredDialog> createState() =>
      _CategoryCenteredDialogState();
}

class _CategoryCenteredDialogState
    extends ConsumerState<CategoryCenteredDialog> {
  final TextEditingController _controller = TextEditingController();
  late FixedExtentScrollController _pickerController;
  int _selectedPriority = 1;

  @override
  void dispose() {
    _controller.dispose();
    _pickerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pickerController = FixedExtentScrollController(initialItem: 0);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 8.0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
          maxHeight: 420,
          minWidth: 280,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Categorías', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nombre de la categoría',
                        filled: true,
                        // keep the input white (dialog is already white) but
                        // draw a grey rounded border around it.
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1.6,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _addCategory(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Wheel picker (1..5) to choose a numeric option
                  SizedBox(
                    width: 96,
                    height: 72,
                    child: CupertinoPicker(
                      scrollController: _pickerController,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          _selectedPriority = i + 1;
                        });
                      },
                      children: List<Widget>.generate(
                        5,
                        (i) => Center(
                          child: Text(
                            '${i + 1}',
                            style: i + 1 == _selectedPriority
                                ? const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: KioraColors.accentKiora,
                                  )
                                : const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // List area: show categories as wrapped chips inside a white box
              Expanded(
                child: categories.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay categorías',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: categories.asMap().entries.map((e) {
                              final idx = e.key;
                              final cat = e.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _priorityBorderColor(cat.priority),
                                    width: 1.4,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(cat.name),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => ref
                                          .read(categoriesProvider.notifier)
                                          .removeAt(idx),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCategory() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(categoriesProvider.notifier).add(text, _selectedPriority);
    _controller.clear();
  }

  Color _priorityBorderColor(int priority) {
    // Blend from a very light accent to the full accent color based on priority (1..5)
    final t = ((priority - 1) / 4).clamp(0.0, 1.0);
    final light = KioraColors.accentKiora.withOpacity(0.20);
    return Color.lerp(light, KioraColors.accentKiora, t)!;
  }
}
