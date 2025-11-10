import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/widgets/quick_add_form_content.dart';
import 'package:kiora/core/di/core_providers.dart';
import 'package:kiora/core/data_sources/app_database.dart' as db;

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
    // Obtener la instancia de la BD para escuchar las categorías
    final dbRef = ref.watch(appDatabaseProvider);

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
          onChanged: (value) =>
              ref.read(quickAddFormProvider.notifier).updateCategoria(value),
        ),

        // Mostrar sugerencias sólo cuando el campo tiene foco
        if (categoryFocus.hasFocus)
          StreamBuilder<List<db.Categoria>>(
            stream: dbRef.select(dbRef.categorias).watch(),
            builder: (context, snapshot) {
              final categorias = snapshot.data ?? <db.Categoria>[];

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
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: categorias.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = categorias[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Rellenar input y actualizar provider
                                _controller.text = item.nombre;
                                ref
                                    .read(quickAddFormProvider.notifier)
                                    .updateCategoria(item.nombre);
                                // Quitar foco para cerrar la lista
                                categoryFocus.unfocus();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Text(item.nombre),
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
      ],
    );
  }
}
