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
        child: SizedBox(
          // Keep the sheet constrained similarly to the embedded panel
          height: MediaQuery.of(sheetContext).size.height * 0.6,
          child: CategoriesPanel(),
        ),
      );
    },
  );
}

/// Reusable panel widget that displays categories UI. It manages its own
/// in-memory list and can be embedded inside the drawer (or used inside the
/// bottom sheet by `showCategoriasBottomSheet`).
class CategoriesPanel extends StatefulWidget {
  const CategoriesPanel({Key? key}) : super(key: key);

  @override
  State<CategoriesPanel> createState() => _CategoriesPanelState();
}

class _CategoriesPanelState extends State<CategoriesPanel> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          const Text(
            'Categorías',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Nueva categoría',
                    isDense: true,
                  ),
                  onSubmitted: _addCategory,
                ),
              ),
              // Removed the Accept button per UX request; submission is via keyboard (Enter)
            ],
          ),
          const SizedBox(height: 12),
          const Text('Tus categorías:'),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: _categories.isEmpty
                ? const Center(child: Text('No tienes categorías aún.'))
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = _categories[index];
                      return ListTile(
                        dense: true,
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
        ],
      ),
    );
  }
}
