import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/innerpages/accueil_inner_page.dart';
import 'package:servy_app/pages/innerpages/profil_inner_page.dart';
import '../components/appbars/accueil_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageActuelle = 0;
  final pages = [
    Container(),
    Container(),
    const ProfilInnerPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: pageActuelle == 3
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed("/creerService"),
              child: const Icon(Icons.add),
            )
          : null,
      appBar: pageActuelle != 3
          ? AccueilAppBar(
              showSearch: pageActuelle == 1,
              callBack: () => setState(() {
                    pageActuelle = 2;
                  }))
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
        return pages[pageActuelle - 1];
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
