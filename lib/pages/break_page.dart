import 'package:ais_project/helpers/time_formatter.dart';
import 'package:ais_project/models/break_model.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/widgets/reason_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

class BreakPage extends StatefulWidget {
  @override
  _BreakPageState createState() => _BreakPageState();
}

class _BreakPageState extends State<BreakPage> {
  String reason;
  TextEditingController _additionalInfoController;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  List<String> breakReasons = [
    'Przerwa śniadaniowa',
    'Skorzystanie z toalety',
    'Nagły przypadek',
    'Inne',
  ];

  // Podaję context z Buildera w body Scaffoldu, żeby wyświetlić snackbar z funckji onPressed RaisedButtona
  void submitBreak(BuildContext context) {
    //Error check
    String errors = '';
    if (reason == null) {
      errors += '\n> Wybierz powód';
    }
    if (reason == 'Inne' && _additionalInfoController.text == "") {
      errors += "\n> Powód 'Inne' wymaga podania dodatkowych informacji";
    }
    if (_startTime == null || _endTime == null) {
      errors += '\n> Wybierz przedział czasowy';
    }

    // -----
    if (errors == '') {
      Navigator.of(context).pop(Break(
          startTime: _startTime,
          endTime: _endTime,
          additionalInfo: _additionalInfoController.text,
          reason: reason));
    } else {
      errors = "Twój formularz zawiera błędy\n" + errors;
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errors)));
    }
  }

  @override
  void initState() {
    _additionalInfoController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zgłoś przerwę w pracy'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ReasonDropdown(
                  reasons: breakReasons,
                  dropdownValue: reason,
                  setDropdownValue: (value) {
                    setState(() {
                      reason = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text(
                          _startTime == null || _endTime == null
                              ? 'Wybierz przedział czasowy'
                              : formatTime(_startTime) +
                                  ' - ' +
                                  formatTime(_endTime),
                          style:
                              TextStyle(color: Colors.grey[300], fontSize: 25),
                        ),
                        color: Palette.buttons,
                        onPressed: () async {
                          dynamic time = await showTimeRangePicker(
                            // Dodawanie 2 godzin ze względu na strefę czasową, w przyszłości zaimplementować strefy czasowe
                            context: context,
                            disabledTime: TimeRange(
                                startTime: TimeOfDay(hour: 23, minute: 55),
                                endTime: TimeOfDay.fromDateTime(
                                    DateTime.now().add(Duration(hours: 2)))),
                            snap: true,
                            interval: Duration(minutes: 5),
                            start: TimeOfDay.fromDateTime(
                                DateTime.now().add(Duration(hours: 2))),
                            end: TimeOfDay.fromDateTime(DateTime.now()
                                .add(Duration(hours: 2, minutes: 15))),
                            fromText: 'Od',
                            toText: 'Do',
                            backgroundColor: Palette.secondary,
                            handlerColor: Palette.appbar,
                            selectedColor: Palette.appbar,
                            strokeColor: Palette.appbar,
                          );

                          if (time != null) {
                            setState(() {
                              _startTime = time.startTime;
                              _endTime = time.endTime;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                  onPressed: () => submitBreak(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
