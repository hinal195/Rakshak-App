import 'package:flutter/material.dart';

class TColors{
  TColors._();

  // Cooper-Style Color Palette (Rakshak Safety Adaptation)
  static const Color deepIndigo = Color(0xFF3F3D8F);      // Primary: Deep Indigo #3F3D8F
  static const Color softTeal = Color(0xFF3DDAD7);        // Secondary: Soft Teal #3DDAD7
  static const Color warmIvory = Color(0xFFFFF6E9);       // Background: Warm Ivory #FFF6E9
  static const Color cardWhite = Color(0xFFFFFFFF);       // Cards: White #FFFFFF
  static const Color softCoral = Color(0xFFFF6B6B);       // SOS/Danger: Soft Coral #FF6B6B
  static const Color textPrimary = Color(0xFF2E2E2E);     // Text Primary: Dark Charcoal #2E2E2E
  static const Color textSecondary = Color(0xFF7A7A7A);   // Text Secondary: Muted Grey #7A7A7A

  // Legacy compatibility - mapping to new palette
  static const Color primaryColor = deepIndigo;
  static const Color secondary = softTeal;
  static const Color accent = softTeal;
  static const Color mintGreen = softTeal;                // Alias for compatibility
  static const Color softSand = warmIvory;                // Alias for compatibility
  static const Color sunsetOrange = softCoral;             // Alias for compatibility
  static const Color goldenAmber = Color(0xFFFFD93D);     // Updated to softer amber
  static const Color sosRed = softCoral;                   // SOS uses soft coral

  // Soft Pastel Gradients (Cooper-style)
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3F3D8F),  // Deep Indigo
      Color(0xFF5A58A8),  // Lighter Indigo
      Color(0xFF6B6AB8),  // Softer Indigo
    ],
  );

  static const Gradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3DDAD7),  // Soft Teal
      Color(0xFF5FE5E2),  // Lighter Teal
    ],
  );

  static const Gradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B6B),  // Soft Coral
      Color(0xFFFF8E8E),  // Lighter Coral
    ],
  );

  // Text Colors
  static const Color textWhite = Colors.white;
  static const Color textOnDark = Colors.white;
  static const Color textOnLight = textPrimary;

  // Background Colors
  static const Color light = warmIvory;
  static const Color dark = Color(0xFF1A1A1A);
  static const Color primaryBackground = warmIvory;
  static const Color secondaryBackground = cardWhite;

  // Container Colors
  static const Color lightContainer = warmIvory;
  static const Color darkContainer = Color(0xFF2A2A2A);
  static const Color white = cardWhite;

  // Button Colors
  static const Color buttonPrimary = softTeal;
  static const Color buttonSecondary = goldenAmber;
  static const Color buttonDanger = softCoral;
  static const Color buttonDisabled = Color(0xFFD0D0D0);

  // Status Colors
  static const Color success = softTeal;
  static const Color warning = goldenAmber;
  static const Color error = softCoral;
  static const Color info = deepIndigo;

  // Neutral Shades
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF4A4A4A);
  static const Color grey = Color(0xFF9A9A9A);
  static const Color lightGrey = Color(0xFFE8E8E8);
  static const Color borderColor = Color(0xFFE5E5E5);

  // Category Colors for News & Reports
  static const Color domesticViolence = softCoral;
  static const Color onlineHarassment = deepIndigo;
  static const Color safetyTips = softTeal;
  static const Color generalNews = goldenAmber;

  // Emergency Service Colors
  static const Color police = deepIndigo;
  static const Color hospital = softTeal;
  static const Color busStop = goldenAmber;
  static const Color pharmacy = Color(0xFFB794D3);  // Soft purple

}