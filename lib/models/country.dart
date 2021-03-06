class CountryModel {
  final String key;
  final String countryName;
  final String countryFlag;
  final int countryCode;
  final int countryMobileLength;
  final bool isApnOpened;
  final int phoneNumberLength;
  final String error;

  CountryModel({
    this.key,
    this.phoneNumberLength,
    this.countryCode,
    this.countryFlag,
    this.countryName,
    this.countryMobileLength,
    this.isApnOpened,
    this.error,
  });
}
