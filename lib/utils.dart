import 'package:intl/intl.dart';

String formatChatTimestamp(DateTime timestamp) {
  DateTime now = DateTime.now();
  DateTime justNow = DateTime(now.year, now.month, now.day);
  DateTime yesterday = justNow.subtract(const Duration(days: 1));

  if (timestamp.isAfter(justNow)) {
    return "Today ${DateFormat('HH:mm').format(timestamp)}";
  } else if (timestamp.isAfter(yesterday)) {
    return "Yesterday ${DateFormat('HH:mm').format(timestamp)}";
  } else {
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }
}
