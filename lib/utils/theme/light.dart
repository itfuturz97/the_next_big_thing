import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static MaterialColor createPrimarySwatch() {
    return MaterialColor(0xFF2C1810, {
      100: Color(0xFFFDF6E8),
      200: Color(0xFFFBEDD1),
      300: Color(0xFFF9E4BA),
      400: Color(0xFFF7DBA3),
      500: Color(0xFF2C1810),
      600: Color(0xFF8B4513),
      700: Color(0xFF2C1810),
      800: Color(0xFF1A0F08),
      900: Color(0xFF0F0804),
    });
  }

  static ThemeData getThemeByIndex(BuildContext context) {
    return _logoBasedTheme(context);
  }

  static const _logoBasedColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2C1810),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFDF6E8),
    onPrimaryContainer: Color(0xFF2C1810),
    secondary: Color(0xFFF4C430),
    onSecondary: Color(0xFF2C1810),
    secondaryContainer: Color(0xFFFDF9E8),
    onSecondaryContainer: Color(0xFF8B4513),
    tertiary: Color(0xFF8B4513),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF5E6D3),
    onTertiaryContainer: Color(0xFF3C1810),
    error: Color(0xFFDC3545),
    errorContainer: Color(0xFFFDEDED),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF5A1A1A),
    surface: Color(0xFFFFFAF5),
    onSurface: Color(0xFF2C1810),
    surfaceContainer: Color(0xFFFBF5ED),
    surfaceContainerHighest: Color(0xFFF7EFDF),
    onSurfaceVariant: Color(0xFF6B4423),
    outline: Color(0xFFC4A484),
    onInverseSurface: Color(0xFFFDF6E8),
    inverseSurface: Color(0xFF2C1810),
    inversePrimary: Color(0xFFF4C430),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF2C1810),
    outlineVariant: Color(0xFFE6D4C0),
    scrim: Color(0xFF000000),
  );

  static ThemeData _logoBasedTheme(BuildContext context) => _buildTheme(_logoBasedColorScheme, context);

  static ThemeData _buildTheme(ColorScheme colorScheme, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface),
      cardTheme: cardTheme(colorScheme),
      appBarTheme: appBarTheme(colorScheme),
      dialogTheme: dialogTheme(colorScheme),
      elevatedButtonTheme: elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: outlinedButtonTheme(colorScheme),
      textButtonTheme: textButtonTheme(colorScheme),
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      iconTheme: iconTheme(colorScheme),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        textTheme: CupertinoTextThemeData(textStyle: GoogleFonts.poppins(color: colorScheme.onSurface)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 8,
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: colorScheme.secondary.withOpacity(0.12),
      highlightColor: colorScheme.secondary.withOpacity(0.08),
    );
  }

  static CardThemeData cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 4,
      color: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: colorScheme.secondary.withOpacity(0.05),
      shadowColor: colorScheme.shadow.withOpacity(0.15),
    );
  }

  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
      scrolledUnderElevation: 2,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.primary,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.secondary.withOpacity(0.05),
      iconTheme: IconThemeData(color: colorScheme.primary),
      titleTextStyle: GoogleFonts.poppins(fontSize: 22, letterSpacing: 0.5, fontWeight: FontWeight.w700, color: colorScheme.primary),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static DialogThemeData dialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      elevation: 8,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.secondary.withOpacity(0.05),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.3),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.secondary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      labelStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
      hintStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static IconThemeData iconTheme(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.onSurface, size: 24);
  }

  static Color get logoGolden => const Color(0xFFF4C430);
  static Color get logoDarkBrown => const Color(0xFF2C1810);
  static Color get logoWarmCream => const Color(0xFFFDF6E8);
  static LinearGradient get logoGradient => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [logoGolden.withOpacity(0.1), logoWarmCream]);
}
