import 'package:fan_floating_menu/fan_floating_menu.dart';
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
    const AccueilInnerPage(),
    Container(),
    Container(),
    const ProfilInnerPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: pageActuelle == 3
          ? Transform.translate(
              offset: Offset(20, 70),
              child: Transform.scale(
                scale: .8,
                child: FanFloatingMenu(
                    toggleButtonColor: Palette.blue,
                    fanMenuDirection: FanMenuDirection.rtl,
                    menuItems: [
                      FanMenuItem(
                          menuItemIconColor: Palette.blue,
                          onTap: () => null,
                          icon: Icons.pin_drop,
                          title: "Ajouter une adresse"),
                      FanMenuItem(
                          menuItemIconColor: Palette.blue,
                          onTap: () => null,
                          icon: Icons.work,
                          title: "Ajouter un service"),
                    ]),
              ),
            )
          : null,
      appBar: pageActuelle != 3
          ? AccueilAppBar(
              callBack: () => setState(() {
                    pageActuelle = 3;
                  }))
          : AppBar(
              title: const Text("Votre profil"),
            ),
      body: SingleChildScrollView(
          child: Builder(builder: (context) => pages[pageActuelle])),
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
