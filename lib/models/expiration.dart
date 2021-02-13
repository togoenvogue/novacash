class ExpirationModel {
  final String key;
  final dynamic timeStamp;
  final int days;
  final dynamic expiry;
  final dynamic userKey;
  final dynamic amount;
  final String error;

  ExpirationModel({
    this.key,
    this.amount,
    this.days,
    this.expiry,
    this.timeStamp,
    this.userKey,
    this.error,
  });
}
