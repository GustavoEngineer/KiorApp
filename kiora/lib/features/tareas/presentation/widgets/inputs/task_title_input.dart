import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/widgets/quick_add_form_content.dart';

class TaskTitleInput extends ConsumerStatefulWidget {
  const TaskTitleInput({super.key});

  @override
  TaskTitleInputState createState() => TaskTitleInputState();
}

class TaskTitleInputState extends ConsumerState<TaskTitleInput> {
  final titleFocus = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    titleFocus.removeListener(_onFocusChange);
    titleFocus.dispose();
    textController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        // El cambio de foco actualizará el estado
      });
    }
  }

  void _resetText() {
    textController.clear();
    ref.read(quickAddFormProvider.notifier).updateTitulo('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      focusNode: titleFocus,
      decoration: InputDecoration(
        labelText: 'Título',
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
          color: titleFocus.hasFocus
              ? KioraColors.accentKiora
              : Colors.grey.shade600,
        ),
        floatingLabelStyle: TextStyle(
          color: titleFocus.hasFocus ? KioraColors.accentKiora : Colors.black,
        ),
        suffixIcon: textController.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: titleFocus.hasFocus
                      ? KioraColors.accentKiora
                      : Colors.grey.shade600,
                ),
                onPressed: _resetText,
              )
            : null,
      ),
      onChanged: (value) {
        ref.read(quickAddFormProvider.notifier).updateTitulo(value);
        setState(() {}); // Para actualizar la visibilidad del icono
      },
    );
  }
}
