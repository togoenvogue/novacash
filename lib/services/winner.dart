import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/winner.dart';

class WinnerService {
  Future<List<WinnerModel>> winners({int day, int month, int year}) async {
    var body = '''query {
                    winners(day: $day, month: $month, year: $year) {
                      _key
                      timeStamp
                      userKey {
                        _key
                        fullName
                        username
                        countryFlag
                        countryName
                      }
                      amountBet
                      amountGained
                      gameTypeKey {
                        _key
                        name
                        gameCategory
                        imageUrl
                        iconUrl
                        description
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
      var jsonDataFinal = jsonData['data']['winners'];

      //print(jsonDataFinal);
      List<WinnerModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          // print(data);
          WinnerModel obj = WinnerModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            amountBet: data['amountBet'] as dynamic,
            amountGained: data['amountGained'] as dynamic,
            userKey: data['userKey'] as Object,
            gameTypeKey: data['gameTypeKey'] as Object,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<WinnerModel> objArray = [];
        WinnerModel obj = WinnerModel(
          key: null,
          timeStamp: null,
          amountBet: null,
          amountGained: null,
          gameTypeKey: null, // PMUPS, PMUPG
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<WinnerModel> objArray = [];
      WinnerModel obj = WinnerModel(
        key: null,
        timeStamp: null,
        amountBet: null,
        amountGained: null,
        userKey: null,
        gameTypeKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end mes paris
}
