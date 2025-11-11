import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para la lista de categorías (lista simple de strings).
final categoriasProvider =
    StateNotifierProvider<CategoriasNotifier, List<String>>(
      (ref) => CategoriasNotifier(),
    );

class CategoriasNotifier extends StateNotifier<List<String>> {
  CategoriasNotifier() : super([]);

  void addCategoria(String name) {
    final n = name.trim();
    if (n.isEmpty) return;
    // evitar duplicados exactos
    if (state.contains(n)) return;
    state = [...state, n];
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }

  void clear() => state = [];
}

/// Bottom sheet que muestra el formulario para agregar una categoría y la lista
/// de categorías actuales. Toda la lógica de añadir/borrar usa el provider
/// `categoriasProvider`.
class CategoryBottomSheet extends ConsumerStatefulWidget {
  const CategoryBottomSheet({super.key});

  @override
  ConsumerState<CategoryBottomSheet> createState() =>
      _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends ConsumerState<CategoryBottomSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(categoriasProvider.notifier).addCategoria(text);
    _controller.clear();
    // keep focus on the field
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ref.watch(categoriasProvider);

    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Nueva categoría',
                              hintText: 'Escribe el nombre',
                            ),
                            onFieldSubmitted: (_) => _add(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _add,
                          child: const Text('Añadir'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Categorías',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: categorias.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(
                            child: Text(
                              'Aún no hay categorías. Añade una arriba.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          itemCount: categorias.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final name = categorias[index];
                            return Dismissible(
                              key: ValueKey(name + index.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) {
                                ref
                                    .read(categoriasProvider.notifier)
                                    .removeAt(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Categoría "${name}" eliminada',
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    ref
                                        .read(categoriasProvider.notifier)
                                        .removeAt(index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
