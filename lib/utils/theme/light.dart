import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static MaterialColor createPrimarySwatch() {
    return MaterialColor(0xFF2C3E50, {
      100: Color(0xFFE8EAF0),
      200: Color(0xFFD1D6E0),
      300: Color(0xFFBAC2D0),
      400: Color(0xFFA3AEC0),
      500: Color(0xFF2C3E50),
      600: Color(0xFF34495E),
      700: Color(0xFF2C3E50),
      800: Color(0xFF1A252F),
      900: Color(0xFF0F1419),
    });
  }

  static ThemeData getThemeByIndex(BuildContext context) {
    return _classicTheme(context);
  }

  static const _classicColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2C3E50),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8EAF0),
    onPrimaryContainer: Color(0xFF0F1419),
    secondary: Color(0xFFD4AF37),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFFFDF6E3),
    onSecondaryContainer: Color(0xFF5D4E37),
    tertiary: Color(0xFF8B4513),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF5E6D3),
    onTertiaryContainer: Color(0xFF3C1810),
    error: Color(0xFFDC3545),
    errorContainer: Color(0xFFFDEDED),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF5A1A1A),
    surface: Color(0xFFFFFDF7),
    onSurface: Color(0xFF1C1B1F),
    surfaceContainer: Color(0xFFF8F6F0),
    surfaceContainerHighest: Color(0xFFF0EDE5),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    onInverseSurface: Color(0xFFF4EFF4),
    inverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF85A3C1),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF2C3E50),
    outlineVariant: Color(0xFFCAC4D0),
    scrim: Color(0xFF000000),
  );

  static ThemeData _classicTheme(BuildContext context) => _buildTheme(_classicColorScheme, context);

  static ThemeData _buildTheme(ColorScheme colorScheme, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface),
      cardTheme: cardTheme(colorScheme),
      appBarTheme: appBarTheme(colorScheme),
      dialogTheme: dialogTheme,
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
        elevation: 4,
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: colorScheme.primary.withOpacity(0.12),
      highlightColor: colorScheme.primary.withOpacity(0.08),
    );
  }

  static CardThemeData cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 2,
      color: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: colorScheme.surface,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
    );
  }

  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.primary,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.surfaceTint,
      iconTheme: IconThemeData(color: colorScheme.primary),
      titleTextStyle: GoogleFonts.poppins(fontSize: 20, letterSpacing: 0.5, fontWeight: FontWeight.w600),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static const DialogThemeData dialogTheme = DialogThemeData(
    elevation: 4,
    backgroundColor: Color(0xFFFFFDF7),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  );

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        elevation: 2,
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
      hintStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
    );
  }

  static IconThemeData iconTheme(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.onSurface, size: 24);
  }
}
