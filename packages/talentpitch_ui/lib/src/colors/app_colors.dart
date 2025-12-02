import 'package:flutter/material.dart';

/// Defines the color palette for the App UI Kit.
abstract class AppColors {
  /// primary
  static const Color primary = Color(0xFFde1c7e);

  /// White
  static const Color white = Color(0xFFFCFDFD);

  /// Black
  static const Color black = Color(0xFF282727);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// The grey primary color and swatch.

  static const Color grey = Color(0x33939AAA);

  static const Color primaryMain = Color(0xFF0056D2);
  static const MaterialColor secondary = MaterialColor(
    0xFF4F8BFF,
    <int, Color>{
      300: Color(0xFF4F8BFF),
    },
  );
  static const MaterialColor secondaryDark = MaterialColor(
    0xFF133C55,
    <int, Color>{
      50: Color(0xFFF6F8FD),
      100: Color(0xFFB3D0E0),
      200: Color(0xFF80B5CE),
      300: Color(0xFF4D9ABD),
      400: Color(0xFF2680AD),
      500: Color(0xFF133C55),
      600: Color(0xFF0F354C),
      700: Color(0xFF0A2C41),
      800: Color(0xFF062336),
      900: Color(0xFF00171A),
    },
  );

  static const MaterialColor redyMain = MaterialColor(
    0xFFFF4860,
    <int, Color>{
      50: Color(0xFFFFE6E9),
      100: Color(0xFFFFBDC3),
      200: Color(0xFFFF8F9B),
      300: Color(0xFFFF6174),
      400: Color(0xFFFF4860),
      500: Color(0xFFFF304C),
      600: Color(0xFFE62A46),
      700: Color(0xFFCC2440),
      800: Color(0xFFB21D3A),
      900: Color(0xFF8A132F),
    },
  );

  static const Color whiteTechnical = Color(0xFFF5F8FF);
  static const Color whitePure = Color(0xFFFFFFFF);

  /// Error
  static const Color error = Color(0XFFFF5555);
  // GRAY
  static const Color gray100 = Color(0xFF748A9D);
  static const Color gray80 = Color(0xFF9FB2C2);
  static const Color gray50 = Color(0xFFD3DDE6);
}
