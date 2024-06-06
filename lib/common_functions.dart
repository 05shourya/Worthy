import 'package:flutter/material.dart';

String formatNumber(double value) {
  if (value < 10000) {
    return value.toStringAsFixed(0);
  } else if (value < 1000000) {
    if (value < 100000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
  } else if (value < 1000000000) {
    if (value < 100000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(value / 1000000).toStringAsFixed(0)}M';
    }
  } else {
    if (value < 100000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else {
      return '${(value / 1000000000).toStringAsFixed(0)}B';
    }
  }
}

Future<DateTime> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDateTime,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDateTime ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(1900),
    lastDate: lastDate ?? DateTime.now(),
  );

  if (selectedDate != null) {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  }

  return DateTime.now();
}

bool isLightColor(Color color) {
  // Calculate the luminance of the color
  double luminance =
      (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  return luminance > 0.5;
}
