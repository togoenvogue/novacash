import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../config/configuration.dart';
import '../models/user.dart';
import '../models/maxtix_core.dart';

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
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
                    channel_mobile1
                    channel_mobile2
                    channel_mobile3
                    channel_cash
                    channel_btc
                    channel_eth
                    channel_pm
                    channel_py
                    channel_pp
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
      var data = jsonData['data']['userLogin'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          channel_btc: data['channel_btc'] as String,
          channel_cash: data['channel_cash'] as String,
          channel_eth: data['channel_eth'] as String,
          channel_mobile1: data['channel_mobile1'] as String,
          channel_mobile2: data['channel_mobile2'] as String,
          channel_pm: data['channel_pm'] as String,
          channel_py: data['channel_py'] as String,
          channel_pp: data['channel_pp'] as String,
          nextQuizPlay: data['nextQuizPlay'] as dynamic,
          channel_mobile3: data['channel_mobile3'] as String,
          error: null,
        );
        // save user main details
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('jwtoken', data['token']);
        prefs.setString('username', data['username']);
        prefs.setInt('expiry', data['expiry']);
        prefs.setString('firstName', data['firstName']);
        prefs.setString('lastName', data['lastName']);
        prefs.setString('userKey', data['_key']);
        prefs.setBool('isAuth', data['isAuth']);
        prefs.setInt('authExpir', data['authExpir']);
        return obj;
      } // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        nextQuizPlay: null,
        channel_mobile3: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        channel_btc: null,
        channel_cash: null,
        channel_eth: null,
        channel_mobile1: null,
        channel_mobile2: null,
        channel_pm: null,
        channel_py: null,
        channel_pp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }

  // ignore: missing_return
  Future<bool> isUsernameFree({String username}) async {
    //print(username);
    var body = '''query {
                    userExists(username: "$username")
                  }''';
    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': body}),
      headers: {"Content-Type": "application/json"},
    ).catchError((error) {
      throw error;
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var jsonDataFinal = jsonData['data']['userExists'];
      if (jsonDataFinal == true) {
        return true;
      } else {
        return false;
      }
    } else {
      // failed to get user details
      return false;
    }
  }
  // end isUsernameFree

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
      prefs.setString('MATRIXX', '');
      // return the user
      return user;
    } else {
      UserModel user = UserModel(
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return user;
    } // end logout
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
    @required String username,
    @required String email,
  }) async {
    var _body = '''mutation{
                    userNewPassword(
                      username: "$username", 
                      email: "$email")
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
  Future<UserModel> signupP2P({
    @required String username,
    @required String password,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String sex,
    @required int age,
  }) async {
    var body = '''mutation {
                  userCreateP2P(
                      userPhoneNumber: "$username",
                      password: "$password",
                      email: "$email",
                      firstName: "$firstName",
                      lastName: "$lastName",
                      sex: "$sex",
                      age: $age
                  ) {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
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
      var data = jsonData['data']['userCreateP2P'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end signup p2p

  // ignore: missing_return
  Future<UserModel> signupPremium({
    @required String username,
    @required String password,
    @required String sponsorUsername,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String code,
    @required String sex,
    @required int age,
  }) async {
    var body = '''mutation {
                  userCreatePremium(
                      userPhoneNumber: "$username",
                      password: "$password",
                      email: "$email",
                      firstName: "$firstName",
                      lastName: "$lastName",
                      sponsorUsername: "$sponsorUsername",
                      kode: "$code",
                      sex: "$sex",
                      age: $age
                  ) {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    channel_mobile3
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
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
      var data = jsonData['data']['userCreatePremium'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end signup premium

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
    if (isAuth == true && userKey != null) {
      var body = '''query {
                  userByKey(_key: "$userKey") {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
                    channel_mobile1
                    channel_mobile2
                    channel_mobile3
                    channel_cash
                    channel_btc
                    channel_eth
                    channel_pm
                    channel_py
                    channel_pp
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
        var data = jsonData['data']['userByKey'];
        //print(jsonDataFinal['credits_balance']);
        if (data != null) {
          UserModel obj = UserModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            username: data['username'] as String,
            email: data['email'] as String,
            phone: data['phone'] as int,
            expiry: data['expiry'] as dynamic,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            countryFlag: data['countryFlag'] as String,
            countryName: data['countryName'] as String,
            countryCode: data['countryCode'] as int,
            lastLogin: data['lastLogin'] as dynamic,
            isAuth: data['isAuth'] as bool,
            gadget1Given: data['gadget1Given'] as bool,
            gadget1Qualified: data['gadget1Qualified'] as bool,
            gadget2Given: data['gadget2Given'] as bool,
            gadget2Qualified: data['gadget2Qualified'] as bool,
            gadget3Given: data['gadget3Given'] as bool,
            gadget3Qualified: data['gadget3Qualified'] as bool,
            phoneVerified: data['phoneVerified'] as bool,
            conditionsAccepted: data['conditionsAccepted'] as bool,
            picture: data['picture'] as String,
            whatsApp: data['whatsApp'] as String,
            ewallet_balance: data['ewallet_balance'] as dynamic,
            ewallet_total: data['ewallet_total'] as dynamic,
            ewalletReset: data['ewalletReset'] as dynamic,
            credits_balance: data['credits_balance'] as dynamic,
            credits_total: data['credits_total'] as dynamic,
            isSupport: data['isSupport'] as bool,
            age: data['age'] as int,
            authExpir: data['authExpir'] as dynamic,
            categories: ['categories'],
            ewallet_p2p: data['ewallet_p2p'] as dynamic,
            isActive: data['isActive'] as bool,
            isAdmin: data['isAdmin'] as bool,
            isDemoAccount: data['isDemoAccount'] as bool,
            isLocked: data['isLocked'] as bool,
            isSuperAdmin: data['isSuperAdmin'] as bool,
            loginRef: data['loginRef'] as String,
            nextToWithdraw: data['nextToWithdraw'] as dynamic,
            novaCashCore: data['novaCashCore'] as bool,
            novaCashP2PGold: data['novaCashP2PGold'] as bool,
            novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
            novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
            passwordReset: data['passwordReset'] as String,
            phoneVerificationCode: data['phoneVerificationCode'] as String,
            resetStamp: data['resetStamp'] as dynamic,
            sex: data['sex'] as String,
            token: data['token'] as String,
            channel_btc: data['channel_btc'] as String,
            channel_cash: data['channel_cash'] as String,
            channel_eth: data['channel_eth'] as String,
            channel_mobile1: data['channel_mobile1'] as String,
            channel_mobile2: data['channel_mobile2'] as String,
            channel_pm: data['channel_pm'] as String,
            channel_py: data['channel_py'] as String,
            channel_pp: data['channel_pp'] as String,
            nextQuizPlay: data['nextQuizPlay'] as dynamic,
            channel_mobile3: data['channel_mobile3'] as String,
            error: null,
          );
          return obj;
        } // end
      } else {
        // failed to get user details
        UserModel obj = UserModel(
          key: null,
          timeStamp: null,
          username: null,
          email: null,
          phone: null,
          password: null,
          nextQuizPlay: null,
          channel_mobile3: null,
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
          ewalletReset: null,
          expiry: null,
          gadget1Given: null,
          gadget1Qualified: null,
          gadget2Given: null,
          gadget2Qualified: null,
          gadget3Given: null,
          gadget3Qualified: null,
          phoneVerificationCode: null,
          phoneVerified: null,
          age: null,
          sex: null,
          categories: null,
          ewallet_p2p: null,
          novaCashCore: null,
          novaCashP2PGold: null,
          novaCashP2PRuby: null,
          novaCashP2PSilver: null,
          channel_btc: null,
          channel_cash: null,
          channel_eth: null,
          channel_mobile1: null,
          channel_mobile2: null,
          channel_pm: null,
          channel_py: null,
          channel_pp: null,
          error: jsonDecode(response.body)['errors'][0]['message'],
        );
        return obj;
      }
    } else {
      UserModel obj = UserModel(
        key: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        channel_btc: null,
        channel_cash: null,
        channel_eth: null,
        channel_mobile1: null,
        channel_mobile2: null,
        channel_pm: null,
        channel_py: null,
        channel_pp: null,
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
    //print(userKey);
    //print(option);
    var body = '''mutation{
                    userAcceptConditions
                    (userKey: "$userKey", option: $option) 
                    {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
                    channel_mobile1
                    channel_mobile2
                    channel_mobile3
                    channel_cash
                    channel_btc
                    channel_eth
                    channel_pm
                    channel_py
                    channel_pp
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
      var data = jsonData['data']['userAcceptConditions'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          channel_btc: data['channel_btc'] as String,
          channel_cash: data['channel_cash'] as String,
          channel_eth: data['channel_eth'] as String,
          channel_mobile1: data['channel_mobile1'] as String,
          channel_mobile2: data['channel_mobile2'] as String,
          channel_pm: data['channel_pm'] as String,
          channel_py: data['channel_py'] as String,
          channel_pp: data['channel_pp'] as String,
          nextQuizPlay: data['nextQuizPlay'] as dynamic,
          channel_mobile3: data['channel_mobile3'] as String,
          error: null,
        );
        return obj;
      } // end
    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        nextQuizPlay: null,
        channel_mobile3: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        channel_btc: null,
        channel_cash: null,
        channel_eth: null,
        channel_mobile1: null,
        channel_mobile2: null,
        channel_pm: null,
        channel_py: null,
        channel_pp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end accept conditions

  // ignore: missing_return
  Future<UserModel> updateChannels({
    String userKey,
    String channel_cash, // ignore: non_constant_identifier_names
    String channel_btc, // ignore: non_constant_identifier_names
    String channel_eth, // ignore: non_constant_identifier_names
    String channel_mobile1, // ignore: non_constant_identifier_names
    String channel_mobile2, // ignore: non_constant_identifier_names
    String channel_mobile3, // ignore: non_constant_identifier_names
    String channel_py, // ignore: non_constant_identifier_names
    String channel_pm, // ignore: non_constant_identifier_names
    String channel_pp, // ignore: non_constant_identifier_names
  }) async {
    //print(userKey);
    //print(option);
    var body = '''mutation{
                    userUpdateChannels
                    ( userKey: "$userKey", 
                      channel_cash: "$channel_cash",
                      channel_btc: "$channel_btc",
                      channel_eth: "$channel_eth",
                      channel_mobile1: "$channel_mobile1",
                      channel_mobile2: "$channel_mobile2",
                      channel_mobile3: "$channel_mobile3",
                      channel_py: "$channel_py",
                      channel_pm: "$channel_pm",
                      channel_pp: "$channel_pp",
                    ) {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
                    channel_mobile1
                    channel_mobile2
                    channel_mobile3
                    channel_cash
                    channel_btc
                    channel_eth
                    channel_pm
                    channel_py
                    channel_pp
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
      var data = jsonData['data']['userUpdateChannels'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          channel_btc: data['channel_btc'] as String,
          channel_cash: data['channel_cash'] as String,
          channel_eth: data['channel_eth'] as String,
          channel_mobile1: data['channel_mobile1'] as String,
          channel_mobile2: data['channel_mobile2'] as String,
          channel_pm: data['channel_pm'] as String,
          channel_py: data['channel_py'] as String,
          channel_pp: data['channel_pp'] as String,
          nextQuizPlay: data['nextQuizPlay'] as dynamic,
          channel_mobile3: data['channel_mobile3'] as String,
          error: null,
        );
        return obj;
      } // end
    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        nextQuizPlay: null,
        channel_mobile3: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        channel_btc: null,
        channel_cash: null,
        channel_eth: null,
        channel_mobile1: null,
        channel_mobile2: null,
        channel_pm: null,
        channel_py: null,
        channel_pp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end update channels

  // ignore: missing_return
  Future<UserModel> setUserCategories({
    @required String userKey,
    @required List<dynamic> categories,
  }) async {
    var body = '''mutation{
                    userNotifications
                    (userKey: "$userKey", categories: $categories) 
                    {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
                    channel_mobile1
                    channel_mobile2
                    channel_mobile3
                    channel_cash
                    channel_btc
                    channel_eth
                    channel_pm
                    channel_py
                    channel_pp
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
      var data = jsonData['data']['userNotifications'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          channel_btc: data['channel_btc'] as String,
          channel_cash: data['channel_cash'] as String,
          channel_eth: data['channel_eth'] as String,
          channel_mobile1: data['channel_mobile1'] as String,
          channel_mobile2: data['channel_mobile2'] as String,
          channel_pm: data['channel_pm'] as String,
          channel_py: data['channel_py'] as String,
          channel_pp: data['channel_pp'] as String,
          nextQuizPlay: data['nextQuizPlay'] as dynamic,
          channel_mobile3: data['channel_mobile3'] as String,
          error: null,
        );
        return obj;
      } // end
    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        timeStamp: null,
        username: null,
        email: null,
        phone: null,
        password: null,
        passwordReset: null,
        nextQuizPlay: null,
        channel_mobile3: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        channel_btc: null,
        channel_cash: null,
        channel_eth: null,
        channel_mobile1: null,
        channel_mobile2: null,
        channel_pm: null,
        channel_py: null,
        channel_pp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end user notification categories

  // search member
  Future<List<MatrixCoreModel>> searchMember(
      {@required String toSearch}) async {
    var body = '''query {
                    searchMember(toSearch: "$toSearch") {
                      _key
                      timeStamp
                      userKey {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      sponsorKey {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      linkedTo {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level2 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level3 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level4 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level5 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level6 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level7 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level8 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level9 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level10 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level11 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level12 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level13 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level14 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level15 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level16 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level17 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level18 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level19 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level20 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1Count
                      teamCount
                      totalSponsored 
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
      var jsonDataFinal = jsonData['data']['searchMember'];

      //print(jsonDataFinal.length);
      List<MatrixCoreModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          MatrixCoreModel obj = MatrixCoreModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            level1: data['level1'] as dynamic,
            level2: data['level2'] as dynamic,
            level3: data['level3'] as dynamic,
            level4: data['level4'] as dynamic,
            level5: data['level5'] as dynamic,
            level6: data['level6'] as dynamic,
            level7: data['level7'] as dynamic,
            level8: data['level8'] as dynamic,
            level9: data['level9'] as dynamic,
            level10: data['level10'] as dynamic,
            level11: data['level11'] as dynamic,
            level12: data['level12'] as dynamic,
            level13: data['level13'] as dynamic,
            level14: data['level14'] as dynamic,
            level15: data['level15'] as dynamic,
            level16: data['level16'] as dynamic,
            level17: data['level17'] as dynamic,
            level18: data['level18'] as dynamic,
            level19: data['level19'] as dynamic,
            level20: data['level20'] as dynamic,
            userKey: data['userKey'] as dynamic,
            linkedTo: data['linkedTo'] as dynamic,
            sponsorKey: data['sponsorKey'] as dynamic,
            level1Count: data['level1Count'] as int,
            teamCount: data['teamCount'] as int,
            totalSponsored: data['totalSponsored'] as int,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<MatrixCoreModel> objArray = [];
        MatrixCoreModel obj = MatrixCoreModel(
          key: null,
          timeStamp: null,
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
          sponsorKey: null,
          teamCount: null,
          totalSponsored: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<MatrixCoreModel> objArray = [];
      MatrixCoreModel obj = MatrixCoreModel(
        key: null,
        timeStamp: null,
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
        sponsorKey: null,
        teamCount: null,
        totalSponsored: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end search member

// get user by username
// ignore: missing_return
  Future<UserModel> getUserByUsername({String username}) async {
    var body = '''query {
                  userByUsername(username: "$username") {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    nextQuizPlay
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
                    channel_mobile1
                    channel_mobile2
                    channel_mobile3
                    channel_cash
                    channel_btc
                    channel_eth
                    channel_pm
                    channel_py 
                    channel_pp 
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
      var data = jsonData['data']['userByUsername'];
      //print(jsonDataFinal['credits_balance']);

      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          channel_btc: data['channel_btc'] as String,
          channel_cash: data['channel_cash'] as String,
          channel_eth: data['channel_eth'] as String,
          channel_mobile1: data['channel_mobile1'] as String,
          channel_mobile2: data['channel_mobile2'] as String,
          channel_pm: data['channel_pm'] as String,
          channel_py: data['channel_py'] as String,
          channel_pp: data['channel_pp'] as String,
          nextQuizPlay: data['nextQuizPlay'] as dynamic,
          channel_mobile3: data['channel_mobile3'] as String,
          error: null,
        );
        return obj;
      } // end
    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        timeStamp: null,
        nextQuizPlay: null,
        channel_mobile3: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        channel_btc: null,
        channel_cash: null,
        channel_eth: null,
        channel_mobile1: null,
        channel_mobile2: null,
        channel_pm: null,
        channel_py: null,
        channel_pp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end get user by username

  // admin users
  Future<List<UserModel>> adminUsers({int month, int year}) async {
    var body = '''query {
                    adminUsers(month: $month, year: $year) {
                      _key
                      timeStamp
                      expiry
                      nextToWithdraw
                      email
                      username
                      phone
                      password
                      passwordReset
                      resetStamp
                      firstName
                      sex
                      age
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
                      ewallet_p2p
                      credits_balance
                      credits_total
                      gadget1Qualified
                      gadget2Qualified
                      gadget3Qualified
                      gadget1Given
                      gadget2Given
                      gadget3Given
                      categories {
                          _key
                          category
                          isActive
                        }
                      fullCount
                      novaCashCore
                      novaCashP2PSilver
                      novaCashP2PGold
                      novaCashP2PRuby 
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
      var jsonDataFinal = jsonData['data']['adminUsers'];

      //print(jsonDataFinal.length);
      List<UserModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          UserModel obj = UserModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            username: data['username'] as String,
            email: data['email'] as String,
            phone: data['phone'] as int,
            expiry: data['expiry'] as dynamic,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            countryFlag: data['countryFlag'] as String,
            countryName: data['countryName'] as String,
            countryCode: data['countryCode'] as int,
            lastLogin: data['lastLogin'] as dynamic,
            isAuth: data['isAuth'] as bool,
            gadget1Given: data['gadget1Given'] as bool,
            gadget1Qualified: data['gadget1Qualified'] as bool,
            gadget2Given: data['gadget2Given'] as bool,
            gadget2Qualified: data['gadget2Qualified'] as bool,
            gadget3Given: data['gadget3Given'] as bool,
            gadget3Qualified: data['gadget3Qualified'] as bool,
            phoneVerified: data['phoneVerified'] as bool,
            conditionsAccepted: data['conditionsAccepted'] as bool,
            picture: data['picture'] as String,
            whatsApp: data['whatsApp'] as String,
            ewallet_balance: data['ewallet_balance'] as dynamic,
            ewallet_total: data['ewallet_total'] as dynamic,
            ewalletReset: data['ewalletReset'] as dynamic,
            credits_balance: data['credits_balance'] as dynamic,
            credits_total: data['credits_total'] as dynamic,
            isSupport: data['isSupport'] as bool,
            age: data['age'] as int,
            authExpir: data['authExpir'] as dynamic,
            categories: ['categories'],
            ewallet_p2p: data['ewallet_p2p'] as dynamic,
            isActive: data['isActive'] as bool,
            isAdmin: data['isAdmin'] as bool,
            isDemoAccount: data['isDemoAccount'] as bool,
            isLocked: data['isLocked'] as bool,
            isSuperAdmin: data['isSuperAdmin'] as bool,
            loginRef: data['loginRef'] as String,
            nextToWithdraw: data['nextToWithdraw'] as dynamic,
            novaCashCore: data['novaCashCore'] as bool,
            novaCashP2PGold: data['novaCashP2PGold'] as bool,
            novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
            novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
            passwordReset: data['passwordReset'] as String,
            phoneVerificationCode: data['phoneVerificationCode'] as String,
            resetStamp: data['resetStamp'] as dynamic,
            sex: data['sex'] as String,
            token: data['token'] as String,
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
          ewalletReset: null,
          expiry: null,
          gadget1Given: null,
          gadget1Qualified: null,
          gadget2Given: null,
          gadget2Qualified: null,
          gadget3Given: null,
          gadget3Qualified: null,
          phoneVerificationCode: null,
          phoneVerified: null,
          age: null,
          sex: null,
          categories: null,
          ewallet_p2p: null,
          novaCashCore: null,
          novaCashP2PGold: null,
          novaCashP2PRuby: null,
          novaCashP2PSilver: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<UserModel> objArray = [];
      UserModel obj = UserModel(
        key: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end adminUsers

  Future<List<UserModel>> adminApns({int month, int year}) async {
    var body = '''query {
                    adminApns {
                      _key
                      timeStamp
                      expiry
                      nextToWithdraw
                      email
                      username
                      phone
                      password
                      passwordReset
                      resetStamp
                      firstName
                      sex
                      age
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
                      ewallet_p2p
                      credits_balance
                      credits_total
                      gadget1Qualified
                      gadget2Qualified
                      gadget3Qualified
                      gadget1Given
                      gadget2Given
                      gadget3Given
                      categories {
                          _key
                          category
                          isActive
                        }
                      fullCount
                      novaCashCore
                      novaCashP2PSilver
                      novaCashP2PGold
                      novaCashP2PRuby 
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
      var jsonDataFinal = jsonData['data']['adminApns'];

      //print(jsonDataFinal.length);
      List<UserModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          UserModel obj = UserModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            username: data['username'] as String,
            email: data['email'] as String,
            phone: data['phone'] as int,
            expiry: data['expiry'] as dynamic,
            firstName: data['firstName'] as String,
            lastName: data['lastName'] as String,
            countryFlag: data['countryFlag'] as String,
            countryName: data['countryName'] as String,
            countryCode: data['countryCode'] as int,
            lastLogin: data['lastLogin'] as dynamic,
            isAuth: data['isAuth'] as bool,
            gadget1Given: data['gadget1Given'] as bool,
            gadget1Qualified: data['gadget1Qualified'] as bool,
            gadget2Given: data['gadget2Given'] as bool,
            gadget2Qualified: data['gadget2Qualified'] as bool,
            gadget3Given: data['gadget3Given'] as bool,
            gadget3Qualified: data['gadget3Qualified'] as bool,
            phoneVerified: data['phoneVerified'] as bool,
            conditionsAccepted: data['conditionsAccepted'] as bool,
            picture: data['picture'] as String,
            whatsApp: data['whatsApp'] as String,
            ewallet_balance: data['ewallet_balance'] as dynamic,
            ewallet_total: data['ewallet_total'] as dynamic,
            ewalletReset: data['ewalletReset'] as dynamic,
            credits_balance: data['credits_balance'] as dynamic,
            credits_total: data['credits_total'] as dynamic,
            isSupport: data['isSupport'] as bool,
            age: data['age'] as int,
            authExpir: data['authExpir'] as dynamic,
            categories: ['categories'],
            ewallet_p2p: data['ewallet_p2p'] as dynamic,
            isActive: data['isActive'] as bool,
            isAdmin: data['isAdmin'] as bool,
            isDemoAccount: data['isDemoAccount'] as bool,
            isLocked: data['isLocked'] as bool,
            isSuperAdmin: data['isSuperAdmin'] as bool,
            loginRef: data['loginRef'] as String,
            nextToWithdraw: data['nextToWithdraw'] as dynamic,
            novaCashCore: data['novaCashCore'] as bool,
            novaCashP2PGold: data['novaCashP2PGold'] as bool,
            novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
            novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
            passwordReset: data['passwordReset'] as String,
            phoneVerificationCode: data['phoneVerificationCode'] as String,
            resetStamp: data['resetStamp'] as dynamic,
            sex: data['sex'] as String,
            token: data['token'] as String,
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
          ewalletReset: null,
          expiry: null,
          gadget1Given: null,
          gadget1Qualified: null,
          gadget2Given: null,
          gadget2Qualified: null,
          gadget3Given: null,
          gadget3Qualified: null,
          phoneVerificationCode: null,
          phoneVerified: null,
          age: null,
          sex: null,
          categories: null,
          ewallet_p2p: null,
          novaCashCore: null,
          novaCashP2PGold: null,
          novaCashP2PRuby: null,
          novaCashP2PSilver: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<UserModel> objArray = [];
      UserModel obj = UserModel(
        key: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  }
  // end admin APN

  // NovaCash Core
  // my downlines
  Future<List<MatrixCoreModel>> myDownlines({@required String userKey}) async {
    var body = '''query {
                    myDownlines(userKey: "$userKey") {
                      _key
                      timeStamp
                      username
                      userKey {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      sponsorKey {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      linkedTo {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level2 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level3 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level4 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level5 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level6 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level7 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level8 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level9 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level10 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level11 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level12 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level13 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level14 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level15 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level16 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level17 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level18 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level19 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level20 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1Count
                      teamCount
                      totalSponsored
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
      List<MatrixCoreModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          MatrixCoreModel obj = MatrixCoreModel(
            key: data['_key'] as String,
            username: data['username'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            level10: data['level10'] as dynamic,
            level11: data['level11'] as dynamic,
            level12: data['level12'] as dynamic,
            level13: data['level13'] as dynamic,
            level14: data['level14'] as dynamic,
            level15: data['level15'] as dynamic,
            level16: data['level16'] as dynamic,
            level17: data['level17'] as dynamic,
            level18: data['level18'] as dynamic,
            level19: data['level19'] as dynamic,
            level1: data['level1'] as dynamic,
            level20: data['level20'] as dynamic,
            level2: data['level2'] as dynamic,
            level3: data['level3'] as dynamic,
            level4: data['level4'] as dynamic,
            level5: data['level5'] as dynamic,
            level6: data['level6'] as dynamic,
            level7: data['level7'] as dynamic,
            level8: data['level8'] as dynamic,
            level9: data['level9'] as dynamic,
            userKey: data['userKey'] as dynamic,
            linkedTo: data['linkedTo'] as dynamic,
            sponsorKey: data['sponsorKey'] as dynamic,
            level1Count: data['level1Count'] as int,
            teamCount: data['teamCount'] as int,
            totalSponsored: data['totalSponsored'] as int,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<MatrixCoreModel> objArray = [];
        MatrixCoreModel obj = MatrixCoreModel(
          key: null,
          username: null,
          timeStamp: null,
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
          sponsorKey: null,
          teamCount: null,
          totalSponsored: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<MatrixCoreModel> objArray = [];
      MatrixCoreModel obj = MatrixCoreModel(
        key: null,
        username: null,
        timeStamp: null,
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
        sponsorKey: null,
        teamCount: null,
        totalSponsored: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end my downlines

  // my network
  Future<List<MatrixCoreModel>> myNetwork(
      {@required String userKey, level}) async {
    var body = '''query {
                    myNetwork(userKey: "$userKey", level: $level) {
                      _key
                      timeStamp
                      username
                      userKey {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      sponsorKey {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      linkedTo {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level2 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level3 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level4 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level5 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level6 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level7 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level8 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level9 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level10 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level11 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level12 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level13 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level14 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level15 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level16 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level17 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level18 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level19 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level20 {
                        _key
                        expiry
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1Count
                      teamCount
                      totalSponsored
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
      var jsonDataFinal = jsonData['data']['myNetwork'];

      //print(jsonDataFinal.length);
      List<MatrixCoreModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          MatrixCoreModel obj = MatrixCoreModel(
            key: data['_key'] as String,
            username: data['username'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            level10: data['level10'] as dynamic,
            level11: data['level11'] as dynamic,
            level12: data['level12'] as dynamic,
            level13: data['level13'] as dynamic,
            level14: data['level14'] as dynamic,
            level15: data['level15'] as dynamic,
            level16: data['level16'] as dynamic,
            level17: data['level17'] as dynamic,
            level18: data['level18'] as dynamic,
            level19: data['level19'] as dynamic,
            level1: data['level1'] as dynamic,
            level20: data['level20'] as dynamic,
            level2: data['level2'] as dynamic,
            level3: data['level3'] as dynamic,
            level4: data['level4'] as dynamic,
            level5: data['level5'] as dynamic,
            level6: data['level6'] as dynamic,
            level7: data['level7'] as dynamic,
            level8: data['level8'] as dynamic,
            level9: data['level9'] as dynamic,
            userKey: data['userKey'] as dynamic,
            linkedTo: data['linkedTo'] as dynamic,
            sponsorKey: data['sponsorKey'] as dynamic,
            level1Count: data['level1Count'] as int,
            teamCount: data['teamCount'] as int,
            totalSponsored: data['totalSponsored'] as int,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<MatrixCoreModel> objArray = [];
        MatrixCoreModel obj = MatrixCoreModel(
          key: null,
          username: null,
          timeStamp: null,
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
          sponsorKey: null,
          teamCount: null,
          totalSponsored: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<MatrixCoreModel> objArray = [];
      MatrixCoreModel obj = MatrixCoreModel(
        key: null,
        username: null,
        timeStamp: null,
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
        sponsorKey: null,
        teamCount: null,
        totalSponsored: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  }
  // end my network

  // myCoreMatrix
  // ignore: missing_return
  Future<MatrixCoreModel> myCoreMatrix({@required String userKey}) async {
    var body = '''query {
                    myCoreMatrix(userKey: "$userKey") {
                      _key
                      timeStamp
                      username
                      userKey {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      sponsorKey {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      linkedTo {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level2 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level3 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level4 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level5 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level6 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level7 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level8 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level9 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level10 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level11 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level12 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level13 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level14 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level15 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level16 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level17 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level18 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level19 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level20 {
                        _key
                        firstName
                        lastName
                        countryName
                        countryFlag
                        username
                      }
                      level1Count
                      teamCount
                      totalSponsored
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
      var data = jsonData['data']['myCoreMatrix'];
      //print(data);
      if (data != null) {
        MatrixCoreModel obj = MatrixCoreModel(
          key: data['_key'] as String,
          username: data['username'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          level1: data['level1'] as dynamic,
          level2: data['level2'] as dynamic,
          level3: data['level3'] as dynamic,
          level4: data['level4'] as dynamic,
          level5: data['level5'] as dynamic,
          level6: data['level6'] as dynamic,
          level7: data['level7'] as dynamic,
          level8: data['level8'] as dynamic,
          level9: data['level9'] as dynamic,
          level10: data['level10'] as dynamic,
          level11: data['level11'] as dynamic,
          level12: data['level12'] as dynamic,
          level13: data['level13'] as dynamic,
          level14: data['level14'] as dynamic,
          level15: data['level15'] as dynamic,
          level16: data['level16'] as dynamic,
          level17: data['level17'] as dynamic,
          level18: data['level18'] as dynamic,
          level19: data['level19'] as dynamic,
          level20: data['level20'] as dynamic,
          userKey: data['userKey'] as dynamic,
          linkedTo: data['linkedTo'] as dynamic,
          sponsorKey: data['sponsorKey'] as dynamic,
          level1Count: data['level1Count'] as int,
          teamCount: data['teamCount'] as int,
          totalSponsored: data['totalSponsored'] as int,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      MatrixCoreModel obj = MatrixCoreModel(
        key: null,
        username: null,
        timeStamp: null,
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
        sponsorKey: null,
        teamCount: null,
        totalSponsored: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end myCoreMatrix

// ignore: missing_return
  Future<UserModel> matrixCoreCreate({
    @required String sponsorUsername,
    @required String userKey,
    @required String code,
  }) async {
    var body = '''mutation {
                  userMatrixCoreCreate(
                      userKey: "$userKey",
                      sponsorUsername: "$sponsorUsername",
                      kode: "$code",
                  ) {
                    _key
                    timeStamp
                    expiry
                    nextToWithdraw
                    email
                    username
                    phone
                    password
                    passwordReset
                    resetStamp
                    firstName
                    sex
                    age
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
                    ewallet_p2p
                    credits_balance
                    credits_total
                    gadget1Qualified
                    gadget2Qualified
                    gadget3Qualified
                    gadget1Given
                    gadget2Given
                    gadget3Given
                    categories {
                        _key
                        category
                        isActive
                      }
                    fullCount
                    novaCashCore
                    novaCashP2PSilver
                    novaCashP2PGold
                    novaCashP2PRuby
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
      var data = jsonData['data']['userMatrixCoreCreate'];
      if (data != null) {
        UserModel obj = UserModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          username: data['username'] as String,
          email: data['email'] as String,
          phone: data['phone'] as int,
          expiry: data['expiry'] as dynamic,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          countryFlag: data['countryFlag'] as String,
          countryName: data['countryName'] as String,
          countryCode: data['countryCode'] as int,
          lastLogin: data['lastLogin'] as dynamic,
          isAuth: data['isAuth'] as bool,
          gadget1Given: data['gadget1Given'] as bool,
          gadget1Qualified: data['gadget1Qualified'] as bool,
          gadget2Given: data['gadget2Given'] as bool,
          gadget2Qualified: data['gadget2Qualified'] as bool,
          gadget3Given: data['gadget3Given'] as bool,
          gadget3Qualified: data['gadget3Qualified'] as bool,
          phoneVerified: data['phoneVerified'] as bool,
          conditionsAccepted: data['conditionsAccepted'] as bool,
          picture: data['picture'] as String,
          whatsApp: data['whatsApp'] as String,
          ewallet_balance: data['ewallet_balance'] as dynamic,
          ewallet_total: data['ewallet_total'] as dynamic,
          ewalletReset: data['ewalletReset'] as dynamic,
          credits_balance: data['credits_balance'] as dynamic,
          credits_total: data['credits_total'] as dynamic,
          isSupport: data['isSupport'] as bool,
          age: data['age'] as int,
          authExpir: data['authExpir'] as dynamic,
          categories: ['categories'],
          ewallet_p2p: data['ewallet_p2p'] as dynamic,
          isActive: data['isActive'] as bool,
          isAdmin: data['isAdmin'] as bool,
          isDemoAccount: data['isDemoAccount'] as bool,
          isLocked: data['isLocked'] as bool,
          isSuperAdmin: data['isSuperAdmin'] as bool,
          loginRef: data['loginRef'] as String,
          nextToWithdraw: data['nextToWithdraw'] as dynamic,
          nextQuizPlay: data['nextQuizPlay'] as dynamic,
          channel_mobile3: data['channel_mobile3'] as String,
          novaCashCore: data['novaCashCore'] as bool,
          novaCashP2PGold: data['novaCashP2PGold'] as bool,
          novaCashP2PRuby: data['novaCashP2PRuby'] as bool,
          novaCashP2PSilver: data['novaCashP2PSilver'] as bool,
          passwordReset: data['passwordReset'] as String,
          phoneVerificationCode: data['phoneVerificationCode'] as String,
          resetStamp: data['resetStamp'] as dynamic,
          sex: data['sex'] as String,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      UserModel obj = UserModel(
        key: null,
        timeStamp: null,
        username: null,
        email: null,
        nextQuizPlay: null,
        channel_mobile3: null,
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
        ewalletReset: null,
        expiry: null,
        gadget1Given: null,
        gadget1Qualified: null,
        gadget2Given: null,
        gadget2Qualified: null,
        gadget3Given: null,
        gadget3Qualified: null,
        phoneVerificationCode: null,
        phoneVerified: null,
        age: null,
        sex: null,
        categories: null,
        ewallet_p2p: null,
        novaCashCore: null,
        novaCashP2PGold: null,
        novaCashP2PRuby: null,
        novaCashP2PSilver: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end of CoreMatrix creation

}
