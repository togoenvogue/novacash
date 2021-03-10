class AppConfigModel {
  final String key;
  final String name;
  final String company;
  final String email;
  final String telegram;
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
  final String error;
  // ignore: non_constant_identifier_names
  final dynamic sum_partner;
  // ignore: non_constant_identifier_names
  final dynamic sum_tgv;
  // ignore: non_constant_identifier_names
  final dynamic sum_debos;
  // ignore: non_constant_identifier_names
  final dynamic sum_reserve;
  // ignore: non_constant_identifier_names
  final dynamic sum_ewallet;
  // ignore: non_constant_identifier_names
  final dynamic sum_cash_in;
  // ignore: non_constant_identifier_names
  final dynamic sum_cash_out;
  // ignore: non_constant_identifier_names
  final dynamic sum_cash_out_tax;
  // ignore: non_constant_identifier_names
  final dynamic sum_phone;
  // ignore: non_constant_identifier_names
  final dynamic sum_moto;
  // ignore: non_constant_identifier_names
  final dynamic sum_car;
  final dynamic free_coin_amount; // ignore: non_constant_identifier_names
  final int free_coin_limit; // ignore: non_constant_identifier_names

  AppConfigModel({
    this.company,
    this.telegram,
    this.free_coin_amount, // ignore: non_constant_identifier_names
    this.free_coin_limit, // ignore: non_constant_identifier_names
    this.desc,
    this.email,
    this.error,
    // ignore: non_constant_identifier_names
    this.key,
    // ignore: non_constant_identifier_names
    this.name,
    this.phone1,
    this.phone2,
    // ignore: non_constant_identifier_names
    this.version_current,
    // ignore: non_constant_identifier_names
    this.version_previous,
    // ignore: non_constant_identifier_names
    this.app_android_store,
    // ignore: non_constant_identifier_names
    this.app_ios_store,
    // ignore: non_constant_identifier_names
    this.app_whats_new,
    this.website,
    // ignore: non_constant_identifier_names
    this.auth_devices,
    // ignore: non_constant_identifier_names
    this.sum_car,
    // ignore: non_constant_identifier_names
    this.sum_cash_in,
    // ignore: non_constant_identifier_names
    this.sum_cash_out,
    // ignore: non_constant_identifier_names
    this.sum_cash_out_tax,
    // ignore: non_constant_identifier_names
    this.sum_debos,
    // ignore: non_constant_identifier_names
    this.sum_ewallet,
    // ignore: non_constant_identifier_names
    this.sum_moto,
    // ignore: non_constant_identifier_names
    this.sum_partner,
    // ignore: non_constant_identifier_names
    this.sum_phone,
    // ignore: non_constant_identifier_names
    this.sum_reserve,
    // ignore: non_constant_identifier_names
    this.sum_tgv,
  });
}
