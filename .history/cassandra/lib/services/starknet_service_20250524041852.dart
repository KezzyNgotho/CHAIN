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

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      // Create account from private key
      final signer = Signer(privateKey: Felt.fromString(privateKey));
      // For now, we'll use a placeholder address since getAddress() isn't available
      final accountAddress = Felt.fromInt(0);

      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: Felt.fromString('SN_SEPOLIA'),
      );

      // Initialize contract
      contract = Contract(
        account: account,
        address: Felt.fromString(contractAddress),
      );

      // Get user address
      userAddress = accountAddress.toString();
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
    try {
      final result = await contract.call(
        'getStake',
        [Felt.fromString(userAddress)],
      );

      return {
        'amount': result[0].toString(),
        'start_time': result[1].toString(),
        'end_time': result[2].toString(),
        'last_claim_time': result[3].toString(),
        'total_rewards': result[4].toString(),
        'is_active': result[5].toString() == '1',
      };
    } catch (e) {
      throw Exception('Failed to get stake: $e');
    }
  }

  Future<Map<String, dynamic>> getStakingPool() async {
    try {
      final result = await contract.call(
        'getStakingPool',
        [],
      );

      return {
        'total_staked': result[0].toString(),
        'total_rewards': result[1].toString(),
        'reward_rate': result[2].toString(),
        'last_update_time': result[3].toString(),
        'min_stake_duration': result[4].toString(),
        'max_stake_duration': result[5].toString(),
      };
    } catch (e) {
      throw Exception('Failed to get staking pool: $e');
    }
  }

  Future<String> stakeTokens(String amount, int duration) async {
    try {
      final amountWei = BigInt.from(double.parse(amount) * 1e18);
      final durationSeconds = duration * 86400; // Convert days to seconds

      final tx = await contract.execute(
        'stakeTokens',
        [
          Felt.fromString(amountWei.toString()),
          Felt.fromInt(durationSeconds),
        ],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to stake tokens: $e');
    }
  }

  Future<String> unstake() async {
    try {
      final tx = await contract.execute(
        'unstake',
        [],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to unstake: $e');
    }
  }

  Future<String> claimRewards() async {
    try {
      final tx = await contract.execute(
        'claimRewards',
        [],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to claim rewards: $e');
    }
  }

  // Governance methods
  Future<Map<String, dynamic>> getStakingProposal(String proposalId) async {
    try {
      final result = await contract.call(
        'getStakingProposal',
        [Felt.fromString(proposalId)],
      );

      return {
        'id': result[0].toString(),
        'proposer': result[1].toString(),
        'title': result[2].toString(),
        'description': result[3].toString(),
        'start_time': result[4].toString(),
        'end_time': result[5].toString(),
        'yes_votes': result[6].toString(),
        'no_votes': result[7].toString(),
        'required_stake': result[8].toString(),
        'status': result[9].toString(),
        'executed': result[10].toString() == '1',
      };
    } catch (e) {
      throw Exception('Failed to get proposal: $e');
    }
  }

  Future<String> createStakingProposal(
    String title,
    String description,
    String requiredStake,
  ) async {
    try {
      final stakeWei = BigInt.from(double.parse(requiredStake) * 1e18);

      final tx = await contract.execute(
        'createStakingProposal',
        [
          Felt.fromString(title),
          Felt.fromString(description),
          Felt.fromString(stakeWei.toString()),
        ],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to create proposal: $e');
    }
  }

  Future<String> voteOnStakingProposal(String proposalId, bool vote) async {
    try {
      final tx = await contract.execute(
        'voteOnStakingProposal',
        [
          Felt.fromString(proposalId),
          Felt.fromInt(vote ? 1 : 0),
        ],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to vote: $e');
    }
  }

  Future<String> executeStakingProposal(String proposalId) async {
    try {
      final tx = await contract.execute(
        'executeStakingProposal',
        [Felt.fromString(proposalId)],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to execute proposal: $e');
    }
  }

  // Existing methods
  Future<List<Map<String, dynamic>>> getMarkets() async {
    try {
      final result = await contract.call(
        'get_markets',
        [],
      );
      final markets = result[0] as List;

      return markets.map((market) {
        return {
          'id': market[0],
          'question': market[1],
          'endTime': market[2],
          'resolved': market[3],
          'outcome': market[4],
          'yesAmount': market[5],
          'noAmount': market[6],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get markets: $e');
    }
  }

  Future<String> stake(String predictionId, bool isYes, String amount) async {
    try {
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      final tx = await contract.execute(
        'stake',
        [
          Felt.fromString(predictionId),
          Felt.fromInt(isYes ? 1 : 0),
          Felt.fromString(amountWei.toString()),
        ],
      );

      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to stake: $e');
    }
  }

  Future<Map<String, dynamic>> getPredictionDetails(String predictionId) async {
    try {
      final result = await contract.call(
        'getPrediction',
        [Felt.fromString(predictionId)],
      );

      return {
        'yesPool': result[0].toString(),
        'noPool': result[1].toString(),
        'totalStaked': result[2].toString(),
        'endTime': result[3].toString(),
      };
    } catch (e) {
      throw Exception('Failed to get prediction details: $e');
    }
  }

  Future<String> getExpectedReturn(
      String predictionId, bool isYes, String amount) async {
    try {
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      final result = await contract.call(
        'calculateReturn',
        [
          Felt.fromString(predictionId),
          Felt.fromInt(isYes ? 1 : 0),
          Felt.fromString(amountWei.toString()),
        ],
      );

      return result[0].toString();
    } catch (e) {
      throw Exception('Failed to calculate return: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(int marketId) async {
    try {
      final result = await contract.call(
        'get_comments',
        [Felt.fromInt(marketId)],
      );
      final comments = result[0] as List;

      return comments.map((comment) {
        return {
          'id': comment[0],
          'user': comment[1],
          'text': comment[2],
          'timestamp': comment[3],
          'likes': comment[4],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  Future<void> addComment(int marketId, String text) async {
    try {
      await contract.execute(
        'add_comment',
        [Felt.fromInt(marketId), Felt.fromString(text)],
      );
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deleteComment(int marketId, int commentId) async {
    try {
      await contract.execute(
        'delete_comment',
        [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> likeComment(int marketId, int commentId) async {
    try {
      await contract.execute(
        'like_comment',
        [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<void> unlikeComment(int marketId, int commentId) async {
    try {
      await contract.execute(
        'unlike_comment',
        [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }
}
