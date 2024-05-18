import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/devenir_vendeur.dart';
import 'package:servy_app/pages/main_page.dart';
import 'package:servy_app/pages/page_connexion.dart';
import 'package:servy_app/pages/page_creation_service.dart';
import 'package:servy_app/pages/page_inscription.dart';
import 'package:servy_app/pages/page_intro.dart';
import 'package:servy_app/pages/page_remplir_profil.dart';
import 'package:servy_app/static_test/fr.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:servy_app/utils/auth_service.dart';
import 'package:servy_app/utils/servy_backend.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ServyBackend.initialize();
  await Future.delayed(const Duration(milliseconds: 1000));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppText.titre,
      theme: Design.themeData,
      initialRoute:
          //  "/creerService",
          AuthService().currentUser != null ? "/main" : "/intro",
      routes: {
        "/intro": (context) => const PageIntro(),
        "/inscription": (context) => PageInscription(),
        "/remplirProfil": (context) => PageRemplirProfil(),
        "/connexion": (context) => PageConnexion(),
        "/mdp_oublié": (context) => Container(),
        "/page_recherche": (context) => Container(),
        "/main": (context) => const MainPage(),
        "/devenirVendeur": (context) => const PageDevenirVendeur(),
        "/creerService": (context) => const PageCreationService(),
      },
    );
  }
}
