class AppConfigModel {
  final String key;
  final String name;
  final String company;
  final String email;
  final String website;
  final String phone1;
  final String phone2;
  // ignore: non_constant_identifier_names
  final List<dynamic> auth_devices;
  // ignore: non_constant_identifier_names
  final String app_ios_store;
  // ignore: non_constant_identifier_names
  final String app_android_store;
  // ignore: non_constant_identifier_names
  final String version_previous;
  // ignore: non_constant_identifier_names
  final String version_current;
  // ignore: non_constant_identifier_names
  final String app_whats_new;
  final String desc;
  // ignore: non_constant_identifier_names
  final dynamic foot_base_amount;
  // ignore: non_constant_identifier_names
  final dynamic pmu_base_amount;
  // ignore: non_constant_identifier_names
  final dynamic pmu_parisur_amount;
  // ignore: non_constant_identifier_names
  final dynamic jackpot1_base_amount;
  // ignore: non_constant_identifier_names
  final dynamic jackpot1_system_balance;
  // ignore: non_constant_identifier_names
  final dynamic jackpot2_base_amount;
  // ignore: non_constant_identifier_names
  final dynamic jackpot2_system_balance;
  // ignore: non_constant_identifier_names
  final dynamic foot_system_balance;
  // ignore: non_constant_identifier_names
  final dynamic pmu_system_balance;
  // ignore: non_constant_identifier_names
  final dynamic expiration_cost;
  // ignore: non_constant_identifier_names
  final dynamic minimum_withdraw;
  // ignore: non_constant_identifier_names
  final dynamic minimum_deposit;
  // ignore: non_constant_identifier_names
  final dynamic jackpot1_extra;
  // ignore: non_constant_identifier_names
  final dynamic jackpot2_extra;
  final String error;
  // ignore: non_constant_identifier_names
  final dynamic bet_tax;
  // ignore: non_constant_identifier_names
  final dynamic maximum_withdrawal;
  // ignore: non_constant_identifier_names
  final dynamic test_period;
  // ignore: non_constant_identifier_names
  final dynamic renewal_period;
  // ignore: non_constant_identifier_names
  final dynamic foot_sum_tax;
  // ignore: non_constant_identifier_names
  final dynamic foot_sum_assur;
  // ignore: non_constant_identifier_names
  final dynamic pmu_sum_tax;
  // ignore: non_constant_identifier_names
  final dynamic pmu_sum_assur;
  // ignore: non_constant_identifier_names
  final String version_update_desc;
  final bool isGameCoted;
  final dynamic sumPronostics;
  final dynamic sumRenewals;
  final dynamic sumDeposits;
  final dynamic sumWithdrawals;

  AppConfigModel({
    // ignore: non_constant_identifier_names
    this.bet_tax,
    // ignore: non_constant_identifier_names
    this.maximum_withdrawal,
    // ignore: non_constant_identifier_names
    this.test_period,
    // ignore: non_constant_identifier_names
    this.renewal_period,
    this.company,
    this.desc,
    this.email,
    this.error,
    // ignore: non_constant_identifier_names
    this.expiration_cost,
    // ignore: non_constant_identifier_names
    this.foot_base_amount,
    // ignore: non_constant_identifier_names
    this.jackpot1_base_amount,
    // ignore: non_constant_identifier_names
    this.jackpot2_base_amount,
    // ignore: non_constant_identifier_names
    this.jackpot1_system_balance,
    // ignore: non_constant_identifier_names
    this.jackpot2_system_balance,
    this.key,
    // ignore: non_constant_identifier_names
    this.minimum_deposit,
    // ignore: non_constant_identifier_names
    this.minimum_withdraw,
    this.name,
    this.phone1,
    this.phone2,
    // ignore: non_constant_identifier_names
    this.pmu_base_amount,
    // ignore: non_constant_identifier_names
    this.pmu_parisur_amount,
    // ignore: non_constant_identifier_names
    this.pmu_system_balance,
    // ignore: non_constant_identifier_names
    this.foot_system_balance,
    // ignore: non_constant_identifier_names
    this.version_current,
    // ignore: non_constant_identifier_names
    this.version_previous,
    // ignore: non_constant_identifier_names
    this.jackpot1_extra,
    // ignore: non_constant_identifier_names
    this.jackpot2_extra,
    // ignore: non_constant_identifier_names
    this.foot_sum_assur,
    // ignore: non_constant_identifier_names
    this.foot_sum_tax,
    // ignore: non_constant_identifier_names
    this.pmu_sum_assur,
    // ignore: non_constant_identifier_names
    this.pmu_sum_tax,
    // ignore: non_constant_identifier_names
    this.app_android_store,
    // ignore: non_constant_identifier_names
    this.app_ios_store,
    // ignore: non_constant_identifier_names
    this.app_whats_new,
    this.website,
    // ignore: non_constant_identifier_names
    this.version_update_desc,
    // ignore: non_constant_identifier_names
    this.auth_devices,
    this.isGameCoted,
    this.sumDeposits,
    this.sumPronostics,
    this.sumRenewals,
    this.sumWithdrawals,
  });
}
