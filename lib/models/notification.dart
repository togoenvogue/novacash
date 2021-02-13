class NotificationModel {
  final String id;
  final dynamic timeStamp;
  final dynamic userKey;
  final dynamic phone;
  final String message;
  final String status;
  final bool opened;
  final String error;

  NotificationModel({
    this.id,
    this.message,
    this.opened,
    this.phone,
    this.status,
    this.timeStamp,
    this.userKey,
    this.error,
  });
}
