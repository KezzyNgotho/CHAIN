import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800';

  // Contract addresses
  static const String userProfileAddress =
      '0x...'; // Add your deployed contract address
  static const String securityFeaturesAddress =
      '0x...'; // Add your deployed contract address
  static const String tokenStakingAddress =
      '0x...'; // Add your deployed contract address

  // Mock data
  final Map<String, dynamic> _mockProfile = {
    'username': 'crypto_whale',
    'bio':
        'Building the future of decentralized prediction markets. Early adopter and blockchain enthusiast.',
    'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=crypto_whale',
    'socialLinks': 'twitter.com/crypto_whale\ngithub.com/crypto_whale',
    'createdAt': '1711234567',
    'lastUpdated': '1711234567',
    'isVerified': true,
    'verificationLevel': 3,
    'totalCurated': 15,
    'curationScore': 850,
    'governancePower': '50000000000000000000', // 50 tokens
  };

  final Map<String, dynamic> _mockStake = {
    'amount': '25000000000000000000', // 25 tokens
    'startTime': '1711234567',
    'endTime': '1711839367', // 7 days from start
    'lastClaimTime': '1711234567',
    'totalRewards': '250000000000000000', // 0.25 tokens
    'isActive': true,
    'apy': '12.5', // 12.5% APY
    'nextReward': '25000000000000000', // 0.025 tokens
  };

  final List<Map<String, dynamic>> _mockProposals = [
    {
      'id': 1,
      'proposer': '0x123',
      'title': 'Increase Staking Rewards',
      'description':
          'Proposal to increase staking rewards from 10% to 15% APY to attract more stakers.',
      'startTime': '1711234567',
      'endTime': '1711839367',
      'yesVotes': '150000000000000000000', // 150 tokens
      'noVotes': '50000000000000000000', // 50 tokens
      'requiredStake': '10000000000000000000', // 10 tokens
      'status': 0, // 0: Active, 1: Passed, 2: Failed, 3: Executed
      'executed': false,
      'votingPower': '200000000000000000000', // 200 tokens total
      'quorum': '100000000000000000000', // 100 tokens required
    },
    {
      'id': 2,
      'proposer': '0x456',
      'title': 'Add New Prediction Categories',
      'description':
          'Proposal to add sports and entertainment categories to the prediction market.',
      'startTime': '1711234567',
      'endTime': '1711839367',
      'yesVotes': '80000000000000000000', // 80 tokens
      'noVotes': '20000000000000000000', // 20 tokens
      'requiredStake': '10000000000000000000', // 10 tokens
      'status': 1, // Passed
      'executed': true,
      'votingPower': '100000000000000000000', // 100 tokens total
      'quorum': '100000000000000000000', // 100 tokens required
    }
  ];

  final Map<String, dynamic> _mockRateLimit = {
    'dailyTransactions': 45,
    'dailyVolume': '750000000000000000000', // 750 tokens
    'lastReset': '1711234567',
    'failedAttempts': 2,
    'lastFailed': '1711234567',
    'maxDailyTransactions': 100,
    'maxDailyVolume': '1000000000000000000000', // 1000 tokens
    'cooldownPeriod': 3600, // 1 hour in seconds
  };

  final Map<String, dynamic> _mockEmergencyState = {
    'isActive': false,
    'activatedBy': '',
    'activationTime': '0',
    'reason': '',
    'affectedContracts': '',
    'lastCheck': '1711234567',
    'systemStatus': 'normal',
    'maintenanceMode': false,
  };

  String? userAddress;

  StarkNetService() {
    // provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    // Stub: always return true
    userAddress = '0x123456789abcdef';
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }

  // User Profile Functions
  Future<void> updateProfile({
    required String username,
    required String bio,
    required String avatar,
    required String socialLinks,
  }) async {
    // Stub: update mock profile
    await Future.delayed(Duration(milliseconds: 500));
    _mockProfile['username'] = username;
    _mockProfile['bio'] = bio;
    _mockProfile['avatar'] = avatar;
    _mockProfile['socialLinks'] = socialLinks;
    _mockProfile['lastUpdated'] =
        DateTime.now().millisecondsSinceEpoch.toString();
    return;
  }

  Future<Map<String, dynamic>> getUserProfile(String address) async {
    // Stub: return mock profile
    await Future.delayed(Duration(milliseconds: 500));
    return _mockProfile;
  }

  // Staking Functions
  Future<void> stake(String amount, int duration) async {
    // Stub: update mock stake
    await Future.delayed(Duration(milliseconds: 500));
    final amountWei = BigInt.from(double.parse(amount) * 1e18);
    _mockStake['amount'] = amountWei.toString();
    _mockStake['startTime'] = DateTime.now().millisecondsSinceEpoch.toString();
    _mockStake['endTime'] =
        (DateTime.now().millisecondsSinceEpoch + duration * 1000).toString();
    _mockStake['isActive'] = true;
    return;
  }

  Future<void> unstake() async {
    // Stub: update mock stake
    await Future.delayed(Duration(milliseconds: 500));
    _mockStake['isActive'] = false;
    _mockStake['totalRewards'] = '0';
    return;
  }

  Future<void> claimRewards() async {
    // Stub: update mock stake
    await Future.delayed(Duration(milliseconds: 500));
    _mockStake['lastClaimTime'] =
        DateTime.now().millisecondsSinceEpoch.toString();
    _mockStake['totalRewards'] = '0';
    return;
  }

  Future<Map<String, dynamic>> getStake(String address) async {
    // Stub: return mock stake
    await Future.delayed(Duration(milliseconds: 500));
    return _mockStake;
  }

  // Governance Functions
  Future<void> createProposal({
    required String title,
    required String description,
    required String requiredStake,
  }) async {
    // Stub: add new proposal
    await Future.delayed(Duration(milliseconds: 500));
    final newProposal = {
      'id': _mockProposals.length + 1,
      'proposer': userAddress,
      'title': title,
      'description': description,
      'startTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'endTime':
          (DateTime.now().millisecondsSinceEpoch + 7 * 24 * 60 * 60 * 1000)
              .toString(),
      'yesVotes': '0',
      'noVotes': '0',
      'requiredStake': requiredStake,
      'status': 0,
      'executed': false,
      'votingPower': '0',
      'quorum': '100000000000000000000', // 100 tokens required
    };
    _mockProposals.add(newProposal);
    return;
  }

  Future<void> voteOnProposal(int proposalId, bool vote) async {
    // Stub: update proposal votes
    await Future.delayed(Duration(milliseconds: 500));
    final proposal = _mockProposals.firstWhere((p) => p['id'] == proposalId);
    if (vote) {
      proposal['yesVotes'] =
          (BigInt.parse(proposal['yesVotes']) + BigInt.from(50e18)).toString();
    } else {
      proposal['noVotes'] =
          (BigInt.parse(proposal['noVotes']) + BigInt.from(50e18)).toString();
    }
    proposal['votingPower'] =
        (BigInt.parse(proposal['yesVotes']) + BigInt.parse(proposal['noVotes']))
            .toString();
    return;
  }

  Future<Map<String, dynamic>> getProposal(int proposalId) async {
    // Stub: return mock proposal
    await Future.delayed(Duration(milliseconds: 500));
    return _mockProposals.firstWhere((p) => p['id'] == proposalId);
  }

  Future<List<Map<String, dynamic>>> getAllProposals() async {
    // Stub: return all mock proposals
    await Future.delayed(Duration(milliseconds: 500));
    return _mockProposals;
  }

  // Security Functions
  Future<bool> checkRateLimit(String amount) async {
    // Stub: check against mock limits
    await Future.delayed(Duration(milliseconds: 200));
    final amountWei = BigInt.from(double.parse(amount) * 1e18);
    final currentVolume = BigInt.parse(_mockRateLimit['dailyVolume']);
    return currentVolume + amountWei <=
        BigInt.parse(_mockRateLimit['maxDailyVolume']);
  }

  Future<Map<String, dynamic>> getRateLimit(String address) async {
    // Stub: return mock rate limit
    await Future.delayed(Duration(milliseconds: 200));
    return _mockRateLimit;
  }

  Future<bool> isBlacklisted(String address) async {
    // Stub: check mock blacklist
    await Future.delayed(Duration(milliseconds: 200));
    return false;
  }

  Future<Map<String, dynamic>> getEmergencyState() async {
    // Stub: return mock emergency state
    await Future.delayed(Duration(milliseconds: 200));
    return _mockEmergencyState;
  }

  // Additional mock functions
  Future<Map<String, dynamic>> getStakingStats() async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      'totalStaked': '1000000000000000000000', // 1000 tokens
      'totalStakers': 150,
      'averageStake': '6666666666666666666', // ~6.67 tokens
      'totalRewards': '100000000000000000000', // 100 tokens
      'currentApy': '12.5',
      'stakingPeriods': [
        {'duration': 30, 'apy': '10.0'}, // 30 days, 10% APY
        {'duration': 90, 'apy': '12.5'}, // 90 days, 12.5% APY
        {'duration': 180, 'apy': '15.0'}, // 180 days, 15% APY
        {'duration': 365, 'apy': '20.0'}, // 365 days, 20% APY
      ],
    };
  }

  Future<Map<String, dynamic>> getGovernanceStats() async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      'totalProposals': _mockProposals.length,
      'activeProposals': _mockProposals.where((p) => p['status'] == 0).length,
      'totalVotes': '500000000000000000000', // 500 tokens
      'totalVoters': 75,
      'quorum': '100000000000000000000', // 100 tokens
      'minProposalStake': '10000000000000000000', // 10 tokens
      'votingPeriod': 604800, // 7 days in seconds
    };
  }
}
