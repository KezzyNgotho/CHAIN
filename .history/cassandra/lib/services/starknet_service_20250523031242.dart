import 'package:starknet/starknet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-goerli.infura.io/v3/YOUR_INFURA_KEY';
  static const String contractAddress = '0x...'; // Your contract address
  static const String abi = '[...]'; // Your contract ABI

  final Provider provider;
  final Contract contract;

  StarkNetService()
      : provider = Provider(rpcUrl),
        contract = Contract(contractAddress, abi);

  Future<String> stake(String predictionId, bool isYes, String amount) async {
    try {
      // Convert amount to wei
      final amountWei = BigInt.from(double.parse(amount) * 1e18);

      // Prepare the transaction
      final tx = await contract.write(
        'stake',
        [predictionId, isYes, amountWei],
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
        [predictionId, isYes, amountWei],
      );

      return result[0].toString();
    } catch (e) {
      throw Exception('Failed to calculate return: $e');
    }
  }
}
