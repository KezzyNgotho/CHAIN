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
                const SizedBox(height: 24),
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stake on $stakeOn',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter amount',
              filled: true,
              fillColor: const Color(0xFF23263A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
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
              child: const Text('Confirm Stake'),
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Prediction',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your prediction',
              filled: true,
              fillColor: const Color(0xFF23263A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: 'End date (e.g., 2025-12-31)',
              filled: true,
              fillColor: const Color(0xFF23263A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF7B61FF),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'User Name',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '0x1234...5678',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
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
