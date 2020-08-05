import 'package:ais_project/pages/hello_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:ais_project/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ais_project/pages/auth_gate.dart';

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
      // locale: DevicePreview.of(context).locale,
      // builder: DevicePreview.appBuilder,
      supportedLocales: [const Locale('pl')],
      theme: ThemeData(
        accentColor: Palette.accentColor,
        scaffoldBackgroundColor: Palette.scaffoldBackground,
        appBarTheme: AppBarTheme(color: Palette.appbar),
        canvasColor: Palette.secondary, // Kolor na dropdownbutton
        // platform: TargetPlatform.iOS,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: AuthGate(
          notAuthChild: HelloPage(),
          authChild: HomePage(),
        ),
      ),
    );
  }
}
