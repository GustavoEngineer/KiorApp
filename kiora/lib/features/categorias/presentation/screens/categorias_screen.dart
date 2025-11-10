import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/features/categorias/presentation/providers/categories_notifier.dart';

/// Muestra un modal simple con el contenido de "Categorías".
///
/// Llamar a `showCategoriasModal(context)` desde cualquier lugar (por ejemplo
/// desde `DrawerNavigationPanel`) para abrir el modal. El drawer permanecerá
/// abierto ya que este modal se muestra encima del panel.
Future<void> showCategoriasModal(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return const _CategoriasDialog();
    },
  );
}

class _CategoriasDialog extends ConsumerStatefulWidget {
  const _CategoriasDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<_CategoriasDialog> createState() => _CategoriasDialogState();
}

class _CategoriasDialogState extends ConsumerState<_CategoriasDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return AlertDialog(
      title: const Text('Categorías'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nueva categoría'),
                onSubmitted: (value) {
                  if (value.trim().isEmpty) return;
                  ref.read(categoriesProvider.notifier).addCategory(value);
                  _controller.clear();
                },
              ),
              const SizedBox(height: 12),
              const Text('Tus categorías:'),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: categories.isEmpty
                    ? const Center(child: Text('No tienes categorías aún.'))
                    : ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = categories[index];
                          return ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                ref
                                    .read(categoriesProvider.notifier)
                                    .removeAt(index);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            });
          },
          child: const Text('Cerrar'),
        ),
        TextButton(
          onPressed: () {
            final value = _controller.text;
            if (value.trim().isNotEmpty) {
              ref.read(categoriesProvider.notifier).addCategory(value);
              _controller.clear();
            }
            FocusScope.of(context).unfocus();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            });
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
