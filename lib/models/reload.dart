import 'package:flutter/foundation.dart';

class ReloadModel {
  final String key;
  final dynamic timeStamp;
  final String channel;
  final String account;
  final String system;
  final dynamic amountXOF;
  final dynamic balanceBefore;
  final dynamic balanceAfter;
  final dynamic amountCrypto;
  final dynamic userKey;
  final String txid;
  final String network;
  final String status;
  final String error;

  ReloadModel({
    this.key,
    this.timeStamp,
    this.channel,
    this.account,
    this.system,
    this.amountCrypto,
    this.amountXOF,
    this.balanceAfter,
    this.balanceBefore,
    this.error,
    this.network,
    this.status,
    this.txid,
    this.userKey,
  });
}

class CryptoNetworkModel {
  final String key;
  final String name;
  final String currency;
  // ignore: non_constant_identifier_names
  final dynamic total_received;
  // ignore: non_constant_identifier_names
  final dynamic total_sent;
  final bool isActive;
  final String error;

  CryptoNetworkModel({
    this.key,
    this.name,
    this.currency,
    // ignore: non_constant_identifier_names
    this.total_received,
    // ignore: non_constant_identifier_names
    this.total_sent,
    this.isActive,
    this.error,
  });
}

class CryptoPayinModel {
  final String key;
  final dynamic timeStamp;
  final dynamic usageStamp;
  final int confirmations;
  final dynamic amountCrypto;
  final dynamic amountXOF;
  final dynamic rateXOF;
  final dynamic fees;
  final dynamic amountPaid;
  final String txid;
  final String systemAddress;
  final String fromAddress;
  final String currency;
  final dynamic userKey;
  final String username;
  final String token;
  final String status;
  final String error;

  CryptoPayinModel({
    this.key,
    this.amountCrypto,
    this.amountPaid,
    this.amountXOF,
    this.confirmations,
    this.currency,
    this.fees,
    this.fromAddress,
    this.rateXOF,
    this.status,
    this.systemAddress,
    this.timeStamp,
    this.txid,
    this.usageStamp,
    this.userKey,
    this.username,
    this.token,
    this.error,
  });
}

class MobileNetworkModel {
  final String key;
  final String name;
  final int countryCode;
  final String countryName;
  // ignore: non_constant_identifier_names
  final int local_number_length;
  // ignore: non_constant_identifier_names
  final String mobile_money_name;
  // ignore: non_constant_identifier_names
  final String system_benef_name;
  // ignore: non_constant_identifier_names
  final String system_account_international;
  // ignore: non_constant_identifier_names
  final String system_account_national;
  // ignore: non_constant_identifier_names
  final int network_mmc;
  // ignore: non_constant_identifier_names
  final int network_mnc;
  // ignore: non_constant_identifier_names
  final dynamic total_received;
  // ignore: non_constant_identifier_names
  final dynamic total_sent;
  final List<dynamic> codes;
  // ignore: non_constant_identifier_names
  final String ussd_money_send_national;
  // ignore: non_constant_identifier_names
  final String ussd_money_send_international;
  // ignore: non_constant_identifier_names
  final String ussd_money_balance;
  final String logo;
  final bool isActive;
  final String error;

  MobileNetworkModel({
    this.key,
    this.codes,
    this.countryCode,
    this.countryName,
    this.error,
    this.isActive,
    // ignore: non_constant_identifier_names
    this.local_number_length,
    this.logo,
    // ignore: non_constant_identifier_names
    this.mobile_money_name,
    // ignore: non_constant_identifier_names
    @required this.system_benef_name,
    this.name,
    // ignore: non_constant_identifier_names
    this.system_account_international,
    // ignore: non_constant_identifier_names
    this.system_account_national,
    // ignore: non_constant_identifier_names
    this.network_mmc,
    // ignore: non_constant_identifier_names
    this.network_mnc,
    // ignore: non_constant_identifier_names
    this.total_received,
    // ignore: non_constant_identifier_names
    this.total_sent,
    // ignore: non_constant_identifier_names
    this.ussd_money_balance,
    // ignore: non_constant_identifier_names
    this.ussd_money_send_international,
    // ignore: non_constant_identifier_names
    this.ussd_money_send_national,
  });
}
