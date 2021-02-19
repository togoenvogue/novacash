import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/withdrawal.dart';

class WithdrawService {
  // ignore: missing_return
  Future<WithdrawalModel> withdraw({
    @required String userKey,
    @required dynamic amount,
    @required String channel,
    @required String account,
    @required bool isLocal,
    @required int countryCode,
    @required String mobileMoney,
    String firstName,
    String lastName,
    String city,
    String country,
  }) async {
    var body = '''mutation {
                    withdrawalCreate(
                      userKey: "$userKey", 
                      amount: $amount, 
                      channel: "$channel", 
                      mobileMoney: "$mobileMoney",
                      account: "$account", 
                      isLocal: $isLocal, 
                      countryCode: $countryCode,
                      firstName: "$firstName",
                      lastName: "$lastName",
                      city: "$city",
                      country: "$country"
                      ) {
                      _key
                      timeStamp
                      channel
                      mobileMoney
                      account
                      amountCrypto
                      amount
                      txid
                      balance_before
                      balance_after
                      status
                      firstName
                      lastName
                      city
                      country
                      countryCode
                      isLocal
                      userKey {
                        _key
                        username
                        firstName
                        lastName
                        phone
                      }
                    }
                  }''';

    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': body}),
      headers: {"Content-Type": "application/json"},
    ).catchError((error) {
      throw error;
    });

    //print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data']['withdrawalCreate'];
      //print(data);

      if (data != null) {
        WithdrawalModel obj = WithdrawalModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          account: data['account'] as String,
          channel: data['channel'] as String,
          mobileMoney: data['mobileMoney'] as String,
          status: data['status'] as String,
          amount: data['amount'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          txid: data['txid'] as String,
          countryCode: data['countryCode'] as int,
          isLocal: data['isLocal'] as bool,
          userKey: data['userKey'] as Object,
          city: data['city'] as String,
          country: data['country'] as String,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      WithdrawalModel obj = WithdrawalModel(
        key: null,
        timeStamp: null,
        account: null,
        channel: null,
        countryCode: null,
        isLocal: null,
        mobileMoney: null,
        status: null,
        amount: null,
        amountCrypto: null,
        txid: null,
        userKey: null,
        city: null,
        country: null,
        firstName: null,
        lastName: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end withdraw

  Future<List<WithdrawalModel>> myWithdrawals({
    @required String userKey,
    @required int month,
    @required int year,
  }) async {
    var body = '''query {
                    withdrawalsByUserKey(
                      userKey: "$userKey", 
                      month: $month, 
                      year: $year) {
                      _key
                      timeStamp
                      channel
                      account
                      mobileMoney
                      amountCrypto
                      amount
                      balance_before
                      balance_after
                      firstName
                      lastName
                      city
                      country
                      status
                      txid
                      countryCode
                      isLocal
                      userKey {
                        _key
                        username
                        firstName
                        lastName
                        phone
                      }
                    }
                  }''';

    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': body}),
      headers: {"Content-Type": "application/json"},
    ).catchError((error) {
      //print('error > $error');
      throw error;
    });

    //print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var jsonDataFinal = jsonData['data']['withdrawalsByUserKey'];

      //print(jsonDataFinal.length);
      List<WithdrawalModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          WithdrawalModel obj = WithdrawalModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            account: data['account'] as String,
            channel: data['channel'] as String,
            mobileMoney: data['mobileMoney'] as String,
            status: data['status'] as String,
            amount: data['amount'] as dynamic,
            amountCrypto: data['amountCrypto'] as dynamic,
            txid: data['txid'] as String,
            countryCode: data['countryCode'] as int,
            isLocal: data['isLocal'] as bool,
            userKey: data['userKey'] as Object,
            city: data['city'] as String,
            country: data['country'] as String,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<WithdrawalModel> objArray = [];
        WithdrawalModel obj = WithdrawalModel(
          key: null,
          timeStamp: null,
          account: null,
          channel: null,
          countryCode: null,
          isLocal: null,
          mobileMoney: null,
          status: null,
          amount: null,
          amountCrypto: null,
          txid: null,
          userKey: null,
          city: null,
          country: null,
          firstName: null,
          lastName: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<WithdrawalModel> objArray = [];
      WithdrawalModel obj = WithdrawalModel(
        key: null,
        timeStamp: null,
        account: null,
        channel: null,
        countryCode: null,
        isLocal: null,
        status: null,
        amount: null,
        amountCrypto: null,
        mobileMoney: null,
        txid: null,
        userKey: null,
        city: null,
        country: null,
        firstName: null,
        lastName: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  }
  // end my withdrawals
}
