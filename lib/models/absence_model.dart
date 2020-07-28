import 'package:ais_project/helpers/date_formatter.dart';

// Model zawierający dane nieobecności gotowe do wysłania do bazy
class Absence {
  Absence({this.startDate, this.endDate, this.reason, this.additionalInfo});
  String toString() {
    return formatDate(startDate) +
        ' -> ' +
        formatDate(endDate) +
        ' [$reason] [$additionalInfo]';
  }

  DateTime startDate;
  DateTime endDate;
  String reason;
  String additionalInfo;
}
