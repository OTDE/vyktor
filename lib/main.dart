import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
import 'theme.dart';

void main() => runApp(Vyktor());

/// The base widget of Vyktor.
class Vyktor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: vyktorColorScheme.primaryVariant,
      statusBarColor: vyktorColorScheme.primaryVariant,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Vyktor',
      theme: vyktorTheme,
      home: HomePage(),
    );
  }
}
