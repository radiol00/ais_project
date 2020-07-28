import 'package:flutter/material.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/* RootWidget 
 * buduje MaterialApp, Scaffold z AppBar'em i HomePage
 * 
 * Kolory widget'ów są importowane z abstrakcyjnej klasy Palette(styling/palette.dart)
 */

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pl')],
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.scaffoldBackground,
        appBarTheme: AppBarTheme(color: Palette.appbar),
        canvasColor: Palette.secondary, // Kolor na dropdownbutton
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: HomePage(),
      ),
    );
  }
}
