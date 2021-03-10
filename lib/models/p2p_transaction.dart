class P2PTransactionModel {
  final String key;
  final dynamic timeStamp;
  final dynamic expiry;
  final dynamic fromKey;
  final dynamic toKey;
  final String matrix;
  final dynamic matrixKey;
  final int rang;
  final int cycle;
  final String status;
  final dynamic amountXOF;
  final dynamic amountUSD;
  final dynamic amountBTC;
  final dynamic amountETH;
  final dynamic toChannel;
  final String toAccount;
  final String payRef;
  final dynamic payStamp;
  final String error;

  P2PTransactionModel({
    this.amountBTC,
    this.amountETH,
    this.amountUSD,
    this.amountXOF,
    this.error,
    this.expiry,
    this.fromKey,
    this.key,
    this.matrix,
    this.matrixKey,
    this.payRef,
    this.payStamp,
    this.rang,
    this.cycle,
    this.status,
    this.timeStamp,
    this.toAccount,
    this.toChannel,
    this.toKey,
  });
}
