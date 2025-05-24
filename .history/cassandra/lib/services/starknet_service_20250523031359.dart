import 'package:starknet/starknet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-goerli.infura.io/v3/YOUR_INFURA_KEY';
  static const String contractAddress = '0x...'; // Your contract address

  late final RpcProvider provider;
  late final Account account;
  late final Contract contract;

  StarkNetService() {
    provider = RpcProvider(rpcUrl);
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
        functionName: 'stake',
        calldata: [
          predictionId,
          isYes ? 1 : 0,
          amountWei.toString(),
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
        functionName: 'getPrediction',
        calldata: [predictionId],
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
        functionName: 'calculateReturn',
        calldata: [
          predictionId,
          isYes ? 1 : 0,
          amountWei.toString(),
        ],
      );

      return result[0].toString();
    } catch (e) {
      throw Exception('Failed to calculate return: $e');
    }
  }
}
