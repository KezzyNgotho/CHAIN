import 'package:starknet/starknet.dart';

class PredictionMarketABI {
  static const String contractAddress =
      '0x0245dfbee17aec37573fe5d3c8b9160eba3ba8b44a29366fbcee838be8cca192';

  // Function selectors
  static const String getMarketCount = 'getMarketCount';
  static const String getMarket = 'getMarket';
  static const String createMarket = 'createMarket';
  static const String placeBet = 'placeBet';
  static const String resolveMarket = 'resolveMarket';
  static const String claimWinnings = 'claimWinnings';
  static const String getCommentCount = 'getCommentCount';
  static const String getComment = 'getComment';
  static const String addComment = 'addComment';
  static const String deleteComment = 'deleteComment';
  static const String likeComment = 'likeComment';
  static const String unlikeComment = 'unlikeComment';

  // Function signatures
  static Map<String, List<String>> functionSignatures = {
    getMarketCount: ['felt'],
    getMarket: ['felt', 'felt'],
    createMarket: ['felt', 'felt'],
    placeBet: ['felt', 'felt', 'felt'],
    resolveMarket: ['felt', 'felt'],
    claimWinnings: ['felt'],
    getCommentCount: ['felt'],
    getComment: ['felt', 'felt'],
    addComment: ['felt', 'felt'],
    deleteComment: ['felt', 'felt'],
    likeComment: ['felt', 'felt'],
    unlikeComment: ['felt', 'felt'],
  };

  // Function selectors (hashed function names)
  static Map<String, String> selectors = {
    getMarketCount: '0x2f54bf6e', // Example hash, replace with actual
    getMarket: '0x3d7d3f5a', // Example hash, replace with actual
    createMarket: '0x4a25d94a', // Example hash, replace with actual
    placeBet: '0x5a4b9c3d', // Example hash, replace with actual
    resolveMarket: '0x6a4b9c3d', // Example hash, replace with actual
    claimWinnings: '0x7a4b9c3d', // Example hash, replace with actual
    getCommentCount: '0x8a4b9c3d', // Example hash, replace with actual
    getComment: '0x9a4b9c3d', // Example hash, replace with actual
    addComment: '0xaa4b9c3d', // Example hash, replace with actual
    deleteComment: '0xba4b9c3d', // Example hash, replace with actual
    likeComment: '0xca4b9c3d', // Example hash, replace with actual
    unlikeComment: '0xda4b9c3d', // Example hash, replace with actual
  };

  // Helper method to get selector for a function
  static String getSelector(String functionName) {
    return selectors[functionName] ?? '';
  }

  // Helper method to get function signature
  static List<String> getFunctionSignature(String functionName) {
    return functionSignatures[functionName] ?? [];
  }

  // Helper method to prepare calldata for a function
  static List<Felt> prepareCalldata(String functionName, List<dynamic> params) {
    final signature = getFunctionSignature(functionName);
    if (signature.length != params.length) {
      throw Exception('Invalid number of parameters for $functionName');
    }

    return params.map((param) {
      if (param is int) return Felt.fromInt(param);
      if (param is String) return Felt.fromString(param);
      if (param is bool) return Felt.fromInt(param ? 1 : 0);
      throw Exception('Unsupported parameter type for $functionName');
    }).toList();
  }
}
