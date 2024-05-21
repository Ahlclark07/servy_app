import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servy_app/components/forms/custom_text_field.dart';
import 'package:servy_app/utils/servy_backend.dart';

import '../components/buttons/ask_for_file_button.dart';

class PageDevenirVendeur extends StatefulWidget {
  const PageDevenirVendeur({super.key});

  @override
  State<PageDevenirVendeur> createState() => _PageDevenirVendeurState();
}

class _PageDevenirVendeurState extends State<PageDevenirVendeur> {
  final TextEditingController professionController = TextEditingController();

  late final File photoDeProfil;

  late final File carteId;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: screenSize.width,
          height: screenSize.height,
          child: FormBuilder(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Remplissez les infos nécessaires",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    labelTitle: "Votre profession",
                    labelText: "Menusier...",
                    controller: professionController,
                    name: "profession",
                    icon: Icons.precision_manufacturing),
                const SizedBox(
                  height: 20,
                ),
                AskForFile(
                  nom: "photo de profil",
                  callback: (e) => setState(() {
                    photoDeProfil = e;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                AskForFile(
                  nom: "Carte d'identité",
                  callback: (e) => setState(() {
                    carteId = e;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final message = await ServyBackend().becomeSeller(
                        profession: professionController.text,
                        photo: photoDeProfil,
                        carte: carteId);
                    String texte;
                    if (message == ServyBackend.success) {
                      Navigator.of(context).popAndPushNamed("/main");
                      texte =
                          "Votre demande a été soumise et est en cours d'approbation";
                    } else {
                      texte = message;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(texte),
                      ),
                    );
                  },
                  child: SizedBox(
                      width: screenSize.width - 60,
                      child: const Text(
                        "Soumettre la demande",
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
