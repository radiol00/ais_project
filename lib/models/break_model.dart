import 'package:ais_project/helpers/date_formatter.dart';
import 'package:ais_project/helpers/time_formatter.dart';
import 'package:flutter/material.dart';

class Break {
  Break({this.startTime, this.endTime, this.reason, this.additionalInfo}) {
    day = DateTime.now();
  }
  String toString() {
    return formatDate(day) +
        ' ' +
        formatTime(startTime) +
        ' -> ' +
        formatTime(endTime) +
        ' [$reason] [$additionalInfo]';
  }

  DateTime day;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String reason;
  String additionalInfo;
}
