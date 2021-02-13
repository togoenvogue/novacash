import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tutorial.dart';
import '../config/configuration.dart';

class TutorialService {
  Future<List<TutorialModel>> tutorials() async {
    var body = '''query {
                    tutorials {
                      _key
                      timeStamp
                      title
                      transcript
                      url
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
      var jsonDataFinal = jsonData['data']['tutorials'];

      //print(jsonDataFinal.length);
      List<TutorialModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          TutorialModel obj = TutorialModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            title: data['title'] as String,
            transcript: data['transcript'] as String,
            url: data['url'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<TutorialModel> objArray = [];
        TutorialModel obj = TutorialModel(
          key: null,
          timeStamp: null,
          title: null,
          transcript: null,
          url: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<TutorialModel> objArray = [];
      TutorialModel obj = TutorialModel(
        key: null,
        timeStamp: null,
        title: null,
        transcript: null,
        url: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end get bonuses
}
