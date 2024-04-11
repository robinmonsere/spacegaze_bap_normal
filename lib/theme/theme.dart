import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

class SpaceGazeTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: ColorConstants.accentColor,
      surface: ColorConstants.surfaceGray,
      //onSurface: ColorConstants.onSurfaceGray,
      background: ColorConstants.black,
      onBackground: ColorConstants.white,
    ),
    textTheme: GoogleFonts.robotoTextTheme()
        .apply(
          bodyColor: ColorConstants.white,
          //displayColor: ColorConstants.accentColor,
        )
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 32, // Set your desired font size here
            color: ColorConstants.white,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24, // Set your desired font size here
            color: ColorConstants.accentColor,
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: const TextStyle(
            fontSize: 14, // Set your desired font size here
            color: ColorConstants.accentColor,
          ),
          bodyMedium: const TextStyle(
            fontWeight: FontWeight.bold,
            //color: ColorConstants.accentColor
          ),
        ),
    splashColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: ColorConstants
          .accentColor, // Using the same red color for selected items
    ),
  );
}
