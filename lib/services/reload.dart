import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/reload.dart';

class ReloadService {
  // ignore: missing_return
  Future<CryptoPayinModel> cryptoPayinCreate({
    @required String userKey,
    @required String currency,
    @required dynamic amount,
  }) async {
    var body = '''mutation {
                    payinCreate(
                      amount: $amount, 
                      currency: "$currency", 
                      userKey: "$userKey"
                      ) {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      userKey {
                        _key
                        username
                        firstName
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
      var data = jsonData['data']['payinCreate'];
      //print(data);

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          userKey: data['userKey'] as Object,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        status: null,
        txid: null,
        userKey: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end payin

// ignore: missing_return
  Future<CryptoPayinModel> cryptoPayinCreateUsername({
    @required String username,
    @required String currency,
    @required dynamic amount,
    @required type,
  }) async {
    var body = '''mutation {
                    payinCreateWithUsername(
                      amountXOF: $amount, 
                      currency: "$currency", 
                      username: "$username",
                      type: "$type"
                      ) {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      username
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
      var data = jsonData['data']['payinCreateWithUsername'];
      //print(data);

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          username: data['username'] as String,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        status: null,
        txid: null,
        username: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end payin with username

  // ignore: missing_return
  Future<CryptoPayinModel> payinPending({
    @required String userKey,
    @required String currency,
    @required String type,
  }) async {
    var body = '''query {
                    payinPending(
                      userKey: "$userKey",
                      currency: "$currency",
                      type: "$type"
                      ) {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      username
                      token
                      userKey {
                        _key
                        username
                        firstName
                        lastName
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
      var data = jsonData['data']['payinPending'];

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          userKey: data['userKey'] as Object,
          username: data['username'] as String,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        token: null,
        status: null,
        txid: null,
        userKey: null,
        username: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }

  // ignore: missing_return
  Future<CryptoPayinModel> payin({@required String searchString}) async {
    var body = '''query {
                    payin(searchString: "$searchString") {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      username
                      token
                      userKey {
                        _key
                        username
                        firstName
                        lastName
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
      var data = jsonData['data']['payin'];

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          userKey: data['userKey'] as Object,
          username: data['username'] as String,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        token: null,
        status: null,
        txid: null,
        userKey: null,
        username: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // end payin

  // ignore: missing_return
  Future<CryptoPayinModel> payinVerifyAndGenerateToken(
      {@required String address}) async {
    var body = '''query {
                    payinCheckAndGenerateToken(address: "$address") {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      username
                      token
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
      var data = jsonData['data']['payinCheckAndGenerateToken'];

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          userKey: data['userKey'] as Object,
          username: data['username'] as String,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        status: null,
        txid: null,
        token: null,
        userKey: null,
        username: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end verify payin payment

  // ignore: missing_return
  Future<CryptoPayinModel> payinVerifyAndRenewAutoship({
    @required String address,
    @required userKey,
  }) async {
    var body = '''query {
                    payinCheckAndRenewAutoship(
                      address: "$address",
                      userKey: "$userKey"
                      ) {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      username
                      token
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
      var data = jsonData['data']['payinCheckAndRenewAutoship'];

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          userKey: data['userKey'] as Object,
          username: data['username'] as String,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          token: data['token'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        status: null,
        txid: null,
        token: null,
        userKey: null,
        username: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
  // and verity and renew autoship

  // end payin pending
  // ignore: missing_return
  Future<CryptoPayinModel> payinCancel({
    @required String userKey,
    @required String payinKey,
  }) async {
    var body = '''mutation {
                    payinCancel(userKey: "$userKey", payinKey: "$payinKey") {
                      _key
                      timeStamp
                      usageStamp
                      confirmations
                      amountCrypto
                      currency
                      amountXOF
                      rateXOF
                      fees
                      amountPaid
                      txid
                      status
                      systemAddress
                      currency
                      username
                      userKey {
                        _key
                        username
                        firstName
                        lastName
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
      var data = jsonData['data']['payinCancel'];

      if (data != null) {
        CryptoPayinModel obj = CryptoPayinModel(
          key: data['_key'] as String,
          timeStamp: data['timeStamp'] as dynamic,
          amountCrypto: data['amountCrypto'] as dynamic,
          amountXOF: data['amountXOF'] as dynamic,
          status: data['status'] as String,
          txid: data['txid'] as String,
          userKey: data['userKey'] as Object,
          amountPaid: data['amountPaid'] as dynamic,
          confirmations: data['confirmations'] as int,
          currency: data['currency'] as String,
          fees: data['fees'] as dynamic,
          fromAddress: data['fromAddress'] as String,
          rateXOF: data['rateXOF'] as dynamic,
          systemAddress: data['systemAddress'] as String,
          usageStamp: data['usageStamp'] as dynamic,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      CryptoPayinModel obj = CryptoPayinModel(
        key: null,
        timeStamp: null,
        amountCrypto: null,
        amountXOF: null,
        status: null,
        txid: null,
        userKey: null,
        amountPaid: null,
        confirmations: null,
        currency: null,
        fees: null,
        fromAddress: null,
        rateXOF: null,
        systemAddress: null,
        usageStamp: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  } // end cancel payin

  // get operators
  // ignore: missing_return
  Future<List<MobileNetworkModel>> getMobileNetworks(
      {@required int code}) async {
    var body = '''query {
                      mobileNetworksByCountry(countryCode: $code) {
                        _key
                        name
                        countryCode
                        local_number_length
                        mobile_money_name
                        system_benef_name
                        countryName
                        system_account_national
                        system_account_international
                        network_mmc
                        network_mnc
                        total_received
                        total_sent
                        codes
                        ussd_money_send_international
                        ussd_money_send_national
                        ussd_money_balance
                        logo
                        isActive
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
      var jsonDataFinal = jsonData['data']['mobileNetworksByCountry'];

      //print(jsonDataFinal.length);
      List<MobileNetworkModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          MobileNetworkModel obj = MobileNetworkModel(
            key: data['_key'] as String,
            isActive: data['isActive'] as bool,
            name: data['name'] as String,
            codes: data['codes'],
            countryCode: data['countryCode'] as int,
            countryName: data['countryName'] as String,
            local_number_length: data['local_number_length'] as int,
            logo: data['logo'] as String,
            mobile_money_name: data['mobile_money_name'] as String,
            system_benef_name: data['system_benef_name'] as String,
            system_account_international:
                data['system_account_international'] as String,
            system_account_national: data['system_account_national'] as String,
            network_mnc: data['network_mnc'] as int,
            network_mmc: data['network_mmc'] as int,
            total_received: data['total_received'] as dynamic,
            total_sent: data['total_sent'] as dynamic,
            ussd_money_balance: data['ussd_money_balance'] as String,
            ussd_money_send_international:
                data['ussd_money_send_international'] as String,
            ussd_money_send_national:
                data['ussd_money_send_national'] as String,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<MobileNetworkModel> objArray = [];
        MobileNetworkModel obj = MobileNetworkModel(
          key: null,
          isActive: null,
          name: null,
          codes: null,
          countryCode: null,
          countryName: null,
          local_number_length: null,
          logo: null,
          mobile_money_name: null,
          system_benef_name: null,
          system_account_international: null,
          system_account_national: null,
          network_mmc: null,
          network_mnc: null,
          total_received: null,
          total_sent: null,
          ussd_money_balance: null,
          ussd_money_send_national: null,
          ussd_money_send_international: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<MobileNetworkModel> objArray = [];
      MobileNetworkModel obj = MobileNetworkModel(
        key: null,
        isActive: null,
        name: null,
        codes: null,
        countryCode: null,
        countryName: null,
        local_number_length: null,
        logo: null,
        mobile_money_name: null,
        system_benef_name: null,
        system_account_international: null,
        system_account_national: null,
        total_received: null,
        network_mmc: null,
        network_mnc: null,
        total_sent: null,
        ussd_money_balance: null,
        ussd_money_send_national: null,
        ussd_money_send_international: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  }
  // end get operators

  Future<bool> isPhoneNumberValid({@required dynamic phone}) async {
    var body = '''query {
                    mobilePhoneNetworkIsValid(phone: $phone) 
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
      var data = jsonData['data']['mobilePhoneNetworkIsValid'];
      //print(data);
      if (data != null && data == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  // end is phone number valid

  Future<bool> rewloadWithMobilePayin({
    @required String userKey,
    @required String sender,
    @required String message,
    @required String client,
    @required String system,
    @required dynamic amount,
    @required int countryCode,
    @required String ussd,
  }) async {
    var body = '''mutation {
                  depositMobilePayin(
                    sender: "$sender",
                    message: "$message", 
                    countryCode: $countryCode, 
                    client: "$client", 
                    system: "$system",
                    userKey: "$userKey",
                    amount: $amount,
                    ussd: "$ussd"
                  )
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
      var data = jsonData['data']['depositMobilePayin'];

      if (data != null && data == true) {
        return true;
      } else {
        return false;
      }
      // end

    } else {
      return false;
    }
  } // end reloadMobileCreate

}
