class JackpotModel {
  final String key;
  final dynamic secret;
  final dynamic totalGained;
  final String error;

  JackpotModel({
    this.key,
    this.totalGained,
    this.secret,
    this.error,
  });
}

class JackpotPlayModel {
  final String key;
  final dynamic timeStamp;
  final dynamic userKey;
  final int systemChoice;
  final int userChoice;
  final bool hasWon;
  final dynamic amountBet;
  final dynamic amountGained;
  final String status;
  final String error;

  JackpotPlayModel({
    this.key,
    this.userKey,
    this.timeStamp,
    this.userChoice,
    this.systemChoice,
    this.hasWon,
    this.amountBet,
    this.amountGained,
    this.status,
    this.error,
  });
}
