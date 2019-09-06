import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/home_page.dart';
import 'theme.dart';

void main() => runApp(Vyktor());

/// The root widget of Vyktor.
class Vyktor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Set the status bar color.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: vyktorTheme.colorScheme.primaryVariant,
      statusBarColor: vyktorTheme.colorScheme.primaryVariant,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Vyktor',
      theme: vyktorTheme,
      home: HomePage(),
    );
  }
}
