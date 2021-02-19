import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/transfer.dart';
import '../config/configuration.dart';

class TransfertService {
  Future<List<TransferModel>> transferts({
    @required String userKey,
    @required int month,
    @required int year,
  }) async {
    var body = '''query {
                transferByUserKey(userKey: "$userKey", month: $month, year: $year) {
                  _key
                  timeStamp
                  amount
                  senderBalanceBefore
                  senderBalanceAfter
                  benefBalanceBefore
                  benefBalanceAfter
                  fromKey {
                    _key
                    firstName
                    lastName
                    username
                  }
                  toKey {
                    _key
                    firstName
                    lastName
                    username
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
      var jsonDataFinal = jsonData['data']['transferByUserKey'];

      //print(jsonDataFinal.length);
      List<TransferModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          TransferModel obj = TransferModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            amount: data['amount'] as dynamic,
            senderBalanceBefore: data['senderBalanceBefore'] as dynamic,
            senderBalanceAfter: data['senderBalanceAfter'] as dynamic,
            benefBalanceBefore: data['benefBalanceBefore'] as dynamic,
            benefBalanceAfter: data['benefBalanceAfter'] as dynamic,
            fromKey: data['fromKey'] as Object,
            toKey: data['toKey'] as Object,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<TransferModel> objArray = [];
        TransferModel obj = TransferModel(
          key: null,
          timeStamp: null,
          amount: null,
          fromKey: null,
          toKey: null,
          benefBalanceAfter: null,
          benefBalanceBefore: null,
          senderBalanceAfter: null,
          senderBalanceBefore: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<TransferModel> objArray = [];
      TransferModel obj = TransferModel(
        key: null,
        timeStamp: null,
        amount: null,
        fromKey: null,
        toKey: null,
        benefBalanceAfter: null,
        benefBalanceBefore: null,
        senderBalanceAfter: null,
        senderBalanceBefore: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // get transferts

  // create transfert
  // ignore: missing_return
  Future<TransferModel> transfertCreate({
    @required String fromKey,
    @required String toKey,
    @required dynamic amount,
  }) async {
    var body = '''mutation {
                    transferCreate(fromKey: "$fromKey", toKey: "$toKey", amount: $amount) {
                      _key
                      timeStamp
                      amount
                      senderBalanceBefore
                      senderBalanceAfter
                      benefBalanceBefore
                      benefBalanceAfter
                      fromKey {
                        _key
                        firstName
                        lastName
                        username
                      }
                      toKey {
                        _key
                        firstName
                        lastName
                        username
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
      var data = jsonData['data']['transferCreate'];
      //print(data);

      if (data != null) {
        TransferModel obj = TransferModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amount: data['amount'] as dynamic,
          senderBalanceBefore: data['senderBalanceBefore'] as dynamic,
          senderBalanceAfter: data['senderBalanceAfter'] as dynamic,
          benefBalanceBefore: data['benefBalanceBefore'] as dynamic,
          benefBalanceAfter: data['benefBalanceAfter'] as dynamic,
          fromKey: data['fromKey'] as Object,
          toKey: data['toKey'] as Object,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      TransferModel obj = TransferModel(
        key: null,
        timeStamp: null,
        amount: null,
        fromKey: null,
        benefBalanceAfter: null,
        benefBalanceBefore: null,
        senderBalanceAfter: null,
        senderBalanceBefore: null,
        toKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end create transfer

}
