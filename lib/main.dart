import 'package:flutter/material.dart';
import 'package:vyktor/pages/home_page.dart';

void main() => runApp(Vyktor());

/// The base widget of Vyktor.
/// TODO: build a separate widget for theme data.
class Vyktor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyktor',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        canvasColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}
