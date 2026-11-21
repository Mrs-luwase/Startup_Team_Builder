import 'package:flutter/material.dart';

/// Every color in the app lives here, so a change happens in one place.
class AppColors {
  static const green = Color(0xFF1F5E3B);
  static const yellow = Color(0xFFFAD201);
  static const background = Color(0xFFF3F6F4);
  static const ink = Color(0xFF14211B);
  static const mint = Color(0xFFE4EFE8);
  static const fieldBorder = Color(0xFFBFC4C1);
}

ThemeData buildAppTheme() {
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c, width: w),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.green,
      primary: AppColors.green,
      secondary: AppColors.yellow,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.ink,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(AppColors.fieldBorder),
      enabledBorder: border(AppColors.fieldBorder),
      focusedBorder: border(AppColors.green, 2),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: shape,
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.green,
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.green, width: 1.5),
        minimumSize: const Size.fromHeight(52),
        shape: shape,
        textStyle: buttonText,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.green),
    ),
  );
}