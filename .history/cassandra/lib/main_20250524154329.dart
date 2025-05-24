import 'package:flutter/material.dart';
import 'package:cassandra/theme/app_theme.dart';
import 'package:cassandra/widgets/bottom_nav_bar.dart';
//import 'package:cassandra/pages/home_page.dart';
import 'package:cassandra/pages/portfolio_page.dart';
import 'package:cassandra/pages/analytics_page.dart';
import 'package:cassandra/pages/governance_page.dart';
import 'package:cassandra/screens/more_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cassandra',
      theme: AppTheme.darkTheme,
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
  int _currentIndex = 0;

  final List<Widget> _pages = [
    //const HomePage(),
    const PortfolioPage(),
    const AnalyticsPage(),
    const GovernancePage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
