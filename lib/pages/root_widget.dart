import 'package:flutter/material.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/pages/home_page.dart';

/* RootWidget 
 * builds MaterialApp, Scaffold with AppBar and HomePage
 * 
 * Colors of widgets are imported from abstract class Palette (styling/palette.dart)
 */

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Palette.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Palette.appbar,
        ),
        body: HomePage(),
      ),
    );
  }
}
