class BonusModel {
  final String key;
  final dynamic timeStamp;
  final dynamic toKey;
  final dynamic fromKey;
  final String type;
  final dynamic amount;
  final String status;
  final String error;

  BonusModel({
    this.amount,
    this.status,
    this.fromKey,
    this.key,
    this.timeStamp,
    this.toKey,
    this.type,
    this.error,
  });
}
