import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl = 'https://starknet-sepolia.public.blastapi.io';
  static const String predictionMarketAddress =
      '0x0245dfbee17aec37573fe5d3c8b9160eba3ba8b44a29366fbcee838be8cca192';

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract predictionMarketContract;
  String? userAddress;

  StarkNetService() {
    provider = JsonRpcProvider(rpcUrl);
  }

  Future<void> connectWallet(String privateKey) async {
    try {
      account = Account(
        provider: provider,
        privateKey: privateKey,
      );

      predictionMarketContract = await Contract.fromAddress(
        provider: provider,
        address: predictionMarketAddress,
      );

      userAddress = account.address.toString();
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
      final count = await predictionMarketContract.call('getMarketCount');
      final markets = <Map<String, dynamic>>[];

      for (var i = 0; i < count.toInt(); i++) {
        final market =
            await predictionMarketContract.call('getMarket', [Felt.fromInt(i)]);
        markets.add({
          'id': i,
          'question': market[0].toString(),
          'endTime': market[1].toInt(),
          'yesStake': market[2].toInt(),
          'noStake': market[3].toInt(),
          'resolved': market[4].toBool(),
          'outcome': market[5].toBool(),
        });
      }

      return markets;
    } catch (e) {
      throw Exception('Failed to get markets: $e');
    }
  }

  Future<Map<String, dynamic>> getMarket(int marketId) async {
    try {
      final market = await predictionMarketContract
          .call('getMarket', [Felt.fromInt(marketId)]);
      return {
        'id': marketId,
        'question': market[0].toString(),
        'endTime': market[1].toInt(),
        'yesStake': market[2].toInt(),
        'noStake': market[3].toInt(),
        'resolved': market[4].toBool(),
        'outcome': market[5].toBool(),
      };
    } catch (e) {
      throw Exception('Failed to get market: $e');
    }
  }

  Future<String> createMarket(String question, int endTime) async {
    try {
      final tx = await predictionMarketContract.execute(
        'createMarket',
        [Felt.fromString(question), Felt.fromInt(endTime)],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to create market: $e');
    }
  }

  Future<String> placeBet(int marketId, bool isYes, int amount) async {
    try {
      final tx = await predictionMarketContract.execute(
        'placeBet',
        [Felt.fromInt(marketId), Felt.fromBool(isYes), Felt.fromInt(amount)],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to place bet: $e');
    }
  }

  Future<String> resolveMarket(int marketId, bool outcome) async {
    try {
      final tx = await predictionMarketContract.execute(
        'resolveMarket',
        [Felt.fromInt(marketId), Felt.fromBool(outcome)],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to resolve market: $e');
    }
  }

  Future<String> claimWinnings(int marketId) async {
    try {
      final tx = await predictionMarketContract.execute(
        'claimWinnings',
        [Felt.fromInt(marketId)],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to claim winnings: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(int marketId) async {
    try {
      final commentCount =
          await predictionMarketContract.call('get_comment_count', [marketId]);
      final comments = <Map<String, dynamic>>[];

      for (var i = 0; i < commentCount; i++) {
        final comment =
            await predictionMarketContract.call('get_comment', [marketId, i]);
        comments.add({
          'id': i,
          'text': comment[0],
          'user': comment[1],
          'likes': comment[2],
          'liked': comment[3],
        });
      }

      return comments;
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  Future<String> addComment(int marketId, String text) async {
    try {
      final tx = await predictionMarketContract.invoke(
        'add_comment',
        [marketId, text],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<String> deleteComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.invoke(
        'delete_comment',
        [marketId, commentId],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<String> likeComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.invoke(
        'like_comment',
        [marketId, commentId],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<String> unlikeComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.invoke(
        'unlike_comment',
        [marketId, commentId],
      );
      return tx.transactionHash;
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }
}
