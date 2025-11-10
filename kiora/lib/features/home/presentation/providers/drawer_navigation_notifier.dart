import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
// Categories feature removed for now; icon kept as placeholder.

/// Estado del drawer lateral.
///
/// - [isOpen]: si el panel está visible.
/// - [widthFactor]: fracción del ancho de la pantalla que ocupa (0.0 - 1.0).
@immutable
class DrawerNavigationState {
  final bool isOpen;
  final double widthFactor;

  const DrawerNavigationState({this.isOpen = false, this.widthFactor = 0.2});

  DrawerNavigationState copyWith({bool? isOpen, double? widthFactor}) {
    return DrawerNavigationState(
      isOpen: isOpen ?? this.isOpen,
      widthFactor: widthFactor ?? this.widthFactor,
    );
  }
}

final drawerNavigationProvider =
    StateNotifierProvider<DrawerNavigationNotifier, DrawerNavigationState>((
      ref,
    ) {
      return DrawerNavigationNotifier();
    });

class DrawerNavigationNotifier extends StateNotifier<DrawerNavigationState> {
  DrawerNavigationNotifier() : super(const DrawerNavigationState());

  /// Abre el drawer (lo muestra).
  void open() => state = state.copyWith(isOpen: true);

  /// Cierra el drawer (lo oculta).
  void close() => state = state.copyWith(isOpen: false);

  /// Alterna el estado abierto/cerrado.
  void toggle() => state = state.copyWith(isOpen: !state.isOpen);

  /// Ajusta la fracción del ancho que ocupa el drawer.
  ///
  /// El valor se normaliza entre 0.0 y 1.0. Para el requerimiento actual
  /// usaremos por defecto 0.2 (20%).
  void setWidthFactor(double factor) {
    final normalized = factor.clamp(0.0, 1.0);
    state = state.copyWith(widthFactor: normalized);
  }
}

/// Widget que renderiza el panel lateral y el backdrop.
///
/// Contiene la UI (AnimatedPositioned, backdrop, etc.) y se conecta
/// al mismo provider (`drawerNavigationProvider`) para comportamiento.
class DrawerNavigationPanel extends ConsumerWidget {
  const DrawerNavigationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerNavigationProvider);
    final isOpen = drawerState.isOpen;
    final widthFactor = drawerState.widthFactor;
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * widthFactor;

    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isOpen ? 1.0 : 0.0,
        child: Stack(
          children: [
            // Backdrop (transparent by design)
            GestureDetector(
              onTap: () => ref.read(drawerNavigationProvider.notifier).close(),
              child: Container(color: Colors.transparent),
            ),
            // Drawer panel
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              right: isOpen ? 0 : -drawerWidth,
              width: drawerWidth,
              child: Material(
                elevation: 0,
                shadowColor: Colors.transparent,
                color: const Color.fromARGB(255, 202, 202, 202),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            // Placeholder: categories section removed. Icon kept
                            // for future implementation. No action for now.
                          },
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: KioraColors.accentKiora,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  offset: const Offset(0, 2),
                                  blurRadius: 6.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.sell,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
