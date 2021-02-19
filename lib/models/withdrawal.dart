import 'package:flutter/foundation.dart';

class WithdrawalModel {
  final String key;
  final dynamic timeStamp;
  final dynamic userKey;
  final dynamic amount;
  final dynamic amountCrypto;
  final String channel;
  final String mobileMoney;
  final String account;
  final String txid;
  final String status;
  final String error;
  final int countryCode;
  final bool isLocal;
  final String firstName;
  final String lastName;
  final String city;
  final String country;

  WithdrawalModel({
    this.key,
    this.timeStamp,
    @required this.userKey,
    @required this.amount,
    this.amountCrypto,
    @required this.channel,
    @required this.account,
    @required this.mobileMoney,
    this.txid,
    this.status,
    this.error,
    this.countryCode,
    this.isLocal,
    this.city,
    this.country,
    this.firstName,
    this.lastName,
  });
}
