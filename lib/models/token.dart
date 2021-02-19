class TokenModel {
  final String key;
  final dynamic timeStamp;
  final dynamic usageStamp;
  final dynamic adminKey;
  final dynamic userKey;
  final dynamic amount;
  final String token;
  final String error;
  final dynamic userBalanceBefore;
  final dynamic userBalanceAfter;

  TokenModel({
    this.adminKey,
    this.amount,
    this.error,
    this.key,
    this.timeStamp,
    this.usageStamp,
    this.token,
    this.userKey,
    this.userBalanceAfter,
    this.userBalanceBefore,
  });
}
