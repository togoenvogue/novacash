class UssdIncomingModel {
  final String key;
  final dynamic timeStamp;
  final String sender;
  final String message;
  final String error;
  final dynamic amount;
  final String payId;
  final String phone;
  final String network;
  final dynamic newBalance;
  final String type;
  final String zone;
  final String status;

  UssdIncomingModel({
    this.timeStamp,
    this.message,
    this.sender,
    this.error,
    this.amount,
    this.key,
    this.network,
    this.newBalance,
    this.payId,
    this.phone,
    this.status,
    this.type,
    this.zone,
  });
}
