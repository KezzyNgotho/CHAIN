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
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      final signer = Signer(privateKey: Felt.fromString(privateKey));
      final accountAddress = Felt.fromString(
          '0x2195d4d849cddeaaad7e62d7aaf49ee7cc79534d41c6271eed7535c9cb6cce1');

      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: Felt.fromString('SN_SEPOLIA'),
      );

      predictionMarketContract = Contract(
        account: account,
        address: Felt.fromString(predictionMarketAddress),
      );

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

  // Market methods
  Future<Map<String, dynamic>> getMarket(int marketId) async {
    try {
      final result = await predictionMarketContract.call(
        'getMarket',
        [Felt.fromInt(marketId)],
      );

      return {
        'id': result[0].toString(),
        'creator': result[1].toString(),
        'question': result[2].toString(),
        'category': result[3].toString(),
        'end_time': result[4].toString(),
        'resolved': result[5].toString() == '1',
        'outcome': result[6].toString() == '1',
        'yes_pool': result[7].toString(),
        'no_pool': result[8].toString(),
        'created_at': result[9].toString(),
        'total_staked': result[10].toString(),
        'is_verified': result[11].toString() == '1',
        'is_cancelled': result[12].toString() == '1',
      };
    } catch (e) {
      throw Exception('Failed to get market: $e');
    }
  }

  Future<String> createMarket(
      String question, String category, int endTime) async {
    try {
      final tx = await predictionMarketContract.execute(
        'createMarket',
        [
          Felt.fromString(question),
          Felt.fromString(category),
          Felt.fromInt(endTime),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to create market: $e');
    }
  }

  Future<String> placeBet(int marketId, String amount, bool isYes) async {
    try {
      final tx = await predictionMarketContract.execute(
        'placeBet',
        [
          Felt.fromInt(marketId),
          Felt.fromString(amount),
          Felt.fromInt(isYes ? 1 : 0),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to place bet: $e');
    }
  }

  Future<String> resolveMarket(int marketId, bool outcome) async {
    try {
      final tx = await predictionMarketContract.execute(
        'resolveMarket',
        [
          Felt.fromInt(marketId),
          Felt.fromInt(outcome ? 1 : 0),
        ],
      );

      return tx.hash.toString();
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

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to claim winnings: $e');
    }
  }
}
