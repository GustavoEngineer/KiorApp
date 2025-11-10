import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que guarda la lista de categorías en memoria.
final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<String>>((ref) {
  return CategoriesNotifier();
});

class CategoriesNotifier extends StateNotifier<List<String>> {
  CategoriesNotifier() : super([]);

  void addCategory(String name) {
    if (name.trim().isEmpty) return;
    state = [...state, name.trim()];
  }

  void removeAt(int index) {
    final copy = [...state];
    if (index < 0 || index >= copy.length) return;
    copy.removeAt(index);
    state = copy;
  }

  void clear() => state = [];
}
