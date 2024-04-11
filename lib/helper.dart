import 'package:intl/intl.dart';

String formatDateToDayMonth(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('d MMM').format(dateTime); // "8 Dec"
}

String formatDateToHourMinute(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('h:mm a').format(dateTime); // "8:00 AM"
}
