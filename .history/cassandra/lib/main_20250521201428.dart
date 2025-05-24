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
        backgroundColor: const Color(0xFF00FFF7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
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
      fillColor: const Color(0xFF181A22),
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
    dividerColor: Colors.white12,
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
    ProfilePage(),
  ];

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
    setState(() {
      _selectedIndex = index == 1 ? _selectedIndex : index;
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
          currentIndex:
              _selectedIndex > 1 ? _selectedIndex - 1 : _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, semanticLabel: 'Home'),
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
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const CreatePredictionScreen(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
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
