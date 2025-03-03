import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

enum FontType { BOLD, SEMI_BOLD, MEDIUM, REGULAR, LIGHT }

class AppTextStyles {
  // Returns the corresponding font weight for a given FontType.
  static FontWeight fontWeightFor(FontType fontType) {
    switch (fontType) {
      case FontType.BOLD:
        return FontWeight.w700;
      case FontType.SEMI_BOLD:
        return FontWeight.w600;
      case FontType.MEDIUM:
        return FontWeight.w500;
      case FontType.REGULAR:
        return FontWeight.w400;
      case FontType.LIGHT:
        return FontWeight.w300;
    }
  }

  // Base method to create a TextStyle using GoogleFonts.poppins.
  static TextStyle textStyle({
    required FontType fontType,
    Color? color,
    required double size,
    bool isUnderline = false,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color ?? AppColor.black,
        fontSize: size,
        fontWeight: fontWeightFor(fontType),
        decoration:
            isUnderline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }

  // Convenience methods for common font sizes.
  static TextStyle s8({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 8);

  static TextStyle s10({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 10.5);

  static TextStyle s12({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 12);

  static TextStyle s14({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 14);

  static TextStyle s16({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 16);

  static TextStyle s18({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 18);

  static TextStyle s20({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 20);

  static TextStyle s24({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 24);

  static TextStyle s30({required Color color, required FontType fontType}) =>
      textStyle(fontType: fontType, color: color, size: 30);

  // Additional custom style method.
  static TextStyle custom({
    required Color color,
    required FontType fontType,
    required double size,
  }) =>
      textStyle(fontType: fontType, color: color, size: size);

  // Method to create a style with underline.
  static TextStyle withUnderline({
    required Color color,
    required FontType fontType,
    required double size,
  }) =>
      textStyle(
          fontType: fontType, color: color, size: size, isUnderline: true);
}
