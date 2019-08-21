import 'package:flutter/material.dart';
import 'dart:ui';

final vyktorTheme = ThemeData(
  accentColor: vyktorColorScheme.secondary,
  accentColorBrightness: Brightness.light,
  accentIconTheme: IconThemeData(
    color: vyktorColorScheme.secondary,
    opacity: 1.0,
    size: 1.0,
  ),
  backgroundColor: vyktorColorScheme.background,
  buttonTheme: ButtonThemeData(
    shape: BeveledRectangleBorder(),
  ),
  colorScheme: vyktorColorScheme,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: vyktorColorScheme.primary,
    elevation: 10.0,
    foregroundColor: vyktorColorScheme.onPrimary,
  ),
  primarySwatch: vyktorColorScheme.primary,
  primaryTextTheme: vyktorPrimaryTextTheme,
);

final vyktorColorScheme = ColorScheme(
  background: Colors.grey[300],
  brightness: Brightness.light,
  error: Colors.red[900],
  onBackground: Colors.black,
  onError: Colors.grey[200],
  onPrimary: Colors.grey[200],
  onSecondary: Colors.black,
  onSurface: Colors.grey[200],
  primary: Colors.purple,
  primaryVariant: Colors.purple[800],
  secondary: Colors.amber[400],
  secondaryVariant: Colors.amber[900],
  surface: Colors.deepPurple[400],
);

final vyktorPrimaryTextTheme = TextTheme(
  body1: TextStyle(
    color: vyktorColorScheme.onPrimary,
    fontFamily: 'Computer Modern Concrete',
    fontSize: 16,
  ),
  body2: TextStyle(
    color: vyktorColorScheme.secondary,
    fontFamily: 'Computer Modern Serif',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  button: TextStyle(
    color: vyktorColorScheme.onSurface,
    fontFamily: 'Computer Modern Concrete',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  caption: TextStyle(
    color: vyktorColorScheme.onPrimary,
    fontFamily: 'Computer Modern Serif',
    fontSize: 12,
    fontStyle: FontStyle.italic,
  ),
  display1: TextStyle(
    color: vyktorColorScheme.secondary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    shadows: [Shadow(
      color: vyktorColorScheme.secondaryVariant,
      offset: Offset.fromDirection(0.5, 1),
    )],
  ),
  display2: TextStyle(
    color: vyktorColorScheme.secondary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 36,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    shadows: [Shadow(
      color: vyktorColorScheme.secondaryVariant,
      offset: Offset.fromDirection(0.5, 1),
    )],
  ),
  display3: TextStyle(
    color: vyktorColorScheme.secondary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    shadows: <Shadow>[
      Shadow(
        color: vyktorColorScheme.secondaryVariant,
        offset: Offset.fromDirection(0.5, 2),
      ),
    ],
  ),
  display4: TextStyle(
    color: vyktorColorScheme.secondary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 72,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    shadows: [Shadow(
      color: vyktorColorScheme.secondaryVariant,
      offset: Offset.fromDirection(0.5, 1),
    )],
  ),
  headline: TextStyle(
    color: vyktorColorScheme.onPrimary,
    fontFamily: 'Computer Modern Concrete',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  overline: TextStyle(
    color: vyktorColorScheme.onPrimary,
    fontFamily: 'Computer Modern Serif',
    fontSize: 8,
    fontStyle: FontStyle.italic,
  ),
  subhead: TextStyle(
    color: vyktorColorScheme.onPrimary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
  subtitle: TextStyle(
    color: vyktorColorScheme.secondary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),
  title: TextStyle(
    color: vyktorColorScheme.onPrimary,
    fontFamily: 'Computer Modern Typewriter',
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
);