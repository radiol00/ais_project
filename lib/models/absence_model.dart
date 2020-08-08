import 'package:ais_project/helpers/date_formatter.dart';

// Model zawierający dane nieobecności gotowe do wysłania do bazy
class Absence {
  Absence({this.startDate, this.endDate, this.reason, this.additionalInfo});
  Absence.fromMap(Map map) {
    startDate = DateTime.parse(map['start_date']);
    endDate = DateTime.parse(map['end_date']);
    reason = map['reason'];
    additionalInfo = map['additional_info'];
  }

  String toString() {
    return formatDate(startDate) +
        ' -> ' +
        formatDate(endDate) +
        ' [$reason] [$additionalInfo]';
  }

  Map toMap() {
    return {
      'start_date': startDate.toString().substring(0, 10),
      'end_date': endDate.toString().substring(0, 10),
      'reason': reason,
      'additional_info': additionalInfo,
    };
  }

  DateTime startDate;
  DateTime endDate;
  String reason;
  String additionalInfo;
}
