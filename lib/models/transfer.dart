class TransferModel {
  final String key;
  final dynamic timeStamp;
  final dynamic amount;
  final dynamic senderBalanceBefore;
  final dynamic senderBalanceAfter;
  final dynamic benefBalanceBefore;
  final dynamic benefBalanceAfter;
  final dynamic fromKey;
  final dynamic toKey;
  final String error;

  TransferModel({
    this.amount,
    this.benefBalanceAfter,
    this.benefBalanceBefore,
    this.senderBalanceAfter,
    this.senderBalanceBefore,
    this.fromKey,
    this.key,
    this.timeStamp,
    this.toKey,
    this.error,
  });
}
