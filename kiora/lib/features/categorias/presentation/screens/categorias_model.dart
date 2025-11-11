import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:kiora/config/app_theme.dart';

/// Simple categories state holder using Riverpod.
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<String>>(
      (ref) => CategoriesNotifier(),
    );

class CategoriesNotifier extends StateNotifier<List<String>> {
  CategoriesNotifier() : super(<String>[]);

  void add(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (state.contains(trimmed)) return;
    state = [...state, trimmed];
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    final newList = [...state]..removeAt(index);
    state = newList;
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
              // List area: keep it flexible but constrained so dialog isn't huge
              Expanded(
                child: categories.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay categorías',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(categories[i]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(categoriesProvider.notifier)
                                .removeAt(i),
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
    ref.read(categoriesProvider.notifier).add(text);
    _controller.clear();
  }
}
