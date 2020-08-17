import 'package:ais_project/formatters/date_formatter.dart';
import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';
import 'package:ais_project/widgets/reason_dropdown.dart';

class AddAbsencePage extends StatefulWidget {
  @override
  _AddAbsencePageState createState() => _AddAbsencePageState();
}

class _AddAbsencePageState extends State<AddAbsencePage>
    with SingleTickerProviderStateMixin {
  List<String> absenceReasons = [
    'Choroba',
    'Sprawy rodzinne',
    'Nagły wypadek',
    'Inne',
  ];

  String pickedReason;
  DateTimeRange absenceRange;

  // void submitAbsence(BuildContext context) {
  //   //Error check
  //   String errors = '';
  //   if (pickedReason == null) {
  //     errors += '\n> Wybierz powód';
  //   }
  //   if (pickedReason == 'Inne' && _additionalInfoController.text == "") {
  //     errors += "\n> Powód 'Inne' wymaga podania dodatkowych informacji";
  //   }
  //   if (_startDate == null) {
  //     errors += '\n> Podaj datę rozpoczęcia';
  //   }
  //   if (_endDate == null) {
  //     errors += '\n> Podaj datę zakończenia';
  //   }
  //   // -----
  //   if (errors == '') {
  //     Navigator.of(context).pop(Absence(
  //         startDate: _startDate,
  //         endDate: _endDate,
  //         additionalInfo: _additionalInfoController.text,
  //         reason: pickedReason));
  //   } else {
  //     errors = "Twój formularz zawiera błędy\n" + errors;
  //     Scaffold.of(context).showSnackBar(SnackBar(content: Text(errors)));
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zgłoś nieobecność'),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: ReasonDropdown(
                  dropdownValue: pickedReason,
                  setDropdownValue: (value) {
                    setState(() {
                      pickedReason = value;
                    });
                  },
                  reasons: absenceReasons),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: TextField(
                // controller: _additionalInfoController,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'Informacje dodatkowe',
                    border: InputBorder.none,
                    fillColor: Palette.secondary,
                    filled: true),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: RaisedButton(
                onPressed: () async {
                  DateTimeRange range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)));
                  if (range != null) {
                    setState(() {
                      absenceRange = range;
                    });
                  }
                },
                child: Text(
                  '${formatDate(absenceRange.start)} - ${formatDate(absenceRange.end)}',
                  style: TextStyle(color: Colors.white),
                ),
                color: Palette.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
