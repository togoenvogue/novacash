import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/expiration.dart';

class ExpirationService {
  // ignore: missing_return
  Future<ExpirationModel> renew({String userKey}) async {
    var body = '''mutation {
                    expirCreate(userKey: "$userKey") {
                      _key
                      timeStamp
                      amount
                      expiry
                      days
                      userKey {
                        _key
                        fullName
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
      var data = jsonData['data']['expirCreate'];
      //print(data);

      if (data != null) {
        ExpirationModel obj = ExpirationModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amount: data['amount'] as dynamic,
          days: data['days'] as int,
          expiry: data['expiry'] as dynamic,
          userKey: data['userKey'] as Object,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      ExpirationModel obj = ExpirationModel(
        key: null,
        timeStamp: null,
        amount: null,
        days: null,
        expiry: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end play

  // get jackpot

  Future<List<ExpirationModel>> expirByUserkey({String userKey}) async {
    var body = '''query {
                    expirByUserKey(userKey: "$userKey") {
                      _key
                      timeStamp
                      amount
                      expiry
                      days
                      userKey {
                        _key
                        fullName
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
      var jsonDataFinal = jsonData['data']['expirByUserKey'];

      //print(jsonDataFinal.length);
      List<ExpirationModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          ExpirationModel obj = ExpirationModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            amount: data['amount'] as dynamic,
            days: data['days'] as int,
            expiry: data['expiry'] as dynamic,
            userKey: data['userKey'] as Object,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<ExpirationModel> objArray = [];
        ExpirationModel obj = ExpirationModel(
          key: null,
          timeStamp: null,
          amount: null,
          days: null,
          expiry: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<ExpirationModel> objArray = [];
      ExpirationModel obj = ExpirationModel(
        key: null,
        timeStamp: null,
        amount: null,
        days: null,
        expiry: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end mes abonnements
}
