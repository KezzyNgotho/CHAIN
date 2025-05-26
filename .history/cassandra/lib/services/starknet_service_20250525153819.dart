import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../contracts/prediction_market_abi.dart';

class StarkNetService {
  static const String rpcUrl = 'https://starknet-sepolia.public.blastapi.io';
  static const Felt chainId = Felt.fromHexString('0x534e5f5345504f4c4941'); // SN_SEPOLIA
  static const String _accountClassHash = '0xYOUR_ACCOUNT_CLASS_HASH';

  late final JsonRpcProvider _provider;
  late final Account _account;
  late final Contract _predictionMarketContract;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> initialize() async {
    _provider = JsonRpcProvider(nodeUri: Uri.parse(rpcUrl));
    await _initializeAccount();
    _initializeContract();
  }

  Future<void> _initializeAccount() async {
    final privateKey = await _secureStorage.read(key: 'starknet_key') 
      ?? throw Exception('No private key stored');
    
    final signer = Signer(privateKey: Felt.fromHexString(privateKey));
    final publicKey = await signer.getPublicKey();
    
    _account = Account(
      provider: _provider,
      signer: signer,
      accountAddress: Account.computeAddress(
        publicKey: publicKey,
        classHash: Felt.fromHexString(_accountClassHash),
      ),
      chainId: chainId,
    );
  }

  void _initializeContract() {
    _predictionMarketContract = Contract(
      account: _account,
      abi: PredictionMarketABI.abi,
      address: Felt.fromHexString(PredictionMarketABI.contractAddress),
    );
  }

  Future<String> get currentUserAddress async => _account.accountAddress.toHexString();

  Future<List<Map<String, dynamic>>> getMarkets() async {
    try {
      final response = await _predictionMarketContract.call('getMarketCount');
      final count = response[0].toInt();
      
      return await Future.wait(
        List.generate(count, (i) => _getMarketDetails(i))
      );
    } on RpcError catch (e) {
      throw Exception('RPC Error: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> _getMarketDetails(int marketId) async {
    final response = await _predictionMarketContract.call(
      'getMarket', 
      [Felt.fromInt(marketId)]
    );
    
    return {
      'id': marketId,
      'question': _decodeString(response[0]),
      'endTime': response[1].toInt(),
      'yesStake': (response[2].toDouble() / 1e18).toStringAsFixed(4),
      'noStake': (response[3].toDouble() / 1e18).toStringAsFixed(4),
      'resolved': response[4].toInt() == 1,
      'outcome': response[5].toInt() == 1,
    };
  }

  Future<String> createMarket(String question, int endTime) async {
    try {
      final call = _predictionMarketContract.prepareCall(
        'createMarket',
        [..._encodeString(question), Felt.fromInt(endTime)],
      );

      final estimatedFee = await _account.estimateFee(call);
      final tx = await _predictionMarketContract.execute(
        call,
        maxFee: estimatedFee.amount * BigInt.from(150) ~/ BigInt.from(100),
      );

      return tx.transactionHash;
    } on RpcError catch (e) {
      throw Exception('Create market failed: ${e.message}');
    }
  }

  Future<String> placeBet(int marketId, bool isYes, double amount) async {
    try {
      final weiAmount = BigInt.from(amount * 1e18);
      final call = _predictionMarketContract.prepareCall(
        'placeBet',
        [Felt.fromInt(marketId), Felt.fromInt(isYes ? 1 : 0), Felt.fromBigInt(weiAmount)],
      );

      final estimatedFee = await _account.estimateFee(call);
      final tx = await _predictionMarketContract.execute(
        call,
        maxFee: estimatedFee.amount * BigInt.from(120) ~/ BigInt.from(100),
      );

      return tx.transactionHash;
    } on RpcError catch (e) {
      throw Exception('Place bet failed: ${e.message}');
    }
  }

  // Similar pattern for other transaction methods (resolveMarket, claimWinnings, etc.)

  List<Felt> _encodeString(String input) {
    final encoded = encodeShortString(input);
    return [Felt.fromInt(encoded.length)]..addAll(encoded);
  }

  String _decodeString(Felt felt) {
    return decodeShortString(felt.toDartInt());
  }

  Future<void> _validateConnection() async {
    if (!_account.accountAddress.isValid) {
      await initialize();
    }
  }

  // Security-sensitive methods
  Future<void> updatePrivateKey(String newKey) async {
    await _secureStorage.write(key: 'starknet_key', value: newKey);
    await initialize();
  }

  Future<void> clearWallet() async {
    await _secureStorage.delete(key: 'starknet_key');
    _account.dispose();
  }
}