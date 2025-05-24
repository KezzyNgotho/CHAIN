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

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract userProfileContract;
  late final Contract securityFeaturesContract;
  late final Contract tokenStakingContract;
  String? userAddress;

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      final signer = Signer(privateKey: Felt.fromString(privateKey));
      final accountAddress = Felt.fromInt(0); // Replace with actual address

      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: Felt.fromString('SN_SEPOLIA'),
      );

      // Initialize contracts
      userProfileContract = Contract(
        account: account,
        address: Felt.fromString(userProfileAddress),
      );

      securityFeaturesContract = Contract(
        account: account,
        address: Felt.fromString(securityFeaturesAddress),
      );

      tokenStakingContract = Contract(
        account: account,
        address: Felt.fromString(tokenStakingAddress),
      );

      userAddress = accountAddress.toString();
      return true;
    } catch (e) {
      print('Error connecting wallet: $e');
      return false;
    }
  }

  // User Profile Functions
  Future<void> updateProfile({
    required String username,
    required String bio,
    required String avatar,
    required String socialLinks,
  }) async {
    try {
      await userProfileContract.execute(
        selector: 'updateProfile',
        calldata: [
          Felt.fromString(username),
          Felt.fromString(bio),
          Felt.fromString(avatar),
          Felt.fromString(socialLinks),
        ],
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String address) async {
    try {
      final result = await userProfileContract.call(
        selector: 'getUserProfile',
        calldata: [Felt.fromString(address)],
      );

      return {
        'username': result[0].toString(),
        'bio': result[1].toString(),
        'avatar': result[2].toString(),
        'socialLinks': result[3].toString(),
        'createdAt': result[4].toString(),
        'lastUpdated': result[5].toString(),
        'isVerified': result[6].toString() == '1',
        'verificationLevel': int.parse(result[7].toString()),
        'totalCurated': int.parse(result[8].toString()),
        'curationScore': int.parse(result[9].toString()),
        'governancePower': result[10].toString(),
      };
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Staking Functions
  Future<void> stake(String amount, int duration) async {
    try {
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      await tokenStakingContract.execute(
        selector: 'stake',
        calldata: [
          Felt.fromString(amountWei.toString()),
          Felt.fromInt(duration),
        ],
      );
    } catch (e) {
      throw Exception('Failed to stake: $e');
    }
  }

  Future<void> unstake() async {
    try {
      await tokenStakingContract.execute(
        selector: 'unstake',
        calldata: [],
      );
    } catch (e) {
      throw Exception('Failed to unstake: $e');
    }
  }

  Future<void> claimRewards() async {
    try {
      await tokenStakingContract.execute(
        selector: 'claimRewards',
        calldata: [],
      );
    } catch (e) {
      throw Exception('Failed to claim rewards: $e');
    }
  }

  Future<Map<String, dynamic>> getStake(String address) async {
    try {
      final result = await tokenStakingContract.call(
        selector: 'getStake',
        calldata: [Felt.fromString(address)],
      );

      return {
        'amount': result[0].toString(),
        'startTime': result[1].toString(),
        'endTime': result[2].toString(),
        'lastClaimTime': result[3].toString(),
        'totalRewards': result[4].toString(),
        'isActive': result[5].toString() == '1',
      };
    } catch (e) {
      throw Exception('Failed to get stake: $e');
    }
  }

  // Governance Functions
  Future<void> createProposal({
    required String title,
    required String description,
    required String requiredStake,
  }) async {
    try {
      final stakeWei = BigInt.from(double.parse(requiredStake) * 1e18);

      await userProfileContract.execute(
        selector: 'createProposal',
        calldata: [
          Felt.fromString(title),
          Felt.fromString(description),
          Felt.fromString(stakeWei.toString()),
        ],
      );
    } catch (e) {
      throw Exception('Failed to create proposal: $e');
    }
  }

  Future<void> voteOnProposal(int proposalId, bool vote) async {
    try {
      await userProfileContract.execute(
        selector: 'castVote',
        calldata: [
          Felt.fromInt(proposalId),
          Felt.fromInt(vote ? 1 : 0),
        ],
      );
    } catch (e) {
      throw Exception('Failed to vote: $e');
    }
  }

  Future<Map<String, dynamic>> getProposal(int proposalId) async {
    try {
      final result = await userProfileContract.call(
        selector: 'getProposal',
        calldata: [Felt.fromInt(proposalId)],
      );

      return {
        'id': int.parse(result[0].toString()),
        'proposer': result[1].toString(),
        'title': result[2].toString(),
        'description': result[3].toString(),
        'startTime': result[4].toString(),
        'endTime': result[5].toString(),
        'yesVotes': result[6].toString(),
        'noVotes': result[7].toString(),
        'requiredStake': result[8].toString(),
        'status': int.parse(result[9].toString()),
        'executed': result[10].toString() == '1',
      };
    } catch (e) {
      throw Exception('Failed to get proposal: $e');
    }
  }

  // Security Functions
  Future<bool> checkRateLimit(String amount) async {
    try {
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      final result = await securityFeaturesContract.call(
        selector: 'checkRateLimit',
        calldata: [Felt.fromString(amountWei.toString())],
      );

      return result[0].toString() == '1';
    } catch (e) {
      throw Exception('Failed to check rate limit: $e');
    }
  }

  Future<Map<String, dynamic>> getRateLimit(String address) async {
    try {
      final result = await securityFeaturesContract.call(
        selector: 'getRateLimit',
        calldata: [Felt.fromString(address)],
      );

      return {
        'dailyTransactions': int.parse(result[0].toString()),
        'dailyVolume': result[1].toString(),
        'lastReset': result[2].toString(),
        'failedAttempts': int.parse(result[3].toString()),
        'lastFailed': result[4].toString(),
      };
    } catch (e) {
      throw Exception('Failed to get rate limit: $e');
    }
  }

  Future<bool> isBlacklisted(String address) async {
    try {
      final result = await securityFeaturesContract.call(
        selector: 'isBlacklisted',
        calldata: [Felt.fromString(address)],
      );

      return result[0].toString() == '1';
    } catch (e) {
      throw Exception('Failed to check blacklist status: $e');
    }
  }

  Future<Map<String, dynamic>> getEmergencyState() async {
    try {
      final result = await securityFeaturesContract.call(
        selector: 'getEmergencyState',
        calldata: [],
      );

      return {
        'isActive': result[0].toString() == '1',
        'activatedBy': result[1].toString(),
        'activationTime': result[2].toString(),
        'reason': result[3].toString(),
        'affectedContracts': result[4].toString(),
      };
    } catch (e) {
      throw Exception('Failed to get emergency state: $e');
    }
  }
}
