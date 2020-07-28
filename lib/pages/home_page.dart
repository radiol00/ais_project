import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Twój email',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  Icon(Icons.edit),
                ],
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
                    onPressed: () {},
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
                    onPressed: () {},
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
