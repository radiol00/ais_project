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
      theme: ThemeData(
          scaffoldBackgroundColor: Palette.scaffoldBackground,
          appBarTheme: AppBarTheme(color: Palette.appbar)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: HomePage(),
      ),
    );
  }
}
