import 'package:flutter/material.dart';

class AppTokens {
  static const Color primary = Color(0xFF4C6FFF);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color background = Color(0xFF0E1221);
  static const Color surface = Color(0xFF161B2E);
  static const Color surfaceLight = Color(0xFF1F2540);
  static const Color onSurface = Colors.white;
  static const Color muted = Color(0xFF9AA4BF);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const double radiusLarge = 28;
  static const double radiusMedium = 20;
  static const double radiusSmall = 14;

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0E1221), Color(0xFF151A2F), Color(0xFF1B2040)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1B2140), Color(0xFF141A33)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
