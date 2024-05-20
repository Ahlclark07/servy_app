import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:servy_app/components/buttons/ask_for_file_button.dart';
import 'package:servy_app/components/forms/custom_text_field.dart';
import 'package:servy_app/utils/servy_backend.dart';

class MateriauForm extends StatefulWidget {
  final String id;
  final Function(String s) callback;

  const MateriauForm({super.key, this.id = "", required this.callback});

  @override
  State<MateriauForm> createState() => _MateriauFormState();
}

class _MateriauFormState extends State<MateriauForm> {
  bool enModif = true;
  String id = "";
  TextEditingController prixController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  late final File photo;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: enModif
          ? Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: width - 140,
                      child: CustomTextField(
                          labelTitle: "Nom du matériel",
                          labelText: "Tournevis, vis cruciforme....",
                          controller: nomController,
                          name: "nom",
                          icon: Icons.build_rounded),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            final response = await ServyBackend()
                                .createMateriel(
                                    minidesc: descController.text,
                                    photo: photo,
                                    nom: nomController.text,
                                    prix: prixController.text);

                            setState(() {
                              id = response[1];
                              enModif = false;
                            });
                            widget.callback(id);
                          } catch (e) {
                            inspect(e);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Icon(
                            Icons.check,
                          ),
                        ))
                  ],
                ),
                CustomTextField(
                    labelTitle: "Prix du matériel",
                    labelText: "Prix en FCFA",
                    isNumber: true,
                    controller: prixController,
                    name: "prix",
                    icon: Icons.money),
                CustomTextField(
                    labelTitle: "Légère description",
                    labelText: "Description",
                    controller: descController,
                    maxLines: 4,
                    name: "description",
                    icon: Icons.present_to_all_outlined),
                AskForFile(
                  callback: (f) {
                    setState(() {
                      photo = f;
                    });
                  },
                  nom: "images du matériel",
                  limit: 2,
                  hauteur: 80,
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                    child: Text(
                  nomController.text,
                  overflow: TextOverflow.clip,
                )),
                ElevatedButton(
                    onPressed: () => setState(() {
                          enModif = true;
                        }),
                    child: const Icon(Icons.mode))
              ],
            ),
    );
  }
}
