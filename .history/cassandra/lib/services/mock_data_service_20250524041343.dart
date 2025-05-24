import 'package:cassandra/models/user_profile.dart';
import 'package:cassandra/models/market.dart';
import 'package:cassandra/models/stake.dart';
import 'package:cassandra/models/proposal.dart';
import 'package:cassandra/models/curation.dart';

class MockDataService {
  static final Map<String, UserProfile> _users = {
    'alice': UserProfile(
      id: 'alice',
      username: 'alice',
      bio: 'Crypto enthusiast and prediction market creator',
      avatar: 'https://example.com/avatar1.jpg',
      socialLinks: {
        'twitter': 'https://twitter.com/alice',
        'github': 'https://github.com/alice',
      },
      createdAt: DateTime(2023, 1, 1),
      lastUpdated: DateTime.now(),
      isVerified: true,
      verificationLevel: 2,
      totalCurated: 25,
      curationScore: 85,
      governancePower: BigInt.from(1000),
      reputation: 100,
      totalPredictions: 50,
      successfulPredictions: 35,
      totalStaked: BigInt.from(1000),
      totalRewards: BigInt.from(500),
    ),
    'bob': UserProfile(
      id: 'bob',
      username: 'bob',
      bio: 'DeFi researcher and market analyst',
      avatar: 'https://example.com/avatar2.jpg',
      socialLinks: {
        'twitter': 'https://twitter.com/bob',
        'linkedin': 'https://linkedin.com/in/bob',
      },
      createdAt: DateTime(2023, 2, 1),
      lastUpdated: DateTime.now(),
      isVerified: true,
      verificationLevel: 1,
      totalCurated: 15,
      curationScore: 75,
      governancePower: BigInt.from(500),
      reputation: 80,
      totalPredictions: 30,
      successfulPredictions: 20,
      totalStaked: BigInt.from(500),
      totalRewards: BigInt.from(200),
    ),
  };

  static final List<Market> _markets = [
    Market(
      id: '1',
      question: 'Will Bitcoin reach $100k by end of 2024?',
      endTime: DateTime(2024, 12, 31),
      resolved: false,
      yesAmount: BigInt.from(5000),
      noAmount: BigInt.from(3000),
      totalStaked: BigInt.from(8000),
      creator: _users['alice']!,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Market(
      id: '2',
      question: 'Will Ethereum 2.0 be fully implemented by Q2 2024?',
      endTime: DateTime(2024, 6, 30),
      resolved: false,
      yesAmount: BigInt.from(3000),
      noAmount: BigInt.from(2000),
      totalStaked: BigInt.from(5000),
      creator: _users['bob']!,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<Stake> _stakes = [
    Stake(
      amount: BigInt.from(500),
      startTime: DateTime.now().subtract(const Duration(days: 30)),
      endTime: DateTime.now().add(const Duration(days: 30)),
      lastClaimTime: DateTime.now().subtract(const Duration(hours: 12)),
      totalRewards: BigInt.from(50),
      isActive: true,
    ),
    Stake(
      amount: BigInt.from(300),
      startTime: DateTime.now().subtract(const Duration(days: 60)),
      endTime: DateTime.now().subtract(const Duration(days: 30)),
      lastClaimTime: DateTime.now().subtract(const Duration(days: 31)),
      totalRewards: BigInt.from(30),
      isActive: false,
    ),
  ];

  static final List<Proposal> _proposals = [
    Proposal(
      id: '1',
      proposer: _users['alice']!,
      title: 'Increase minimum stake amount',
      description: 'Proposal to increase the minimum stake amount from 100 to 200 tokens.',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().add(const Duration(days: 5)),
      yesVotes: BigInt.from(3000),
      noVotes: BigInt.from(1000),
      requiredStake: BigInt.from(1000),
      status: 0,
      executed: false,
    ),
  ];

  static final List<Curation> _curations = [
    Curation(
      id: '1',
      curator: _users['alice']!,
      contentType: 'market',
      contentId: '1',
      rating: 5,
      comment: 'Well-researched market with clear parameters.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      upvotes: 10,
      downvotes: 2,
      isFeatured: true,
    ),
  ];

  static Map<String, dynamic> getStakingPool() {
    return {
      'totalStaked': '10000',
      'totalRewards': '1000',
      'rewardRate': '0.1',
    };
  }

  static UserProfile getUserProfile(String userId) {
    return _users[userId]!;
  }

  static List<Market> getMarkets() {
    return _markets;
  }

  static List<Stake> getUserStakes(String userId) {
    return _stakes;
  }

  static List<Proposal> getProposals() {
    return _proposals;
  }

  static List<Curation> getCurations() {
    return _curations;
  }
} 