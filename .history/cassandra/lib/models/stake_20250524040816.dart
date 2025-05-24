class Stake {
  final BigInt amount;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime lastClaimTime;
  final BigInt totalRewards;
  final bool isActive;

  Stake({
    required this.amount,
    required this.startTime,
    required this.endTime,
    required this.lastClaimTime,
    required this.totalRewards,
    required this.isActive,
  });

  factory Stake.fromJson(Map<String, dynamic> json) {
    return Stake(
      amount: BigInt.parse(json['amount'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      lastClaimTime: DateTime.parse(json['lastClaimTime'] as String),
      totalRewards: BigInt.parse(json['totalRewards'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toString(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'lastClaimTime': lastClaimTime.toIso8601String(),
      'totalRewards': totalRewards.toString(),
      'isActive': isActive,
    };
  }

  Duration get remainingTime {
    if (!isActive) return Duration.zero;
    final now = DateTime.now();
    if (now.isAfter(endTime)) return Duration.zero;
    return endTime.difference(now);
  }

  bool get canClaim {
    if (!isActive) return false;
    final now = DateTime.now();
    return now.isAfter(lastClaimTime.add(const Duration(hours: 24)));
  }
}
