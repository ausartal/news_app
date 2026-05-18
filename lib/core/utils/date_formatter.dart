import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime? dateTime) {
    if (dateTime == null) {
      return '-';
    }
    return DateFormat('dd MMM yyyy • HH:mm').format(dateTime.toLocal());
  }
}
