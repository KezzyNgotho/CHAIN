import 'package:flutter/material.dart';
import '../services/starknet_service.dart';

class ProfileScreen extends StatefulWidget {
  final StarkNetService starknetService;

  const ProfileScreen({
    Key? key,
    required this.starknetService,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userAddress;
  bool isLoading = false;
  List<Map<String, dynamic>> userPredictions = [];
  List<Map<String, dynamic>> userComments = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);
    try {
      userAddress = await widget.starknetService.getCurrentUserAddress();
      // TODO: Load user predictions and comments
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Wallet Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userAddress ?? 'Not connected',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'My Predictions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (userPredictions.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No predictions yet'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userPredictions.length,
                      itemBuilder: (context, index) {
                        final prediction = userPredictions[index];
                        return Card(
                          child: ListTile(
                            title: Text(prediction['question']),
                            subtitle: Text(
                              'Staked: ${prediction['amount']} ETH',
                            ),
                            trailing: Text(
                              prediction['outcome'] ? 'Yes' : 'No',
                              style: TextStyle(
                                color: prediction['outcome']
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'My Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (userComments.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No comments yet'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userComments.length,
                      itemBuilder: (context, index) {
                        final comment = userComments[index];
                        return Card(
                          child: ListTile(
                            title: Text(comment['text']),
                            subtitle: Text(
                              'Likes: ${comment['likes']}',
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
} 