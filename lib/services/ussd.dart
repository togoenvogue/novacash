import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/withdrawal.dart';
import '../models/ussd.dart';

class UssdService {
  // ignore: missing_return
  Future<List<UssdIncomingModel>> getIncomingUssd({@required int code}) async {
    var body = '''''';

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
      var jsonDataFinal = jsonData['data']['mobileNetworksByCountry'];

      //print(jsonDataFinal.length);
      List<UssdIncomingModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          UssdIncomingModel obj = UssdIncomingModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            amount: data['amount'] as dynamic,
            message: data['message'] as String,
            network: data['network'] as String,
            newBalance: data['newBalance'] as dynamic,
            payId: data['payId'] as String,
            phone: data['phone'] as String,
            sender: data['sender'] as String,
            status: data['status'] as String,
            type: data['type'] as String,
            zone: data['zone'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<UssdIncomingModel> objArray = [];
        UssdIncomingModel obj = UssdIncomingModel(
          message: null,
          sender: null,
          key: null,
          timeStamp: null,
          amount: null,
          payId: null,
          phone: null,
          network: null,
          newBalance: null,
          type: null,
          zone: null,
          status: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<UssdIncomingModel> objArray = [];
      UssdIncomingModel obj = UssdIncomingModel(
        message: null,
        sender: null,
        key: null,
        timeStamp: null,
        amount: null,
        payId: null,
        phone: null,
        network: null,
        newBalance: null,
        type: null,
        zone: null,
        status: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  }
  // end get operators

  // ignore: missing_return
  Future<UssdIncomingModel> processNewPaymentMessage({
    @required String sender,
    @required String message,
  }) async {
    var body = '''mutation {
                  incomingPayment(sender: "$sender", message: "$message") {
                    _key
                    timeStamp
                    sender
                    message
                    amount
                    payId
                    phone
                    network
                    newBalance
                    type
                    zone
                    status
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
      var data = jsonData['data']['incomingPayment'];
      //print(data);
      if (data != null) {
        UssdIncomingModel obj = UssdIncomingModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amount: data['amount'] as dynamic,
          message: data['message'] as String,
          network: data['network'] as String,
          newBalance: data['newBalance'] as dynamic,
          payId: data['payId'] as String,
          phone: data['phone'] as String,
          sender: data['sender'] as String,
          status: data['status'] as String,
          type: data['type'] as String,
          zone: data['zone'] as String,
          error: null,
        );
        return obj;
      }
    } else {
      UssdIncomingModel obj = UssdIncomingModel(
        message: null,
        sender: null,
        key: null,
        timeStamp: null,
        amount: null,
        payId: null,
        phone: null,
        network: null,
        newBalance: null,
        type: null,
        zone: null,
        status: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end send new message to the server

  // get pending withdrawals
  Future<List<WithdrawalModel>> adminWithdrawals({
    @required int month,
    @required int year,
  }) async {
    var body = '''query {
                    adminWithdrawals(
                      month: $month, 
                      year: $year) {
                      _key
                      timeStamp
                      channel
                      account
                      mobileMoney
                      amountCrypto
                      amount
                      txid
                      firstName
                      lastName
                      city
                      country
                      balance_before
                      balance_after
                      status
                      countryCode
                      isLocal
                      userKey {
                        _key
                        username
                        firstName
                        lastName
                        phone
                        countryCode
                        countryFlag
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
      var jsonDataFinal = jsonData['data']['adminWithdrawals'];

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
            status: data['status'] as String,
            amount: data['amount'] as dynamic,
            mobileMoney: data['mobileMoney'] as String,
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
        mobileMoney: null,
        countryCode: null,
        isLocal: null,
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
      objArray.add(obj);
      return objArray;
    }
  }

  // process withdrawal (close)
  // ignore: missing_return
  Future<WithdrawalModel> closeWithdrawal({@required String key}) async {
    var body = '''mutation {
                    withdrawalMobileClose(key: $key) {
                      _key
                      timeStamp
                      channel
                      account
                      mobileMoney
                      amountCrypto
                      amount
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
      var data = jsonData['data']['withdrawalMobileClose'];
      //print(data);

      if (data != null) {
        WithdrawalModel obj = WithdrawalModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          account: data['account'] as String,
          channel: data['channel'] as String,
          status: data['status'] as String,
          amount: data['amount'] as dynamic,
          mobileMoney: data['mobileMoney'] as String,
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
  } // end close withdrawal

  // withdrawal by Key
  // ignore: missing_return
  Future<WithdrawalModel> getWithdrawal({@required String key}) async {
    var body = '''query {
                    withdrawalByKey(key: "$key") {
                      _key
                      timeStamp
                      channel
                      account
                      mobileMoney
                      amountCrypto
                      amount
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
                        fullName
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
      var data = jsonData['data']['withdrawalByKey'];
      //print(data);

      if (data != null) {
        WithdrawalModel obj = WithdrawalModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          account: data['account'] as String,
          channel: data['channel'] as String,
          status: data['status'] as String,
          amount: data['amount'] as dynamic,
          mobileMoney: data['mobileMoney'] as String,
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
  } // end withdrawal by key

}
