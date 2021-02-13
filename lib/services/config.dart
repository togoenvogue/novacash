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
                      phone1
                      phone2
                      version_previous
                      version_current
                      version_update_desc
                      desc
                      app_android_store
                      app_ios_store
                      auth_devices
                      foot_base_amount
                      pmu_base_amount
                      pmu_parisur_amount
                      jackpot1_base_amount
                      jackpot1_system_balance
                      jackpot2_base_amount
                      jackpot2_system_balance
                      jackpot1_extra
                      jackpot2_extra
                      foot_system_balance
                      pmu_system_balance
                      expiration_cost
                      minimum_withdraw
                      minimum_deposit
                      bet_tax
                      maximum_withdrawal
                      test_period
                      renewal_period
                      foot_sum_assur
                      foot_sum_tax
                      pmu_sum_assur
                      pmu_sum_tax
                      isGameCoted
                      sumPronostics
                      sumRenewals
                      sumDeposits
                      sumWithdrawals
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
          website: data['website'] as String,
          phone1: data['phone1'] as String,
          phone2: data['phone2'] as String,
          version_previous: data['version_previous'] as String,
          version_current: data['version_current'] as String,
          desc: data['desc'] as String,
          foot_base_amount: data['foot_base_amount'] as dynamic,
          bet_tax: data['bet_tax'] as dynamic,
          maximum_withdrawal: data['maximum_withdrawal'] as dynamic,
          test_period: data['test_period'] as dynamic,
          renewal_period: data['renewal_period'] as dynamic,
          jackpot1_base_amount: data['jackpot1_base_amount'] as dynamic,
          jackpot1_system_balance: data['jackpot1_system_balance'] as dynamic,
          jackpot2_base_amount: data['jackpot2_base_amount'] as dynamic,
          jackpot2_system_balance: data['jackpot2_system_balance'] as dynamic,
          expiration_cost: data['expiration_cost'] as dynamic,
          minimum_withdraw: data['minimum_withdraw'] as dynamic,
          minimum_deposit: data['minimum_deposit'] as dynamic,
          foot_system_balance: data['foot_system_balance'] as dynamic,
          pmu_system_balance: data['pmu_system_balance'] as dynamic,
          jackpot1_extra: data['jackpot1_extra'] as dynamic,
          jackpot2_extra: data['jackpot2_extra'] as dynamic,
          foot_sum_assur: data['foot_sum_assur'] as dynamic,
          isGameCoted: data['isGameCoted'] as bool,
          sumDeposits: data['sumDeposits'] as dynamic,
          sumPronostics: data['sumPronostics'] as dynamic,
          sumRenewals: data['sumRenewals'] as dynamic,
          sumWithdrawals: data['sumWithdrawals'] as dynamic,
          app_android_store: data['app_android_store'] as String,
          app_ios_store: data['app_ios_store'] as String,
          app_whats_new: data['app_whats_new'] as String,
          foot_sum_tax: data['foot_sum_tax'] as dynamic,
          pmu_base_amount: data['pmu_base_amount'] as dynamic,
          pmu_parisur_amount: data['pmu_parisur_amount'] as dynamic,
          pmu_sum_assur: data['pmu_sum_assur'] as dynamic,
          pmu_sum_tax: data['pmu_sum_tax'] as dynamic,
          version_update_desc: data['version_update_desc'] as String,
          error: null,
        );
        return obj;
      }
      // end

    } else {
      // failed to get user details
      AppConfigModel obj = AppConfigModel(
        key: null,
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
        version_update_desc: null,
        desc: null,
        auth_devices: null,
        foot_base_amount: null,
        app_whats_new: null,
        bet_tax: null,
        maximum_withdrawal: null,
        test_period: null,
        renewal_period: null,
        pmu_base_amount: null,
        pmu_parisur_amount: null,
        jackpot1_base_amount: null,
        jackpot1_system_balance: null,
        jackpot2_base_amount: null,
        jackpot2_system_balance: null,
        foot_system_balance: null,
        jackpot1_extra: null,
        jackpot2_extra: null,
        pmu_system_balance: null,
        expiration_cost: null,
        minimum_withdraw: null,
        minimum_deposit: null,
        foot_sum_assur: null,
        foot_sum_tax: null,
        pmu_sum_assur: null,
        pmu_sum_tax: null,
        isGameCoted: null,
        sumDeposits: null,
        sumPronostics: null,
        sumRenewals: null,
        sumWithdrawals: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      return obj;
    }
  }
}
