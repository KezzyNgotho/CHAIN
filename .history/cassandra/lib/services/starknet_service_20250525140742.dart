import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl = 'https://starknet-sepolia.public.blastapi.io';
  static const String predictionMarketAddress =
      '0x0245dfbee17aec37573fe5d3c8b9160eba3ba8b44a29366fbcee838be8cca192';
  static const String chainId = 'SN_SEPOLIA';

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract predictionMarketContract;
  String? userAddress;

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: rpcUrl);
  }

  Future<void> connectWallet(String privateKey) async {
    try {
      final signer = Signer(privateKey: privateKey);
      final accountAddress = await signer.getPublicKey();

      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: chainId,
      );

      predictionMarketContract = Contract(
        provider: provider,
        address: Felt.fromHexString(predictionMarketAddress),
      );

      userAddress = accountAddress.toString();
    } catch (e) {
      throw Exception('Failed to connect wallet: $e');
    }
  }

  Future<String> getCurrentUserAddress() async {
    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }
    return userAddress!;
  }

  Future<List<Map<String, dynamic>>> getMarkets() async {
    try {
      final count = await predictionMarketContract.call(
        selector: 'getMarketCount',
        calldata: [],
      );
      final markets = <Map<String, dynamic>>[];

      for (var i = 0; i < count[0].toInt(); i++) {
        final market = await predictionMarketContract.call(
          selector: 'getMarket',
          calldata: [Felt.fromInt(i)],
        );
        markets.add({
          'id': i,
          'question': market[0].toString(),
          'endTime': market[1].toInt(),
          'yesStake': market[2].toInt(),
          'noStake': market[3].toInt(),
          'resolved': market[4].toInt() == 1,
          'outcome': market[5].toInt() == 1,
        });
      }

      return markets;
    } catch (e) {
      throw Exception('Failed to get markets: $e');
    }
  }

  Future<Map<String, dynamic>> getMarket(int marketId) async {
    try {
      final market = await predictionMarketContract.call(
        selector: 'getMarket',
        calldata: [Felt.fromInt(marketId)],
      );
      return {
        'id': marketId,
        'question': market[0].toString(),
        'endTime': market[1].toInt(),
        'yesStake': market[2].toInt(),
        'noStake': market[3].toInt(),
        'resolved': market[4].toInt() == 1,
        'outcome': market[5].toInt() == 1,
      };
    } catch (e) {
      throw Exception('Failed to get market: $e');
    }
  }

  Future<String> createMarket(String question, int endTime) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'createMarket',
        calldata: [Felt.fromString(question), Felt.fromInt(endTime)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to create market: $e');
    }
  }

  Future<String> placeBet(int marketId, bool isYes, int amount) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'placeBet',
        calldata: [
          Felt.fromInt(marketId),
          Felt.fromInt(isYes ? 1 : 0),
          Felt.fromInt(amount),
        ],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to place bet: $e');
    }
  }

  Future<String> resolveMarket(int marketId, bool outcome) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'resolveMarket',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(outcome ? 1 : 0)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to resolve market: $e');
    }
  }

  Future<String> claimWinnings(int marketId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'claimWinnings',
        calldata: [Felt.fromInt(marketId)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to claim winnings: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(int marketId) async {
    try {
      final commentCount = await predictionMarketContract.call(
        selector: 'getCommentCount',
        calldata: [Felt.fromInt(marketId)],
      );
      final comments = <Map<String, dynamic>>[];

      for (var i = 0; i < commentCount[0].toInt(); i++) {
        final comment = await predictionMarketContract.call(
          selector: 'getComment',
          calldata: [Felt.fromInt(marketId), Felt.fromInt(i)],
        );
        comments.add({
          'id': i,
          'text': comment[0].toString(),
          'user': comment[1].toString(),
          'likes': comment[2].toInt(),
          'liked': comment[3].toInt() == 1,
        });
      }

      return comments;
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  Future<String> addComment(int marketId, String text) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'addComment',
        calldata: [Felt.fromInt(marketId), Felt.fromString(text)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<String> deleteComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'deleteComment',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<String> likeComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'likeComment',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<String> unlikeComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: 'unlikeComment',
        calldata: [Felt.fromInt(marketId), Felt.fromInt(commentId)],
      );
      return tx.hash;
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }
}
