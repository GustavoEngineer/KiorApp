import 'package:flutter_test/flutter_test.dart';
import 'package:kiorapp/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the home screen is displayed
    expect(find.text('Mis Tareas'), findsOneWidget);
  });
}
