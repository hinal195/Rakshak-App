import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TElevatedButtonTheme{
  TElevatedButtonTheme._();

  // Cooper-style buttons: Rounded (20px), soft shadows, pastel gradients
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.textWhite,
      backgroundColor: TColors.softTeal,
      disabledForegroundColor: TColors.grey,
      disabledBackgroundColor: TColors.lightGrey,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),  // More rounded (20px)
      ),
      shadowColor: TColors.softTeal.withOpacity(0.3),
    )
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.textWhite,
      backgroundColor: TColors.softTeal,
      disabledForegroundColor: TColors.grey,
      disabledBackgroundColor: TColors.lightGrey,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: TColors.softTeal.withOpacity(0.3),
    )
  );
}

