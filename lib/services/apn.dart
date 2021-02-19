import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apn.dart';
import '../config/configuration.dart';

class ApnService {
  Future<List<ApnModel>> getApns({String flag}) async {
    var body = '''query {
                    apnList(flag: "$flag") {
                      _key
                      firstName
                      lastName
                      email
                      username
                      countryFlag
                      countryName
                      whatsApp
                      isSupport
                      picture
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
      var jsonDataFinal = jsonData['data']['apnList'];

      //print(jsonDataFinal.length);
      List<ApnModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          ApnModel obj = ApnModel(
            key: data['_key'] as String,
            countryFlag: data['countryFlag'] as String,
            countryName: data['countryName'] as String,
            email: data['email'] as String,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            picture: data['picture'] as String,
            username: data['username'] as String,
            whatsApp: data['whatsApp'] as String,
            userKey: data['userKey'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<ApnModel> objArray = [];
        ApnModel obj = ApnModel(
          key: null,
          countryFlag: null,
          countryName: null,
          email: null,
          firstName: null,
          lastName: null,
          picture: null,
          username: null,
          whatsApp: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<ApnModel> objArray = [];
      ApnModel obj = ApnModel(
        key: null,
        countryFlag: null,
        countryName: null,
        email: null,
        firstName: null,
        lastName: null,
        picture: null,
        username: null,
        whatsApp: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end getApns

}
