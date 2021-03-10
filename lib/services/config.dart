import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/configuration.dart';
import '../models/config.dart';

class AppService {
// ignore: missing_return
  Future<AppConfigModel> app() async {
    var body = '''query {
                    appConfig {
                      _key
                      name
                      company
                      email
                      website
                      telegram
                      phone1
                      phone2
                      version_previous
                      version_current
                      version_update_desc
                      app_android_store
                      app_whats_new
                      app_ios_store
                      desc
                      auth_devices
                      sum_partner
                      sum_tgv
                      sum_debos
                      sum_reserve
                      sum_ewallet
                      sum_cash_in
                      sum_cash_out
                      sum_cash_out_tax
                      sum_phone
                      sum_moto
                      sum_car
                      free_coin_amount
                      free_coin_limit
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
      var data = jsonData['data']['appConfig'];
      //print(data);

      if (data != null) {
        AppConfigModel obj = AppConfigModel(
          key: data['_key'] as String,
          name: data['name'] as String,
          company: data['company'] as String,
          auth_devices: data['auth_devices'],
          email: data['email'] as String,
          telegram: data['telegram'] as String,
          website: data['website'] as String,
          phone1: data['phone1'] as String,
          phone2: data['phone2'] as String,
          version_previous: data['version_previous'] as String,
          version_current: data['version_current'] as String,
          desc: data['desc'] as String,
          app_android_store: data['app_android_store'] as String,
          app_ios_store: data['app_ios_store'] as String,
          app_whats_new: data['app_whats_new'] as String,
          sum_car: data['sum_car'] as dynamic,
          sum_cash_in: data['sum_cash_in'] as dynamic,
          sum_cash_out: data['sum_cash_out'] as dynamic,
          sum_cash_out_tax: data['sum_cash_out_tax'] as dynamic,
          sum_debos: data['sum_debos'] as dynamic,
          sum_ewallet: data['sum_ewallet'] as dynamic,
          sum_moto: data['sum_moto'] as dynamic,
          sum_partner: data['sum_partner'] as dynamic,
          sum_phone: data['sum_phone'] as dynamic,
          sum_reserve: data['sum_reserve'] as dynamic,
          sum_tgv: data['sum_tgv'] as dynamic,
          free_coin_amount: data['free_coin_amount'] as dynamic,
          free_coin_limit: data['free_coin_limit'] as int,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      AppConfigModel obj = AppConfigModel(
        key: null,
        telegram: null,
        name: null,
        company: null,
        email: null,
        website: null,
        phone1: null,
        phone2: null,
        version_previous: null,
        version_current: null,
        app_android_store: null,
        app_ios_store: null,
        desc: null,
        auth_devices: null,
        app_whats_new: null,
        sum_car: null,
        sum_cash_in: null,
        sum_cash_out: null,
        sum_cash_out_tax: null,
        sum_debos: null,
        sum_ewallet: null,
        sum_moto: null,
        sum_partner: null,
        sum_phone: null,
        sum_reserve: null,
        sum_tgv: null,
        free_coin_amount: null,
        free_coin_limit: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
}
