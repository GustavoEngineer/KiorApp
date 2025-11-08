import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickAddFormVisibilityProvider =
    StateNotifierProvider<FormVisibilityNotifier, bool>((ref) {
      return FormVisibilityNotifier();
    });

class FormVisibilityNotifier extends StateNotifier<bool> {
  FormVisibilityNotifier() : super(false);

  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
}
