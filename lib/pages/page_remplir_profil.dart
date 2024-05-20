import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servy_app/components/buttons/ask_for_localisation_button.dart';
import 'package:servy_app/components/forms/customDateField.dart';
import 'package:servy_app/components/forms/customSelectField.dart';

import 'package:servy_app/utils/servy_backend.dart';
import '../components/forms/custom_text_field.dart';

class PageRemplirProfil extends StatefulWidget {
  const PageRemplirProfil({super.key});

  @override
  State<PageRemplirProfil> createState() => _PageRemplirProfilState();
}

class _PageRemplirProfilState extends State<PageRemplirProfil> {
  final TextEditingController nomController = TextEditingController();

  final TextEditingController prenomController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  String departementValue = "";

  String villeValue = "";

  String quartierValue = "";

  final String language = "fr";

  late final Position currentPosition;

  set setCurrentPos(Position pos) {
    currentPosition = pos;
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final departement = ["Borgou", "Mono", "Littoral"];
    final ville = ["Lokossa", "Cotonou", "Pobè"];
    final quartier = ["Tchicomè", "Agla", "Agonvè"];
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: screenSize.width,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Remplissez votre profil public",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                CustomTextField(
                    name: "nom",
                    labelText: "Votre nom",
                    labelTitle: "Entrez votre nom de famille",
                    controller: nomController,
                    icon: Icons.person),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    name: "prenom",
                    labelText: "Votre prénom",
                    labelTitle: "Entrez votre prénom",
                    controller: prenomController,
                    icon: Icons.person),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  name: "tel",
                  labelText: "Votre numéro de téléphone",
                  labelTitle: "Entrez votre numéro",
                  controller: numeroController,
                  icon: Icons.settings_cell,
                  isNumber: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDateField(
                    name: "date",
                    labelTitle: "Entrez votre date de naissance",
                    controller: dateController,
                    icon: Icons.date_range),
                const SizedBox(
                  height: 20,
                ),
                CustomSelectField(
                    name: "departement",
                    labelText: "Departement",
                    labelTitle: "Choisissez votre département",
                    list: departement,
                    values: departement,
                    controller: (value) => setState(() {
                          departementValue = value;
                        }),
                    icon: Icons.pin_drop),
                const SizedBox(
                  height: 20,
                ),
                CustomSelectField(
                    name: "ville",
                    labelText: "Ville",
                    labelTitle: "Choisissez votre ville",
                    list: ville,
                    values: ville,
                    controller: (value) => setState(() {
                          villeValue = value;
                        }),
                    icon: Icons.pin_drop),
                const SizedBox(
                  height: 20,
                ),
                CustomSelectField(
                    name: "quartier",
                    labelText: "quartier",
                    labelTitle: "Choisissez votre quartier",
                    list: quartier,
                    values: quartier,
                    controller: ((value) => setState(() {
                          quartierValue = value;
                        })),
                    icon: Icons.pin_drop),
                const SizedBox(
                  height: 20,
                ),
                LocalisationButton(callback: ((pos) => setCurrentPos = pos)),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.isValid) {
                      final message = await ServyBackend().remplirProfil(
                          nom: nomController.value.text,
                          prenoms: prenomController.value.text,
                          departement: departementValue,
                          date: dateController.value.text,
                          ville: villeValue,
                          quartier: quartierValue,
                          pos: currentPosition,
                          telephone: numeroController.text);
                      String texte;
                      if (message == ServyBackend.success) {
                        Navigator.of(context).popAndPushNamed("/main");
                        texte = "Bienvenu ${nomController.text}";
                      } else {
                        texte = message;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(texte),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Validez tous les champs requis"),
                      ));
                    }
                  },
                  child: SizedBox(
                      width: screenSize.width - 60,
                      child: const Text(
                        "Accéder à l'application",
                        textAlign: TextAlign.center,
                      )),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
