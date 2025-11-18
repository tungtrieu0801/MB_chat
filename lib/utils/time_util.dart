import 'package:intl/intl.dart';

/// Convert and format UTC time (ISO 8601) to 12-hour clock (hh:mm am/pm)
String formatTimeMessage(String isoString) {
  try {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat.jm().format(dateTime);
  } catch (e) {
    print('fail when parsing time $e');
    return '';
  }
}