import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:novacash/models/token.dart';
import '../config/configuration.dart';

class TokenService {
  Future<List<TokenModel>> adminTokens({
    @required String adminKey,
    @required int month,
    @required int year,
    @required int day,
  }) async {
    var body = '''query {
                    tokensByAdminKey(
                      adminKey: "$adminKey", 
                      day: $day, 
                      month: $month, 
                      year: $year) {
                      _key
                      amount
                      token
                      userBalanceBefore
                      userBalanceAfter
                      timeStamp
                      usageStamp
                      userKey {
                        _key
                        firstName
                        lastName
                        username
                      }
                      adminKey {
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
      var jsonDataFinal = jsonData['data']['tokensByAdminKey'];

      //print(jsonDataFinal.length);
      List<TokenModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          TokenModel obj = TokenModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            usageStamp: data['usageStamp'] as dynamic,
            amount: data['amount'] as dynamic,
            adminKey: data['adminKey'] as Object,
            token: data['token'] as String,
            userKey: data['userKey'] as Object,
            userBalanceAfter: data['userBalanceAfter'] as dynamic,
            userBalanceBefore: data['userBalanceBefore'] as dynamic,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<TokenModel> objArray = [];
        TokenModel obj = TokenModel(
          key: null,
          timeStamp: null,
          amount: null,
          usageStamp: null,
          userKey: null,
          token: null,
          adminKey: null,
          userBalanceAfter: null,
          userBalanceBefore: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<TokenModel> objArray = [];
      TokenModel obj = TokenModel(
        key: null,
        timeStamp: null,
        amount: null,
        usageStamp: null,
        token: null,
        userKey: null,
        userBalanceAfter: null,
        userBalanceBefore: null,
        adminKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // get transferts

  // create transfert
  // ignore: missing_return
  Future<TokenModel> tokenCreate({
    @required String adminKey,
    @required int quantity,
  }) async {
    var body = '''mutation {
                    tokenCreate(adminKey: "$adminKey", quantity: $quantity) {
                      _key
                      amount
                      token
                      timeStamp
                      usageStamp
                      userKey {
                        _key
                        firstName
                        lastName
                        username
                      }
                      adminKey {
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
      var data = jsonData['data']['tokenCreate'];
      //print(data);

      if (data != null) {
        TokenModel obj = TokenModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          usageStamp: data['usageStamp'] as dynamic,
          amount: data['amount'] as dynamic,
          adminKey: data['adminKey'] as Object,
          token: data['token'] as String,
          userKey: data['userKey'] as Object,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      TokenModel obj = TokenModel(
        key: null,
        timeStamp: null,
        amount: null,
        usageStamp: null,
        userKey: null,
        adminKey: null,
        token: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end create transfer

  // ignore: missing_return
  Future<TokenModel> token({@required String token}) async {
    var body = '''query {
                    token(token: "$token") {
                      _key
                      amount
                      token
                      userBalanceBefore
                      userBalanceAfter
                      timeStamp
                      usageStamp
                      userKey {
                        _key
                        firstName
                        lastName
                        username
                      }
                      adminKey {
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
      var data = jsonData['data']['token'];
      //print(data);

      if (data != null) {
        TokenModel obj = TokenModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          usageStamp: data['usageStamp'] as dynamic,
          amount: data['amount'] as dynamic,
          adminKey: data['adminKey'] as Object,
          userKey: data['userKey'] as Object,
          token: data['token'] as String,
          userBalanceAfter: data['userBalanceAfter'] as dynamic,
          userBalanceBefore: data['userBalanceBefore'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      TokenModel obj = TokenModel(
        key: null,
        timeStamp: null,
        amount: null,
        usageStamp: null,
        token: null,
        userKey: null,
        adminKey: null,
        userBalanceAfter: null,
        userBalanceBefore: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // token by code

}
