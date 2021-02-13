import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../config/configuration.dart';
import '../models/user.dart';

class AuthService {
  // ignore: missing_return
  Future<UserModel> login({
    String username,
    String password,
    String loginRef,
    bool adminRequest,
  }) async {
    //print(serverURL);
    String devId = await PlatformDeviceId.getDeviceId;
    //print('DEVICE ID : $devId');

    var body = '''query {
                  userLogin(
                    username: "$username", 
                    password: "$password", 
                    loginRef: "$devId", 
                    adminRequest: $adminRequest
                  ) { 
                    _key
                    timeStamp
                    expiry
                    pronoExpiry
                    isDemoAccount
                    nextToWithdraw
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    linkedTo{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level2{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level3{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level4{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level5{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level6{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level7{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level8{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level9{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level10{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level11{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level12{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level13{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level14{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level15{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level16{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level17{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level18{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level19{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level20{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1Count
                    teamCount
                    totalSponsored
                    bulkId
                    nextBulkId
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    lastName
                    countryFlag
                    countryName
                    countryCode
                    lastLogin
                    isAuth
                    token
                    loginRef
                    authExpir
                    isLocked
                    isActive
                    isAdmin
                    isSuperAdmin
                    isSupport
                    conditionsAccepted
                    phoneVerified
                    phoneVerificationCode
                    picture
                    whatsApp
                    ewalletReset
                    ewallet_balance
                    ewallet_total
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
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
      var jsonDataFinal = jsonData['data']['userLogin'];

      if (jsonDataFinal != null) {
        UserModel obj = UserModel(
          key: jsonDataFinal['_key'] as String,
          timeStamp: jsonDataFinal['timeStamp'] as dynamic,
          username: jsonDataFinal['username'] as String,
          email: jsonDataFinal['email'] as String,
          phone: jsonDataFinal['phone'] as int,
          password: jsonDataFinal['password'] as String,
          passwordReset: jsonDataFinal['passwordReset'] as String,
          resetStamp: jsonDataFinal['resetStamp'] as dynamic,
          isDemoAccount: jsonDataFinal['isDemoAccount'] as bool,
          nextToWithdraw: jsonDataFinal['nextToWithdraw'] as dynamic,
          //expiry: new DateTime.fromMillisecondsSinceEpoch(jsonDataFinal['expiry']),
          expiry: jsonDataFinal['expiry'] as dynamic,
          firstName: jsonDataFinal['firstName'] as String,
          lastName: jsonDataFinal['lastName'] as String,
          countryFlag: jsonDataFinal['countryFlag'] as String,
          countryName: jsonDataFinal['countryName'] as String,
          countryCode: jsonDataFinal['countryCode'] as int,
          lastLogin: jsonDataFinal['lastLogin'] as dynamic,
          isAuth: jsonDataFinal['isAuth'] as bool,
          token: jsonDataFinal['token'] as String,
          loginRef: jsonDataFinal['loginRef'] as String,
          authExpir: jsonDataFinal['authExpir'] as dynamic,
          isLocked: jsonDataFinal['isLocked'] as bool,
          isActive: jsonDataFinal['isActive'] as bool,
          isAdmin: jsonDataFinal['isAdmin'] as bool,
          isSuperAdmin: jsonDataFinal['isSuperAdmin'] as bool,
          isSupport: jsonDataFinal['isSupport'] as bool,
          bulkId: jsonDataFinal['bulkId'] as dynamic,
          gadget1Given: jsonDataFinal['gadget1Given'] as bool,
          gadget1Qualified: jsonDataFinal['gadget1Qualified'] as bool,
          gadget2Given: jsonDataFinal['gadget2Given'] as bool,
          gadget2Qualified: jsonDataFinal['gadget2Qualified'] as bool,
          gadget3Given: jsonDataFinal['gadget3Given'] as bool,
          gadget3Qualified: jsonDataFinal['gadget3Qualified'] as bool,
          level10: jsonDataFinal['level10'] as Object,
          level11: jsonDataFinal['level11'] as Object,
          level12: jsonDataFinal['level12'] as Object,
          level13: jsonDataFinal['level13'] as Object,
          level14: jsonDataFinal['level14'] as Object,
          level15: jsonDataFinal['level15'] as Object,
          level16: jsonDataFinal['level16'] as Object,
          level17: jsonDataFinal['level17'] as Object,
          level18: jsonDataFinal['level18'] as Object,
          level19: jsonDataFinal['level19'] as Object,
          level1: jsonDataFinal['level1'] as Object,
          level20: jsonDataFinal['level20'] as Object,
          level2: jsonDataFinal['level2'] as Object,
          level3: jsonDataFinal['level3'] as Object,
          level4: jsonDataFinal['level4'] as Object,
          level5: jsonDataFinal['level5'] as Object,
          level6: jsonDataFinal['level6'] as Object,
          level7: jsonDataFinal['level7'] as Object,
          level8: jsonDataFinal['level8'] as Object,
          level9: jsonDataFinal['level9'] as Object,
          linkedTo: jsonDataFinal['linkedTo'] as Object,
          nextBulkId: jsonDataFinal['nextBulkId'] as dynamic,
          phoneVerificationCode:
              jsonDataFinal['phoneVerificationCode'] as String,
          phoneVerified: jsonDataFinal['phoneVerified'] as bool,
          pronoExpiry: jsonDataFinal['pronoExpiry'] as dynamic,
          sponsorKey: jsonDataFinal['sponsorKey'] as dynamic,
          level1Count: jsonDataFinal['level1Count'] as int,
          teamCount: jsonDataFinal['teamCount'] as int,
          totalSponsored: jsonDataFinal['totalSponsored'] as int,
          conditionsAccepted: jsonDataFinal['conditionsAccepted'] as bool,
          picture: jsonDataFinal['picture'] as String,
          whatsApp: jsonDataFinal['whatsApp'] as String,
          ewallet_balance: jsonDataFinal['ewallet_balance'] as dynamic,
          ewallet_total: jsonDataFinal['ewallet_total'] as dynamic,
          ewalletReset: jsonDataFinal['ewalletReset'] as dynamic,
          credits_balance: jsonDataFinal['credits_balance'] as dynamic,
          credits_total: jsonDataFinal['credits_total'] as dynamic,
          error: null,
        );

        // save user main details
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('jwtoken', jsonDataFinal['token']);
        prefs.setString('username', jsonDataFinal['username']);
        prefs.setInt('expiry', jsonDataFinal['expiry']);
        prefs.setString('firstName', jsonDataFinal['firstName']);
        prefs.setString('lastName', jsonDataFinal['lastName']);
        prefs.setString('userKey', jsonDataFinal['_key']);
        prefs.setBool('isAuth', jsonDataFinal['isAuth']);
        prefs.setInt('authExpir', jsonDataFinal['authExpir']);

        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        sponsorKey: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        resetStamp: null,
        firstName: null,
        lastName: null,
        countryFlag: null,
        countryName: null,
        countryCode: null,
        lastLogin: null,
        isAuth: null,
        token: null,
        loginRef: null,
        authExpir: null,
        isLocked: null,
        isActive: null,
        isAdmin: null,
        isDemoAccount: null,
        nextToWithdraw: null,
        isSuperAdmin: null,
        isSupport: null,
        conditionsAccepted: null,
        picture: null,
        whatsApp: null,
        ewallet_balance: null,
        ewallet_total: null,
        credits_balance: null,
        credits_total: null,
        bulkId: null,
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        level10: null,
        level11: null,
        level12: null,
        level13: null,
        level14: null,
        level15: null,
        level16: null,
        level17: null,
        level18: null,
        level19: null,
        level1: null,
        level1Count: null,
        level20: null,
        level2: null,
        level3: null,
        level4: null,
        level5: null,
        level6: null,
        level7: null,
        level8: null,
        level9: null,
        linkedTo: null,
        nextBulkId: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        pronoExpiry: null,
        teamCount: null,
        totalSponsored: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }

// log out
  Future<UserModel> logout({String key}) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('jwtoken') ?? null;
    var _body = '''query {
                    userLogout(token: "$token", userKey: "$key") {
                      _key
                      username
                      firstName
                      lastName
                      token
                      password
                    }
                  }''';

    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': _body}),
      headers: {'Content-Type': 'application/json'},
    ).catchError((error) {
      throw error;
    });

    // print(response.statusCode);

    if (response.statusCode == 200) {
      UserModel user = UserModel(
        key: null,
        token: null,
        error: null,
        firstName: null,
        lastName: null,
        username: null,
      );

      // remove user details
      prefs.setString('jwtoken', null);
      prefs.setString('username', null);
      prefs.setString('firstName', null);
      prefs.setString('lastName', null);
      prefs.setString('userKey', null);
      prefs.setBool('isAuth', false);
      prefs.setInt('authExpir', 0);
      // return the user
      return user;
    } else {
      UserModel user = UserModel(
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return user;
    }
    // end logout
  }

  // get user details
  isUserAuthenticated() async {
    var prefs = await SharedPreferences.getInstance().catchError((error) {
      throw error;
    });

    UserModel user = UserModel(
      key: (prefs.getString('userKey') ?? null),
      username: (prefs.getString('username') ?? null),
      firstName: (prefs.getString('firstName') ?? null),
      lastName: (prefs.getString('lastName') ?? null),
      isAuth: prefs.getInt('authExpir') > DateTime.now().millisecondsSinceEpoch
          ? true
          : false,
      token: (prefs.getString('jwtoken') ?? null),
      authExpir: (prefs.getInt('authExpir') ?? null),
      expiry: (prefs.getInt('expiry') ?? null),
    );
    return user;
  }

  // change password
  Future<UserModel> changePassword({
    String password,
    String newPassword,
  }) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('jwtoken') ?? null;
    var key = prefs.getString('userKey') ?? null;

    var _body = '''mutation{
                    userChangePassword(
                      userKey: "$key", 
                      password: "$password", 
                      newPassword: "$newPassword")
                  }''';

    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': _body}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).catchError((error) {
      throw error;
    });

    //print(response.body);
    if (response.statusCode == 200) {
      UserModel pass = UserModel(
        isAuth: jsonDecode(response.body)['data']['userChangePassword'], // true
        error: null,
      );

      // save token
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('jwtoken', null);
      prefs.setInt('username', null);
      prefs.setString('firstName', null);
      prefs.setString('lastName', null);
      prefs.setString('userKey', null);
      prefs.setBool('isAuth', null);
      prefs.setInt('authExpir', null);
      return pass;
    } else {
      //var jsonDataFinal = jsonData;
      UserModel pass = UserModel(
        isAuth: false,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return pass;
    }
  } // change password

  // user reset password
  Future<UserModel> requestPassword({
    String username,
    String fullName,
  }) async {
    var _body = '''mutation{
                    userNewPassword(
                      username: "$username", 
                      fullName: "$fullName")
                  }''';

    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': _body}),
      headers: {'Content-Type': 'application/json'},
    ).catchError((error) {
      throw error;
    });

    //print(response.body);
    if (response.statusCode == 200) {
      UserModel pass = UserModel(
        isAuth: jsonDecode(response.body)['data']['userNewPassword'], // true
        error: null,
      );

      // save token
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('jwtoken', null);
      prefs.setInt('username', null);
      prefs.setString('firstName', null);
      prefs.setString('lastName', null);
      prefs.setString('userKey', null);
      prefs.setBool('isAuth', null);
      prefs.setInt('authExpir', null);
      return pass;
    } else {
      //var jsonDataFinal = jsonData;
      UserModel pass = UserModel(
        isAuth: false,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return pass;
    }
  } // end user new password

  // signup
  // ignore: missing_return
  Future<UserModel> signup({
    String username,
    String password,
    @required String sponsorUsername,
    @required String firstName,
    @required String lastName,
    @required String email,
  }) async {
    var body = '''mutation {
                  userCreate(
                    username: "$username", 
                    password: "$password", 
                    sponsorUsername: "$sponsorUsername", 
                    email: "$email",
                    firstName: "$firstName",
                    lastName: "$lastName"
                  ) {
                    _key
                    timeStamp
                    expiry
                    pronoExpiry
                    isDemoAccount
                    nextToWithdraw
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    linkedTo{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level2{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level3{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level4{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level5{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level6{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level7{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level8{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level9{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level10{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level11{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level12{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level13{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level14{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level15{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level16{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level17{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level18{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level19{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level20{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1Count
                    teamCount
                    totalSponsored
                    bulkId
                    nextBulkId
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    lastName
                    countryFlag
                    countryName
                    countryCode
                    lastLogin
                    isAuth
                    token
                    loginRef
                    authExpir
                    isLocked
                    isActive
                    isAdmin
                    isSuperAdmin
                    isSupport
                    conditionsAccepted
                    phoneVerified
                    phoneVerificationCode
                    picture
                    whatsApp
                    ewalletReset
                    ewallet_balance
                    ewallet_total
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
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
      var jsonDataFinal = jsonData['data']['userCreate'];

      if (jsonDataFinal != null) {
        UserModel obj = UserModel(
          key: jsonDataFinal['_key'] as String,
          timeStamp: jsonDataFinal['timeStamp'] as dynamic,
          username: jsonDataFinal['username'] as String,
          email: jsonDataFinal['email'] as String,
          phone: jsonDataFinal['phone'] as int,
          password: jsonDataFinal['password'] as String,
          passwordReset: jsonDataFinal['passwordReset'] as String,
          resetStamp: jsonDataFinal['resetStamp'] as dynamic,
          isDemoAccount: jsonDataFinal['isDemoAccount'] as bool,
          nextToWithdraw: jsonDataFinal['nextToWithdraw'] as dynamic,
          //expiry: new DateTime.fromMillisecondsSinceEpoch(jsonDataFinal['expiry']),
          expiry: jsonDataFinal['expiry'] as dynamic,
          firstName: jsonDataFinal['firstName'] as String,
          lastName: jsonDataFinal['lastName'] as String,
          countryFlag: jsonDataFinal['countryFlag'] as String,
          countryName: jsonDataFinal['countryName'] as String,
          countryCode: jsonDataFinal['countryCode'] as int,
          lastLogin: jsonDataFinal['lastLogin'] as dynamic,
          isAuth: jsonDataFinal['isAuth'] as bool,
          token: jsonDataFinal['token'] as String,
          loginRef: jsonDataFinal['loginRef'] as String,
          authExpir: jsonDataFinal['authExpir'] as dynamic,
          isLocked: jsonDataFinal['isLocked'] as bool,
          isActive: jsonDataFinal['isActive'] as bool,
          isAdmin: jsonDataFinal['isAdmin'] as bool,
          isSuperAdmin: jsonDataFinal['isSuperAdmin'] as bool,
          isSupport: jsonDataFinal['isSupport'] as bool,
          bulkId: jsonDataFinal['bulkId'] as dynamic,
          gadget1Given: jsonDataFinal['gadget1Given'] as bool,
          gadget1Qualified: jsonDataFinal['gadget1Qualified'] as bool,
          gadget2Given: jsonDataFinal['gadget2Given'] as bool,
          gadget2Qualified: jsonDataFinal['gadget2Qualified'] as bool,
          gadget3Given: jsonDataFinal['gadget3Given'] as bool,
          gadget3Qualified: jsonDataFinal['gadget3Qualified'] as bool,
          level10: jsonDataFinal['level10'] as Object,
          level11: jsonDataFinal['level11'] as Object,
          level12: jsonDataFinal['level12'] as Object,
          level13: jsonDataFinal['level13'] as Object,
          level14: jsonDataFinal['level14'] as Object,
          level15: jsonDataFinal['level15'] as Object,
          level16: jsonDataFinal['level16'] as Object,
          level17: jsonDataFinal['level17'] as Object,
          level18: jsonDataFinal['level18'] as Object,
          level19: jsonDataFinal['level19'] as Object,
          level1: jsonDataFinal['level1'] as Object,
          level20: jsonDataFinal['level20'] as Object,
          level2: jsonDataFinal['level2'] as Object,
          level3: jsonDataFinal['level3'] as Object,
          level4: jsonDataFinal['level4'] as Object,
          level5: jsonDataFinal['level5'] as Object,
          level6: jsonDataFinal['level6'] as Object,
          level7: jsonDataFinal['level7'] as Object,
          level8: jsonDataFinal['level8'] as Object,
          level9: jsonDataFinal['level9'] as Object,
          linkedTo: jsonDataFinal['linkedTo'] as Object,
          nextBulkId: jsonDataFinal['nextBulkId'] as dynamic,
          phoneVerificationCode:
              jsonDataFinal['phoneVerificationCode'] as String,
          phoneVerified: jsonDataFinal['phoneVerified'] as bool,
          pronoExpiry: jsonDataFinal['pronoExpiry'] as dynamic,
          sponsorKey: jsonDataFinal['sponsorKey'] as dynamic,
          level1Count: jsonDataFinal['level1Count'] as int,
          teamCount: jsonDataFinal['teamCount'] as int,
          totalSponsored: jsonDataFinal['totalSponsored'] as int,
          conditionsAccepted: jsonDataFinal['conditionsAccepted'] as bool,
          picture: jsonDataFinal['picture'] as String,
          whatsApp: jsonDataFinal['whatsApp'] as String,
          ewallet_balance: jsonDataFinal['ewallet_balance'] as dynamic,
          ewallet_total: jsonDataFinal['ewallet_total'] as dynamic,
          ewalletReset: jsonDataFinal['ewalletReset'] as dynamic,
          credits_balance: jsonDataFinal['credits_balance'] as dynamic,
          credits_total: jsonDataFinal['credits_total'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        sponsorKey: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        resetStamp: null,
        firstName: null,
        lastName: null,
        countryFlag: null,
        countryName: null,
        countryCode: null,
        lastLogin: null,
        isAuth: null,
        token: null,
        loginRef: null,
        authExpir: null,
        isLocked: null,
        isActive: null,
        isAdmin: null,
        isDemoAccount: null,
        nextToWithdraw: null,
        isSuperAdmin: null,
        isSupport: null,
        conditionsAccepted: null,
        picture: null,
        whatsApp: null,
        ewallet_balance: null,
        ewallet_total: null,
        credits_balance: null,
        credits_total: null,
        bulkId: null,
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        level10: null,
        level11: null,
        level12: null,
        level13: null,
        level14: null,
        level15: null,
        level16: null,
        level17: null,
        level18: null,
        level19: null,
        level1: null,
        level1Count: null,
        level20: null,
        level2: null,
        level3: null,
        level4: null,
        level5: null,
        level6: null,
        level7: null,
        level8: null,
        level9: null,
        linkedTo: null,
        nextBulkId: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        pronoExpiry: null,
        teamCount: null,
        totalSponsored: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }

  // get user by Key
  // ignore: missing_return
  Future<UserModel> getThisUser() async {
    var prefs = await SharedPreferences.getInstance();
    //var token = prefs.getString('jwtoken') ?? null;
    String userKey = prefs.getString('userKey') ?? null;
    //print(prefs.getInt('authExpir'));
    bool isAuth = prefs.getInt('authExpir') != null &&
            prefs.getInt('authExpir') > DateTime.now().millisecondsSinceEpoch
        ? true
        : false;

    if (isAuth && userKey != null) {
      var body = '''query {
                  userByKey(_key: "$userKey") {
                    _key
                    timeStamp
                    expiry
                    pronoExpiry
                    isDemoAccount
                    nextToWithdraw
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    linkedTo{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level2{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level3{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level4{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level5{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level6{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level7{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level8{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level9{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level10{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level11{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level12{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level13{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level14{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level15{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level16{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level17{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level18{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level19{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level20{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1Count
                    teamCount
                    totalSponsored
                    bulkId
                    nextBulkId
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    lastName
                    countryFlag
                    countryName
                    countryCode
                    lastLogin
                    isAuth
                    token
                    loginRef
                    authExpir
                    isLocked
                    isActive
                    isAdmin
                    isSuperAdmin
                    isSupport
                    conditionsAccepted
                    phoneVerified
                    phoneVerificationCode
                    picture
                    whatsApp
                    ewalletReset
                    ewallet_balance
                    ewallet_total
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given 
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
        var jsonDataFinal = jsonData['data']['userByKey'];
        //print(jsonDataFinal['credits_balance']);

        if (jsonDataFinal != null) {
          UserModel obj = UserModel(
            key: jsonDataFinal['_key'] as String,
            timeStamp: jsonDataFinal['timeStamp'] as dynamic,
            username: jsonDataFinal['username'] as String,
            email: jsonDataFinal['email'] as String,
            phone: jsonDataFinal['phone'] as int,
            password: jsonDataFinal['password'] as String,
            passwordReset: jsonDataFinal['passwordReset'] as String,
            resetStamp: jsonDataFinal['resetStamp'] as dynamic,
            isDemoAccount: jsonDataFinal['isDemoAccount'] as bool,
            nextToWithdraw: jsonDataFinal['nextToWithdraw'] as dynamic,
            //expiry: new DateTime.fromMillisecondsSinceEpoch(jsonDataFinal['expiry']),
            expiry: jsonDataFinal['expiry'] as dynamic,
            firstName: jsonDataFinal['firstName'] as String,
            lastName: jsonDataFinal['lastName'] as String,
            countryFlag: jsonDataFinal['countryFlag'] as String,
            countryName: jsonDataFinal['countryName'] as String,
            countryCode: jsonDataFinal['countryCode'] as int,
            lastLogin: jsonDataFinal['lastLogin'] as dynamic,
            isAuth: jsonDataFinal['isAuth'] as bool,
            token: jsonDataFinal['token'] as String,
            loginRef: jsonDataFinal['loginRef'] as String,
            authExpir: jsonDataFinal['authExpir'] as dynamic,
            isLocked: jsonDataFinal['isLocked'] as bool,
            isActive: jsonDataFinal['isActive'] as bool,
            isAdmin: jsonDataFinal['isAdmin'] as bool,
            isSuperAdmin: jsonDataFinal['isSuperAdmin'] as bool,
            isSupport: jsonDataFinal['isSupport'] as bool,
            bulkId: jsonDataFinal['bulkId'] as dynamic,
            gadget1Given: jsonDataFinal['gadget1Given'] as bool,
            gadget1Qualified: jsonDataFinal['gadget1Qualified'] as bool,
            gadget2Given: jsonDataFinal['gadget2Given'] as bool,
            gadget2Qualified: jsonDataFinal['gadget2Qualified'] as bool,
            gadget3Given: jsonDataFinal['gadget3Given'] as bool,
            gadget3Qualified: jsonDataFinal['gadget3Qualified'] as bool,
            level10: jsonDataFinal['level10'] as Object,
            level11: jsonDataFinal['level11'] as Object,
            level12: jsonDataFinal['level12'] as Object,
            level13: jsonDataFinal['level13'] as Object,
            level14: jsonDataFinal['level14'] as Object,
            level15: jsonDataFinal['level15'] as Object,
            level16: jsonDataFinal['level16'] as Object,
            level17: jsonDataFinal['level17'] as Object,
            level18: jsonDataFinal['level18'] as Object,
            level19: jsonDataFinal['level19'] as Object,
            level1: jsonDataFinal['level1'] as Object,
            level20: jsonDataFinal['level20'] as Object,
            level2: jsonDataFinal['level2'] as Object,
            level3: jsonDataFinal['level3'] as Object,
            level4: jsonDataFinal['level4'] as Object,
            level5: jsonDataFinal['level5'] as Object,
            level6: jsonDataFinal['level6'] as Object,
            level7: jsonDataFinal['level7'] as Object,
            level8: jsonDataFinal['level8'] as Object,
            level9: jsonDataFinal['level9'] as Object,
            linkedTo: jsonDataFinal['linkedTo'] as Object,
            nextBulkId: jsonDataFinal['nextBulkId'] as dynamic,
            phoneVerificationCode:
                jsonDataFinal['phoneVerificationCode'] as String,
            phoneVerified: jsonDataFinal['phoneVerified'] as bool,
            pronoExpiry: jsonDataFinal['pronoExpiry'] as dynamic,
            sponsorKey: jsonDataFinal['sponsorKey'] as dynamic,
            level1Count: jsonDataFinal['level1Count'] as int,
            teamCount: jsonDataFinal['teamCount'] as int,
            totalSponsored: jsonDataFinal['totalSponsored'] as int,
            conditionsAccepted: jsonDataFinal['conditionsAccepted'] as bool,
            picture: jsonDataFinal['picture'] as String,
            whatsApp: jsonDataFinal['whatsApp'] as String,
            ewallet_balance: jsonDataFinal['ewallet_balance'] as dynamic,
            ewallet_total: jsonDataFinal['ewallet_total'] as dynamic,
            ewalletReset: jsonDataFinal['ewalletReset'] as dynamic,
            credits_balance: jsonDataFinal['credits_balance'] as dynamic,
            credits_total: jsonDataFinal['credits_total'] as dynamic,
            error: null,
          );
          return obj;
        }
        // end

      } else {
        // failed to get user details
        UserModel obj = UserModel(
          key: null,
          sponsorKey: null,
          timeStamp: null,
          username: null,
          email: null,
          phone: null,
          password: null,
          passwordReset: null,
          resetStamp: null,
          firstName: null,
          lastName: null,
          countryFlag: null,
          countryName: null,
          countryCode: null,
          lastLogin: null,
          isAuth: null,
          token: null,
          loginRef: null,
          authExpir: null,
          isLocked: null,
          isActive: null,
          isAdmin: null,
          isDemoAccount: null,
          nextToWithdraw: null,
          isSuperAdmin: null,
          isSupport: null,
          conditionsAccepted: null,
          picture: null,
          whatsApp: null,
          ewallet_balance: null,
          ewallet_total: null,
          credits_balance: null,
          credits_total: null,
          bulkId: null,
          ewalletReset: null,
          expiry: null,
          gadget1Given: null,
          gadget1Qualified: null,
          gadget2Given: null,
          gadget2Qualified: null,
          gadget3Given: null,
          gadget3Qualified: null,
          level10: null,
          level11: null,
          level12: null,
          level13: null,
          level14: null,
          level15: null,
          level16: null,
          level17: null,
          level18: null,
          level19: null,
          level1: null,
          level1Count: null,
          level20: null,
          level2: null,
          level3: null,
          level4: null,
          level5: null,
          level6: null,
          level7: null,
          level8: null,
          level9: null,
          linkedTo: null,
          nextBulkId: null,
          phoneVerificationCode: null,
          phoneVerified: null,
          pronoExpiry: null,
          teamCount: null,
          totalSponsored: null,
          error: jsonDecode(response.body)['errors'][0]['message'],
        );
        return obj;
      }
    } else {
      UserModel obj = UserModel(
        key: null,
        sponsorKey: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        resetStamp: null,
        firstName: null,
        lastName: null,
        countryFlag: null,
        countryName: null,
        countryCode: null,
        lastLogin: null,
        isAuth: null,
        token: null,
        loginRef: null,
        authExpir: null,
        isLocked: null,
        isActive: null,
        isAdmin: null,
        isDemoAccount: null,
        nextToWithdraw: null,
        isSuperAdmin: null,
        isSupport: null,
        conditionsAccepted: null,
        picture: null,
        whatsApp: null,
        ewallet_balance: null,
        ewallet_total: null,
        credits_balance: null,
        credits_total: null,
        bulkId: null,
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        level10: null,
        level11: null,
        level12: null,
        level13: null,
        level14: null,
        level15: null,
        level16: null,
        level17: null,
        level18: null,
        level19: null,
        level1: null,
        level1Count: null,
        level20: null,
        level2: null,
        level3: null,
        level4: null,
        level5: null,
        level6: null,
        level7: null,
        level8: null,
        level9: null,
        linkedTo: null,
        nextBulkId: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        pronoExpiry: null,
        teamCount: null,
        totalSponsored: null,
        error: 'AUTH_EXPIRED',
      );
      return obj;
    }
  }

// ignore: missing_return
  Future<UserModel> acceptConditions({
    String userKey,
    bool option,
  }) async {
    //print('DEVICE ID : $devId');

    var body = '''mutation{
                    userAcceptConditions
                    (userKey: "$userKey", option: $option) 
                    {
                    _key
                    timeStamp
                    expiry
                    pronoExpiry
                    isDemoAccount
                    nextToWithdraw
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    linkedTo{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level2{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level3{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level4{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level5{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level6{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level7{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level8{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level9{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level10{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level11{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level12{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level13{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level14{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level15{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level16{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level17{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level18{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level19{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level20{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1Count
                    teamCount
                    totalSponsored
                    bulkId
                    nextBulkId
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    lastName
                    countryFlag
                    countryName
                    countryCode
                    lastLogin
                    isAuth
                    token
                    loginRef
                    authExpir
                    isLocked
                    isActive
                    isAdmin
                    isSuperAdmin
                    isSupport
                    conditionsAccepted
                    phoneVerified
                    phoneVerificationCode
                    picture
                    whatsApp
                    ewalletReset
                    ewallet_balance
                    ewallet_total
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given 
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
      var jsonDataFinal = jsonData['data']['userAcceptConditions'];

      if (jsonDataFinal != null) {
        UserModel obj = UserModel(
          key: jsonDataFinal['_key'] as String,
          timeStamp: jsonDataFinal['timeStamp'] as dynamic,
          username: jsonDataFinal['username'] as String,
          email: jsonDataFinal['email'] as String,
          phone: jsonDataFinal['phone'] as int,
          password: jsonDataFinal['password'] as String,
          passwordReset: jsonDataFinal['passwordReset'] as String,
          resetStamp: jsonDataFinal['resetStamp'] as dynamic,
          isDemoAccount: jsonDataFinal['isDemoAccount'] as bool,
          nextToWithdraw: jsonDataFinal['nextToWithdraw'] as dynamic,
          //expiry: new DateTime.fromMillisecondsSinceEpoch(jsonDataFinal['expiry']),
          expiry: jsonDataFinal['expiry'] as dynamic,
          firstName: jsonDataFinal['firstName'] as String,
          lastName: jsonDataFinal['lastName'] as String,
          countryFlag: jsonDataFinal['countryFlag'] as String,
          countryName: jsonDataFinal['countryName'] as String,
          countryCode: jsonDataFinal['countryCode'] as int,
          lastLogin: jsonDataFinal['lastLogin'] as dynamic,
          isAuth: jsonDataFinal['isAuth'] as bool,
          token: jsonDataFinal['token'] as String,
          loginRef: jsonDataFinal['loginRef'] as String,
          authExpir: jsonDataFinal['authExpir'] as dynamic,
          isLocked: jsonDataFinal['isLocked'] as bool,
          isActive: jsonDataFinal['isActive'] as bool,
          isAdmin: jsonDataFinal['isAdmin'] as bool,
          isSuperAdmin: jsonDataFinal['isSuperAdmin'] as bool,
          isSupport: jsonDataFinal['isSupport'] as bool,
          bulkId: jsonDataFinal['bulkId'] as dynamic,
          gadget1Given: jsonDataFinal['gadget1Given'] as bool,
          gadget1Qualified: jsonDataFinal['gadget1Qualified'] as bool,
          gadget2Given: jsonDataFinal['gadget2Given'] as bool,
          gadget2Qualified: jsonDataFinal['gadget2Qualified'] as bool,
          gadget3Given: jsonDataFinal['gadget3Given'] as bool,
          gadget3Qualified: jsonDataFinal['gadget3Qualified'] as bool,
          level10: jsonDataFinal['level10'] as Object,
          level11: jsonDataFinal['level11'] as Object,
          level12: jsonDataFinal['level12'] as Object,
          level13: jsonDataFinal['level13'] as Object,
          level14: jsonDataFinal['level14'] as Object,
          level15: jsonDataFinal['level15'] as Object,
          level16: jsonDataFinal['level16'] as Object,
          level17: jsonDataFinal['level17'] as Object,
          level18: jsonDataFinal['level18'] as Object,
          level19: jsonDataFinal['level19'] as Object,
          level1: jsonDataFinal['level1'] as Object,
          level20: jsonDataFinal['level20'] as Object,
          level2: jsonDataFinal['level2'] as Object,
          level3: jsonDataFinal['level3'] as Object,
          level4: jsonDataFinal['level4'] as Object,
          level5: jsonDataFinal['level5'] as Object,
          level6: jsonDataFinal['level6'] as Object,
          level7: jsonDataFinal['level7'] as Object,
          level8: jsonDataFinal['level8'] as Object,
          level9: jsonDataFinal['level9'] as Object,
          linkedTo: jsonDataFinal['linkedTo'] as Object,
          nextBulkId: jsonDataFinal['nextBulkId'] as dynamic,
          phoneVerificationCode:
              jsonDataFinal['phoneVerificationCode'] as String,
          phoneVerified: jsonDataFinal['phoneVerified'] as bool,
          pronoExpiry: jsonDataFinal['pronoExpiry'] as dynamic,
          sponsorKey: jsonDataFinal['sponsorKey'] as dynamic,
          level1Count: jsonDataFinal['level1Count'] as int,
          teamCount: jsonDataFinal['teamCount'] as int,
          totalSponsored: jsonDataFinal['totalSponsored'] as int,
          conditionsAccepted: jsonDataFinal['conditionsAccepted'] as bool,
          picture: jsonDataFinal['picture'] as String,
          whatsApp: jsonDataFinal['whatsApp'] as String,
          ewallet_balance: jsonDataFinal['ewallet_balance'] as dynamic,
          ewallet_total: jsonDataFinal['ewallet_total'] as dynamic,
          ewalletReset: jsonDataFinal['ewalletReset'] as dynamic,
          credits_balance: jsonDataFinal['credits_balance'] as dynamic,
          credits_total: jsonDataFinal['credits_total'] as dynamic,
          error: null,
        );

        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        sponsorKey: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        resetStamp: null,
        firstName: null,
        lastName: null,
        countryFlag: null,
        countryName: null,
        countryCode: null,
        lastLogin: null,
        isAuth: null,
        token: null,
        loginRef: null,
        authExpir: null,
        isLocked: null,
        isActive: null,
        isAdmin: null,
        isDemoAccount: null,
        nextToWithdraw: null,
        isSuperAdmin: null,
        isSupport: null,
        conditionsAccepted: null,
        picture: null,
        whatsApp: null,
        ewallet_balance: null,
        ewallet_total: null,
        credits_balance: null,
        credits_total: null,
        bulkId: null,
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        level10: null,
        level11: null,
        level12: null,
        level13: null,
        level14: null,
        level15: null,
        level16: null,
        level17: null,
        level18: null,
        level19: null,
        level1: null,
        level1Count: null,
        level20: null,
        level2: null,
        level3: null,
        level4: null,
        level5: null,
        level6: null,
        level7: null,
        level8: null,
        level9: null,
        linkedTo: null,
        nextBulkId: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        pronoExpiry: null,
        teamCount: null,
        totalSponsored: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
// end accept conditions

  // my downlines
  Future<List<UserModel>> myDownlines({@required String userKey}) async {
    var body = '''query {
                    myDownlines(userKey: "$userKey") {
                      _key
                      timeStamp
                    expiry
                    pronoExpiry
                    isDemoAccount
                    nextToWithdraw
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    linkedTo{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level2{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level3{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level4{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level5{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level6{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level7{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level8{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level9{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level10{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level11{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level12{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level13{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level14{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level15{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level16{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level17{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level18{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level19{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level20{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1Count
                    teamCount
                    totalSponsored
                    bulkId
                    nextBulkId
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    lastName
                    countryFlag
                    countryName
                    countryCode
                    lastLogin
                    isAuth
                    token
                    loginRef
                    authExpir
                    isLocked
                    isActive
                    isAdmin
                    isSuperAdmin
                    isSupport
                    conditionsAccepted
                    phoneVerified
                    phoneVerificationCode
                    picture
                    whatsApp
                    ewalletReset
                    ewallet_balance
                    ewallet_total
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given 
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
      var jsonDataFinal = jsonData['data']['myDownlines'];

      //print(jsonDataFinal.length);
      List<UserModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          UserModel obj = UserModel(
            key: data['_key'] as String,
            timeStamp: jsonDataFinal['timeStamp'] as dynamic,
            username: jsonDataFinal['username'] as String,
            email: jsonDataFinal['email'] as String,
            phone: jsonDataFinal['phone'] as int,
            password: jsonDataFinal['password'] as String,
            passwordReset: jsonDataFinal['passwordReset'] as String,
            resetStamp: jsonDataFinal['resetStamp'] as dynamic,
            isDemoAccount: jsonDataFinal['isDemoAccount'] as bool,
            nextToWithdraw: jsonDataFinal['nextToWithdraw'] as dynamic,
            //expiry: new DateTime.fromMillisecondsSinceEpoch(jsonDataFinal['expiry']),
            expiry: jsonDataFinal['expiry'] as dynamic,
            firstName: jsonDataFinal['firstName'] as String,
            lastName: jsonDataFinal['lastName'] as String,
            countryFlag: jsonDataFinal['countryFlag'] as String,
            countryName: jsonDataFinal['countryName'] as String,
            countryCode: jsonDataFinal['countryCode'] as int,
            lastLogin: jsonDataFinal['lastLogin'] as dynamic,
            isAuth: jsonDataFinal['isAuth'] as bool,
            token: jsonDataFinal['token'] as String,
            loginRef: jsonDataFinal['loginRef'] as String,
            authExpir: jsonDataFinal['authExpir'] as dynamic,
            isLocked: jsonDataFinal['isLocked'] as bool,
            isActive: jsonDataFinal['isActive'] as bool,
            isAdmin: jsonDataFinal['isAdmin'] as bool,
            isSuperAdmin: jsonDataFinal['isSuperAdmin'] as bool,
            isSupport: jsonDataFinal['isSupport'] as bool,
            bulkId: jsonDataFinal['bulkId'] as dynamic,
            gadget1Given: jsonDataFinal['gadget1Given'] as bool,
            gadget1Qualified: jsonDataFinal['gadget1Qualified'] as bool,
            gadget2Given: jsonDataFinal['gadget2Given'] as bool,
            gadget2Qualified: jsonDataFinal['gadget2Qualified'] as bool,
            gadget3Given: jsonDataFinal['gadget3Given'] as bool,
            gadget3Qualified: jsonDataFinal['gadget3Qualified'] as bool,
            level10: jsonDataFinal['level10'] as Object,
            level11: jsonDataFinal['level11'] as Object,
            level12: jsonDataFinal['level12'] as Object,
            level13: jsonDataFinal['level13'] as Object,
            level14: jsonDataFinal['level14'] as Object,
            level15: jsonDataFinal['level15'] as Object,
            level16: jsonDataFinal['level16'] as Object,
            level17: jsonDataFinal['level17'] as Object,
            level18: jsonDataFinal['level18'] as Object,
            level19: jsonDataFinal['level19'] as Object,
            level1: jsonDataFinal['level1'] as Object,
            level20: jsonDataFinal['level20'] as Object,
            level2: jsonDataFinal['level2'] as Object,
            level3: jsonDataFinal['level3'] as Object,
            level4: jsonDataFinal['level4'] as Object,
            level5: jsonDataFinal['level5'] as Object,
            level6: jsonDataFinal['level6'] as Object,
            level7: jsonDataFinal['level7'] as Object,
            level8: jsonDataFinal['level8'] as Object,
            level9: jsonDataFinal['level9'] as Object,
            linkedTo: jsonDataFinal['linkedTo'] as Object,
            nextBulkId: jsonDataFinal['nextBulkId'] as dynamic,
            phoneVerificationCode:
                jsonDataFinal['phoneVerificationCode'] as String,
            phoneVerified: jsonDataFinal['phoneVerified'] as bool,
            pronoExpiry: jsonDataFinal['pronoExpiry'] as dynamic,
            sponsorKey: jsonDataFinal['sponsorKey'] as dynamic,
            level1Count: jsonDataFinal['level1Count'] as int,
            teamCount: jsonDataFinal['teamCount'] as int,
            totalSponsored: jsonDataFinal['totalSponsored'] as int,
            conditionsAccepted: jsonDataFinal['conditionsAccepted'] as bool,
            picture: jsonDataFinal['picture'] as String,
            whatsApp: jsonDataFinal['whatsApp'] as String,
            ewallet_balance: jsonDataFinal['ewallet_balance'] as dynamic,
            ewallet_total: jsonDataFinal['ewallet_total'] as dynamic,
            ewalletReset: jsonDataFinal['ewalletReset'] as dynamic,
            credits_balance: jsonDataFinal['credits_balance'] as dynamic,
            credits_total: jsonDataFinal['credits_total'] as dynamic,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<UserModel> objArray = [];
        UserModel obj = UserModel(
          key: null,
          sponsorKey: null,
          timeStamp: null,
          username: null,
          email: null,
          phone: null,
          password: null,
          passwordReset: null,
          resetStamp: null,
          firstName: null,
          lastName: null,
          countryFlag: null,
          countryName: null,
          countryCode: null,
          lastLogin: null,
          isAuth: null,
          token: null,
          loginRef: null,
          authExpir: null,
          isLocked: null,
          isActive: null,
          isAdmin: null,
          isDemoAccount: null,
          nextToWithdraw: null,
          isSuperAdmin: null,
          isSupport: null,
          conditionsAccepted: null,
          picture: null,
          whatsApp: null,
          ewallet_balance: null,
          ewallet_total: null,
          credits_balance: null,
          credits_total: null,
          bulkId: null,
          ewalletReset: null,
          expiry: null,
          gadget1Given: null,
          gadget1Qualified: null,
          gadget2Given: null,
          gadget2Qualified: null,
          gadget3Given: null,
          gadget3Qualified: null,
          level10: null,
          level11: null,
          level12: null,
          level13: null,
          level14: null,
          level15: null,
          level16: null,
          level17: null,
          level18: null,
          level19: null,
          level1: null,
          level1Count: null,
          level20: null,
          level2: null,
          level3: null,
          level4: null,
          level5: null,
          level6: null,
          level7: null,
          level8: null,
          level9: null,
          linkedTo: null,
          nextBulkId: null,
          phoneVerificationCode: null,
          phoneVerified: null,
          pronoExpiry: null,
          teamCount: null,
          totalSponsored: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<UserModel> objArray = [];
      UserModel obj = UserModel(
        key: null,
        sponsorKey: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        resetStamp: null,
        firstName: null,
        lastName: null,
        countryFlag: null,
        countryName: null,
        countryCode: null,
        lastLogin: null,
        isAuth: null,
        token: null,
        loginRef: null,
        authExpir: null,
        isLocked: null,
        isActive: null,
        isAdmin: null,
        isDemoAccount: null,
        nextToWithdraw: null,
        isSuperAdmin: null,
        isSupport: null,
        conditionsAccepted: null,
        picture: null,
        whatsApp: null,
        ewallet_balance: null,
        ewallet_total: null,
        credits_balance: null,
        credits_total: null,
        bulkId: null,
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        level10: null,
        level11: null,
        level12: null,
        level13: null,
        level14: null,
        level15: null,
        level16: null,
        level17: null,
        level18: null,
        level19: null,
        level1: null,
        level1Count: null,
        level20: null,
        level2: null,
        level3: null,
        level4: null,
        level5: null,
        level6: null,
        level7: null,
        level8: null,
        level9: null,
        linkedTo: null,
        nextBulkId: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        pronoExpiry: null,
        teamCount: null,
        totalSponsored: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  }

// get user by username
// ignore: missing_return
  Future<UserModel> getUserByUsername({String username}) async {
    var body = '''query {
                  userByUsername(username: "$username") {
                    _key
                    timeStamp
                    expiry
                    pronoExpiry
                    isDemoAccount
                    nextToWithdraw
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    linkedTo{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level2{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level3{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level4{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level5{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level6{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level7{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level8{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level9{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level10{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level11{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level12{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level13{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level14{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level15{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level16{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level17{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level18{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level19{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level20{
                      _key
                      firstName
                      lastName
                      username
                      countryCode
                      countryName
                      countryFlag
                    }
                    level1Count
                    teamCount
                    totalSponsored
                    bulkId
                    nextBulkId
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    lastName
                    countryFlag
                    countryName
                    countryCode
                    lastLogin
                    isAuth
                    token
                    loginRef
                    authExpir
                    isLocked
                    isActive
                    isAdmin
                    isSuperAdmin
                    isSupport
                    conditionsAccepted
                    phoneVerified
                    phoneVerificationCode
                    picture
                    whatsApp
                    ewalletReset
                    ewallet_balance
                    ewallet_total
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given 
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
      var jsonDataFinal = jsonData['data']['userByUsername'];
      //print(jsonDataFinal['credits_balance']);

      if (jsonDataFinal != null) {
        UserModel obj = UserModel(
          key: jsonDataFinal['_key'] as String,
          timeStamp: jsonDataFinal['timeStamp'] as dynamic,
          username: jsonDataFinal['username'] as String,
          email: jsonDataFinal['email'] as String,
          phone: jsonDataFinal['phone'] as int,
          password: jsonDataFinal['password'] as String,
          passwordReset: jsonDataFinal['passwordReset'] as String,
          resetStamp: jsonDataFinal['resetStamp'] as dynamic,
          isDemoAccount: jsonDataFinal['isDemoAccount'] as bool,
          nextToWithdraw: jsonDataFinal['nextToWithdraw'] as dynamic,
          //expiry: new DateTime.fromMillisecondsSinceEpoch(jsonDataFinal['expiry']),
          expiry: jsonDataFinal['expiry'] as dynamic,
          firstName: jsonDataFinal['firstName'] as String,
          lastName: jsonDataFinal['lastName'] as String,
          countryFlag: jsonDataFinal['countryFlag'] as String,
          countryName: jsonDataFinal['countryName'] as String,
          countryCode: jsonDataFinal['countryCode'] as int,
          lastLogin: jsonDataFinal['lastLogin'] as dynamic,
          isAuth: jsonDataFinal['isAuth'] as bool,
          token: jsonDataFinal['token'] as String,
          loginRef: jsonDataFinal['loginRef'] as String,
          authExpir: jsonDataFinal['authExpir'] as dynamic,
          isLocked: jsonDataFinal['isLocked'] as bool,
          isActive: jsonDataFinal['isActive'] as bool,
          isAdmin: jsonDataFinal['isAdmin'] as bool,
          isSuperAdmin: jsonDataFinal['isSuperAdmin'] as bool,
          isSupport: jsonDataFinal['isSupport'] as bool,
          bulkId: jsonDataFinal['bulkId'] as dynamic,
          gadget1Given: jsonDataFinal['gadget1Given'] as bool,
          gadget1Qualified: jsonDataFinal['gadget1Qualified'] as bool,
          gadget2Given: jsonDataFinal['gadget2Given'] as bool,
          gadget2Qualified: jsonDataFinal['gadget2Qualified'] as bool,
          gadget3Given: jsonDataFinal['gadget3Given'] as bool,
          gadget3Qualified: jsonDataFinal['gadget3Qualified'] as bool,
          level10: jsonDataFinal['level10'] as Object,
          level11: jsonDataFinal['level11'] as Object,
          level12: jsonDataFinal['level12'] as Object,
          level13: jsonDataFinal['level13'] as Object,
          level14: jsonDataFinal['level14'] as Object,
          level15: jsonDataFinal['level15'] as Object,
          level16: jsonDataFinal['level16'] as Object,
          level17: jsonDataFinal['level17'] as Object,
          level18: jsonDataFinal['level18'] as Object,
          level19: jsonDataFinal['level19'] as Object,
          level1: jsonDataFinal['level1'] as Object,
          level20: jsonDataFinal['level20'] as Object,
          level2: jsonDataFinal['level2'] as Object,
          level3: jsonDataFinal['level3'] as Object,
          level4: jsonDataFinal['level4'] as Object,
          level5: jsonDataFinal['level5'] as Object,
          level6: jsonDataFinal['level6'] as Object,
          level7: jsonDataFinal['level7'] as Object,
          level8: jsonDataFinal['level8'] as Object,
          level9: jsonDataFinal['level9'] as Object,
          linkedTo: jsonDataFinal['linkedTo'] as Object,
          nextBulkId: jsonDataFinal['nextBulkId'] as dynamic,
          phoneVerificationCode:
              jsonDataFinal['phoneVerificationCode'] as String,
          phoneVerified: jsonDataFinal['phoneVerified'] as bool,
          pronoExpiry: jsonDataFinal['pronoExpiry'] as dynamic,
          sponsorKey: jsonDataFinal['sponsorKey'] as dynamic,
          level1Count: jsonDataFinal['level1Count'] as int,
          teamCount: jsonDataFinal['teamCount'] as int,
          totalSponsored: jsonDataFinal['totalSponsored'] as int,
          conditionsAccepted: jsonDataFinal['conditionsAccepted'] as bool,
          picture: jsonDataFinal['picture'] as String,
          whatsApp: jsonDataFinal['whatsApp'] as String,
          ewallet_balance: jsonDataFinal['ewallet_balance'] as dynamic,
          ewallet_total: jsonDataFinal['ewallet_total'] as dynamic,
          ewalletReset: jsonDataFinal['ewalletReset'] as dynamic,
          credits_balance: jsonDataFinal['credits_balance'] as dynamic,
          credits_total: jsonDataFinal['credits_total'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        sponsorKey: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        resetStamp: null,
        firstName: null,
        lastName: null,
        countryFlag: null,
        countryName: null,
        countryCode: null,
        lastLogin: null,
        isAuth: null,
        token: null,
        loginRef: null,
        authExpir: null,
        isLocked: null,
        isActive: null,
        isAdmin: null,
        isDemoAccount: null,
        nextToWithdraw: null,
        isSuperAdmin: null,
        isSupport: null,
        conditionsAccepted: null,
        picture: null,
        whatsApp: null,
        ewallet_balance: null,
        ewallet_total: null,
        credits_balance: null,
        credits_total: null,
        bulkId: null,
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        level10: null,
        level11: null,
        level12: null,
        level13: null,
        level14: null,
        level15: null,
        level16: null,
        level17: null,
        level18: null,
        level19: null,
        level1: null,
        level1Count: null,
        level20: null,
        level2: null,
        level3: null,
        level4: null,
        level5: null,
        level6: null,
        level7: null,
        level8: null,
        level9: null,
        linkedTo: null,
        nextBulkId: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        pronoExpiry: null,
        teamCount: null,
        totalSponsored: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end get user by username

}
