import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToDDMMMYYYY(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  String formatTimeToDotAMPM(String time) {
    try {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final isAM = hour < 12;
      hour = hour % 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute ${isAM ? 'am' : 'pm'}';
    } catch (e) {
      return '-';
    }
  }

  DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      return DateTime.parse(value); // Try ISO 8601 first
    } catch (_) {
      try {
        // Try custom format: 'dd-MM-yyyy HH:mm:ss' or 'yyyy/MM/dd'
        return DateFormat("dd-MM-yyyy HH:mm:ss").parse(value);
      } catch (_) {
        try {
          return DateFormat("yyyy/MM/dd").parse(value);
        } catch (_) {
          return null; // fallback
        }
      }
    }
  }
}
