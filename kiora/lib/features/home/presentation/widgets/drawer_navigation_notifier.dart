import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/categorias/presentation/screens/categorias_screen_model.dart';

/// Secciones internas del drawer que pueden expandirse.
enum DrawerSection { none, categorias }

/// Estado del drawer lateral.
///
/// - [isOpen]: si el panel está visible.
/// - [widthFactor]: fracción del ancho de la pantalla que ocupa (0.0 - 1.0).
@immutable
class DrawerNavigationState {
  final bool isOpen;
  final double widthFactor;
  final DrawerSection expandedSection;

  const DrawerNavigationState({
    this.isOpen = false,
    this.widthFactor = 0.2,
    this.expandedSection = DrawerSection.none,
  });

  DrawerNavigationState copyWith({
    bool? isOpen,
    double? widthFactor,
    DrawerSection? expandedSection,
  }) {
    return DrawerNavigationState(
      isOpen: isOpen ?? this.isOpen,
      widthFactor: widthFactor ?? this.widthFactor,
      expandedSection: expandedSection ?? this.expandedSection,
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

  /// Alterna la expansión de una sección interna del drawer.
  /// Si la sección ya está abierta, la cerramos (none).
  void toggleSection(DrawerSection section) {
    if (state.expandedSection == section) {
      state = state.copyWith(expandedSection: DrawerSection.none);
    } else {
      state = state.copyWith(expandedSection: section);
    }
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
    final expanded = drawerState.expandedSection;
    final screenWidth = MediaQuery.of(context).size.width;
    // When a section is expanded, increase the drawer width by an extra
    // fraction so the expanded content can be displayed inside the same panel.
    // A bit larger to give more room for the embedded UI when categorias opens.
    const extraForExpanded = 0.55; // 46% extra when expanded (bigger expansion)
    final extra = expanded == DrawerSection.none ? 0.0 : extraForExpanded;
    final totalFactor = (widthFactor + extra).clamp(0.0, 0.9);
    // Avoid fractional-pixel overflows by using a floored, clamped width.
    final drawerWidth = math.min(
      screenWidth,
      (screenWidth * totalFactor).floorToDouble(),
    );

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
                    child: SizedBox(
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left: categories content (only shown when expanded)
                          if (expanded == DrawerSection.categorias) ...[
                            Expanded(
                              child: Padding(
                                // Reduce right padding so the left content can use more width
                                padding: const EdgeInsets.only(right: 2.0),
                                child: SingleChildScrollView(
                                  child: CategoriesPanel(),
                                ),
                              ),
                            ),
                          ] else ...[
                            // keep zero width when not expanded
                            const SizedBox.shrink(),
                          ],

                          // Render a minimal-width row containing the optional divider
                          // and the icon after the left panel. The Expanded above
                          // will take the remaining space, so no Spacer is needed.
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (expanded == DrawerSection.categorias) ...[
                                Container(
                                  width: 1,
                                  color: Colors.black12,
                                  height: double.infinity,
                                ),
                                // Small separation between divider and icon for clarity
                                // Reduced from 4 -> 3 to avoid 1px overflow on narrow layouts
                                const SizedBox(width: 3),
                              ],

                              // Icon (same in both states) placed right next to the divider
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  right: 2.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(drawerNavigationProvider.notifier)
                                        .toggleSection(
                                          DrawerSection.categorias,
                                        );
                                  },
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: SizedBox.square(
                                    dimension: 48,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: KioraColors.accentKiora,
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.12,
                                            ),
                                            offset: const Offset(0, 2),
                                            blurRadius: 6.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.sell,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
