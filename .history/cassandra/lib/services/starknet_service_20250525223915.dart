import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800';
  static const String predictionMarketAddress =
      '0x...'; // Your prediction market contract address
  static const String tokenAddress = '0x...'; // Your token contract address

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract predictionMarketContract;
  late final Contract tokenContract;
  String? userAddress;

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      final signer = Signer(privateKey: Felt.fromString(privateKey));
      final accountAddress =
          Felt.fromInt(0); // Replace with actual address derivation

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

      tokenContract = Contract(
        account: account,
        address: Felt.fromString(tokenAddress),
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
        'get_market',
        [Felt.fromInt(marketId)],
      );

      return {
        'creator': result[0].toString(),
        'title': result[1].toString(),
        'description': result[2].toString(),
        'creation_time': result[3].toString(),
        'end_time': result[4].toString(),
        'is_resolved': result[5].toString() == '1',
        'outcome': result[6].toString() == '1',
        'total_staked': result[7].toString(),
        'yes_staked': result[8].toString(),
        'no_staked': result[9].toString(),
      };
    } catch (e) {
      throw Exception('Failed to get market: $e');
    }
  }

  Future<int> getMarketCount() async {
    try {
      final result = await predictionMarketContract.call(
        'get_market_count',
        [],
      );
      return int.parse(result[0].toString());
    } catch (e) {
      throw Exception('Failed to get market count: $e');
    }
  }

  Future<String> createMarket(
      String title, String description, int endTime) async {
    try {
      final tx = await predictionMarketContract.execute(
        'create_market',
        [
          Felt.fromString(title),
          Felt.fromString(description),
          Felt.fromInt(endTime),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to create market: $e');
    }
  }

  Future<String> resolveMarket(int marketId, bool outcome) async {
    try {
      final tx = await predictionMarketContract.execute(
        'resolve_market',
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

  Future<String> stakeYes(int marketId, String amount) async {
    try {
      final tx = await predictionMarketContract.execute(
        'stake_yes',
        [
          Felt.fromInt(marketId),
          Felt.fromString(amount),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to stake yes: $e');
    }
  }

  Future<String> stakeNo(int marketId, String amount) async {
    try {
      final tx = await predictionMarketContract.execute(
        'stake_no',
        [
          Felt.fromInt(marketId),
          Felt.fromString(amount),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to stake no: $e');
    }
  }

  Future<String> claimWinnings(int marketId) async {
    try {
      final tx = await predictionMarketContract.execute(
        'claim_winnings',
        [Felt.fromInt(marketId)],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to claim winnings: $e');
    }
  }

  // Token methods
  Future<String> getBalance(String userAddress) async {
    try {
      final result = await tokenContract.call(
        'get_balance',
        [Felt.fromString(userAddress)],
      );
      return result[0].toString();
    } catch (e) {
      throw Exception('Failed to get balance: $e');
    }
  }

  Future<String> mint(String to, String amount) async {
    try {
      final tx = await tokenContract.execute(
        'mint',
        [
          Felt.fromString(to),
          Felt.fromString(amount),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to mint tokens: $e');
    }
  }

  Future<String> transfer(String to, String amount) async {
    try {
      final tx = await tokenContract.execute(
        'transfer',
        [
          Felt.fromString(to),
          Felt.fromString(amount),
        ],
      );

      return tx.hash.toString();
    } catch (e) {
      throw Exception('Failed to transfer tokens: $e');
    }
  }
}
