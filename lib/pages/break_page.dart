import 'package:flutter/material.dart';

class BreakPage extends StatefulWidget {
  final String email;
  BreakPage({this.email});
  @override
  _BreakPageState createState() => _BreakPageState();
}

class _BreakPageState extends State<BreakPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zgłoś przerwę w pracy'),
        centerTitle: true,
      ),
    );
  }
}
