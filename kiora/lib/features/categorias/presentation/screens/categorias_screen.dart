import 'package:flutter/material.dart';

/// Muestra un bottom sheet con la UI y lógica mínima de "Categorías".
///
/// Esta implementación gestiona una lista en memoria (List<String>) local al
/// sheet: permite añadir (Enter o botón Aceptar) y borrar categorías. No
/// persiste datos; sirve como scaffold inicial para la sección de categorías.
Future<void> showCategoriasBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: _CategoriasSheet(),
      );
    },
  );
}

class _CategoriasSheet extends StatefulWidget {
  @override
  State<_CategoriasSheet> createState() => _CategoriasSheetState();
}

class _CategoriasSheetState extends State<_CategoriasSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _categories = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addCategory(String value) {
    final v = value.trim();
    if (v.isEmpty) return;
    setState(() => _categories.add(v));
    _controller.clear();
    // scroll to bottom to reveal newly added item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const Text(
                'Categorías',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Nueva categoría',
                        isDense: true,
                      ),
                      onSubmitted: _addCategory,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addCategory(_controller.text),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Tus categorías:'),
              const SizedBox(height: 8),
              Expanded(
                child: _categories.isEmpty
                    ? const Center(child: Text('No tienes categorías aún.'))
                    : ListView.separated(
                        controller: _scrollController,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = _categories[index];
                          return ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => setState(() {
                                _categories.removeAt(index);
                              }),
                            ),
                          );
                        },
                      ),
              ),
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
}
