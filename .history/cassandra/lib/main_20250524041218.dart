import 'package:flutter/material.dart';
import 'package:cassandra/screens/home_screen.dart';
import 'package:cassandra/screens/profile_screen.dart';
import 'package:cassandra/screens/staking_screen.dart';
import 'package:cassandra/screens/governance_screen.dart';
import 'package:cassandra/screens/curation_screen.dart';
import 'package:cassandra/services/mock_data_service.dart';

void main() {
  runApp(const CassandraApp());
}

class CassandraApp extends StatelessWidget {
  const CassandraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cassandra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
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
  String _currentUser = 'alice'; // Mock current user

  final List<Widget> _screens = [
    const HomeScreen(),
    const StakingScreen(),
    const GovernanceScreen(),
    const CurationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Staking',
          ),
          NavigationDestination(
            icon: Icon(Icons.gavel),
            label: 'Governance',
          ),
          NavigationDestination(
            icon: Icon(Icons.rate_review),
            label: 'Curation',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
bottom