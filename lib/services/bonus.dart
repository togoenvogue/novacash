import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/bonus.dart';
import '../config/configuration.dart';

class BonusService {
  Future<List<BonusModel>> myBonuses({
    @required String userKey,
    @required int month,
    @required year,
  }) async {
    var body = '''query {
                    mesBonus(userKey: "$userKey", month: $month, year: $year) {
                      _key
                      timeStamp
                      amount
                      type
                      status
                      toKey {
                        _key
                        fullName
                        username
                        phone
                        countryFlag
                        countryName
                      }
                      fromKey {
                        _key
                        fullName
                        username
                        phone
                        countryFlag
                        countryName
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
      var jsonDataFinal = jsonData['data']['mesBonus'];

      //print(jsonDataFinal.length);
      List<BonusModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          BonusModel obj = BonusModel(
            key: data['_key'] as String,
            amount: data['amount'] as dynamic,
            status: data['status'] as String,
            fromKey: data['fromKey'] as Object,
            timeStamp: data['timeStamp'] as dynamic,
            toKey: data['toKey'] as Object,
            type: data['type'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<BonusModel> objArray = [];
        BonusModel obj = BonusModel(
          key: null,
          amount: null,
          status: null,
          fromKey: null,
          timeStamp: null,
          toKey: null,
          type: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<BonusModel> objArray = [];
      BonusModel obj = BonusModel(
        key: null,
        amount: null,
        status: null,
        fromKey: null,
        timeStamp: null,
        toKey: null,
        type: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end get bonuses
}
