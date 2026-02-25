
import 'package:flutter/material.dart';
import 'custom_theme/TChechboxTheme.dart';
import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottomSheetTheme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/outlined_buttond.dart';
import 'custom_theme/text_field_Theme.dart';
import 'custom_theme/text_theme.dart';
import '../constants/colors.dart';

class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: TColors.deepIndigo,
    scaffoldBackgroundColor: TColors.warmIvory,  // Warm ivory background
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppbarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.ligthBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlineButtonTheme,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,
    colorScheme: ColorScheme.light(
      primary: TColors.deepIndigo,
      secondary: TColors.softTeal,
      surface: TColors.warmIvory,
      error: TColors.softCoral,
      onPrimary: TColors.textWhite,
      onSecondary: TColors.textWhite,
      onSurface: TColors.textPrimary,
      onError: TColors.textWhite,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: TColors.deepIndigo,
    textTheme: TTextTheme.darkTextTheme,
    scaffoldBackgroundColor: TColors.black,
    chipTheme: TChipTheme.darkChiptheme,
    appBarTheme: TAppbarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.darkInputDecorationTheme,
    colorScheme: ColorScheme.dark(
      primary: TColors.deepIndigo,
      secondary: TColors.softTeal,
      surface: TColors.darkContainer,
      error: TColors.softCoral,
      onPrimary: TColors.textWhite,
      onSecondary: TColors.textWhite,
      onSurface: TColors.textWhite,
      onError: TColors.textWhite,
    ),
  );
}