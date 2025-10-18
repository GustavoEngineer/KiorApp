import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kiorapp/presentation/screens/home_screen.dart';
import 'package:kiorapp/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa los datos de localización para el paquete intl.
  await initializeDateFormatting('es_ES', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiorapp',
      theme: baseTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
