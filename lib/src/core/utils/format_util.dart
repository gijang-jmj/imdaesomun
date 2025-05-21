import 'package:intl/intl.dart';

class FormatUtil {
  static String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yyyy.MM.dd').format(date);
  }

  static String formatNumberWithComma(int hits) {
    return NumberFormat('#,###').format(hits);
  }
}
