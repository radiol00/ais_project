import 'dart:async';

import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/models/break_model.dart';
import 'package:ais_project/pages/break_page.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ais_project/pages/absence_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Stan który będzie wykorzystywany do przypisywania zgłoszenia do użytkownika
  String email;

  // Strumień kontrolujący asynchroniczną funkcję pobierającą dane z SharedPreferences
  StreamController _streamController;

  // Kontroler ustawiający wartość w polu po pobraniu jej z SharedPreferences
  TextEditingController _textEditingController;

  // Manipulacja skupienia po przyciśnięciu przycisku edytuj lub klikniecia w przycisk bez podawania maila
  FocusNode _inputFocusNode;

  void getEmailFromPreferences() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final aisEmail = preferences.getString('ais_email');
      if (aisEmail == null) {
        _streamController.sink.addError(Error());
      } else {
        _textEditingController.text = aisEmail;
        _streamController.sink.add(aisEmail);
        setState(() {
          email = aisEmail;
        });
      }
    } catch (e) {
      _streamController.sink.addError(Error());
    }
  }

  void onEmailSubmission(value) async {
    if (email != null && value == "") {
      // Jeśli użytkownik usunie value z input'a to usuwam rekord z SharedPreferences
      final preferences = await SharedPreferences.getInstance();
      preferences.remove('ais_email');
      _streamController.addError(Error());
      setState(() {
        email = null;
      });
    } else if (EmailValidator.validate(value)) {
      // Walidacja maila
      final preferences = await SharedPreferences.getInstance();
      preferences.setString('ais_email', value);
      _streamController.sink.add(value);
      setState(() {
        email = value;
      });
    } else {
      // Wyświetl błąd w snackbarze i zresetuj focus z powrotem na textinput
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Podano niepoprawny email')));
      _inputFocusNode.requestFocus();
    }
  }

  void addNewAbsence(Absence absence, BuildContext context) {
    // Tu będzie połaczenie z bazą
    // Zapewne funkcja będzie musiała być asynchroniczna
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Nowe zgłoszenie')));
    print(email);
    print(absence.toString());
  }

  void addNewBreak(Break breakObject, BuildContext context) {
    // Tu będzie połaczenie z bazą
    // Zapewne funkcja będzie musiała być asynchroniczna
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Nowe zgłoszenie')));
    print(email);
    print(breakObject.toString());
  }

  @override
  void initState() {
    _inputFocusNode = FocusNode();
    _streamController = StreamController();
    getEmailFromPreferences();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/ais_logo.png',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _inputFocusNode,
                          onSubmitted: onEmailSubmission,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              hintText: snapshot.hasData
                                  ? snapshot.data
                                  : 'Podaj email',
                              contentPadding: EdgeInsets.zero,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.buttons)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      ...(snapshot.hasData || snapshot.hasError
                          ? [
                              // Jeśli snapshot posiada dane lub błąd (sygnalizujący brak rekordu w SharedPreferences)
                              IconButton(
                                splashRadius: 20.0,
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _inputFocusNode.requestFocus();
                                },
                              )
                            ]
                          : [
                              // W przeciwnym razie wyświetl ładowanie
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Palette.progressIndicator),
                                  ))
                            ]),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    color: Palette.buttons,
                    child: Text(
                      'Zgłoś nieobecność',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    onPressed: () async {
                      if (email == null) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Podaj email!')));
                        return;
                      }
                      // Po kliknięciu przycisku pushujemy nowy widget z podanym przez uzytkownika mailem
                      dynamic absence =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AbsencePage(),
                      ));
                      if (absence != null) {
                        addNewAbsence(absence, context);
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    color: Palette.buttons,
                    child: Text(
                      'Zgłoś przerwę w pracy',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    onPressed: () async {
                      if (email == null) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Podaj email!')));
                        return;
                      }
                      // Po kliknięciu przycisku pushujemy nowy widget z podanym przez uzytkownika mailem
                      dynamic breakObject =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BreakPage(),
                      ));

                      if (breakObject != null) {
                        addNewBreak(breakObject, context);
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
