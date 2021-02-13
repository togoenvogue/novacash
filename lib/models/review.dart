class ReviewModel {
  final String key;
  final dynamic timeStamp;
  final dynamic userKey;
  final String detail;
  final dynamic rate;
  final String status;
  final String error;

  ReviewModel({
    this.detail,
    this.key,
    this.rate,
    this.status,
    this.timeStamp,
    this.userKey,
    this.error,
  });
}
