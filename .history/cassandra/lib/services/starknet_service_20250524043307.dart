import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800';
  static const String contractAddress = '0x...'; // Your contract address

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract contract;
  String? userAddress;

  // Mock data
  final Map<String, dynamic> _mockStake = {
    'amount': '1000000000000000000', // 1 ETH in wei
    'start_time': DateTime.now().millisecondsSinceEpoch.toString(),
    'end_time': DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch.toString(),
    'last_claim_time': DateTime.now().millisecondsSinceEpoch.toString(),
    'total_rewards': '500000000000000000', // 0.5 ETH in wei
    'is_active': true,
  };

  final Map<String, dynamic> _mockStakingPool = {
    'total_staked': '10000000000000000000', // 10 ETH in wei
    'total_rewards': '2000000000000000000', // 2 ETH in wei
    'reward_rate': '100000000000000000', // 0.1 ETH in wei
    'last_update_time': DateTime.now().millisecondsSinceEpoch.toString(),
    'min_stake_duration': '86400', // 1 day in seconds
    'max_stake_duration': '2592000', // 30 days in seconds
  };

  final Map<String, dynamic> _mockProposal = {
    'id': '1',
    'proposer': '0x123...',
    'title': 'Increase staking rewards',
    'description': 'Proposal to increase staking rewards by 20%',
    'start_time': DateTime.now().millisecondsSinceEpoch.toString(),
    'end_time': DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch.toString(),
    'yes_votes': '5000000000000000000', // 5 ETH in wei
    'no_votes': '2000000000000000000', // 2 ETH in wei
    'required_stake': '1000000000000000000', // 1 ETH in wei
    'status': 'active',
    'executed': false,
  };

  final List<Map<String, dynamic>> _mockMarkets = [
    {
      'id': '1',
      'question': 'Will ETH reach 10k by 2025?',
      'endTime': DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch.toString(),
      'resolved': false,
      'outcome': null,
      'yesAmount': '5000000000000000000', // 5 ETH in wei
      'noAmount': '3000000000000000000', // 3 ETH in wei
    },
    {
      'id': '2',
      'question': 'Will BTC reach $100k by 2024?',
      'endTime': DateTime.now().add(Duration(days: 180)).millisecondsSinceEpoch.toString(),
      'resolved': false,
      'outcome': null,
      'yesAmount': '8000000000000000000', // 8 ETH in wei
      'noAmount': '4000000000000000000', // 4 ETH in wei
    },
  ];

  final List<Map<String, dynamic>> _mockComments = [
    {
      'id': 1,
      'user': '0x123...',
      'text': 'I think this is a great prediction!',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'likes': 5,
    },
    {
      'id': 2,
      'user': '0x456...',
      'text': 'I disagree with this prediction.',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'likes': 2,
    },
  ];

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      // Mock wallet connection
      userAddress = '0x1234567890abcdef1234567890abcdef12345678';
      return true;
    } catch (e) {
      print('Error connecting wallet: $e');
      return false;
    }
  }

  Future<String?> getCurrentUserAddress() async {
    return userAddress;
  }

  // Staking methods
  Future<Map<String, dynamic>> getStake(String userAddress) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));
    return _mockStake;
  }

  Future<Map<String, dynamic>> getStakingPool() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _mockStakingPool;
  }

  Future<String> stakeTokens(String amount, int duration) async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock stake data
    _mockStake['amount'] = amount;
    _mockStake['start_time'] = DateTime.now().millisecondsSinceEpoch.toString();
    _mockStake['end_time'] = DateTime.now().add(Duration(days: duration)).millisecondsSinceEpoch.toString();
    _mockStake['is_active'] = true;
    
    // Update staking pool
    final amountWei = BigInt.parse(_mockStakingPool['total_staked']) + BigInt.parse(amount);
    _mockStakingPool['total_staked'] = amountWei.toString();
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  Future<String> unstake() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock stake data
    _mockStake['is_active'] = false;
    
    // Update staking pool
    final amountWei = BigInt.parse(_mockStakingPool['total_staked']) - BigInt.parse(_mockStake['amount']);
    _mockStakingPool['total_staked'] = amountWei.toString();
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  Future<String> claimRewards() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock stake data
    _mockStake['last_claim_time'] = DateTime.now().millisecondsSinceEpoch.toString();
    _mockStake['total_rewards'] = '0';
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  // Governance methods
  Future<Map<String, dynamic>> getStakingProposal(String proposalId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _mockProposal;
  }

  Future<String> createStakingProposal(
    String title,
    String description,
    String requiredStake,
  ) async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock proposal data
    _mockProposal['title'] = title;
    _mockProposal['description'] = description;
    _mockProposal['required_stake'] = requiredStake;
    _mockProposal['proposer'] = userAddress;
    _mockProposal['start_time'] = DateTime.now().millisecondsSinceEpoch.toString();
    _mockProposal['end_time'] = DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch.toString();
    _mockProposal['status'] = 'active';
    _mockProposal['executed'] = false;
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  Future<String> voteOnStakingProposal(String proposalId, bool vote) async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock proposal data
    if (vote) {
      final yesVotes = BigInt.parse(_mockProposal['yes_votes']) + BigInt.from(1000000000000000000);
      _mockProposal['yes_votes'] = yesVotes.toString();
    } else {
      final noVotes = BigInt.parse(_mockProposal['no_votes']) + BigInt.from(1000000000000000000);
      _mockProposal['no_votes'] = noVotes.toString();
    }
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  Future<String> executeStakingProposal(String proposalId) async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock proposal data
    _mockProposal['status'] = 'executed';
    _mockProposal['executed'] = true;
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  // Market methods
  Future<List<Map<String, dynamic>>> getMarkets() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _mockMarkets;
  }

  Future<String> stake(String predictionId, bool isYes, String amount) async {
    await Future.delayed(Duration(milliseconds: 1000));
    // Update mock market data
    final market = _mockMarkets.firstWhere((m) => m['id'] == predictionId);
    if (isYes) {
      final yesAmount = BigInt.parse(market['yesAmount']) + BigInt.parse(amount);
      market['yesAmount'] = yesAmount.toString();
    } else {
      final noAmount = BigInt.parse(market['noAmount']) + BigInt.parse(amount);
      market['noAmount'] = noAmount.toString();
    }
    
    return '0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef';
  }

  Future<Map<String, dynamic>> getPredictionDetails(String predictionId) async {
    await Future.delayed(Duration(milliseconds: 500));
    final market = _mockMarkets.firstWhere((m) => m['id'] == predictionId);
    return {
      'yesPool': market['yesAmount'],
      'noPool': market['noAmount'],
      'totalStaked': (BigInt.parse(market['yesAmount']) + BigInt.parse(market['noAmount'])).toString(),
      'endTime': market['endTime'],
    };
  }

  Future<String> getExpectedReturn(
      String predictionId, bool isYes, String amount) async {
    await Future.delayed(Duration(milliseconds: 500));
    final market = _mockMarkets.firstWhere((m) => m['id'] == predictionId);
    
    // Mock calculation: 20% return
    final amountWei = BigInt.parse(amount);
    final returnAmount = (amountWei * BigInt.from(12)) ~/ BigInt.from(10);
    return returnAmount.toString();
  }

  // Comment methods
  Future<List<Map<String, dynamic>>> getComments(int marketId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _mockComments;
  }

  Future<void> addComment(int marketId, String text) async {
    await Future.delayed(Duration(milliseconds: 500));
    // Add new comment to mock data
    _mockComments.add({
      'id': _mockComments.length + 1,
      'user': userAddress,
      'text': text,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'likes': 0,
    });
  }

  Future<void> deleteComment(int marketId, int commentId) async {
    await Future.delayed(Duration(milliseconds: 500));
    // Remove comment from mock data
    _mockComments.removeWhere((comment) => comment['id'] == commentId);
  }

  Future<void> likeComment(int marketId, int commentId) async {
    await Future.delayed(Duration(milliseconds: 500));
    // Update likes in mock data
    final comment = _mockComments.firstWhere((c) => c['id'] == commentId);
    comment['likes'] = (comment['likes'] as int) + 1;
  }

  Future<void> unlikeComment(int marketId, int commentId) async {
    await Future.delayed(Duration(milliseconds: 500));
    // Update likes in mock data
    final comment = _mockComments.firstWhere((c) => c['id'] == commentId);
    comment['likes'] = (comment['likes'] as int) - 1;
  }
}
