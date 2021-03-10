class MatrixP2PModel {
  final String key;
  final dynamic timeStamp;
  final dynamic userKey;
  final String username;
  final dynamic sponsorKey;
  final dynamic linkedTo;
  final dynamic uplineLevel1;
  final dynamic uplineLevel2;
  final dynamic uplineLevel3;
  final dynamic uplineLevel4;
  final dynamic uplineLevel5;
  final dynamic uplineLevel6;
  final dynamic uplineLevel7;
  final dynamic uplineLevel8;
  final dynamic uplineLevel9;
  final dynamic uplineLevel10;
  final int level1Count;
  final int level2Count;
  final String error;

  MatrixP2PModel({
    this.key,
    this.username,
    this.level1Count,
    this.error,
    this.level2Count,
    this.linkedTo,
    this.sponsorKey,
    this.timeStamp,
    this.uplineLevel1,
    this.uplineLevel10,
    this.uplineLevel2,
    this.uplineLevel3,
    this.uplineLevel4,
    this.uplineLevel5,
    this.uplineLevel6,
    this.uplineLevel7,
    this.uplineLevel8,
    this.uplineLevel9,
    this.userKey,
  });
}
