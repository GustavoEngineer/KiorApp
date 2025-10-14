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
  // No necesitamos una lista de pantallas, solo HomeScreen.

  void _onItemTapped(int index) async {
    // El índice 0 es para 'Tasks', que ya está visible.
    if (index == 1) {
      final result = await Navigator.of(
        context,
      ).push(TopDownPageRoute(child: const NewTaskScreen()));
      if (result == true) {
        // Si se guardó una tarea, recargamos la lista en HomeScreen.
        _homeScreenKey.currentState?.loadTasks();
      }
    }
    // Actualizamos el índice seleccionado para el feedback visual del BottomNavigationBar.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: HomeScreen(key: _homeScreenKey),
      ),
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
