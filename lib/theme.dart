import 'package:flutter/material.dart';

/// The [ThemeData] used to build the various widgets in Vyktor.
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

/// Vyktor's [ColorScheme].
final vyktorColorScheme = ColorScheme(
  background: primary,
  brightness: Brightness.dark,
  error: Colors.red[900],
  onBackground: Colors.white,
  onError: Colors.white,
  onPrimary: Colors.white,
  onSecondary: darkerPrimary,
  onSurface: Colors.white,
  primary: primary,
  primaryVariant: darkerPrimary,
  secondary: secondary,
  secondaryVariant: darkerSecondary,
  surface: darkerSecondary,
);


const darkerPrimary = MaterialColor(
  0xFF303A52,
  <int, Color> {
    50: Color(0xFF303A52),
    100: Color(0xFF303A52),
    200: Color(0xFF303A52),
    300: Color(0xFF303A52),
    400: Color(0xFF303A52),
    500: Color(0xFF303A52),
    600: Color(0xFF303A52),
    700: Color(0xFF303A52),
    800: Color(0xFF303A52),
    900: Color(0xFF303A52),
  }
);

const primary = MaterialColor(
    0xFF574B90,
    <int, Color> {
      50: Color(0xFF574B90),
      100: Color(0xFF574B90),
      200: Color(0xFF574B90),
      300: Color(0xFF574B90),
      400: Color(0xFF574B90),
      500: Color(0xFF574B90),
      600: Color(0xFF574B90),
      700: Color(0xFF574B90),
      800: Color(0xFF574B90),
      900: Color(0xFF574B90),
    }
);

const darkerSecondary = MaterialColor(
    0xFF9E579D,
    <int, Color> {
      50: Color(0xFF9E579D),
      100: Color(0xFF9E579D),
      200: Color(0xFF9E579D),
      300: Color(0xFF9E579D),
      400: Color(0xFF9E579D),
      500: Color(0xFF9E579D),
      600: Color(0xFF9E579D),
      700: Color(0xFF9E579D),
      800: Color(0xFF9E579D),
      900: Color(0xFF9E579D),
    }
);

const secondary = MaterialColor(
    0xFFFC85AE,
    <int, Color> {
      50: Color(0xFFFC85AE),
      100: Color(0xFFFC85AE),
      200: Color(0xFFFC85AE),
      300: Color(0xFFFC85AE),
      400: Color(0xFFFC85AE),
      500: Color(0xFFFC85AE),
      600: Color(0xFFFC85AE),
      700: Color(0xFFFC85AE),
      800: Color(0xFFFC85AE),
      900: Color(0xFFFC85AE),
    }
);

/// Vyktor's [TextTheme].
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
    fontFamily: 'Computer Modern Concrete',
    fontSize: 12,
    fontWeight: FontWeight.bold,
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
    fontFamily: 'Computer Modern Concrete',
    fontSize: 16,
    fontWeight: FontWeight.w300,
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