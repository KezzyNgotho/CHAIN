import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart' show JsonRpcProvider;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StarkNetService {
  static const String rpcUrl =
      'https://starknet-sepolia.infura.io/v3/d0715abf1c98448697d99e36f2ed2800';
  static const String contractAddress = '0x...'; // Your contract address

  // StarkNet Sepolia chain ID (0x534e5f5345504f4c4941 in hex)
  static final _sepoliaChainId = Felt.fromString('SN_SEPOLIA');

  late final JsonRpcProvider provider;
  late final Account account;
  late final Contract contract;
  String? userAddress;

  StarkNetService() {
    provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
  }

  Future<bool> connectWallet(String privateKey) async {
    try {
      // 1. Create signer with proper validation
      if (!privateKey.startsWith('0x')) {
        throw ArgumentError('Private key must start with 0x');
      }
      final signer = Signer(privateKey: Felt.fromHexString(privateKey));

      // 2. Calculate account address properly
      final accountClassHash =
          Felt.fromHexString('0x...'); // Your account class hash
      final publicKey = await signer.getPublicKey();
      final constructorCalldata = [publicKey];

      final accountAddress = calculateContractAddress(
        classHash: accountClassHash,
        constructorCalldata: constructorCalldata,
      );

      // 3. Initialize account with chain ID
      account = Account(
        provider: provider,
        signer: signer,
        accountAddress: accountAddress,
        chainId: _sepoliaChainId,
      );

      // 4. Check if account is deployed
      final isDeployed = await provider.getClassHashAt(accountAddress);
      if (isDeployed == Felt.zero) {
        throw Exception('Account needs deployment');
      }

      // 5. Initialize contract with ABI (if available)
      contract = Contract(
        account: account,
        address: Felt.fromHexString(contractAddress),
        abi: await _loadContractAbi(), // Implement ABI loading
      );

      userAddress = accountAddress.toHexString();
      return true;
    } catch (e) {
      print('Error connecting wallet: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getMarkets() async {
    try {
      // Use ABI-encoded call
      final result = await contract.call(
        functionName: 'get_markets',
        calldata: [],
      );

      // Proper ABI decoding for struct returns
      return _decodeMarketData(result);
    } catch (e) {
      throw Exception('Failed to get markets: ${e.toString()}');
    }
  }

  Future<String> stake(String predictionId, bool isYes, String amount) async {
    try {
      // 1. Validate input
      final amountBigInt = BigInt.parse(amount);
      if (amountBigInt <= BigInt.zero) {
        throw ArgumentError('Amount must be positive');
      }

      // 2. Use Uint256 for value handling
      final amountUint256 = Uint256.fromBigInt(amountBigInt);

      // 3. Execute transaction with proper encoding
      final tx = await contract.execute(
        functionName: 'stake',
        calldata: [
          Felt.fromHexString(predictionId),
          Felt.fromInt(isYes ? 1 : 0),
          ...amountUint256.toCalldata(),
        ],
      );

      // 4. Wait for transaction confirmation
      final receipt = await provider.waitForTransaction(tx.hash);
      if (receipt.isReverted) {
        throw Exception('Transaction reverted: ${receipt.revertReason}');
      }

      return tx.hash.toHexString();
    } catch (e) {
      throw Exception('Failed to stake: ${e.toString()}');
    }
  }

  // Add similar error handling and ABI encoding/decoding for other methods

  // Helper methods
  Future<Abi> _loadContractAbi() async {
    // Implement ABI loading from file or static definition
    return Abi.fromJson(/* Your contract ABI */);
  }

  List<Map<String, dynamic>> _decodeMarketData(List<Felt> data) {
    // Implement proper ABI decoding based on your contract structure
    // Example for a struct array:
    final markets = <Map<String, dynamic>>[];
    final elementSize = 7; // Number of fields per market struct
    for (var i = 0; i < data.length; i += elementSize) {
      markets.add({
        'id': data[i].toBigInt(),
        'question': _decodeString(data.sublist(i + 1, i + 4)),
        'endTime': data[i + 4].toBigInt(),
        'resolved': data[i + 5].toBigInt() != BigInt.zero,
        'outcome': data[i + 6].toBigInt(),
      });
    }
    return markets;
  }

  String _decodeString(List<Felt> data) {
    return data.map((felt) => String.fromCharCodes(felt.toBytes())).join();
  }
}
