import 'package:flutter/material.dart';

/// Muestra un modal simple con el contenido de "Categorías".
///
/// Llamar a `showCategoriasModal(context)` desde cualquier lugar (por ejemplo
/// desde `DrawerNavigationPanel`) para abrir el modal. El drawer permanecerá
/// abierto ya que este modal se muestra encima del panel.
Future<void> showCategoriasModal(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Categorías'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Aquí puedes listar o gestionar las categorías.'),
              SizedBox(height: 12),
              // Placeholder: puedes reemplazar por una lista real
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
