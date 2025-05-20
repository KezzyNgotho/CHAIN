import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10111A),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.dark,
        ),
      ),
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreatePredictionScreen()),
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

class _FeedPageState extends State<FeedPage> {
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePredictionScreen()),
    );
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vertical swipe navigation
        PageView.builder(
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
        // TikTok-style top icon bar
        Positioned(
          top: 32,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FeedTabIcon(
                icon: Icons.home,
                label: 'For You',
                selected: selectedTab == 0,
                onTap: () => setState(() => selectedTab = 0),
              ),
              const SizedBox(width: 18),
              _FeedTabIcon(
                icon: Icons.explore,
                label: 'Explore',
                selected: selectedTab == 1,
                onTap: () => setState(() => selectedTab = 1),
              ),
              const SizedBox(width: 18),
              _FeedTabIcon(
                icon: Icons.search,
                label: 'Search',
                selected: selectedTab == 2,
                onTap: () => setState(() => selectedTab = 2),
              ),
              const SizedBox(width: 18),
              _FeedTabIcon(
                icon: Icons.people,
                label: 'Following',
                selected: selectedTab == 3,
                onTap: () => setState(() => selectedTab = 3),
              ),
              const SizedBox(width: 18),
              _FeedTabIcon(
                icon: Icons.live_tv,
                label: 'Live',
                selected: selectedTab == 4,
                onTap: () => setState(() => selectedTab = 4),
              ),
            ],
          ),
        ),
        // Floating Action Button overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Center(
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF7B61FF),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () => _showCreatePredictionScreen(context),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: selected ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              icon,
              color: selected ? const Color(0xFF7B61FF) : Colors.white54,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF7B61FF) : Colors.white54,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StakeScreen(stakeOn: stakeOn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          // Card content (full width)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF181A24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart/Image placeholder
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF23263A),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.show_chart,
                      color: Color(0xFF7B61FF),
                      size: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white54,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                timeLeft,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Color(0xFF7B61FF),
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                amount,
                                style: const TextStyle(
                                  color: Color(0xFF7B61FF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF23263A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () => _showStakeScreen(context, 'YES'),
                              child: const Text('Stake Yes'),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF23263A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () => _showStakeScreen(context, 'NO'),
                              child: const Text('Stake No'),
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
          // Floating action bar (right, vertically centered)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color: liked ? const Color(0xFF7B61FF) : Colors.white,
                        size: 22,
                      ),
                      onPressed: onLike,
                    ),
                    Text(
                      '$likes',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.comment,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: onComment,
                    ),
                    Text(
                      '$comments',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {}, // TODO: implement save
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {}, // TODO: implement share
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          'Stake',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                    text: 'YES',
                    style: TextStyle(
                      color:
                          widget.stakeOn == 'YES'
                              ? Colors.blue[300]
                              : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const TextSpan(
                    text: ' or ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                    text: 'NO',
                    style: TextStyle(
                      color:
                          widget.stakeOn == 'NO'
                              ? Colors.red[300]
                              : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Current pool',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YE3',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '\$2,400',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'NO',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '\$1,000',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Text(
                  'Expected return',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                SizedBox(width: 6),
                Text(
                  '1.8x',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: const TextStyle(fontSize: 13),
                filled: true,
                fillColor: const Color(0xFF23263A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Confirm Stake'),
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
          'New Prediction',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Type your prediction...',
                hintStyle: const TextStyle(fontSize: 13),
                filled: true,
                fillColor: const Color(0xFF23263A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23263A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.folder_open, size: 18),
              label: const Text('Upload image/video'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23263A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.category, size: 18),
              label: const Text('Select category'),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Stake amount   (STRK)',
                hintStyle: const TextStyle(fontSize: 13),
                filled: true,
                fillColor: const Color(0xFF23263A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Create Prediction'),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Swipe for next prediction',
                style: TextStyle(color: Colors.white38, fontSize: 12),
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
