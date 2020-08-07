import 'package:flutter/material.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ais_project/pages/auth_gate.dart';
// import 'package:device_preview/device_preview.dart';

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
        canvasColor: Palette.scaffoldBackground,
        // platform: TargetPlatform.iOS,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
