import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TTextTheme{
  TTextTheme._();

  // Cooper-style Typography: Poppins for headings (Medium/SemiBold), Poppins Regular for body
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,  // Bold for large headings
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,  // SemiBold
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    headlineSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,  // SemiBold
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),

    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,  // SemiBold
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,  // Medium
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,  // Medium
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),

    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,  // Regular
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,  // Regular
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,  // Regular
      color: TColors.textSecondary,
      fontFamily: 'Poppins',
    ),

    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,  // Medium for buttons
      color: TColors.textPrimary,
      fontFamily: 'Poppins',
    ),
    labelMedium: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textSecondary,
      fontFamily: 'Poppins',
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    headlineSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),

    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),

    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textWhite.withOpacity(0.7),
      fontFamily: 'Poppins',
    ),

    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.textWhite,
      fontFamily: 'Poppins',
    ),
    labelMedium: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textWhite.withOpacity(0.7),
      fontFamily: 'Poppins',
    ),
  );
}
