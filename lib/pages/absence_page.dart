import 'package:flutter/material.dart';

class AbsencePage extends StatefulWidget {
  String email;
  AbsencePage({this.email});
  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
