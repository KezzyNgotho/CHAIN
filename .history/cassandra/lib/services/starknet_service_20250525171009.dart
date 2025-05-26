import 'package:starknet/starknet.dart';
import 'package:starknet_provider/src/model/invoke_transaction.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../contracts/contract_abi.dart';

class StarkNetService {
  static const String rpcUrl = 'https://starknet-sepolia.public.blastapi.io';
  static const String chainId = '0x534e5f5345504f4c4941'; // SN_SEPOLIA in hex

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract predictionMarketContract;
  String? userAddress;

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
    try {
      // Initialize with a default account for read-only operations
      account = Account(
        provider: provider,
        signer: Signer(privateKey: Felt.fromHexString('0x0')),
        accountAddress: Felt.fromHexString('0x0'),
        chainId: Felt.fromHexString(chainId),
      );
      // Use the correct deployed contract address for Sepolia
      final contractAddress =
          '0x0245dfbee17aec37573fe5d3c8b9160eba3ba8b44a29366fbcee838be8cca192';
      predictionMarketContract = Contract(
        account: account,
        address: Felt.fromHexString(contractAddress),
      );
    } catch (e) {
      print('Error initializing StarkNetService: $e');
      // Initialize with null values to prevent null pointer exceptions
      account = Account(
        provider: provider,
        signer: Signer(privateKey: Felt.fromHexString('0x0')),
        accountAddress: Felt.fromHexString('0x0'),
        chainId: Felt.fromHexString(chainId),
      );
      predictionMarketContract = Contract(
        account: account,
        address: Felt.fromHexString('0x0'),
      );
    }
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      final signer = Signer(privateKey: Felt.fromHexString(privateKey));
      final accountAddress = Felt.fromHexString(
          '0x2195d4d849cddeaaad7e62d7aaf49ee7cc79534d41c6271eed7535c9cb6cce1');

      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: Felt.fromHexString(chainId),
      );

      predictionMarketContract = Contract(
        account: account,
        address: Felt.fromHexString(PredictionMarketABI.contractAddress),
      );

      userAddress = accountAddress.toString();
      return true;
    } catch (e) {
      print('Error connecting wallet: $e');
      return false;
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
      final count = await predictionMarketContract.call('getMarketCount', []);
      final markets = <Map<String, dynamic>>[];

      for (var i = 0; i < count[0].toInt(); i++) {
        final market =
            await predictionMarketContract.call('getMarket', [Felt.fromInt(i)]);
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
      final market = await predictionMarketContract
          .call('getMarket', [Felt.fromInt(marketId)]);
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

  Future<String> createMarket(
      String question, String category, int endTime) async {
    try {
      // Selector for createMarket (computed from function name)
      final selector = '0x1e1b5b6e'; // as a hex string

      // Convert question and category to felt-compatible Felts
      Felt stringToFelt(String value) => Felt.fromInt(
            BigInt.parse(value.codeUnits.map((c) => c.toRadixString(16)).join(),
                radix: 16),
          );

      final calldata = <Felt>[
        stringToFelt(question),
        stringToFelt(category),
        Felt.fromInt(BigInt.from(endTime)),
      ];

      final tx = await predictionMarketContract.execute(
        selector: selector,
        calldata: calldata,
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to create market: $e');
    }
  }

  Future<String> placeBet(int marketId, bool isYes, int amount) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector: PredictionMarketABI.getSelector(PredictionMarketABI.placeBet),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.placeBet, [marketId, isYes, amount]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to place bet: $e');
    }
  }

  Future<String> resolveMarket(int marketId, bool outcome) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector:
            PredictionMarketABI.getSelector(PredictionMarketABI.resolveMarket),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.resolveMarket, [marketId, outcome]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to resolve market: $e');
    }
  }

  Future<String> claimWinnings(int marketId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector:
            PredictionMarketABI.getSelector(PredictionMarketABI.claimWinnings),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.claimWinnings, [marketId]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to claim winnings: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getComments(int marketId) async {
    try {
      final commentCount = await predictionMarketContract
          .call('getCommentCount', [Felt.fromInt(marketId)]);
      final comments = <Map<String, dynamic>>[];

      for (var i = 0; i < commentCount[0].toInt(); i++) {
        final comment = await predictionMarketContract
            .call('getComment', [Felt.fromInt(marketId), Felt.fromInt(i)]);
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
        selector:
            PredictionMarketABI.getSelector(PredictionMarketABI.addComment),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.addComment, [marketId, text]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<String> deleteComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector:
            PredictionMarketABI.getSelector(PredictionMarketABI.deleteComment),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.deleteComment, [marketId, commentId]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<String> likeComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector:
            PredictionMarketABI.getSelector(PredictionMarketABI.likeComment),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.likeComment, [marketId, commentId]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to like comment: $e');
    }
  }

  Future<String> unlikeComment(int marketId, int commentId) async {
    try {
      final tx = await predictionMarketContract.execute(
        selector:
            PredictionMarketABI.getSelector(PredictionMarketABI.unlikeComment),
        calldata: PredictionMarketABI.prepareCalldata(
            PredictionMarketABI.unlikeComment, [marketId, commentId]),
      );
      print('Transaction response: $tx');
      return tx.transaction_hash.toString();
    } catch (e) {
      throw Exception('Failed to unlike comment: $e');
    }
  }
}

extension on InvokeTransactionResponse {
  get transaction_hash => null;
}
