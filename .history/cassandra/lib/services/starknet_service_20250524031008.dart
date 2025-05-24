import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show RpcProvider;
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
    provider = RpcProvider(rpcUrl);
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      // Create account from private key
      final signer = Signer(privateKey: Felt.fromString(privateKey));
      final accountAddress = await signer.getPublicKey();

      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: Felt.fromString('SN_SEPOLIA'),
      );

      // Initialize contract
      contract = Contract(
        address: Felt.fromString(contractAddress),
        provider: provider,
        account: account,
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

  Future<List<Map<String, dynamic>>> getMarkets() async {
    try {
      final result = await contract.call(
        selector: 'get_markets',
        calldata: [],
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
      // Convert amount to wei
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      // Prepare the transaction
      final tx = await contract.execute(
        selector: 'stake',
        calldata: [
          Felt.fromString(predictionId),
          Felt.fromInt(isYes ? 1 : 0),
          Felt.fromString(amountWei.toString())
        ],
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
      final result = await contract.call(
        selector: 'getPrediction',
        calldata: [Felt.fromString(predictionId)],
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
        selector: 'calculateReturn',
        calldata: [
          Felt.fromString(predictionId),
          Felt.fromInt(isYes ? 1 : 0),
          Felt.fromString(amountWei.toString())
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
        selector: 'get_comments',
        calldata: [Felt.fromInt(marketId)],
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
        selector: 'add_comment',
        calldata: [Felt.fromInt(marketId), Felt.fromString(text)],
      );
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deleteComment(int marketId, int commentId) async {
    try {
      await contract.execute(
        selector: 'delete_comment',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> likeComment(int marketId, int commentId) async {
    try {
      await contract.execute(
        selector: 'like_comment',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<void> unlikeComment(int marketId, int commentId) async {
    try {
      await contract.execute(
        selector: 'unlike_comment',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }
}
