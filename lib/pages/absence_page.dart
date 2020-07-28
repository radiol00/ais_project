import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/widgets/reason_dropdown.dart';
import 'package:flutter/material.dart';

class AbsencePage extends StatefulWidget {
  final String email;
  AbsencePage({this.email});
  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  String reason;
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zgłoś nieobecność'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              ReasonDropdown(
                dropdownValue: reason,
                setDropdownValue: (value) {
                  setState(() {
                    reason = value;
                  });
                },
              ),
              RaisedButton(
                color: Palette.buttons,
                onPressed: () async {
                  final value = await showDatePicker(
                    context: context,
                    locale: Locale('pl', "PL"),
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
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
                      _dateTime = value;
                    });
                  }
                },
                child: Text(
                  _dateTime == null ? 'Wybierz datę' : _dateTime.toString(),
                  style: TextStyle(color: Colors.grey[300]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
