import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/p2p_transaction.dart';
import '../models/matrix_p2p.dart';
import '../config/configuration.dart';

class P2PService {
  Future<List<P2PTransactionModel>> p2pGetTransactions({
    @required String userKey,
    @required int month,
    @required int year,
  }) async {
    var body = '''query {
                    p2pTransactionsByUserKey
                    (userKey: "$userKey", 
                      month:$month, 
                      year:$year) {
                      _key
                      timeStamp
                      expiry
                      fromKey {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                        channel_pm
                        channel_py
                        channel_mobile1
                        channel_mobile2
                        channel_eth
                        channel_cash
                        channel_btc
                        channel_pp
                        whatsApp
                      }
                      toKey {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                        channel_pm
                        channel_py
                        channel_mobile1
                        channel_mobile2
                        channel_eth
                        channel_cash
                        channel_btc
                        channel_pp
                        whatsApp
                      }
                      matrix
                      matrixKey {
                        _key
                      }
                      rang
                      cycle
                      status
                      amountXOF
                      amountUSD
                      amountBTC
                      amountETH
                      toChannel
                      toAccount
                      payRef
                      payStamp
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
      var jsonDataFinal = jsonData['data']['p2pTransactionsByUserKey'];

      //print(jsonDataFinal.length);
      List<P2PTransactionModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          P2PTransactionModel obj = P2PTransactionModel(
            key: data['_key'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            amountBTC: data['amountBTC'] as dynamic,
            amountETH: data['amountETH'] as dynamic,
            amountUSD: data['amountUSD'] as dynamic,
            amountXOF: data['amountXOF'] as dynamic,
            expiry: data['expiry'] as dynamic,
            toKey: data['toKey'] as dynamic,
            fromKey: data['fromKey'] as dynamic,
            matrix: data['matrix'] as String,
            matrixKey: data['matrixKey'] as dynamic,
            payRef: data['payRef'] as String,
            payStamp: data['payStamp'] as dynamic,
            rang: data['rang'] as int,
            cycle: data['cycle'] as int,
            status: data['status'] as String,
            toAccount: data['toAccount'] as String,
            toChannel: data['toChannel'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<P2PTransactionModel> objArray = [];
        P2PTransactionModel obj = P2PTransactionModel(
          key: null,
          timeStamp: null,
          amountBTC: null,
          amountETH: null,
          amountUSD: null,
          amountXOF: null,
          expiry: null,
          fromKey: null,
          matrix: null,
          matrixKey: null,
          payRef: null,
          payStamp: null,
          rang: null,
          cycle: null,
          status: null,
          toAccount: null,
          toChannel: null,
          toKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<P2PTransactionModel> objArray = [];
      P2PTransactionModel obj = P2PTransactionModel(
        key: null,
        timeStamp: null,
        amountBTC: null,
        amountETH: null,
        amountUSD: null,
        amountXOF: null,
        expiry: null,
        fromKey: null,
        matrix: null,
        matrixKey: null,
        payRef: null,
        payStamp: null,
        rang: null,
        cycle: null,
        status: null,
        toAccount: null,
        toChannel: null,
        toKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end getApns

  // ignore: missing_return
  Future<P2PTransactionModel> p2pSilverCreate({
    @required String userKey,
    @required String sponsorKey,
  }) async {
    var body = '''mutation {
                  p2pSilverCreate(
                    userKey: "$userKey", sponsorKey: "$sponsorKey"
                    ) {
                    _key
                    timeStamp
                    expiry
                    fromKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                      channel_pm
                      channel_py
                      channel_mobile1
                      channel_mobile2
                      channel_eth
                      channel_cash
                      channel_btc
                      channel_pp
                    }
                    toKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                      channel_pm
                      channel_py
                      channel_mobile1
                      channel_mobile2
                      channel_eth
                      channel_cash
                      channel_btc
                      channel_pp
                    }
                    matrix
                    matrixKey {
                      _key
                    }
                    cycle
                    status
                    amountXOF
                    amountUSD
                    amountBTC
                    amountETH
                    toChannel
                    toAccount
                    payRef
                    payStamp
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
      var data = jsonData['data']['p2pSilverCreate'];
      //print(data);
      if (data != null) {
        P2PTransactionModel obj = P2PTransactionModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountBTC: data['amountBTC'] as dynamic,
          amountETH: data['amountETH'] as dynamic,
          amountUSD: data['amountUSD'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          expiry: data['expiry'] as dynamic,
          toKey: data['toKey'] as dynamic,
          fromKey: data['fromKey'] as dynamic,
          matrix: data['matrix'] as String,
          matrixKey: data['matrixKey'] as dynamic,
          payRef: data['payRef'] as String,
          payStamp: data['payStamp'] as dynamic,
          rang: data['rang'] as int,
          cycle: data['cycle'] as int,
          status: data['status'] as String,
          toAccount: data['toAccount'] as String,
          toChannel: data['toChannel'] as String,
          error: null,
        );
        return obj;
      }
    } else {
      // failed to get user details
      P2PTransactionModel obj = P2PTransactionModel(
        key: null,
        timeStamp: null,
        amountBTC: null,
        amountETH: null,
        amountUSD: null,
        amountXOF: null,
        expiry: null,
        fromKey: null,
        matrix: null,
        matrixKey: null,
        payRef: null,
        payStamp: null,
        rang: null,
        cycle: null,
        status: null,
        toAccount: null,
        toChannel: null,
        toKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end join p2pSilver

  // ignore: missing_return
  Future<P2PTransactionModel> p2pSilverLatestPending(
      {@required String userKey}) async {
    var body = '''query {
                  p2pSilverLatestPending(userKey: "$userKey") {
                    _key
                    timeStamp
                    expiry
                    fromKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                      channel_pm
                      channel_py
                      channel_mobile1
                      channel_mobile2
                      channel_eth
                      channel_cash
                      channel_btc
                      channel_pp
                      whatsApp
                    }
                    toKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                      channel_pm
                      channel_py
                      channel_mobile1
                      channel_mobile2
                      channel_eth
                      channel_cash
                      channel_btc
                      channel_pp
                      whatsApp
                    }
                    matrix
                    matrixKey {
                      _key
                    }
                    rang
                    cycle
                    status
                    amountXOF
                    amountUSD
                    amountBTC
                    amountETH
                    toChannel
                    toAccount
                    payRef
                    payStamp
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
      var data = jsonData['data']['p2pSilverLatestPending'];
      //print(data);
      if (data != null) {
        P2PTransactionModel obj = P2PTransactionModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountBTC: data['amountBTC'] as dynamic,
          amountETH: data['amountETH'] as dynamic,
          amountUSD: data['amountUSD'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          expiry: data['expiry'] as dynamic,
          toKey: data['toKey'] as dynamic,
          fromKey: data['fromKey'] as dynamic,
          matrix: data['matrix'] as String,
          matrixKey: data['matrixKey'] as dynamic,
          payRef: data['payRef'] as String,
          payStamp: data['payStamp'] as dynamic,
          rang: data['rang'] as int,
          cycle: data['cycle'] as int,
          status: data['status'] as String,
          toAccount: data['toAccount'] as String,
          toChannel: data['toChannel'] as String,
          error: null,
        );
        return obj;
      }
    } else {
      // failed to get user details
      P2PTransactionModel obj = P2PTransactionModel(
        key: null,
        timeStamp: null,
        amountBTC: null,
        amountETH: null,
        amountUSD: null,
        amountXOF: null,
        expiry: null,
        fromKey: null,
        matrix: null,
        matrixKey: null,
        payRef: null,
        payStamp: null,
        rang: null,
        cycle: null,
        status: null,
        toAccount: null,
        toChannel: null,
        toKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end latest pending

  // ignore: missing_return
  Future<P2PTransactionModel> p2pSilverUpdateTransaction({
    @required String key,
    @required String type,
    @required String ref,
    @required String channel,
    @required String account,
  }) async {
    var body = '''mutation {
                  p2pSilverUpdateTransaction(
                    key: "$key",
                    type: "$type",
                    ref: "$ref",
                    channel: "$channel",
                    account: "$account",
                    ) {
                    _key
                    timeStamp
                    expiry
                    fromKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                      channel_pm
                      channel_py
                      channel_mobile1
                      channel_mobile2
                      channel_eth
                      channel_cash
                      channel_btc
                      channel_pp
                    }
                    toKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                      channel_pm
                      channel_py
                      channel_mobile1
                      channel_mobile2
                      channel_eth
                      channel_cash
                      channel_btc
                      channel_pp
                    }
                    matrix
                    matrixKey {
                      _key
                    }
                    rang
                    cycle
                    status
                    amountXOF
                    amountUSD
                    amountBTC
                    amountETH
                    toChannel
                    toAccount
                    payRef
                    payStamp
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
      var data = jsonData['data']['p2pSilverUpdateTransaction'];
      //print(data);
      if (data != null) {
        P2PTransactionModel obj = P2PTransactionModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountBTC: data['amountBTC'] as dynamic,
          amountETH: data['amountETH'] as dynamic,
          amountUSD: data['amountUSD'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          expiry: data['expiry'] as dynamic,
          toKey: data['toKey'] as dynamic,
          fromKey: data['fromKey'] as dynamic,
          matrix: data['matrix'] as String,
          matrixKey: data['matrixKey'] as dynamic,
          payRef: data['payRef'] as String,
          payStamp: data['payStamp'] as dynamic,
          rang: data['rang'] as int,
          cycle: data['cycle'] as int,
          status: data['status'] as String,
          toAccount: data['toAccount'] as String,
          toChannel: data['toChannel'] as String,
          error: null,
        );
        return obj;
      }
    } else {
      // failed to get user details
      P2PTransactionModel obj = P2PTransactionModel(
        key: null,
        timeStamp: null,
        amountBTC: null,
        amountETH: null,
        amountUSD: null,
        amountXOF: null,
        expiry: null,
        fromKey: null,
        matrix: null,
        matrixKey: null,
        payRef: null,
        payStamp: null,
        rang: null,
        cycle: null,
        status: null,
        toAccount: null,
        toChannel: null,
        toKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // update transaction

  // end my downlines
  // ignore: non_constant_identifier_names
  Future<List<MatrixP2PModel>> p2pMyDownlines({
    @required String userKey,
  }) async {
    var body = '''query {
                    p2pSilverMyDownlines(userKey: "$userKey") {
                      _key
                      timeStamp
                      level1Count
                      level2Count
                      username
                      userKey {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      linkedTo {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      sponsorKey {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel1 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel2 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel3 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel4 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel5 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel6 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel7 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel8 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel9 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
                      }
                      uplineLevel10 {
                        _key
                        firstName
                        lastName
                        username
                        countryFlag
                        countryName
                        countryCode
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
      var jsonDataFinal = jsonData['data']['p2pSilverMyDownlines'];

      //print(jsonDataFinal.length);
      List<MatrixP2PModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          MatrixP2PModel obj = MatrixP2PModel(
            key: data['_key'] as String,
            username: data['username'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            level1Count: data['level1Count'] as int,
            level2Count: data['level2Count'] as int,
            uplineLevel1: data['uplineLevel1'] as dynamic,
            uplineLevel2: data['uplineLevel2'] as dynamic,
            uplineLevel3: data['uplineLevel3'] as dynamic,
            uplineLevel4: data['uplineLevel4'] as dynamic,
            uplineLevel5: data['uplineLevel5'] as dynamic,
            uplineLevel6: data['uplineLevel6'] as dynamic,
            uplineLevel7: data['uplineLevel7'] as dynamic,
            uplineLevel8: data['uplineLevel8'] as dynamic,
            uplineLevel9: data['uplineLevel9'] as dynamic,
            uplineLevel10: data['uplineLevel10'] as dynamic,
            userKey: data['userKey'] as dynamic,
            linkedTo: data['linkedTo'] as dynamic,
            sponsorKey: data['sponsorKey'] as dynamic,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<MatrixP2PModel> objArray = [];
        MatrixP2PModel obj = MatrixP2PModel(
          key: null,
          username: null,
          timeStamp: null,
          level1Count: null,
          level2Count: null,
          uplineLevel1: null,
          uplineLevel10: null,
          uplineLevel2: null,
          uplineLevel3: null,
          uplineLevel4: null,
          uplineLevel5: null,
          uplineLevel6: null,
          uplineLevel7: null,
          uplineLevel8: null,
          uplineLevel9: null,
          linkedTo: null,
          sponsorKey: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<MatrixP2PModel> objArray = [];
      MatrixP2PModel obj = MatrixP2PModel(
        key: null,
        timeStamp: null,
        username: null,
        level1Count: null,
        level2Count: null,
        uplineLevel1: null,
        uplineLevel10: null,
        uplineLevel2: null,
        uplineLevel3: null,
        uplineLevel4: null,
        uplineLevel5: null,
        uplineLevel6: null,
        uplineLevel7: null,
        uplineLevel8: null,
        uplineLevel9: null,
        linkedTo: null,
        sponsorKey: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end my downlines

  // ignore: non_constant_identifier_names
  Future<List<MatrixP2PModel>> p2pMyNetwork({
    @required String userKey,
    @required int level,
  }) async {
    var body = '''query {
                  p2pSilverMyNetwork(
                    userKey: "$userKey", level: $level
                    ) {
                    _key
                    timeStamp
                    level1Count
                    level2Count
                    username
                    userKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    linkedTo {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    sponsorKey {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel1 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel2 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel3 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel4 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel5 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel6 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel7 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel8 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel9 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
                    }
                    uplineLevel10 {
                      _key
                      firstName
                      lastName
                      username
                      countryFlag
                      countryName
                      countryCode
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
      var jsonDataFinal = jsonData['data']['p2pSilverMyNetwork'];

      //print(jsonDataFinal.length);
      List<MatrixP2PModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          MatrixP2PModel obj = MatrixP2PModel(
            key: data['_key'] as String,
            username: data['username'] as String,
            timeStamp: data['timeStamp'] as dynamic,
            level1Count: data['level1Count'] as int,
            level2Count: data['level2Count'] as int,
            uplineLevel1: data['uplineLevel1'] as dynamic,
            uplineLevel2: data['uplineLevel2'] as dynamic,
            uplineLevel3: data['uplineLevel3'] as dynamic,
            uplineLevel4: data['uplineLevel4'] as dynamic,
            uplineLevel5: data['uplineLevel5'] as dynamic,
            uplineLevel6: data['uplineLevel6'] as dynamic,
            uplineLevel7: data['uplineLevel7'] as dynamic,
            uplineLevel8: data['uplineLevel8'] as dynamic,
            uplineLevel9: data['uplineLevel9'] as dynamic,
            uplineLevel10: data['uplineLevel10'] as dynamic,
            userKey: data['userKey'] as dynamic,
            linkedTo: data['linkedTo'] as dynamic,
            sponsorKey: data['sponsorKey'] as dynamic,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<MatrixP2PModel> objArray = [];
        MatrixP2PModel obj = MatrixP2PModel(
          key: null,
          username: null,
          timeStamp: null,
          level1Count: null,
          level2Count: null,
          uplineLevel1: null,
          uplineLevel10: null,
          uplineLevel2: null,
          uplineLevel3: null,
          uplineLevel4: null,
          uplineLevel5: null,
          uplineLevel6: null,
          uplineLevel7: null,
          uplineLevel8: null,
          uplineLevel9: null,
          linkedTo: null,
          sponsorKey: null,
          userKey: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<MatrixP2PModel> objArray = [];
      MatrixP2PModel obj = MatrixP2PModel(
        key: null,
        username: null,
        timeStamp: null,
        level1Count: null,
        level2Count: null,
        uplineLevel1: null,
        uplineLevel10: null,
        uplineLevel2: null,
        uplineLevel3: null,
        uplineLevel4: null,
        uplineLevel5: null,
        uplineLevel6: null,
        uplineLevel7: null,
        uplineLevel8: null,
        uplineLevel9: null,
        linkedTo: null,
        sponsorKey: null,
        userKey: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end my network

  // ignore: missing_return
  Future<bool> p2pSilverIsUserDueFree({@required String userKey}) async {
    var body = '''query {
                    p2pSilverIsUserDueFree(userKey: "$userKey")
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
      var data = jsonData['data']['p2pSilverIsUserDueFree'];
      //print(data);
      if (data == true) {
        return true;
      }
    } else {
      return false;
    }
  }
  // end isUserFree

  // end of
}
