import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class IGenColorScheme {
  const IGenColorScheme._();

  static Color? _calculateONColor(Color? color) {
    if (color == null) return null;
    return color.computeLuminance() > 0.5
        ? const Color(0xff14100e)
        : const Color(0xffffece7);
  }

  static ColorScheme scheme(bool isLight, [Color? primary, Color? secondary]) {
    final primaryColor = primary ?? const Color(0xff1976D2); // Primary Blue
    final onPrimaryColor =
        _calculateONColor(primary) ?? const Color(0xffffffff);

    Color secondaryColor = secondary ?? const Color(0xff1976D2); // Primary Blue

    if (secondaryColor.computeLuminance() < 0.5) {
      if (!isLight) {
        secondaryColor = secondaryColor.blend(Colors.white, 10);
      }
    }
    final onSecondaryColor =
        _calculateONColor(secondary) ?? const Color(0xffffffff);
    return ColorScheme(
      brightness: isLight ? Brightness.light : Brightness.dark,
      primary: primaryColor,
      onPrimary: const Color(0xffffffff),
      primaryContainer: secondaryColor,
      onPrimaryContainer: onSecondaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      secondaryContainer: secondaryColor,
      onSecondaryContainer: onSecondaryColor,
      tertiary: primaryColor,
      onTertiary: onPrimaryColor,
      tertiaryContainer: const Color(0xff1976D2), // Primary Blue
      onTertiaryContainer: const Color(0xffffffff),
      error: const Color(0xffb00020), // Keep red for actual errors
      onError: const Color(0xFFFFF0F3),
      errorContainer:
          const Color(0xff1976D2), // Use Primary Blue for success/info
      onErrorContainer: Colors.white,
      surface: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF021111),
      onSurface: isLight ? const Color(0xff090909) : const Color(0xffececec),
      outline: isLight ? const Color(0xFFBDBDBD) : const Color(0xff797979),
      outlineVariant:
          isLight ? const Color(0xFF595959) : const Color(0xFF5D5D5D),
      shadow: const Color(0xff000000),
      scrim: const Color(0xff000000),
      inverseSurface:
          isLight ? const Color(0xff090808) : const Color(0xFFFFFFFF),
      onInverseSurface:
          isLight ? const Color(0xffececec) : const Color(0xff090909),
      inversePrimary: primaryColor,
      surfaceTint: isLight ? const Color(0xffffffff) : const Color(0xff000000),
    );
  }
}
