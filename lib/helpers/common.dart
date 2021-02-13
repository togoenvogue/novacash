import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

DateFormat timeFormat;
const locale = "fr";

class DateHelper {
  // date only
  formatTimeStamp(dynamic timeStamp) {
    initializeDateFormatting(locale).then((_) {
      timeFormat = DateFormat.Hm(locale);
    });
    final dateTimeFormat = DateFormat.yMMMEd(locale)
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    return dateTimeFormat;
  }

  formatTimeStampShort(dynamic timeStamp) {
    initializeDateFormatting(locale).then((_) {
      timeFormat = DateFormat.Hm(locale);
    });
    final dateTimeFormat = DateFormat.yMMM(locale)
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    return dateTimeFormat;
  }

  // date and hour
  formatTimeStampFull(dynamic timeStamp) {
    initializeDateFormatting(locale).then((_) {
      timeFormat = DateFormat.Hm(locale);
    });
    final dateTimeFormat = DateFormat.yMMMEd(locale)
        .add_Hm()
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    return dateTimeFormat;
  }
}

class NumberHelper {
  formatNumber(dynamic number) {
    //return NumberFormat("###.##", 'fr_FR').format(number);
    return NumberFormat("#,###.##", 'fr_FR').format(number);
  }
}
