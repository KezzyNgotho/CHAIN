import 'package:starknet/starknet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-goerli.infura.io/v3/d0715abf1c98448697d99e36f2ed2800';
  static const String contractAddress = '0x...'; // Your contract address

  late final Provider provider;
  late final Account account;
  late final Contract contract;

  StarkNetService() {
    provider = Provider(rpcUrl);
    // Initialize with a default account for testing
    account = Account(
      provider: provider,
      address: '0x...', // Your account address
      privateKey: '0x...', // Your private key (keep this secure!)
    );

    // Initialize contract with ABI
    contract = Contract(
      address: contractAddress,
      provider: provider,
      account: account,
      abi: [], // We'll add the ABI in the next step
    );
  }

  Future<String> stake(String predictionId, bool isYes, String amount) async {
    try {
      // Convert amount to wei
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      // Prepare the transaction
      final tx = await contract.invoke(
        'stake',
        [predictionId, isYes ? 1 : 0, amountWei.toString()],
      );

      // Send the transaction
      final result = await provider.sendTransaction(tx);

      return result.transactionHash;
    } catch (e) {
      throw Exception('Failed to stake: $e');
    }
  }

  Future<Map<String, dynamic>> getPredictionDetails(String predictionId) async {
    try {
      final result = await contract.read(
        'getPrediction',
        [predictionId],
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

      final result = await contract.read(
        'calculateReturn',
        [predictionId, isYes ? 1 : 0, amountWei.toString()],
      );

      return result[0].toString();
    } catch (e) {
      throw Exception('Failed to calculate return: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(int marketId) async {
    try {
      final result = await contract.call('get_comments', [marketId]);
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
      await contract.invoke('add_comment', [marketId, text]);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deleteComment(int marketId, int commentId) async {
    try {
      await contract.invoke('delete_comment', [marketId, commentId]);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> likeComment(int marketId, int commentId) async {
    try {
      await contract.invoke('like_comment', [marketId, commentId]);
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<void> unlikeComment(int marketId, int commentId) async {
    try {
      await contract.invoke('unlike_comment', [marketId, commentId]);
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }
}
