import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Theme switcher (for demo, use a variable; later, can be a settings menu)
enum AppTheme { livelyLight, livelyDark, forest, sunset, ocean }

AppTheme currentTheme = AppTheme.livelyDark; // Change this to switch themes

ThemeData getThemeData(AppTheme theme) {
  switch (theme) {
    case AppTheme.livelyLight:
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        primaryColor: const Color(0xFF7B61FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme.apply(bodyColor: Colors.black87),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FA),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF7B61FF)),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B61FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    case AppTheme.livelyDark:
      return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10111A),
        primaryColor: const Color(0xFF7B61FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181A24),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF7B61FF)),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF181A24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B61FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    case AppTheme.forest:
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
        primaryColor: const Color(0xFF388E3C),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF388E3C),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme.apply(bodyColor: Colors.green[900]),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE8F5E9),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF388E3C)),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF388E3C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    case AppTheme.sunset:
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF3E0),
        primaryColor: const Color(0xFFFF7043),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme.apply(bodyColor: Colors.deepOrange[900]),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF3E0),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFFFF7043)),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7043),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    case AppTheme.ocean:
      return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        primaryColor: const Color(0xFF0288D1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0288D1),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme.apply(bodyColor: Colors.blue[900]),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE3F2FD),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0288D1)),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0288D1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
  }
}

void main() {
  runApp(const CassandraApp());
}

class CassandraApp extends StatelessWidget {
  const CassandraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cassandra',
      theme: getThemeData(currentTheme),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FeedPage(),
    Placeholder(), // SearchPage
    Placeholder(), // NotificationsPage
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Add button (center) opens CreatePredictionScreen
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const CreatePredictionScreen(),
      );
      return;
    }
    setState(() {
      _selectedIndex = index < 2 ? index : index - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF181A24),
        selectedItemColor: const Color(0xFF7B61FF),
        unselectedItemColor: Colors.white54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex < 2 ? _selectedIndex : _selectedIndex + 1,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentsModal(prediction: currentFeed[index]),
      ),
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

    return Stack(
      children: [
        // Vertical swipe navigation
        Padding(
          padding: EdgeInsets.only(
            top: padding.top + 60,
          ), // Add space for top bar
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: currentFeed.length,
            itemBuilder: (context, index) {
              final pred = currentFeed[index];
              return PredictionCard(
                title: pred['title'],
                timeLeft: pred['timeLeft'],
                amount: pred['amount'],
                likes: pred['likes'],
                comments: pred['comments'],
                liked: pred['liked'],
                onLike: () => _toggleLike(index),
                onComment: () => _showComments(context, index),
              );
            },
          ),
        ),
        // TikTok-style top icon bar
        Positioned(
          top: padding.top + 16,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _FeedTabIcon(
                  icon: Icons.explore,
                  label: 'Explore',
                  selected: selectedTab == 1,
                  onTap: () => setState(() => selectedTab = 1),
                ),
                _FeedTabIcon(
                  icon: Icons.search,
                  label: 'Search',
                  selected: selectedTab == 2,
                  onTap: () => setState(() => selectedTab = 2),
                ),
                _FeedTabIcon(
                  icon: Icons.people,
                  label: 'Following',
                  selected: selectedTab == 3,
                  onTap: () => setState(() => selectedTab = 3),
                ),
                _FeedTabIcon(
                  icon: Icons.live_tv,
                  label: 'Live',
                  selected: selectedTab == 4,
                  onTap: () => setState(() => selectedTab = 4),
                ),
              ],
            ),
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

class PredictionCard extends StatelessWidget {
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
    final cardColor = theme.cardColor;
    final borderRadius =
        (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius ??
        BorderRadius.circular(10);
    final accent = theme.colorScheme.primary;
    final gradient = LinearGradient(
      colors: [accent.withOpacity(0.12), cardColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: accent.withOpacity(0.08), width: 1),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media content with more space
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accent.withOpacity(0.18), cardColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.show_chart_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    // Category tag
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Crypto',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    // Live indicator if applicable
                    if (timeLeft == 'Live')
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: accent,
                            child: const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@username',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              Text(
                                '2 hours ago',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.dividerColor.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_outlined,
                                  color: theme.iconTheme.color?.withOpacity(
                                    0.7,
                                  ),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  timeLeft,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: accent.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money_outlined,
                                  color: accent,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  amount,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Stake buttons at the bottom
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => _showStakeScreen(context, 'YES'),
                              child: const Text('Stake Yes'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: accent,
                                side: BorderSide(color: accent, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => _showStakeScreen(context, 'NO'),
                              child: Text(
                                'Stake No',
                                style: TextStyle(color: accent),
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
            // Action buttons
            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_outline,
                          color: liked ? accent : theme.iconTheme.color,
                          size: 20,
                        ),
                        splashRadius: 22,
                        onPressed: onLike,
                      ),
                      const SizedBox(width: 4),
                      Text('$likes', style: theme.textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          color: theme.iconTheme.color,
                          size: 20,
                        ),
                        splashRadius: 22,
                        onPressed: onComment,
                      ),
                      const SizedBox(width: 4),
                      Text('$comments', style: theme.textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 14),
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_outline,
                      color: theme.iconTheme.color,
                      size: 20,
                    ),
                    splashRadius: 22,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 14),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: theme.iconTheme.color,
                      size: 20,
                    ),
                    splashRadius: 22,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 14),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: accent,
                      size: 24,
                    ),
                    splashRadius: 22,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => const CreatePredictionScreen(),
                      );
                    },
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

class StakeScreen extends StatefulWidget {
  final String stakeOn;

  const StakeScreen({super.key, required this.stakeOn});

  @override
  State<StakeScreen> createState() => _StakeScreenState();
}

class _StakeScreenState extends State<StakeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF181A24),
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stake',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white12, height: 1, thickness: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Stake on: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'YES',
                            style: TextStyle(
                              color:
                                  widget.stakeOn == 'YES'
                                      ? Colors.blue[300]
                                      : Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                            text: ' or ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'NO',
                            style: TextStyle(
                              color:
                                  widget.stakeOn == 'NO'
                                      ? Colors.red[300]
                                      : Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Current pool',
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23263A),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white10, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'YES',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$2,400',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'NO',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$1,000',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Text(
                          'Expected return',
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '1.8x',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: const TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: const Color(0xFF23263A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Colors.white10,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFF7B61FF),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
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
    );
  }
}

class CreatePredictionScreen extends StatefulWidget {
  const CreatePredictionScreen({super.key});

  @override
  State<CreatePredictionScreen> createState() => _CreatePredictionScreenState();
}

class _CreatePredictionScreenState extends State<CreatePredictionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF181A24),
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Prediction',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white12, height: 1, thickness: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your prediction...',
                        hintStyle: const TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: const Color(0xFF23263A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Colors.white10,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF7B61FF),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              textStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.folder_open_outlined,
                              size: 16,
                            ),
                            label: const Text('Upload media'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF7B61FF),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              textStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.category_outlined, size: 16),
                            label: const Text('Category'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Stake amount (STRK)',
                        hintStyle: const TextStyle(fontSize: 12),
                        filled: true,
                        fillColor: const Color(0xFF23263A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Colors.white10,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFF7B61FF),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Create Prediction'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    return Scaffold(
      backgroundColor: const Color(0xFF10111A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF7B61FF),
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              '@yourname',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              children: [
                _buildTab('Active', 0),
                const SizedBox(width: 8),
                _buildTab('History', 1),
                const SizedBox(width: 8),
                _buildTab('Likes', 2),
              ],
            ),
            const SizedBox(height: 14),
            // Active prediction card
            if (selectedTab == 0)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF181A24),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart placeholder
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF23263A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.show_chart,
                          color: Color(0xFF7B61FF),
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You staked YE3 (\$20)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Status: Ongoing',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (selectedTab == 0) const SizedBox(height: 10),
            // List of active predictions
            if (selectedTab == 0)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF181A24),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flash_on,
                      color: Color(0xFF7B61FF),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'yoysffi/ok 12',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            if (selectedTab == 0) const SizedBox(height: 10),
            // Stats
            if (selectedTab == 0)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181A24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Color(0xFF7B61FF),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total wins:',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '12',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181A24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            value: 0.7,
                            color: Color(0xFF7B61FF),
                            backgroundColor: Color(0xFF23263A),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7B61FF) : const Color(0xFF23263A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class CommentsModal extends StatefulWidget {
  final Map<String, dynamic> prediction;

  const CommentsModal({super.key, required this.prediction});

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10111A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your comments list here
            const Center(
              child: Text(
                'No comments yet',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
