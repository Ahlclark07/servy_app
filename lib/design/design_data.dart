import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static Color primary = Colors.black;
  static Color background = Colors.white;
  static Color blue = Color(0xFF0009E5);
  static Color cendre = Colors.grey;
  static Color inputBackground = Color(0xFFF1F1F1);
}

class Design {
  static InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      iconColor: Palette.blue,
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0));
  static ThemeData themeData = ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  // Ajoute un clignotement blanc lorsque le bouton est pressé
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white
                        .withOpacity(0.4); // Opacité du clignotement
                  }
                  return Palette.blue;
                },
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, //
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide(color: Palette.primary, width: 0),
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajuste le rayon pour obtenir des bords légèrement arrondis
                ),
              ),
              foregroundColor:
                  MaterialStatePropertyAll<Color>(Palette.background),
              backgroundColor: MaterialStatePropertyAll<Color>(Palette.blue))),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Palette.cendre, border: InputBorder.none),
      primaryColor: Palette.primary,
      textTheme: GoogleFonts.montserratTextTheme()
          .apply(displayColor: Palette.blue, bodyColor: Palette.primary),
      appBarTheme:
          AppBarTheme(backgroundColor: Palette.background, elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Palette.blue, foregroundColor: Palette.background),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide(color: Palette.primary, width: 6),
                  borderRadius: BorderRadius.circular(
                      10.0), // Ajuste le rayon pour obtenir des bords légèrement arrondis
                ),
              ),
              padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.all(17)),
              backgroundColor: MaterialStatePropertyAll<Color>(Palette.primary),
              foregroundColor:
                  MaterialStatePropertyAll<Color>(Palette.background))));
}
