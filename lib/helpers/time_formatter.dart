import 'package:flutter/material.dart';

// Modyfikowalne formatowanie godzin
String formatTime(TimeOfDay time) {
  String hour = time.hour < 10 ? '0${time.hour}' : '${time.hour}';
  String minute = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
  return '$hour:$minute';
}
