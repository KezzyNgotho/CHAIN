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
    scaffoldBackgroundColor: const Color(0xFF111111),
    primaryColor: const Color(0xFFFFFFFF),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFFDDDDDD),
      background: const Color(0xFF111111),
      surface: const Color(0xFF151515), // Slightly lighter than background
      onPrimary: const Color(0xFF111111),
      onSecondary: const Color(0xFF111111),
      onBackground: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFFFFFFFF),
      tertiary: const Color(0xFFDDDDDD),
      error: const Color(0xFFFF2D55),
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 26, // Reduced from 28
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
          letterSpacing: 0.6, // Reduced from 0.8
        ),
        headlineMedium: const TextStyle(
          fontSize: 20, // Reduced from 22
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
          letterSpacing: 0.4, // Reduced from 0.6
        ),
        titleLarge: const TextStyle(
          fontSize: 17, // Reduced from 18
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        titleMedium: const TextStyle(
          fontSize: 15, // Reduced from 16
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        bodyLarge: const TextStyle(
          fontSize: 14, // Reduced from 15
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
        bodyMedium: const TextStyle(
          fontSize: 13,
          color: Color(0xFFDDDDDD),
        ), // Reduced from 14
        bodySmall: const TextStyle(
          fontSize: 11,
          color: Color(0xFFDDDDDD),
        ), // Reduced from 12
        labelLarge: const TextStyle(
          fontSize: 12, // Reduced from 13
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        labelMedium: const TextStyle(
          fontSize: 11,
          color: Color(0xFFFFFFFF),
        ), // Reduced from 12
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111111),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w600,
        fontSize: 15, // Reduced from 16
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF151515),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ), // Reduced from 10
      elevation: 0,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4,
      ), // Reduced from 6
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF151515),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Reduced from 14
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 15, // Reduced from 16
        fontWeight: FontWeight.w600,
        color: const Color(0xFFFFFFFF),
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 13,
        color: const Color(0xFFDDDDDD),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), // Reduced from 10
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 18,
        ), // Reduced from 12,20
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ), // Reduced from 13
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFFFFFF),
        side: const BorderSide(color: Color(0xFFFFFFFF), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), // Reduced from 10
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 18,
        ), // Reduced from 12,20
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ), // Reduced from 13
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF151515),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Reduced from 10
        borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Reduced from 10
        borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Reduced from 10
        borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 1),
      ),
      hintStyle: const TextStyle(color: Color(0xFFDDDDDD), fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ), // Reduced from 12,14
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
    dividerColor: const Color(0xFF1A1A1A), // Slightly lighter than before
    splashColor: const Color(0xFFFFFFFF).withOpacity(0.04), // Reduced from 0.08
    highlightColor: const Color(
      0xFFFFFFFF,
    ).withOpacity(0.03), // Reduced from 0.06
    hoverColor: const Color(0xFFFFFFFF).withOpacity(0.03), // Reduced from 0.06
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FeedTabIcon(
                icon: Icons.explore,
                label: 'Explore',
                selected: false,
                onTap: () => _showExploreModal(context),
              ),
              _FeedTabIcon(
                icon: Icons.search,
                label: 'Search',
                selected: false,
                onTap: () => _showSearchModal(context),
              ),
              _FeedTabIcon(
                icon: Icons.people,
                label: 'Following',
                selected: false,
                onTap: () => _showFollowingModal(context),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 18,
                ),
                onPressed: () => _showNotificationsModal(context),
                tooltip: 'Notifications',
              ),
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
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: selected ? const Color(0xFF7B61FF) : Colors.white54,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 10,
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
      duration: const Duration(milliseconds: 150),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(12);

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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: borderRadius,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      widget.timeLeft,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.amount,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Right side icons (TikTok style)
              Positioned(
                right: 16,
                bottom: 80,
                child: Column(
                  children: [
                    _ActionButton(
                      icon: widget.liked ? Icons.favorite : Icons.favorite_border,
                      label: widget.likes.toString(),
                      color: widget.liked ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                      onTap: widget.onLike,
                    ),
                    const SizedBox(height: 16),
                    _ActionButton(
                      icon: Icons.comment_outlined,
                      label: widget.comments.toString(),
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      onTap: widget.onComment,
                    ),
                    const SizedBox(height: 16),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Remove the bottom actions container since we moved them to the right
              // Actions
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 12,
              //   ),
              //   decoration: BoxDecoration(
              //     color: theme.colorScheme.surface.withOpacity(0.5),
              //     borderRadius: BorderRadius.only(
              //       bottomLeft: const Radius.circular(12),
              //       bottomRight: const Radius.circular(12),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       _ActionButton(
              //         icon:
              //             widget.liked ? Icons.favorite : Icons.favorite_border,
              //         label: widget.likes.toString(),
              //         color:
              //             widget.liked
              //                 ? theme.colorScheme.primary
              //                 : theme.colorScheme.onSurface.withOpacity(0.6),
              //         onTap: widget.onLike,
              //       ),
              //       const SizedBox(width: 16),
              //       _ActionButton(
              //         icon: Icons.comment_outlined,
              //         label: widget.comments.toString(),
              //         color: theme.colorScheme.onSurface.withOpacity(0.6),
              //         onTap: widget.onComment,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
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
                BoxShadow(color: color.withOpacity(0.12), blurRadius: 6),
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
                    ? [BoxShadow(color: color.withOpacity(0.12), blurRadius: 8)]
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
