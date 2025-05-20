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
      home: const FeedPage(),
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
      'title': 'BTC to $80k by Sept 2025',
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181A24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const CreatePredictionModal(),
    );
  }

  void _goToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181A24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => CommentsModal(prediction: predictions[index]),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181A24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StakeModal(stakeOn: stakeOn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181A24),
        borderRadius: BorderRadius.circular(24),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart/Image placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF23263A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: const Center(
              child: Icon(Icons.show_chart, color: Color(0xFF7B61FF), size: 64),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeLeft,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Color(0xFF7B61FF),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          amount,
                          style: const TextStyle(
                            color: Color(0xFF7B61FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: liked ? const Color(0xFF7B61FF).withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked ? const Color(0xFF7B61FF) : Colors.white54,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('$likes', style: TextStyle(color: liked ? const Color(0xFF7B61FF) : Colors.white54)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onComment,
                      child: Row(
                        children: [
                          const Icon(Icons.mode_comment_outlined, color: Colors.white54, size: 20),
                          const SizedBox(width: 4),
                          Text('$comments', style: const TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23263A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _showStakeModal(context, 'YES'),
                        child: const Text('Stake Yes'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23263A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
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

class StakeModal extends StatelessWidget {
  final String stakeOn;

  const StakeModal({
    super.key,
    required this.stakeOn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Stake on: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(
                      text: stakeOn,
                      style: TextStyle(
                        color:
                            stakeOn == 'YES'
                                ? Colors.blue[300]
                                : Colors.red[300],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const TextSpan(
                      text: ' or ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(
                      text: stakeOn == 'YES' ? 'NO' : 'YES',
                      style: TextStyle(
                        color:
                            stakeOn == 'YES'
                                ? Colors.red[300]
                                : Colors.blue[300],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YE3',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '242,400',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'NO',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1,000',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Expected return',
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF23263A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '1.8x',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF23263A),
              hintText: 'Enter amount',
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B61FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () {},
              child: const Text(
                'Confirm Stake',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreatePredictionModal extends StatelessWidget {
  const CreatePredictionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              Text(
                'New Prediction',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF23263A),
              hintText: 'Type your prediction...',
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF23263A),
              hintText: 'Stake amount   (STRK)',
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B61FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () {},
              child: const Text(
                'Create Prediction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Swipe for next prediction',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10111A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.account_circle, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              '@yourname',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181A24),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFF7B61FF),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Total wins: 12',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181A24),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Color(0xFF7B61FF),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text('STRK: 530', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Tabs
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B61FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23263A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'History',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23263A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Likes',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Active prediction card
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'You staked YE3 ( 20)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF23263A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Ongoing',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Status: Ongoing',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        color: Color(0xFF7B61FF),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'yoysffi/ok 12',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF181A24),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total wins:',
                          style: TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 6),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'STRK:',
                          style: TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '530',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
}

class CommentsModal extends StatelessWidget {
  final Map<String, dynamic> prediction;

  const CommentsModal({
    super.key,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Add your comments list here
          const Center(
            child: Text(
              'No comments yet',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
