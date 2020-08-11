import 'package:ais_project/formatters/time_formatter.dart';
import 'package:ais_project/models/break_model.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/widgets/reason_dropdown.dart';
import 'package:flutter/material.dart';

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
    AppBar appBar = AppBar(
      title: Text('Zgłoś przerwę w pracy'),
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: Builder(
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    50,
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
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 25),
                            ),
                            color: Palette.buttons,
                            onPressed: () async {},
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
        ),
      ),
    );
  }
}
