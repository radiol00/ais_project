import 'package:flutter/material.dart';

// Paleta barw wykorzystywana w aplikacji
abstract class Palette {
  static final scaffoldBackground = Color.fromRGBO(221, 221, 221, 1);
  static final progressIndicator = Color.fromRGBO(99, 91, 85, 1);
  static final secondary = Color.fromRGBO(166, 166, 166, 1);
  static final buttons = Color.fromRGBO(219, 87, 53, 1);
  static final aisred = Color.fromRGBO(232, 122, 91, 1);
  static final appbar = Color.fromRGBO(232, 122, 91, 1);
  static final accentColor = Color.fromRGBO(219, 87, 53, 1);
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
