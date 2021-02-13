import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification.dart';
import '../config/configuration.dart';

class NotificationService {
  Future<List<NotificationModel>> getMyNotifications({String userKey}) async {
    var body = '''query {
            notificationsByUserKey(userKey: "$userKey") {
              _key
              timestamp
              opened
              status
              message
              phone
              userKey {
                _key
                phone
                email
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
      var jsonDataFinal = jsonData['data']['notificationsByUserKey'];

      //print(jsonDataFinal.length);
      List<NotificationModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          NotificationModel obj = NotificationModel(
            id: data['_key'] as String,
            phone: data['phone'] as dynamic,
            message: data['message'] as String,
            opened: data['opened'] as bool,
            status: data['status'] as String,
            timeStamp: data['timestamp'] as dynamic,
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
        List<NotificationModel> objArray = [];
        NotificationModel obj = NotificationModel(
          id: null,
          message: null,
          opened: null,
          phone: null,
          status: null,
          timeStamp: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<NotificationModel> objArray = [];
      NotificationModel obj = NotificationModel(
        id: null,
        message: null,
        opened: null,
        phone: null,
        status: null,
        timeStamp: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end get user notifications
}
