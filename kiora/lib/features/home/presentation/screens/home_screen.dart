import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/widgets/quick_add_buttom_notifier.dart'
    as quick_add;
import 'package:kiora/features/tareas/presentation/widgets/quick_add_form_content.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';
import 'package:kiora/features/categorias/presentation/screens/categorias_model.dart';
import 'dart:ui' show ImageFilter;
// Sidebar / drawer removed. Drawer notifier and panel were deleted.

class DateHeader extends ConsumerWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final String dayName = DateFormat('EEEE', 'es_ES').format(now);
    final String monthAndDay = DateFormat('MMM d', 'es_ES').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const SizedBox.shrink(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final isFormVisible = ref.watch(
                      quickAddFormVisibilityProvider,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            // Top-right label icon (Kiora primary color)
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: isFormVisible ? 0.0 : 1.0,
                                // Show only the icon (no background, no shadow) and make it larger
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Center(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () async {
                                        // Abrir diálogo centrado con blur de fondo.
                                        await showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: 'Categorías',
                                          barrierColor: Colors.transparent,
                                          transitionDuration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          pageBuilder:
                                              (context, animation, secondary) {
                                                return BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 6.0,
                                                    sigmaY: 6.0,
                                                  ),
                                                  child: Container(
                                                    color: Colors.black
                                                        .withOpacity(0.12),
                                                    child: Center(
                                                      child:
                                                          const CategoryCenteredDialog(),
                                                    ),
                                                  ),
                                                );
                                              },
                                        );
                                        // Ensure focus is cleared when returning from the dialog
                                        // so the keyboard doesn't open on the main screen.
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Icon(
                                        Icons.category,
                                        color: KioraColors.accentKiora,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0.0,
                                end: isFormVisible ? 1.0 : 0.0,
                              ),
                              duration: const Duration(milliseconds: 400),
                              builder: (context, value, child) {
                                if (value == 0) {
                                  return const SizedBox.shrink();
                                }
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(-50 * (1 - value), 0),
                                    child: Transform.scale(
                                      scale: (0.9 + (0.1 * value)).toDouble(),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Nueva Tarea",
                                style: TextStyle(
                                  fontFamily: KioraTypography.headlines,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 34.0,
                                ),
                              ),
                            ),
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutCubic,
                              alignment: isFormVisible
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                    style: TextStyle(
                                      fontFamily: KioraTypography.headlines,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: isFormVisible ? 20.0 : 40.0,
                                    ),
                                    child: Text(
                                      isFormVisible
                                          ? dayName.substring(0, 3)
                                          : dayName
                                                    .substring(0, 1)
                                                    .toUpperCase() +
                                                dayName.substring(1),
                                    ),
                                  ),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                    style: TextStyle(
                                      fontFamily: KioraTypography.headlines,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: isFormVisible ? 20.0 : 40.0,
                                    ),
                                    // Add a space after the comma so the date reads "Lunes, nov 10"
                                    child: const Text(', '),
                                  ),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                    style: TextStyle(
                                      fontFamily: KioraTypography.headlines,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: isFormVisible ? 20.0 : 40.0,
                                    ),
                                    child: Text(
                                      isFormVisible
                                          ? monthAndDay.toLowerCase()
                                          : monthAndDay,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final isFormVisible = ref.watch(
                        quickAddFormVisibilityProvider,
                      );
                      return Stack(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: const SizedBox.expand(),
                          ),
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            offset: Offset(isFormVisible ? 0 : 1, 0),
                            child: const QuickAddFormContent(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Adaptive add-button: sits above content and resizes to avoid the drawer
          Consumer(
            builder: (context, ref, child) {
              final isFormVisible = ref.watch(quickAddFormVisibilityProvider);
              final screenWidth = MediaQuery.of(context).size.width;
              // No drawer: remaining width is the full screen width.
              final remainingWidth = screenWidth;

              if (isFormVisible) return const SizedBox.shrink();

              // compute target button width with margins, keep a sensible minimum
              double targetWidth =
                  remainingWidth - 32.0; // leave 16px side margins
              if (targetWidth < 160.0) {
                targetWidth = remainingWidth < 160.0 ? remainingWidth : 160.0;
              }
              if (targetWidth > remainingWidth) targetWidth = remainingWidth;

              return Positioned(
                bottom: 24,
                left: 0,
                child: SizedBox(
                  width: remainingWidth,
                  child: Center(
                    child: SizedBox(
                      width: targetWidth,
                      child: ref.watch(quick_add.quickAddButtonProvider),
                    ),
                  ),
                ),
              );
            },
          ),
          // Drawer removed; no panel rendered.
        ],
      ),
    );
  }
}
