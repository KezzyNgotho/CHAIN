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
  final List<Map<String, dynamic>> predictions = [
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

  void _showCreatePredictionModal(BuildContext context) {
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
      predictions[index]['liked'] = !(predictions[index]['liked'] as bool);
      if (predictions[index]['liked']) {
        predictions[index]['likes']++;
      } else {
        predictions[index]['likes']--;
      }
    });
  }

  void _showComments(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentsModal(prediction: predictions[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF7B61FF),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
        ),
        title: Text(
          'Cassandra',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => _goToProfile(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final pred = predictions[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 24),
            child: PredictionCard(
              title: pred['title'],
              timeLeft: pred['timeLeft'],
              amount: pred['amount'],
              likes: pred['likes'],
              comments: pred['comments'],
              liked: pred['liked'],
              onLike: () => _toggleLike(index),
              onComment: () => _showComments(context, index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B61FF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showCreatePredictionModal(context),
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

  void _showStakeModal(BuildContext context, String stakeOn) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StakeScreen(stakeOn: stakeOn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181A24),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF23263A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: const Center(
              child: Icon(Icons.show_chart, color: Color(0xFF7B61FF), size: 28),
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white54,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          timeLeft,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Color(0xFF7B61FF),
                          size: 16,
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
                const SizedBox(height: 12),
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () => _showStakeModal(context, 'YES'),
                        child: const Text('Stake Yes'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23263A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () => _showStakeModal(context, 'NO'),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Stake',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  TextSpan(
                    text: 'YES',
                    style: TextStyle(
                      color:
                          widget.stakeOn == 'YES'
                              ? Colors.blue[300]
                              : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const TextSpan(
                    text: ' or ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  TextSpan(
                    text: 'NO',
                    style: TextStyle(
                      color:
                          widget.stakeOn == 'NO'
                              ? Colors.red[300]
                              : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Current pool',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YE3',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '\$2,400',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'NO',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '\$1,000',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Text(
                  'Expected return',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                SizedBox(width: 8),
                Text(
                  '1.8x',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter amount',
                filled: true,
                fillColor: Color(0xFF23263A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Prediction',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Type your prediction...',
                filled: true,
                fillColor: Color(0xFF23263A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23263A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              icon: const Icon(Icons.folder_open),
              label: const Text('Upload image/video'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23263A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              icon: const Icon(Icons.category),
              label: const Text('Select category'),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Stake amount   (STRK)',
                filled: true,
                fillColor: Color(0xFF23263A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B61FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Create Prediction'),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Swipe for next prediction',
                style: TextStyle(color: Colors.white38, fontSize: 14),
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
              radius: 20,
              backgroundColor: Color(0xFF7B61FF),
              child: Icon(Icons.person, size: 22, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              '@yourname',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              children: [
                _buildTab('Active', 0),
                const SizedBox(width: 12),
                _buildTab('History', 1),
                const SizedBox(width: 12),
                _buildTab('Likes', 2),
              ],
            ),
            const SizedBox(height: 24),
            // Active prediction card
            if (selectedTab == 0)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF181A24),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart placeholder
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF23263A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.show_chart,
                          color: Color(0xFF7B61FF),
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You staked YE3 ( 20)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Status: Ongoing',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (selectedTab == 0) const SizedBox(height: 18),
            // List of active predictions
            if (selectedTab == 0)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF181A24),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flash_on,
                      color: Color(0xFF7B61FF),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'yoysffi/ok 12',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            if (selectedTab == 0) const SizedBox(height: 18),
            // Stats
            if (selectedTab == 0)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181A24),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Color(0xFF7B61FF),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total wins:',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '12',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF181A24),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          value: 0.7,
                          color: Color(0xFF7B61FF),
                          backgroundColor: Color(0xFF23263A),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7B61FF) : const Color(0xFF23263A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: FontWeight.bold,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add your comments list here
            const Center(
              child: Text(
                'No comments yet',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
