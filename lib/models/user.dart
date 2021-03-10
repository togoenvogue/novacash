class UserModel {
  final String key;
  final dynamic timeStamp;
  final dynamic nextQuizPlay;
  final dynamic expiry;
  final bool isDemoAccount;
  final dynamic nextToWithdraw;
  final String email;
  final String username;
  final dynamic phone;
  final String password;
  final String passwordReset;
  final dynamic resetStamp;
  final String firstName;
  final String lastName;
  final String countryFlag;
  final String countryName;
  final int countryCode;
  final dynamic lastLogin;
  final bool isAuth;
  final String token;
  final String loginRef;
  final dynamic authExpir;
  final bool isLocked;
  final bool isActive;
  final bool isAdmin;
  final bool isSuperAdmin;
  final bool isSupport;
  final bool conditionsAccepted;
  final bool phoneVerified;
  final String phoneVerificationCode;
  final String picture;
  final String whatsApp;
  final dynamic ewalletReset;
  // ignore: non_constant_identifier_names
  final dynamic ewallet_balance;
  // ignore: non_constant_identifier_names
  final dynamic ewallet_total;
  // ignore: non_constant_identifier_names
  final dynamic credits_balance;
  // ignore: non_constant_identifier_names
  final dynamic ewallet_p2p;
  // ignore: non_constant_identifier_names
  final dynamic credits_total;
  final bool gadget1Qualified;
  final bool gadget2Qualified;
  final bool gadget3Qualified;
  final bool gadget1Given;
  final bool gadget2Given;
  final bool gadget3Given;
  final bool novaCashCore;
  final bool novaCashP2PSilver;
  final bool novaCashP2PGold;
  final bool novaCashP2PRuby;
  final List<dynamic> categories;
  final String error;
  final String sex;
  final int age;
  // ignore: non_constant_identifier_names
  final String channel_mobile1;
  // ignore: non_constant_identifier_names
  final String channel_mobile2;
  final String channel_mobile3;
  // ignore: non_constant_identifier_names
  final String channel_cash; // ignore: non_constant_identifier_names
  final String channel_btc; // ignore: non_constant_identifier_names
  final String channel_eth; // ignore: non_constant_identifier_names
  final String channel_pm; // ignore: non_constant_identifier_names
  final String channel_py; // ignore: non_constant_identifier_names
  final String channel_pp; // ignore: non_constant_identifier_names

  UserModel({
    this.age,
    this.sex,
    this.key,
    this.authExpir,
    this.conditionsAccepted,
    this.countryCode,
    this.countryFlag,
    this.countryName,
    // ignore: non_constant_identifier_names
    this.credits_balance,
    // ignore: non_constant_identifier_names
    this.credits_total,
    this.email,
    this.error,
    this.ewalletReset,
    // ignore: non_constant_identifier_names
    this.ewallet_balance,
    // ignore: non_constant_identifier_names
    this.ewallet_total,
    // ignore: non_constant_identifier_names
    this.ewallet_p2p,
    this.expiry,
    this.firstName,
    this.gadget1Given,
    this.gadget1Qualified,
    this.gadget2Given,
    this.gadget2Qualified,
    this.gadget3Given,
    this.gadget3Qualified,
    this.isActive,
    this.isAdmin,
    this.isAuth,
    this.isDemoAccount,
    this.isLocked,
    this.isSuperAdmin,
    this.isSupport,
    this.lastLogin,
    this.lastName,
    this.nextToWithdraw,
    this.password,
    this.passwordReset,
    this.phone,
    this.phoneVerificationCode,
    this.phoneVerified,
    this.picture,
    this.resetStamp,
    this.timeStamp,
    this.token,
    this.username,
    this.whatsApp,
    this.categories,
    this.loginRef,
    this.novaCashCore,
    this.novaCashP2PGold,
    this.novaCashP2PRuby,
    this.novaCashP2PSilver,
    this.nextQuizPlay,
    this.channel_btc, // ignore: non_constant_identifier_names
    this.channel_cash, // ignore: non_constant_identifier_names
    this.channel_eth, // ignore: non_constant_identifier_names
    this.channel_mobile1, // ignore: non_constant_identifier_names
    this.channel_mobile2, // ignore: non_constant_identifier_names
    this.channel_mobile3, // ignore: non_constant_identifier_names
    this.channel_pm, // ignore: non_constant_identifier_names
    this.channel_py, // ignore: non_constant_identifier_names
    this.channel_pp, // ignore: non_constant_identifier_names
  });
}
