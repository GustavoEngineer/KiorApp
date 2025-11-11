import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/widgets/quick_add_form_content.dart';
import 'package:kiora/features/categorias/presentation/screens/categorias_model.dart';
// core providers and direct DB access not required here; we use categoriesProvider

class CategorySelector extends ConsumerStatefulWidget {
  const CategorySelector({super.key});

  @override
  CategorySelectorState createState() => CategorySelectorState();
}

class CategorySelectorState extends ConsumerState<CategorySelector> {
  final categoryFocus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    categoryFocus.removeListener(_onFocusChange);
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    // Obtener las categorías desde el provider (ya se sincroniza con la BD)
    final categorias = ref.watch(categoriesProvider);

    // Widget principal: campo de texto + lista de sugerencias cuando tiene foco
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: categoryFocus,
          decoration: InputDecoration(
            labelText: 'Categoría',
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: KioraColors.accentKiora, width: 2),
            ),
            enabledBorder: const UnderlineInputBorder(
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
          onChanged: (value) {
            // Update provider and rebuild so the suggestions list is recomputed
            ref.read(quickAddFormProvider.notifier).updateCategoria(value);
            setState(() {});
          },
        ),

        // Mostrar sugerencias sólo cuando el campo tiene foco
        if (categoryFocus.hasFocus)
          Builder(
            builder: (context) {
              // Filtrar según el texto actual del controlador (case-insensitive).
              final input = _controller.text.trim().toLowerCase();
              final filtered = input.isEmpty
                  ? categorias
                  : categorias
                        .where((c) => c.name.toLowerCase().contains(input))
                        .toList(growable: false);

              return Container(
                margin: const EdgeInsets.only(top: 8),
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: categorias.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'No hay categorías',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : (filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'No hay categorías que coincidan',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(12.0),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filtered.map((cat) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _priorityBorderColor(
                                          cat.priority,
                                        ),
                                        width: 1.4,
                                      ),
                                    ),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        // seleccionar la categoría
                                        _controller.text = cat.name;
                                        _controller.selection =
                                            TextSelection.fromPosition(
                                              TextPosition(
                                                offset: _controller.text.length,
                                              ),
                                            );
                                        ref
                                            .read(quickAddFormProvider.notifier)
                                            .updateCategoria(cat.name);
                                        categoryFocus.unfocus();
                                      },
                                      child: Text(cat.name),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )),
              );
            },
          ),
      ],
    );
  }

  Color _priorityBorderColor(int priority) {
    // Blend from a very light accent to the full accent color based on priority (1..5)
    final t = ((priority - 1) / 4).clamp(0.0, 1.0);
    final light = KioraColors.accentKiora.withOpacity(0.20);
    return Color.lerp(light, KioraColors.accentKiora, t)!;
  }
}
