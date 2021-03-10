import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/jackpot.dart';

class JackpotService {
  // ignore: missing_return
  Future<JackpotPlayModel> play(
      {@required String userKey, @required int userChoice}) async {
    var body = '''mutation {
                    jackpotPlay(userKey: "$userKey", choice: $userChoice) {
                      _key
                      timeStamp
                      userKey {
                        _key
                        username
                        countryFlag
                        countryName
                        firstName
                        lastName
                      }
                      systemChoice
                      userChoice
                      hasWon
                      amountBet
                      amountGained
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
    //print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data']['jackpotPlay'];
      //print('data: $data');

      if (data != null) {
        JackpotPlayModel obj = JackpotPlayModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountBet: data['amountBet'] as dynamic,
          amountGained: data['amountGained'] as dynamic,
          hasWon: data['hasWon'] as bool,
          systemChoice: data['systemChoice'] as int,
          userChoice: data['userChoice'] as int,
          userKey: data['userKey'] as Object,
          status: data['status'],
          error: null,
        );
        return obj;
      } else {
        JackpotPlayModel obj = JackpotPlayModel(
          key: null,
          timeStamp: null,
          amountBet: null,
          amountGained: null,
          hasWon: null,
          systemChoice: null,
          userChoice: null,
          userKey: null,
          status: null,
          error: jsonDecode(response.body)['errors'][0]['message'],
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      JackpotPlayModel obj = JackpotPlayModel(
        key: null,
        timeStamp: null,
        amountBet: null,
        amountGained: null,
        hasWon: null,
        systemChoice: null,
        userChoice: null,
        userKey: null,
        status: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end play BASIC

  // get jackpot
  // ignore: missing_return
  Future<JackpotModel> jackpot() async {
    var body = '''query {
                    jackpot {
                      _key
                      totalGained
                      secret
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
      var data = jsonData['data']['jackpot'];
      //print(data);

      if (data != null) {
        JackpotModel obj = JackpotModel(
          key: data['_key'] as String,
          totalGained: data['totalGained'] as dynamic,
          secret: data['secret'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      JackpotModel obj = JackpotModel(
        key: null,
        totalGained: null,
        secret: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end get jackpot

  Future<List<JackpotPlayModel>> mesParis({
    @required String userKey,
    @required int day,
    @required int month,
    @required int year,
  }) async {
    var body = '''query {
                    jackpotsByUserKey(
                        userKey: "$userKey",  
                        day: $day, 
                        month: $month, 
                        year: $year
                      ) {
                      _key
                      timeStamp
                      userKey {
                        _key
                        username
                        firstName
                        lastName
                      }
                      systemChoice
                      userChoice
                      hasWon
                      amountBet
                      amountGained
                      status 
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
      var jsonDataFinal = jsonData['data']['jackpotsByUserKey'];

      List<JackpotPlayModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          JackpotPlayModel obj = JackpotPlayModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            amountBet: data['amountBet'] as dynamic,
            amountGained: data['amountGained'] as dynamic,
            userChoice: data['userChoice'] as int,
            userKey: data['userKey'] as Object,
            status: data['status'] as String,
            hasWon: data['hasWon'] as bool,
            systemChoice: data['systemChoice'] as int,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<JackpotPlayModel> objArray = [];
        JackpotPlayModel obj = JackpotPlayModel(
          key: null,
          timeStamp: null,
          amountBet: null,
          amountGained: null,
          userChoice: null,
          status: null,
          hasWon: null,
          systemChoice: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<JackpotPlayModel> objArray = [];
      JackpotPlayModel obj = JackpotPlayModel(
        key: null,
        timeStamp: null,
        amountBet: null,
        amountGained: null,
        userChoice: null,
        status: null,
        hasWon: null,
        systemChoice: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end mes paris
}
