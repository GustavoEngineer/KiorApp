import 'package:flutter/material.dart';
import 'package:kiorapp/screens/home_screen.dart';
import 'package:kiorapp/screens/new_task_screen.dart';
import 'package:kiorapp/screens/tags_screen.dart';
import 'package:kiorapp/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiorapp',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();

  void _onItemTapped(int index) async {
    if (index == 1) {
      final result = await Navigator.of(context).push(
        TopDownPageRoute(child: const NewTaskScreen()),
      );
      if (result == true && _homeScreenKey.currentState != null) {
        await _homeScreenKey.currentState!.loadTasks();
        setState(() {
          _selectedIndex = 0;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // El Scaffold es el contenedor principal de la pantalla.
    return Scaffold(
      // El body contendrá la pantalla principal (HomeScreen).
      // Usamos una clave (key) para poder acceder al estado de HomeScreen
      // desde este widget (MainScreen) y así poder recargar las tareas.
      body: HomeScreen(key: _homeScreenKey),

      // La barra de navegación inferior.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New Task'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
