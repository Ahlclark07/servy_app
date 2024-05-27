import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servy_app/pages/innerpages/accueil_inner_page.dart';
import 'package:servy_app/pages/innerpages/chat_inner_page.dart';
import 'package:servy_app/pages/innerpages/profil_inner_page.dart';
import 'package:servy_app/pages/innerpages/recherche_inner_page.dart';
import 'package:servy_app/utils/servy_backend.dart';
import 'package:shake/shake.dart';
// import 'package:shake_gesture/shake_gesture.dart';
import '../components/appbars/accueil_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageActuelle = 0;
  final pages = [
    const ChatInnerPage(),
    const ProfilInnerPage(),
  ];
  late ValueNotifier<String> queryNotifier;

  @override
  void initState() {
    super.initState();

    queryNotifier = ValueNotifier<String>('');
  }

  @override
  void dispose() {
    queryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      ShakeDetector.autoStart(onPhoneShake: () {
        inspect("ca secoue ooh");
      });
    } on MissingPluginException catch (e) {
      inspect(e);
    } catch (e) {
      inspect(e);
    }
    return Scaffold(
      floatingActionButton: pageActuelle == 3 &&
              ServyBackend().user["role"] != "client"
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed("/creerService"),
              child: const Icon(Icons.add),
            )
          : null,
      appBar: pageActuelle != 3
          ? AccueilAppBar(
              showSearch: pageActuelle == 1,
              callBack: () {
                setState(() {
                  pageActuelle = 2;
                });
              },
              queryNotifier: queryNotifier,
            )
          : AppBar(
              scrolledUnderElevation: 0,
              title: const Text("Votre profil"),
            ),
      body: SingleChildScrollView(child: Builder(builder: (context) {
        if (pageActuelle == 0) {
          return AccueilInnerPage(
            callback: () => setState(() {
              pageActuelle = 1;
            }),
          );
        }
        if (pageActuelle == 1) {
          return InnerPageRecherche(query: queryNotifier);
        }
        return pages[pageActuelle - 2];
      })),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageActuelle,
        onTap: (value) => setState(() {
          pageActuelle = value;
        }),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Rechercher"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
