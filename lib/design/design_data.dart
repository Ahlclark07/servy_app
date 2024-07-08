import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static Color primary = Colors.black;
  static Color background = Colors.white;
  static Color blue = const Color(0xFF6249ce);
  static Color cendre = Colors.grey;
  static Color inputBackground = const Color(0xFFF1F1F1);
}

class Design {
  static InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      iconColor: Palette.blue,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0));
  static ThemeData themeData = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Palette.background, selectedItemColor: Palette.blue),
      scaffoldBackgroundColor: Palette.background,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Palette.blue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  // Ajoute un clignotement blanc lorsque le bouton est pressé
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.white
                        .withOpacity(0.4); // Opacité du clignotement
                  }
                  return Palette.blue;
                },
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, //
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide(color: Palette.primary, width: 0),
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajuste le rayon pour obtenir des bords légèrement arrondis
                ),
              ),
              foregroundColor:
                  WidgetStatePropertyAll<Color>(Palette.background),
              backgroundColor: WidgetStatePropertyAll<Color>(Palette.blue))),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Palette.cendre, border: InputBorder.none),
      primaryColor: Palette.primary,
      textTheme: GoogleFonts.openSansTextTheme()
          .apply(displayColor: Palette.blue, bodyColor: Palette.primary),
      appBarTheme:
          AppBarTheme(backgroundColor: Palette.background, elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Palette.blue, foregroundColor: Palette.background),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide(color: Palette.primary, width: 6),
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajuste le rayon pour obtenir des bords légèrement arrondis
                ),
              ),
              padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.all(17)),
              backgroundColor: WidgetStatePropertyAll<Color>(Palette.primary),
              foregroundColor:
                  WidgetStatePropertyAll<Color>(Palette.background))));
}
