import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../config/configuration.dart';

class CountryService {
  Future<List<CountryModel>> getCountries() async {
    var body = '''query {
                    countries {
                      _key
                      countryName
                      countryFlag
                      countryCode
                      phoneNumberLength
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
      var jsonDataFinal = jsonData['data']['countries'];

      //print(jsonDataFinal.length);
      List<CountryModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          CountryModel obj = CountryModel(
            key: data['_key'] as String,
            countryFlag: data['countryFlag'] as String,
            countryCode: data['countryCode'] as int,
            countryMobileLength: data['countryMobileLength'] as int,
            countryName: data['countryName'] as String,
            isApnOpened: data['isApnOpened'] as bool,
            phoneNumberLength: data['phoneNumberLength'] as int,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<CountryModel> objArray = [];
        CountryModel obj = CountryModel(
          key: null,
          countryFlag: null,
          countryCode: null,
          countryMobileLength: null,
          countryName: null,
          isApnOpened: null,
          phoneNumberLength: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<CountryModel> objArray = [];
      CountryModel obj = CountryModel(
        key: null,
        countryFlag: null,
        countryCode: null,
        countryMobileLength: null,
        countryName: null,
        isApnOpened: null,
        phoneNumberLength: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end country list

  // apn countries
  Future<List<CountryModel>> getApnCountries() async {
    var body = '''query {
                    countriesApn {
                      _key
                      isApnOpened
                      countryName
                      countryFlag
                      countryCode
                      phoneNumberLength
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
      var jsonDataFinal = jsonData['data']['countriesApn'];

      //print(jsonDataFinal.length);
      List<CountryModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          CountryModel obj = CountryModel(
            key: data['_key'] as String,
            countryFlag: data['countryFlag'] as String,
            countryCode: data['countryCode'] as int,
            countryMobileLength: data['countryMobileLength'] as int,
            countryName: data['countryName'] as String,
            isApnOpened: data['isApnOpened'] as bool,
            phoneNumberLength: data['phoneNumberLength'] as int,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<CountryModel> objArray = [];
        CountryModel obj = CountryModel(
          key: null,
          countryFlag: null,
          countryCode: null,
          countryMobileLength: null,
          countryName: null,
          isApnOpened: null,
          phoneNumberLength: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<CountryModel> objArray = [];
      CountryModel obj = CountryModel(
        key: null,
        countryFlag: null,
        countryCode: null,
        countryMobileLength: null,
        countryName: null,
        isApnOpened: null,
        phoneNumberLength: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // apn countries

}
