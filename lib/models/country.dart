class CountryModel {
  final String key;
  final String countryName;
  final String countryFlag;
  final int countryCode;
  final int countryMobileLength;
  final String error;

  CountryModel({
    this.key,
    this.countryCode,
    this.countryFlag,
    this.countryName,
    this.countryMobileLength,
    this.error,
  });
}