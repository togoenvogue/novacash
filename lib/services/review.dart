import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/review.dart';
import '../config/configuration.dart';

class ReviewService {
  // ignore: missing_return
  Future<ReviewModel> reviewCreate({
    @required String userKey,
    @required String detail,
    @required dynamic rate,
  }) async {
    var body = '''mutation {
                    reviewCreate(
                      userKey: "$userKey", 
                      detail: """$detail""", 
                      rate: $rate) {
                      _key
                      timeStamp
                      detail
                      rate
                      status
                      userKey {
                        _key
                        fullName
                        username
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
      throw error;
    });

    //print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data']['reviewCreate'];
      //print(data);

      if (data != null) {
        ReviewModel obj = ReviewModel(
          key: data['_key'] as String,
          detail: data['detail'] as String,
          rate: data['rate'] as dynamic,
          status: data['status'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          userKey: data['userKey'] as Object,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      ReviewModel obj = ReviewModel(
        key: null,
        timeStamp: null,
        detail: null,
        rate: null,
        status: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end play

  // get jackpot

  Future<List<ReviewModel>> reviews({@required int page}) async {
    var body = '''query {
                    reviews(page: $page) {
                      _key
                      timeStamp
                      detail
                      rate
                      status
                      userKey {
                        _key
                        fullName
                        username
                        countryFlag
                        countryName
                        picture
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
      var jsonDataFinal = jsonData['data']['reviews'];

      //print(jsonDataFinal.length);
      List<ReviewModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          ReviewModel obj = ReviewModel(
            key: data['_key'] as String,
            detail: data['detail'] as String,
            rate: data['rate'] as dynamic,
            status: data['status'] as String,
            timeStamp: data['timeStamp'] as dynamic,
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
        List<ReviewModel> objArray = [];
        ReviewModel obj = ReviewModel(
          key: null,
          timeStamp: null,
          detail: null,
          rate: null,
          status: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<ReviewModel> objArray = [];
      ReviewModel obj = ReviewModel(
        key: null,
        timeStamp: null,
        detail: null,
        rate: null,
        status: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end mes abonnements
}
