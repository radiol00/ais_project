import 'package:ais_project/formatters/date_formatter.dart';
import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/widgets/reason_dropdown.dart';
import 'package:flutter/material.dart';

class AbsencePage extends StatefulWidget {
  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  String reason;
  DateTime _startDate;
  DateTime _endDate;
  TextEditingController _additionalInfoController;

  List<String> absenceReasons = [
    'Choroba',
    'Sprawy rodzinne',
    'Nagły wypadek',
    'Inne',
  ];

  // Podaję context z Buildera w body Scaffoldu, żeby wyświetlić snackbar z funckji onPressed RaisedButtona

  Widget buildResponsiveDatePicker(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Widget> children = [
      RaisedButton(
        color: Palette.buttons,
        onPressed: () async {
          // STARTDATE DATEPICKER
          final value = await showDatePicker(
            context: context,
            locale: Locale('pl', "PL"),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: _endDate == null ? DateTime(2200) : _endDate,
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark(),
                child: child,
              );
            },
          );

          if (value != null) {
            setState(() {
              _startDate = value;
            });
          }
        },
        child: Text(
          _startDate == null ? 'Data rozpoczęcia' : formatDate(_startDate),
          style: TextStyle(color: Colors.grey[300]),
        ),
      ),
      ...(width < 348.0
          ? [Icon(Icons.keyboard_arrow_down)]
          : [Icon(Icons.chevron_right)]),
      RaisedButton(
        color: Palette.buttons,
        onPressed: () async {
          // ENDDATE DATEPICKER
          final value = await showDatePicker(
            context: context,
            locale: Locale('pl', "PL"),
            initialDate: _startDate == null ? DateTime.now() : _startDate,
            firstDate: _startDate == null ? DateTime.now() : _startDate,
            lastDate: DateTime(2200),
            builder: (context, child) {
              return Theme(
                data: ThemeData.dark(),
                child: child,
              );
            },
          );

          if (value != null) {
            setState(() {
              _endDate = value;
            });
          }
        },
        child: Text(
          _endDate == null ? 'Data zakończenia' : formatDate(_endDate),
          style: TextStyle(color: Colors.grey[300]),
        ),
      ),
    ];

    if (width < 348.0) {
      return Column(
        children: children,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  @override
  void initState() {
    _additionalInfoController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Zgłoś nieobecność'),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: Builder(
        builder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ReasonDropdown(
                        reasons: absenceReasons,
                        dropdownValue: reason,
                        setDropdownValue: (value) {
                          setState(() {
                            reason = value;
                          });
                        },
                      ),
                      // MediaQuery na horyzontalne ułożenie wybierania dat
                      buildResponsiveDatePicker(context),
                      TextField(
                        controller: _additionalInfoController,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: 'Informacje dodatkowe',
                            border: InputBorder.none,
                            fillColor: Palette.secondary,
                            filled: true),
                      ),
                      RaisedButton(
                        color: Palette.buttons,
                        child: Text(
                          'Wyślij',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                        onPressed: () => submitAbsence(context),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
