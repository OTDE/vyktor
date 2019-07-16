import 'package:flutter/material.dart';
import 'package:vyktor/pages/home_page.dart';

void main() => runApp(Vyktor());

/// TODO: Implement splash screen.
class Vyktor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyktor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Testing Basic Widget Structure'),
    );
  }

}


