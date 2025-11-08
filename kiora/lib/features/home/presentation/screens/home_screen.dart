import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiora/config/app_theme.dart';
import 'package:kiora/features/tareas/presentation/providers/quick_add_buttom_notifier.dart'
    as quick_add;
import 'package:kiora/features/tareas/presentation/providers/quick_add_form_content.dart';
import 'package:kiora/features/tareas/presentation/providers/form_visibility_provider.dart';

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final isFormVisible = ref.watch(quickAddFormVisibilityProvider);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: isFormVisible
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
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
                                      : dayName.substring(0, 1).toUpperCase() +
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
    );
  }
}
