import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/comment_modal.dart';
import 'widgets/explore_modal.dart';
import 'widgets/search_modal.dart';
import 'widgets/following_modal.dart';
import 'widgets/live_modal.dart';
import 'widgets/neon_splash_screen.dart';
import 'pages/governance_page.dart';
import 'pages/staking_page.dart';
import 'services/starknet_service.dart';
import 'screens/market_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'test_contract.dart';

enum AppTheme {
  classicDark,
  classicLight,
  neon,
  aqua,
  sunset,
  violet,
  blush,
  mint,
  nightlife,
}

ThemeData getThemeData(AppTheme theme) {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF111111),
    primaryColor: const Color(0xFF9B5CFF),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF9B5CFF),
      secondary: const Color(0xFF7DF9FF),
      background: const Color(0xFF111111),
      surface: const Color(0xFF181A1A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      tertiary: const Color(0xFF00FFF7),
      error: const Color(0xFFFF2D55),
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.copyWith(
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            headlineMedium: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
            titleLarge: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            titleMedium: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            bodyMedium: const TextStyle(fontSize: 14, color: Colors.white70),
            bodySmall: const TextStyle(fontSize: 12, color: Colors.white54),
            labelLarge: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00FFF7),
            ),
            labelMedium:
                const TextStyle(fontSize: 12, color: Color(0xFF00FFF7)),
          ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A12),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF181A1A),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF181A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00FFF7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00FFF7),
        side: const BorderSide(color: Color(0xFF00FFF7), width: 1.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF181A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7DF9FF), width: 1.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7DF9FF), width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00FFF7), width: 2.2),
      ),
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF00FFF7)),
    dividerColor: const Color(0xFF222222),
    splashColor: const Color(0xFF00FFF7).withOpacity(0.14),
    highlightColor: const Color(0xFF00FFF7).withOpacity(0.10),
    hoverColor: const Color(0xFF00FFF7).withOpacity(0.10),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    materialTapTargetSize: MaterialTapTargetSize.padded,
  );
}

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeController();
  }
}

class ThemeController extends StatefulWidget {
  const ThemeController({super.key});

  @override
  State<ThemeController> createState() => _ThemeControllerState();
}

class _ThemeControllerState extends State<ThemeController> {
  AppTheme _currentTheme = AppTheme.classicDark;
  double _textScale = 1.0;
  bool _showSplash = true;
  bool _showOnboarding = false;
  bool _isLoggedIn = false;
  late final StarkNetService _starknetService;

  @override
  void initState() {
    super.initState();
    _starknetService = StarkNetService();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _showOnboarding = !seenOnboarding;
      _isLoggedIn = loggedIn;
      _showSplash = !loggedIn;
    });
  }

  void _updateTheme(AppTheme theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  void _updateTextScale(double scale) {
    setState(() {
      _textScale = scale;
    });
  }

  void _hideSplash() {
    setState(() {
      _showSplash = false;
      if (_showOnboarding) {
        // Show onboarding after splash
        _showOnboarding = true;
      }
    });
  }

  void _finishOnboarding({bool login = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (login) await prefs.setBool('isLoggedIn', true);
    setState(() {
      _showOnboarding = false;
      _isLoggedIn = login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: _textScale),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cassandra',
        theme: getThemeData(_currentTheme),
        home: _isLoggedIn
            ? MainScaffold(
                currentTheme: _currentTheme,
                onThemeChanged: _updateTheme,
                starknetService: _starknetService,
              )
            : _showSplash
                ? NeonSplashScreen(onContinue: _hideSplash)
                : _showOnboarding
                    ? OnboardingScreen(
                        onFinish: () => _finishOnboarding(login: true),
                        onGuest: () => _finishOnboarding(login: false),
                      )
                    : MainScaffold(
                        currentTheme: _currentTheme,
                        onThemeChanged: _updateTheme,
                        starknetService: _starknetService,
                      ),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;
  final StarkNetService starknetService;

  const MainScaffold({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.starknetService,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MarketListScreen(starknetService: widget.starknetService),
      const Placeholder(), // NotificationsPage
      const Placeholder(), // ExplorePage
      const Placeholder(), // MarketsPage
      ProfileScreen(starknetService: widget.starknetService),
    ];
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      // Live button opens Live modal
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const LiveModal(),
      );
      return;
    }
    if (index == 4) {
      // More button opens More menu
      _showMoreMenu();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Governance Section
            ListTile(
              leading: Icon(Icons.gavel_outlined,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Governance'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GovernancePage()));
              },
            ),
            // Staking Section
            ListTile(
              leading: Icon(Icons.currency_exchange_outlined,
                  color: Theme.of(context).colorScheme.secondary),
              title: const Text('Staking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const StakingPage()));
              },
            ),
            // Analytics Section
            ListTile(
              leading: Icon(Icons.analytics_outlined,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Analytics
              },
            ),
            // Leaderboard Section
            ListTile(
              leading: Icon(Icons.leaderboard_outlined,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Leaderboard'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Leaderboard
              },
            ),
            // Portfolio Section
            ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined,
                  color: Theme.of(context).colorScheme.secondary),
              title: const Text('Portfolio'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Portfolio
              },
            ),
            // Rewards Section
            ListTile(
              leading: Icon(Icons.card_giftcard_outlined,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Rewards'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to Rewards
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_outlined),
            activeIcon: Icon(Icons.live_tv),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
