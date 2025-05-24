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
    scaffoldBackgroundColor: const Color(0xFF0A0A12),
    primaryColor: const Color(0xFF9B5CFF),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF9B5CFF),
      secondary: const Color(0xFF7DF9FF),
      background: const Color(0xFF0A0A12),
      surface: const Color(0xFF181A22),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
      tertiary: const Color(0xFF00FFF7),
      error: const Color(0xFFFF2D55),
    ),
    textTheme: GoogleFonts.soraTextTheme(
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
        labelMedium: const TextStyle(fontSize: 12, color: Color(0xFF00FFF7)),
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
      color: const Color(0xFF181A22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF181A22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
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
        backgroundColor: const Color(0xFF00FFF7), // Neon Cyan
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.22),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00FFF7), // Neon Cyan
        side: const BorderSide(color: Color(0xFF00FFF7), width: 1.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF181A22),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF7DF9FF),
          width: 1.4,
        ), // Vibrant Crystal Blue
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF7DF9FF),
          width: 1.4,
        ), // Vibrant Crystal Blue
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF00FFF7),
          width: 2.2,
        ), // Neon Cyan
      ),
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF00FFF7)), // Neon Cyan
    dividerColor: Colors.white12,
    splashColor: const Color(0xFF00FFF7).withOpacity(0.14),
    highlightColor: const Color(0xFF00FFF7).withOpacity(0.10),
    hoverColor: const Color(0xFF00FFF7).withOpacity(0.10),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // Accessibility: larger tap targets
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

  @override
  void initState() {
    super.initState();
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
        home:
            _isLoggedIn
                ? MainScaffold(
                  currentTheme: _currentTheme,
                  onThemeChanged: _updateTheme,
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
                ),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;
  const MainScaffold({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FeedPage(),
    Placeholder(), // NotificationsPage
    Placeholder(), // Add (dummy, handled by modal)
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Add button opens CreatePredictionScreen
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const CreatePredictionScreen(),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, semanticLabel: 'Home'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded, size: 32, semanticLabel: 'Add'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv, size: 28, semanticLabel: 'Live'),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person, semanticLabel: 'Profile'),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Demo feeds for each tab (in real app, fetch/filter accordingly)
  final List<Map<String, dynamic>> forYouFeed = [
    {
      'title': 'Solana will flip Ethereum in market cap by 2026',
      'timeLeft': '24h left',
      'amount': '3,400',
      'likes': 12,
      'comments': 3,
      'liked': false,
    },
    {
      'title': 'BTC to \$80k by Sept 2025',
      'timeLeft': '3d left',
      'amount': '5,200',
      'likes': 8,
      'comments': 1,
      'liked': false,
    },
    {
      'title': 'AI will pass Turing Test by 2030',
      'timeLeft': '7d left',
      'amount': '1,800',
      'likes': 20,
      'comments': 5,
      'liked': false,
    },
  ];
  final List<Map<String, dynamic>> exploreFeed = [
    {
      'title': 'Ethereum will reach \$10k by 2027',
      'timeLeft': '2d left',
      'amount': '2,100',
      'likes': 5,
      'comments': 2,
      'liked': false,
    },
    {
      'title': 'Dogecoin to \$1 by 2025',
      'timeLeft': '5d left',
      'amount': '900',
      'likes': 15,
      'comments': 4,
      'liked': false,
    },
  ];
  final List<Map<String, dynamic>> searchFeed = [
    {
      'title': 'OpenAI will IPO by 2026',
      'timeLeft': '1d left',
      'amount': '4,000',
      'likes': 7,
      'comments': 1,
      'liked': false,
    },
  ];
  final List<Map<String, dynamic>> followingFeed = [
    {
      'title': 'Your friend predicted: ETH > \$5k in 2024',
      'timeLeft': '12h left',
      'amount': '1,200',
      'likes': 2,
      'comments': 0,
      'liked': false,
    },
  ];
  final List<Map<String, dynamic>> liveFeed = [
    {
      'title': 'Live: Will BTC break \$70k today?',
      'timeLeft': 'Live',
      'amount': '6,000',
      'likes': 30,
      'comments': 10,
      'liked': false,
    },
  ];

  int selectedTab = 0;

  List<Map<String, dynamic>> get currentFeed {
    switch (selectedTab) {
      case 0:
        return forYouFeed;
      case 1:
        return exploreFeed;
      case 2:
        return searchFeed;
      case 3:
        return followingFeed;
      case 4:
        return liveFeed;
      default:
        return forYouFeed;
    }
  }

  void _showCreatePredictionScreen(BuildContext context) {
    _showCreatePredictionScreen(context);
  }

  void _goToProfile(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  void _toggleLike(int index) {
    setState(() {
      currentFeed[index]['liked'] = !(currentFeed[index]['liked'] as bool);
      if (currentFeed[index]['liked']) {
        currentFeed[index]['likes']++;
      } else {
        currentFeed[index]['likes']--;
      }
    });
  }

  void _showComments(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CommentsModal(prediction: currentFeed[index]),
    );
  }

  void _showExploreModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ExploreModal(),
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SearchModal(),
    );
  }

  void _showFollowingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const FollowingModal(),
    );
  }

  void _showLiveModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LiveModal(),
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const NotificationsModal(),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = (screenWidth - 40) / 4; // 40 is total horizontal padding

    final feed = currentFeed;
    if (feed.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Stack(
      children: [
        // Vertical swipe navigation
        Padding(
          padding: EdgeInsets.only(
            top: padding.top + 60,
          ), // Add space for top bar
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: feed.length,
            itemBuilder: (context, index) {
              final pred = feed[index];
              return PredictionCard(
                title: pred['title'] as String,
                timeLeft: pred['timeLeft'] as String,
                amount: pred['amount'] as String,
                likes: pred['likes'] as int,
                comments: pred['comments'] as int,
                liked: pred['liked'] as bool,
                onLike: () => _toggleLike(index),
                onComment: () => _showComments(context, index),
              );
            },
          ),
        ),
        // 1. FeedPage top bar: simple row of icons at the top
        Positioned(
          top: padding.top + 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  _FeedTabIcon(
                    icon: Icons.explore,
                    label: 'Explore',
                    selected: false,
                    onTap: () => _showExploreModal(context),
                  ),
                  const SizedBox(width: 8),
                  _FeedTabIcon(
                    icon: Icons.search,
                    label: 'Search',
                    selected: false,
                    onTap: () => _showSearchModal(context),
                  ),
                  const SizedBox(width: 8),
                  _FeedTabIcon(
                    icon: Icons.people,
                    label: 'Following',
                    selected: false,
                    onTap: () => _showFollowingModal(context),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                onPressed: () => _showNotificationsModal(context),
                tooltip: 'Notifications',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeedTabIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FeedTabIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected
                  ? const Color(0xFF7B61FF).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      selected ? const Color(0xFF7B61FF) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : Colors.white54,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: selected ? const Color(0xFF7B61FF) : Colors.white54,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionCard extends StatefulWidget {
  final String title;
  final String timeLeft;
  final String amount;
  final int likes;
  final int comments;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PredictionCard({
    super.key,
    required this.title,
    required this.timeLeft,
    required this.amount,
    required this.likes,
    required this.comments,
    required this.liked,
    required this.onLike,
    required this.onComment,
  });

  @override
  State<PredictionCard> createState() => _PredictionCardState();
}

class _PredictionCardState extends State<PredictionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showStakeScreen(BuildContext context, String stakeOn) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StakeScreen(stakeOn: stakeOn),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(24);
    final neonGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.7),
        theme.colorScheme.secondary.withOpacity(0.7),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Stack(
            children: [
              // Neon border and glass background
              Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: neonGradient,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.tertiary.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.72),
                        borderRadius: borderRadius,
                        border: Border.all(
                          width: 2.5,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top media/visual
                          Stack(
                            children: [
                              Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(
                                        0.18,
                                      ),
                                      theme.colorScheme.secondary.withOpacity(
                                        0.12,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.show_chart_outlined,
                                    color: theme.colorScheme.tertiary,
                                    size: 42,
                                    shadows: [
                                      Shadow(
                                        color: theme.colorScheme.tertiary
                                            .withOpacity(0.5),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Category tag
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.secondary
                                            .withOpacity(0.12),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Crypto',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                  ),
                                ),
                              ),
                              // Live indicator
                              if (widget.timeLeft == 'Live')
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.redAccent.withOpacity(
                                            0.12,
                                          ),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.tertiary,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme
                                                    .colorScheme
                                                    .tertiary
                                                    .withOpacity(0.5),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'LIVE',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    UserAvatar(name: '@username', radius: 20),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@username',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                fontSize: 16,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                        ),
                                        Text(
                                          '2 hours ago',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: theme
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color
                                                    ?.withOpacity(0.6),
                                                fontSize: 13,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  widget.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                    shadows: [
                                      Shadow(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: theme.colorScheme.secondary
                                              .withOpacity(0.3),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.colorScheme.secondary
                                            .withOpacity(0.08),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_outlined,
                                            color: theme.colorScheme.secondary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            widget.timeLeft,
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  color:
                                                      theme
                                                          .colorScheme
                                                          .secondary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: theme.colorScheme.tertiary
                                              .withOpacity(0.3),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: theme.colorScheme.tertiary
                                            .withOpacity(0.08),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.attach_money_outlined,
                                            color: theme.colorScheme.tertiary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            widget.amount,
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  color:
                                                      theme
                                                          .colorScheme
                                                          .tertiary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              theme.colorScheme.tertiary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          elevation: 4,
                                          shadowColor: theme
                                              .colorScheme
                                              .tertiary
                                              .withOpacity(0.3),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        onPressed:
                                            () => _showStakeScreen(
                                              context,
                                              'YES',
                                            ),
                                        child: const Text('Stake Yes'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              theme.colorScheme.secondary,
                                          side: BorderSide(
                                            color: theme.colorScheme.secondary,
                                            width: 2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        onPressed:
                                            () =>
                                                _showStakeScreen(context, 'NO'),
                                        child: Text(
                                          'Stake No',
                                          style: TextStyle(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Action buttons (floating, right)
              Positioned(
                right: 20,
                bottom: 20,
                child: Column(
                  children: [
                    AnimatedTap(
                      onTap: widget.onLike,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.tertiary.withOpacity(
                                0.2,
                              ),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.liked
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color:
                              widget.liked
                                  ? theme.colorScheme.tertiary
                                  : theme.iconTheme.color,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.tertiary.withOpacity(
                                0.5,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                          semanticLabel: widget.liked ? 'Unlike' : 'Like',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedTap(
                      onTap: widget.onComment,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.2,
                              ),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.comment_outlined,
                          color: theme.iconTheme.color,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.5,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                          semanticLabel: 'Comment',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedTap(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.bookmark_outline,
                          color: theme.iconTheme.color,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.primary.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                          semanticLabel: 'Bookmark',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedTap(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.tertiary.withOpacity(
                                0.2,
                              ),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: theme.iconTheme.color,
                          size: 24,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.tertiary.withOpacity(
                                0.5,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                          semanticLabel: 'Share',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String? name;
  final double radius;
  const UserAvatar({this.name, this.radius = 16, super.key});

  @override
  Widget build(BuildContext context) {
    final initials =
        (name != null && name!.isNotEmpty)
            ? name!
                .trim()
                .split(' ')
                .map((e) => e[0])
                .take(2)
                .join()
                .toUpperCase()
            : '';
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child:
          initials.isNotEmpty
              ? Text(
                initials,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.9,
                ),
              )
              : Icon(
                Icons.person_outline,
                size: radius,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
    );
  }
}

class StakeScreen extends StatefulWidget {
  final String stakeOn;

  const StakeScreen({super.key, required this.stakeOn});

  @override
  State<StakeScreen> createState() => _StakeScreenState();
}

class _StakeScreenState extends State<StakeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.vertical(top: Radius.circular(22));
    final neonGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.7),
        theme.colorScheme.secondary.withOpacity(0.7),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        gradient: neonGradient,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withOpacity(0.25),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.72),
              borderRadius: borderRadius,
              border: Border.all(
                width: 2.5,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  // Neon pill handle
                  Container(
                    margin: const EdgeInsets.only(top: 14, bottom: 8),
                    width: 48,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.tertiary.withOpacity(0.18),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  // Minimal header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stake',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            size: 22,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: theme.dividerColor, height: 1, thickness: 1),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Stake on: ',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: 'YES',
                                  style: TextStyle(
                                    color:
                                        widget.stakeOn == 'YES'
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' or ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: 'NO',
                                  style: TextStyle(
                                    color:
                                        widget.stakeOn == 'NO'
                                            ? theme.colorScheme.secondary
                                            : theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Current pool',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.background.withOpacity(
                                0.85,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.08,
                                ),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.06,
                                  ),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'YES',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '￠2,400',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.tertiary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'NO',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '￠1,000',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Text(
                                'Expected return',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '1.8x',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter amount',
                              filled: true,
                              fillColor: theme.colorScheme.background
                                  .withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.18,
                                  ),
                                  width: 1.2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: theme.colorScheme.primary
                                    .withOpacity(0.18),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                textStyle: theme.textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Confirm Stake'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePredictionScreen extends StatefulWidget {
  const CreatePredictionScreen({super.key});

  @override
  State<CreatePredictionScreen> createState() => _CreatePredictionScreenState();
}

class _CreatePredictionScreenState extends State<CreatePredictionScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  final _predictionController = TextEditingController();
  String? _mediaPath;
  String _outcomeType = 'Yes/No';
  DateTime? _expiry;
  String _visibility = 'Public';
  String _stakeType = 'STRK';
  String _stakeAmount = '';
  late AnimationController _modalAnimController;

  List<String> get outcomeTypes => ['Yes/No', 'Range', 'Custom'];
  List<String> get visibilityOptions => ['Public', 'Anonymous', 'Invite-only'];

  bool get canPublish =>
      _predictionController.text.trim().isNotEmpty &&
      _outcomeType.isNotEmpty &&
      _expiry != null &&
      _visibility.isNotEmpty &&
      _stakeAmount.isNotEmpty;

  void _nextStep() {
    if (_step < 5) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  void initState() {
    super.initState();
    _modalAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _modalAnimController.dispose();
    _predictionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.vertical(top: Radius.circular(32));
    final neonGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.7),
        theme.colorScheme.secondary.withOpacity(0.7),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return FadeTransition(
      opacity: _modalAnimController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _modalAnimController, curve: Curves.easeOut),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            gradient: neonGradient,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.tertiary.withOpacity(0.25),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    // Playful pill-shaped handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 14, bottom: 8),
                      width: 48,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    // Header with crystal ball icon
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: theme.colorScheme.tertiary.withOpacity(
                                  0.8,
                                ),
                                size: 26,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'New Prediction',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: theme.colorScheme.onSurface,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    // Stepper
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (i) => _buildStepDot(i, theme),
                        ),
                      ),
                    ),
                    Divider(color: theme.dividerColor, height: 1, thickness: 1),
                    // Content
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder:
                            (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                        child: Padding(
                          key: ValueKey(_step),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          child: _buildStepContent(theme),
                        ),
                      ),
                    ),
                    // Step navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          if (_step > 0)
                            OutlinedButton(
                              onPressed: _prevStep,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.tertiary,
                                side: BorderSide(
                                  color: theme.colorScheme.tertiary,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                textStyle: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Back'),
                            ).animate().scale(
                              duration: 200.ms,
                              curve: Curves.easeOut,
                            ),
                          if (_step > 0) const SizedBox(width: 16),
                          Expanded(
                            child:
                                _step < 5
                                    ? ElevatedButton(
                                      onPressed:
                                          _canContinue() ? _nextStep : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.tertiary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        elevation: 8,
                                        shadowColor: theme.colorScheme.tertiary
                                            .withOpacity(0.3),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        textStyle: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      child: const Text('Continue'),
                                    ).animate().scale(
                                      duration: 200.ms,
                                      curve: Curves.easeOut,
                                    )
                                    : ElevatedButton(
                                      onPressed:
                                          canPublish
                                              ? () => Navigator.pop(context)
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            canPublish
                                                ? theme.colorScheme.primary
                                                : theme.disabledColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        elevation: 8,
                                        shadowColor: theme.colorScheme.primary
                                            .withOpacity(0.3),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        textStyle: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      child: const Text('Publish Prediction'),
                                    ).animate().shimmer(
                                      color: theme.colorScheme.tertiary,
                                      duration: 400.ms,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canContinue() {
    switch (_step) {
      case 0:
        return _predictionController.text.trim().isNotEmpty;
      case 1:
        return true; // Media is optional
      case 2:
        return _outcomeType.isNotEmpty;
      case 3:
        return _expiry != null;
      case 4:
        return _visibility.isNotEmpty;
      case 5:
        return _stakeAmount.isNotEmpty;
      default:
        return false;
    }
  }

  Widget _buildStepDot(int i, ThemeData theme) {
    final isActive = i == _step;
    return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 22 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color:
                isActive
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.secondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: theme.colorScheme.tertiary.withOpacity(0.7),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
        )
        .animate(target: isActive ? 1 : 0)
        .scale(duration: 200.ms, curve: Curves.easeOut);
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_step) {
      case 0:
        return Column(
          key: const ValueKey('step0'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1: Write your prediction',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _predictionController,
              decoration: InputDecoration(
                hintText: 'Type your prediction... (required)',
                counterText: '${_predictionController.text.length}/240',
                filled: true,
                fillColor: theme.colorScheme.background.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 1.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
              ),
              maxLength: 240,
              maxLines: 3,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        );
      case 1:
        return Column(
          key: const ValueKey('step1'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2: Upload image or video (optional)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {}, // TODO: Implement media picker
              child: DottedBorder(
                color: theme.colorScheme.secondary,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 3],
                strokeWidth: 1.5,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child:
                      _mediaPath == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: theme.colorScheme.secondary,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          )
                          : Text('Media preview here'), // TODO: Show preview
                ),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          key: const ValueKey('step2'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 3: Choose outcome type',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children:
                  outcomeTypes
                      .map(
                        (type) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(type),
                              selected: _outcomeType == type,
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _outcomeType = type);
                              },
                              selectedColor: theme.colorScheme.tertiary,
                              backgroundColor: theme.colorScheme.surface
                                  .withOpacity(0.3),
                              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    _outcomeType == type
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        );
      case 3:
        return Column(
          key: const ValueKey('step3'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 4: Set expiry', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 365)),
                  builder:
                      (context, child) => Theme(
                        data: theme.copyWith(
                          colorScheme: theme.colorScheme.copyWith(
                            primary: theme.colorScheme.tertiary,
                          ),
                        ),
                        child: child!,
                      ),
                );
                if (picked != null) {
                  setState(() => _expiry = picked);
                }
              },
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                _expiry == null
                    ? 'Pick expiry date'
                    : 'Expiry: ${_expiry!.toLocal().toString().split(' ')[0]}',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.secondary,
                side: BorderSide(color: theme.colorScheme.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        );
      case 4:
        return Column(
          key: const ValueKey('step4'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 5: Choose visibility',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Column(
              children:
                  visibilityOptions
                      .map(
                        (option) => ListTile(
                          leading: Icon(
                            option == 'Public'
                                ? Icons.public
                                : option == 'Anonymous'
                                ? Icons.visibility_off
                                : Icons.lock_outline,
                            color:
                                _visibility == option
                                    ? theme.colorScheme.tertiary
                                    : theme.colorScheme.secondary,
                          ),
                          title: Text(
                            option,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            option == 'Public'
                                ? 'Visible to everyone'
                                : option == 'Anonymous'
                                ? 'ZK identity attached'
                                : 'Invite-only (Farcaster/Lens tags)',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing: Radio<String>(
                            value: option,
                            groupValue: _visibility,
                            onChanged:
                                (val) => setState(() => _visibility = val!),
                            activeColor: theme.colorScheme.tertiary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor:
                              _visibility == option
                                  ? theme.colorScheme.tertiary.withOpacity(0.08)
                                  : null,
                        ),
                      )
                      .toList(),
            ),
          ],
        );
      case 5:
        return Column(
          key: const ValueKey('step5'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 6: Stake initial amount',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('STRK'),
                  selected: _stakeType == 'STRK',
                  onSelected: (selected) {
                    if (selected) setState(() => _stakeType = 'STRK');
                  },
                  selectedColor: theme.colorScheme.tertiary,
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        _stakeType == 'STRK'
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Points'),
                  selected: _stakeType == 'Points',
                  onSelected: (selected) {
                    if (selected) setState(() => _stakeType = 'Points');
                  },
                  selectedColor: theme.colorScheme.tertiary,
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        _stakeType == 'Points'
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter amount',
                filled: true,
                fillColor: theme.colorScheme.background.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 1.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
              ),
              keyboardType: TextInputType.number,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: theme.colorScheme.onSurface,
              ),
              onChanged: (val) => setState(() => _stakeAmount = val),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation ?? 0,
        titleSpacing: 0,
        title: Row(
          children: [
            // Remove small avatar here, move to header below
            // UserAvatar(name: '@yourname', radius: 16),
            // const SizedBox(width: 8),
            Text(
              'Profile',
              style:
                  theme.appBarTheme.titleTextStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color:
                  theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color,
              size: 20,
              semanticLabel: 'Settings',
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        children: [
          // Glassy profile header
          Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.18),
                  theme.colorScheme.secondary.withOpacity(0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.7),
                            theme.colorScheme.tertiary.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.18),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    UserAvatar(name: '@yourname', radius: 42),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Your Name',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@yourname',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Web3 enthusiast. Predicting the future, one stake at a time.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ProfileStat(
                      icon: Icons.show_chart,
                      label: 'Predictions',
                      value: '24',
                      color: theme.colorScheme.primary,
                    ),
                    _ProfileStat(
                      icon: Icons.people,
                      label: 'Followers',
                      value: '1.2k',
                      color: theme.colorScheme.secondary,
                    ),
                    _ProfileStat(
                      icon: Icons.person_add_alt_1,
                      label: 'Following',
                      value: '180',
                      color: theme.colorScheme.tertiary,
                    ),
                    _ProfileStat(
                      icon: Icons.emoji_events,
                      label: 'Win Rate',
                      value: '68%',
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 6,
                      shadowColor: theme.colorScheme.tertiary.withOpacity(0.18),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
          // Glassy, pill-shaped tab bar
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProfileTab(
                  label: 'Active',
                  selected: selectedTab == 0,
                  onTap: () => setState(() => selectedTab = 0),
                  icon: Icons.flash_on,
                  color: theme.colorScheme.primary,
                ),
                _ProfileTab(
                  label: 'History',
                  selected: selectedTab == 1,
                  onTap: () => setState(() => selectedTab = 1),
                  icon: Icons.history,
                  color: theme.colorScheme.secondary,
                ),
                _ProfileTab(
                  label: 'Likes',
                  selected: selectedTab == 2,
                  onTap: () => setState(() => selectedTab = 2),
                  icon: Icons.favorite,
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder:
                (child, anim) => FadeTransition(opacity: anim, child: child),
            child: _buildProfileTabContent(selectedTab, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTabContent(int tab, ThemeData theme) {
    if (tab == 0) {
      // Active predictions (demo data)
      final activePredictions = [
        {
          'title': 'Solana will flip Ethereum in market cap by 2026',
          'amount': '3,400',
          'status': 'Ongoing',
          'stake': 'YES',
          'time': '12h left',
        },
        {
          'title': 'BTC to \$80k by Sept 2025',
          'amount': '5,200',
          'status': 'Ongoing',
          'stake': 'NO',
          'time': '3d left',
        },
      ];
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activePredictions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final pred = activePredictions[i];
          return GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.13),
                        theme.colorScheme.secondary.withOpacity(0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        blurRadius: 14,
                      ),
                    ],
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.10),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.show_chart,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (pred['title'] as String?) ?? '',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiary
                                        .withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (pred['stake'] as String?) ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.access_time,
                                  color: theme.colorScheme.secondary,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (pred['time'] as String?) ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: theme.colorScheme.primary,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (pred['amount'] as String?) ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (pred['status'] as String?) ?? 'Ongoing',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(delay: (i * 80).ms, duration: 300.ms),
          );
        },
      );
    }
    if (tab == 1) {
      // History tab: resolved/expired predictions
      final historyPredictions = [
        {
          'title': 'ETH will reach \$10k by 2027',
          'amount': '2,100',
          'outcome': 'Won',
          'stake': 'YES',
          'time': 'Ended 2d ago',
        },
        {
          'title': 'Dogecoin to \$1 by 2025',
          'amount': '900',
          'outcome': 'Lost',
          'stake': 'NO',
          'time': 'Ended 5d ago',
        },
      ];
      if (historyPredictions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: theme.colorScheme.primary.withOpacity(0.18),
              ),
              const SizedBox(height: 12),
              Text(
                'No history yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: historyPredictions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final pred = historyPredictions[i];
          final isWon = pred['outcome'] == 'Won';
          return GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isWon
                            ? theme.colorScheme.primary.withOpacity(0.13)
                            : theme.colorScheme.secondary.withOpacity(0.10),
                        theme.colorScheme.surface.withOpacity(0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (isWon
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary)
                            .withOpacity(0.08),
                        blurRadius: 14,
                      ),
                    ],
                    border: Border.all(
                      color: (isWon
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary)
                          .withOpacity(0.10),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isWon
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary)
                              .withOpacity(0.13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWon ? Icons.emoji_events : Icons.close,
                          color:
                              isWon
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (pred['title'] as String?) ?? '',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiary
                                        .withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (pred['stake'] as String?) ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.access_time,
                                  color: theme.colorScheme.secondary,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (pred['time'] as String?) ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: theme.colorScheme.primary,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (pred['amount'] as String?) ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isWon
                                            ? theme.colorScheme.primary
                                                .withOpacity(0.10)
                                            : theme.colorScheme.secondary
                                                .withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (pred['outcome'] as String?) ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          isWon
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.visibility,
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  tooltip: 'View Details',
                                  splashRadius: 22,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: theme.colorScheme.secondary,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  tooltip: 'Share',
                                  splashRadius: 22,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(delay: (i * 80).ms, duration: 300.ms),
          );
        },
      );
    }
    if (tab == 2) {
      // Likes tab: liked predictions
      final likedPredictions = [
        {
          'title': 'AI will pass Turing Test by 2030',
          'amount': '1,800',
          'status': 'Ongoing',
          'stake': 'YES',
          'time': '7d left',
          'liked': true,
        },
        {
          'title': 'OpenAI will IPO by 2026',
          'amount': '4,000',
          'status': 'Ongoing',
          'stake': 'NO',
          'time': '1d left',
          'liked': true,
        },
      ];
      if (likedPredictions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 48,
                color: theme.colorScheme.tertiary.withOpacity(0.18),
              ),
              const SizedBox(height: 12),
              Text(
                'No liked predictions yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: likedPredictions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final pred = likedPredictions[i];
          bool liked = pred['liked'] as bool;
          return GestureDetector(
            onTap: () {},
            child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.tertiary.withOpacity(0.13),
                        theme.colorScheme.surface.withOpacity(0.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiary.withOpacity(0.08),
                        blurRadius: 14,
                      ),
                    ],
                    border: Border.all(
                      color: theme.colorScheme.tertiary.withOpacity(0.10),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary.withOpacity(0.13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: theme.colorScheme.tertiary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (pred['title'] as String?) ?? '',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiary
                                        .withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (pred['stake'] as String?) ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.access_time,
                                  color: theme.colorScheme.secondary,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (pred['time'] as String?) ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: theme.colorScheme.primary,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  pred['amount'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiary
                                        .withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    (pred['status'] ?? 'Ongoing') as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder:
                                        (child, anim) => ScaleTransition(
                                          scale: anim,
                                          child: child,
                                        ),
                                    child:
                                        liked
                                            ? Icon(
                                              Icons.favorite,
                                              key: ValueKey(true),
                                              color: theme.colorScheme.tertiary,
                                              size: 20,
                                            )
                                            : Icon(
                                              Icons.favorite_border,
                                              key: ValueKey(false),
                                              color: theme.colorScheme.tertiary,
                                              size: 20,
                                            ),
                                  ),
                                  onPressed: () {
                                    // Animate like/unlike (in real app, update state)
                                  },
                                  tooltip: liked ? 'Unlike' : 'Like',
                                  splashRadius: 22,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.visibility,
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  tooltip: 'View Details',
                                  splashRadius: 22,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: theme.colorScheme.secondary,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  tooltip: 'Share',
                                  splashRadius: 22,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(delay: (i * 80).ms, duration: 300.ms),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  double textScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        children: [
          Text('General', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            title: const Text(
              'Enable Notifications',
              semanticsLabel: 'Enable Notifications',
            ),
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
            secondary: const Icon(
              Icons.notifications_active,
              semanticLabel: 'Notifications Icon',
            ),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(height: 32),
          Text('Accessibility', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Text Size', semanticsLabel: 'Text Size'),
            subtitle: Slider(
              value: textScale,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: '${(textScale * 100).toInt()}%',
              onChanged: (val) => setState(() => textScale = val),
              semanticFormatterCallback:
                  (val) => '${(val * 100).toInt()} percent',
            ),
            leading: const Icon(
              Icons.text_fields,
              semanticLabel: 'Text Size Icon',
            ),
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(height: 32),
          Text('Account', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person, semanticLabel: 'Account Icon'),
            title: const Text('Account Info', semanticsLabel: 'Account Info'),
            subtitle: const Text('Username: @yourname'),
            contentPadding: EdgeInsets.zero,
            onTap: () {},
          ),
          const Divider(height: 32),
          Text('About', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              semanticLabel: 'About Icon',
            ),
            title: const Text(
              'About This App',
              semanticsLabel: 'About This App',
            ),
            subtitle: const Text('Cassandra v1.0.0'),
            contentPadding: EdgeInsets.zero,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class AnimatedTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const AnimatedTap({required this.child, this.onTap, super.key});
  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scale = _controller.drive(Tween(begin: 1.0, end: 0.95));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp([_]) => _controller.forward();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const SplashScreen({required this.onContinue, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late AnimationController _bgController;
  late Animation<double> _gradientAnim;
  bool _showTooltip = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _gradientAnim = Tween<double>(begin: 0, end: 1).animate(_bgController);
    // Tooltip after 10s
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) setState(() => _showTooltip = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 420;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _gradientAnim,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _AnimatedGradientPainter(_gradientAnim.value),
              );
            },
          ),
          // Particle shimmer
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _bgController,
                builder:
                    (context, child) => CustomPaint(
                      painter: _ParticlePainter(_bgController.value),
                    ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.18),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // 3. Typewriter effect for app name
                _TypewriterText(
                  text: 'Cassandra',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  duration: const Duration(milliseconds: 1200),
                ),
                const SizedBox(height: 8),
                Text(
                  'Predict the Future',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 48),
                isSmallScreen
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GlassButton(
                          text: 'Get Started',
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            await _audioPlayer.play(
                              AssetSource('sounds/chime.mp3'),
                            );
                            widget.onContinue();
                          },
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 18),
                        _GlassButton(
                          text: 'Continue as Guest',
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            await _audioPlayer.play(
                              AssetSource('sounds/chime.mp3'),
                            );
                            widget.onContinue();
                          },
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _GlassButton(
                          text: 'Get Started',
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            await _audioPlayer.play(
                              AssetSource('sounds/chime.mp3'),
                            );
                            widget.onContinue();
                          },
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 18),
                        _GlassButton(
                          text: 'Continue as Guest',
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            await _audioPlayer.play(
                              AssetSource('sounds/chime.mp3'),
                            );
                            widget.onContinue();
                          },
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
              ],
            ),
          ),
          // 5. Timeout tooltip
          if (_showTooltip)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.18),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Text(
                    'Dive into predictions shaping the future → Tap Get Started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Animated gradient painter
class _AnimatedGradientPainter extends CustomPainter {
  final double t;
  _AnimatedGradientPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      colors: [
        Color.lerp(const Color(0xFF8C52FF), const Color(0xFFFF2DCA), t)!,
        Color.lerp(const Color(0xFF00E5FF), const Color(0xFF8C52FF), t)!,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant _AnimatedGradientPainter old) => old.t != t;
}

// Particle shimmer painter
class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);
  final int count = 18;
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    for (int i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = (size.height * (1 - ((t + i / count) % 1.0)));
      final radius = 1.5 + rnd.nextDouble() * 2.5;
      final color = [
        const Color(0xFF8C52FF),
        const Color(0xFFFF2DCA),
        const Color(0xFF00E5FF),
      ][i % 3].withOpacity(0.18 + 0.18 * rnd.nextDouble());
      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.t != t;
}

// Typewriter text widget
class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  const _TypewriterText({
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1200),
    super.key,
  });
  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final count =
            (widget.text.length * _controller.value)
                .clamp(0, widget.text.length)
                .toInt();
        return Text(widget.text.substring(0, count), style: widget.style);
      },
    );
  }
}

// Glassmorphism button
class _GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const _GlassButton({
    required this.text,
    required this.onPressed,
    required this.color,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.5), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
          backgroundBlendMode: BlendMode.screen,
        ),
        child: Text(
          text,
          style: GoogleFonts.sora(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onGuest;
  const OnboardingScreen({
    required this.onFinish,
    required this.onGuest,
    super.key,
  });
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      icon: Icons.swipe_vertical_rounded,
      title: 'Swipe to Explore',
      desc: 'Swipe up and down to discover predictions from the community.',
      color: Color(0xFF8C52FF),
    ),
    _OnboardingPageData(
      icon: Icons.add_box_rounded,
      title: 'Create Predictions',
      desc: 'Tap the + to create your own prediction and share your vision.',
      color: Color(0xFFFF2DCA),
    ),
    _OnboardingPageData(
      icon: Icons.stacked_line_chart,
      title: 'Stake & Earn',
      desc: 'Stake on outcomes and earn rewards for accurate predictions.',
      color: Color(0xFF00E5FF),
    ),
    _OnboardingPageData(
      icon: Icons.favorite_rounded,
      title: 'Engage & Connect',
      desc: 'Like, comment, and share your favorite predictions.',
      color: Color(0xFF8C52FF),
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final data = _pages[i];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: data.color.withOpacity(0.12),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: data.color.withOpacity(0.18),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Icon(
                        data.icon,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      data.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        data.desc,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
            // Skip button
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: widget.onGuest,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            // Dots and CTA
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i ? _pages[i].color : Colors.white24,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_page == _pages.length - 1)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallScreen = constraints.maxWidth < 400;
                        return isSmallScreen
                            ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _GlassButton(
                                  text: 'Get Started',
                                  onPressed: widget.onFinish,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(height: 18),
                                _GlassButton(
                                  text: 'Continue as Guest',
                                  onPressed: widget.onGuest,
                                  color: theme.colorScheme.secondary,
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _GlassButton(
                                  text: 'Get Started',
                                  onPressed: widget.onFinish,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 18),
                                _GlassButton(
                                  text: 'Continue as Guest',
                                  onPressed: widget.onGuest,
                                  color: theme.colorScheme.secondary,
                                ),
                              ],
                            );
                      },
                    )
                  else
                    ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_page].color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });
}

// Add this widget inside the ProfilePage file, after _ProfilePageState
class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.18), blurRadius: 8),
              ],
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// Add this widget after _ProfileStat
class _ProfileTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  const _ProfileTab({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow:
                selected
                    ? [
                      BoxShadow(color: color.withOpacity(0.18), blurRadius: 10),
                    ]
                    : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? color : color.withOpacity(0.5),
                size: 18,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? color : color.withOpacity(0.7),
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsModal extends StatelessWidget {
  const NotificationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.vertical(top: Radius.circular(22));
    final neonGradient = LinearGradient(
      colors: [
        theme.colorScheme.primary.withOpacity(0.7),
        theme.colorScheme.secondary.withOpacity(0.7),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: neonGradient,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withOpacity(0.25),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.72),
              borderRadius: borderRadius,
              border: Border.all(
                width: 2.5,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 14, bottom: 8),
                  width: 48,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiary.withOpacity(0.18),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(color: theme.dividerColor, height: 1, thickness: 1),
                Expanded(
                  child: Center(
                    child: Text(
                      'You have no notifications yet!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
