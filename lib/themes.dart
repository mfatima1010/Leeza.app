import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColor.primary,
    primary: AppColor.primary,
    secondary: AppColor.secondary,
    surface: AppColor.white,
    background: AppColor.lightGrey,
    error: Colors.red,
    onPrimary: AppColor.white,
    onSecondary: AppColor.white,
    onSurface: AppColor.black,
    onBackground: AppColor.black,
    onError: AppColor.white,
    brightness: Brightness.light,
  ),
  fontFamily: GoogleFonts.poppins().fontFamily,
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.light().textTheme,
  ).copyWith(
    displayLarge:
        AppTextStyles.s30(color: AppColor.black, fontType: FontType.BOLD),
    displayMedium:
        AppTextStyles.s24(color: AppColor.black, fontType: FontType.MEDIUM),
    headlineLarge:
        AppTextStyles.s20(color: AppColor.black, fontType: FontType.REGULAR),
    bodyLarge: AppTextStyles.s16(
        color: AppColor.textDarkGrey, fontType: FontType.REGULAR),
    bodyMedium:
        AppTextStyles.s14(color: AppColor.textGrey, fontType: FontType.REGULAR),
    labelLarge:
        AppTextStyles.s16(color: AppColor.white, fontType: FontType.MEDIUM),
    bodySmall:
        AppTextStyles.s12(color: AppColor.textGrey, fontType: FontType.REGULAR),
    titleMedium:
        AppTextStyles.s18(color: AppColor.black, fontType: FontType.MEDIUM),
    headlineSmall:
        AppTextStyles.s16(color: AppColor.black, fontType: FontType.REGULAR),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(203, 108, 230, 1),
      textStyle:
          AppTextStyles.s16(color: AppColor.white, fontType: FontType.MEDIUM),
    ),
  ),
);
