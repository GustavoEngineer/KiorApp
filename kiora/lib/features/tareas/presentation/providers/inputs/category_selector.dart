import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/quick_add_form_content.dart';

class CategorySelector extends ConsumerStatefulWidget {
  const CategorySelector({super.key});

  @override
  CategorySelectorState createState() => CategorySelectorState();
}

class CategorySelectorState extends ConsumerState<CategorySelector> {
  final categoryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    categoryFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    categoryFocus.removeListener(_onFocusChange);
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
    return TextField(
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
    );
  }
}
