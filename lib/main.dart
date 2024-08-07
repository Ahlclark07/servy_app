import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/devenir_vendeur.dart';
import 'package:servy_app/pages/main_page.dart';
import 'package:servy_app/pages/page_connexion.dart';
import 'package:servy_app/pages/page_creation_service.dart';
import 'package:servy_app/pages/page_inscription.dart';
import 'package:servy_app/pages/page_intro.dart';
import 'package:servy_app/pages/page_remplir_profil.dart';
import 'package:servy_app/pages/page_vendeurs_proches.dart';
import 'package:servy_app/static_test/fr.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:servy_app/utils/android_5_fix.dart';
import 'package:servy_app/utils/auth_service.dart';
import 'package:servy_app/utils/servy_backend.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ServyBackend.initialize();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [Locale('fr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate
      ],
      title: AppText.titre,
      theme: Design.themeData,
      initialRoute:
          // "/intro",
          AuthService().currentUser != null ? "/main" : "/intro",
      routes: {
        "/intro": (context) => const PageIntro(),
        "/connexion": (context) => const PageConnexion(),
        "/inscription": (context) => const PageInscription(),
        "/remplirProfil": (context) => const PageRemplirProfil(),
        "/mdp_oublié": (context) => Container(),
        "/page_recherche": (context) => Container(),
        "/main": (context) => const MainPage(),
        "/vendeursProches": (context) => const PageVendeursProches(),
        "/devenirVendeur": (context) => const PageDevenirVendeur(),
        "/creerService": (context) => const PageCreationService(),
      },
    );
  }
}
