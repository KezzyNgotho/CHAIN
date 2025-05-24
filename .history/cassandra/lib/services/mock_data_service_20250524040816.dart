import 'package:cassandra/models/user_profile.dart';
import 'package:cassandra/models/market.dart';
import 'package:cassandra/models/stake.dart';
import 'package:cassandra/models/proposal.dart';
import 'package:cassandra/models/curation.dart';

class MockDataService {
  // Mock user profiles
  static final List<UserProfile> mockProfiles = [
    UserProfile(
      username: 'alice',
      bio: 'Crypto enthusiast and prediction market trader',
      avatar: 'https://i.pravatar.cc/150?img=1',
      socialLinks: {'twitter': '@alice', 'discord': 'alice#1234'},
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastUpdated: DateTime.now(),
      isVerified: true,
      verificationLevel: 2,
      totalCurated: 15,
      curationScore: 1200,
      governancePower: BigInt.from(10000000000000000000), // 10 tokens
    ),
    UserProfile(
      username: 'bob',
      bio: 'Professional market maker',
      avatar: 'https://i.pravatar.cc/150?img=2',
      socialLinks: {'twitter': '@bob', 'discord': 'bob#5678'},
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      lastUpdated: DateTime.now(),
      isVerified: true,
      verificationLevel: 3,
      totalCurated: 30,
      curationScore: 2500,
      governancePower: BigInt.from(50000000000000000000), // 50 tokens
    ),
  ];

  // Mock markets
  static final List<Market> mockMarkets = [
    Market(
      id: '1',
      question: 'Will ETH reach $5,000 by end of 2024?',
      endTime: DateTime.now().add(const Duration(days: 30)),
      resolved: false,
      outcome: null,
      yesAmount: BigInt.from(1000000000000000000000), // 1000 tokens
      noAmount: BigInt.from(800000000000000000000), // 800 tokens
      totalStaked: BigInt.from(1800000000000000000000), // 1800 tokens
      creator: mockProfiles[0],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Market(
      id: '2',
      question: 'Will Bitcoin ETF be approved in Q1 2024?',
      endTime: DateTime.now().add(const Duration(days: 15)),
      resolved: false,
      outcome: null,
      yesAmount: BigInt.from(2000000000000000000000), // 2000 tokens
      noAmount: BigInt.from(1500000000000000000000), // 1500 tokens
      totalStaked: BigInt.from(3500000000000000000000), // 3500 tokens
      creator: mockProfiles[1],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Mock stakes
  static final List<Stake> mockStakes = [
    Stake(
      amount: BigInt.from(10000000000000000000), // 10 tokens
      startTime: DateTime.now().subtract(const Duration(days: 10)),
      endTime: DateTime.now().add(const Duration(days: 20)),
      lastClaimTime: DateTime.now().subtract(const Duration(days: 1)),
      totalRewards: BigInt.from(100000000000000000), // 0.1 tokens
      isActive: true,
    ),
    Stake(
      amount: BigInt.from(50000000000000000000), // 50 tokens
      startTime: DateTime.now().subtract(const Duration(days: 20)),
      endTime: DateTime.now().add(const Duration(days: 40)),
      lastClaimTime: DateTime.now().subtract(const Duration(days: 2)),
      totalRewards: BigInt.from(500000000000000000), // 0.5 tokens
      isActive: true,
    ),
  ];

  // Mock proposals
  static final List<Proposal> mockProposals = [
    Proposal(
      id: '1',
      proposer: mockProfiles[0],
      title: 'Increase reward rate to 2%',
      description: 'Proposal to increase the staking reward rate from 1% to 2%',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().add(const Duration(days: 5)),
      yesVotes: BigInt.from(30000000000000000000), // 30 tokens
      noVotes: BigInt.from(20000000000000000000), // 20 tokens
      requiredStake: BigInt.from(50000000000000000000), // 50 tokens
      status: 0, // Active
      executed: false,
    ),
    Proposal(
      id: '2',
      proposer: mockProfiles[1],
      title: 'Add new market categories',
      description: 'Proposal to add sports and politics categories',
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 6)),
      yesVotes: BigInt.from(40000000000000000000), // 40 tokens
      noVotes: BigInt.from(10000000000000000000), // 10 tokens
      requiredStake: BigInt.from(50000000000000000000), // 50 tokens
      status: 0, // Active
      executed: false,
    ),
  ];

  // Mock curations
  static final List<Curation> mockCurations = [
    Curation(
      id: '1',
      curator: mockProfiles[0],
      contentType: 'market',
      contentId: '1',
      rating: 5,
      comment: 'Very well-structured market with clear parameters',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      upvotes: 10,
      downvotes: 2,
      isFeatured: true,
    ),
    Curation(
      id: '2',
      curator: mockProfiles[1],
      contentType: 'market',
      contentId: '2',
      rating: 4,
      comment: 'Good market but could use more detailed parameters',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      upvotes: 8,
      downvotes: 1,
      isFeatured: false,
    ),
  ];

  // Get user profile
  static UserProfile? getUserProfile(String username) {
    return mockProfiles.firstWhere(
      (profile) => profile.username == username,
      orElse: () => throw Exception('Profile not found'),
    );
  }

  // Get all markets
  static List<Market> getMarkets() {
    return mockMarkets;
  }

  // Get market by ID
  static Market? getMarket(String id) {
    return mockMarkets.firstWhere(
      (market) => market.id == id,
      orElse: () => throw Exception('Market not found'),
    );
  }

  // Get user stakes
  static List<Stake> getUserStakes(String username) {
    return mockStakes;
  }

  // Get active proposals
  static List<Proposal> getActiveProposals() {
    return mockProposals.where((p) => p.status == 0).toList();
  }

  // Get market curations
  static List<Curation> getMarketCurations(String marketId) {
    return mockCurations.where((c) => c.contentId == marketId).toList();
  }

  // Get featured content
  static List<Curation> getFeaturedContent() {
    return mockCurations.where((c) => c.isFeatured).toList();
  }
} 