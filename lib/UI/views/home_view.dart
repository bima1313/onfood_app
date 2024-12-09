import 'package:flutter/material.dart';
import 'package:onfood/UI/screens/history_screen.dart';
import 'package:onfood/UI/screens/setting_screen.dart';
import 'package:onfood/UI/screens/food_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentScreen = 0;
  final List<Widget> _screen = const [
    FoodScreen(),
    HistoryScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _screen[_currentScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentScreen,
        onDestinationSelected: (value) {
          setState(() {
            _currentScreen = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.food_bank),
            selectedIcon: Icon(Icons.food_bank_outlined),
            label: 'Pesan',
          ),
          NavigationDestination(
            icon: Icon(Icons.inbox_rounded),
            selectedIcon: Icon(Icons.inbox_outlined),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
