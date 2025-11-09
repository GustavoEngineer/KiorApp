import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/quick_add_buttom_notifier.dart'
    as quick_add;
import 'package:kiora/features/tareas/presentation/providers/quick_add_form_content.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';
import 'package:kiora/features/home/presentation/providers/sidebar_visibility_provider.dart';

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
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isFormVisible = ref.watch(quickAddFormVisibilityProvider);
          if (isFormVisible) return const SizedBox.shrink();
          return ref.watch(quick_add.quickAddButtonProvider);
        },
      ),
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
                          children: [
                            Positioned(
                              right: 0,
                              top: 4,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: isFormVisible ? 0.0 : 1.0,
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(
                                          sidebarVisibilityProvider.notifier,
                                        )
                                        .state = !ref.read(
                                      sidebarVisibilityProvider,
                                    );
                                  },
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: KioraColors.accentKiora,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: KioraColors.accentKiora,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: isFormVisible ? 1 : 0,
                              ),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                              builder: (context, value, child) {
                                if (!isFormVisible || value == 0)
                                  return const SizedBox.shrink();
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(-50 * (1 - value), 0),
                                    child: Transform.scale(
                                      scale: 0.9 + (0.1 * value),
                                      child: Text(
                                        "Nueva Tarea",
                                        style: const TextStyle(
                                          fontFamily: KioraTypography.headlines,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 34.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutCubic,
                              alignment: isFormVisible
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                        children: [
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
          Consumer(
            builder: (context, ref, child) {
              final isSidebarVisible = ref.watch(sidebarVisibilityProvider);
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 0,
                right: isSidebarVisible
                    ? 0
                    : -(MediaQuery.of(context).size.width * 0.2),
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Container(color: Colors.black),
              );
            },
          ),
        ],
      ),
    );
  }
}
