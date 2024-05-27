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


const appId = 1841062972;
const appSign = 'f1492941d96e74157c5fcc8344e98d6ea8d0f021e67cb2a0edd63cd235209a65';