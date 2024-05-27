import 'dart:io';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:servy_app/components/buttons/ask_for_file_button.dart';
import 'package:servy_app/components/forms/customSelectField.dart';
import 'package:servy_app/components/forms/custom_text_field.dart';
import 'package:servy_app/components/forms/materiau_form.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';
import 'package:flutter_sound/flutter_sound.dart';

class PageCreationService extends StatefulWidget {
  const PageCreationService({super.key});

  @override
  State<PageCreationService> createState() => _PageCreationServiceState();
}

class _PageCreationServiceState extends State<PageCreationService> {
  int nombrePhoto = 0;
  String service = "";
  final List<File> photos = [];
  final List<String> materiels = [];
  late File audio;
  final TextEditingController tarifController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController delaiController = TextEditingController();

  final recorder = FlutterSoundRecorder();
  final _formKey = GlobalKey<FormBuilderState>();
  bool formulaireSoumis = false;
  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    // Annuler l'abonnement au flux lorsque le widget est retiré de l'arbre
    recorder.closeRecorder();
    super.dispose();
  }

  Future<void> record() async {
    await recorder.startRecorder(toFile: "audio.mp4");
  }

  Future<void> stop() async {
    audio = File("${await recorder.stopRecorder()}");
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }

    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Creation de service"),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                AsyncBuilder(
                    retain: true,
                    waiting: (context) => const CircularProgressIndicator(),
                    future: ServyBackend().getListOfServices(),
                    builder: (context, services) {
                      List<String> titres = [];
                      List<String> values = [];

                      services?.forEach((element) {
                        titres.add(element["nom"]);
                        values.add(element["_id"]);
                      });

                      return Column(
                        children: [
                          Text(
                            "Créez un service professionnel",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomSelectField(
                              labelTitle: "Services",
                              labelText: "Choisissez un service",
                              list: titres,
                              values: values,
                              controller: (val) => setState(() {
                                    service = val;
                                  }),
                              name: "services",
                              icon: Icons.work),
                          const SizedBox(
                            height: 20,
                          ),
                          AskForFile(
                              callback: (File f) => setState(() {
                                    photos.add(f);
                                  }),
                              limit: 4,
                              nom: "photos du service"),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                              labelTitle: "Tarif",
                              labelText: "Entrez le tarif en FCFA",
                              controller: tarifController,
                              name: "tarif",
                              isNumber: true,
                              icon: Icons.money),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                              labelTitle: "Delai en jours",
                              labelText:
                                  "Entrez le delai de réalisation en jour",
                              controller: delaiController,
                              name: "delai",
                              isNumber: true,
                              icon: Icons.timelapse),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                              labelTitle: "Description du service",
                              labelText: "Entrez la description du service",
                              maxLines: 7,
                              controller: descController,
                              name: "delai",
                              icon: Icons.timelapse),
                          const SizedBox(
                            height: 20,
                          ),
                          AsyncBuilder(
                              initial: null,
                              stream: recorder.onProgress,
                              builder: (context, value) {
                                return ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        if (recorder.isRecording) {
                                          await stop();
                                          await recorder.getRecordURL(
                                              path: "audio");
                                        } else {
                                          await record();
                                        }
                                      } catch (e) {
                                        await initRecorder();
                                      }
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(recorder.isRecording
                                              ? Icons.stop
                                              : Icons.mic),
                                          Text(
                                              "Durée : ${value != null ? value.duration.toString().substring(2, 7) : "00:00"}")
                                        ],
                                      ),
                                    ));
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text("Ajouter du matériel")),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                materiels.contains("")
                                    ? materiels.remove("")
                                    : materiels.add("");
                              });
                            },
                            child: Icon(materiels.contains("")
                                ? Icons.remove_circle
                                : Icons.add),
                          )
                        ],
                      ),
                      ...List<MateriauForm>.generate(materiels.length, (index) {
                        return MateriauForm(callback: (id) {
                          setState(() {
                            materiels[index] = id;
                          });
                        });
                      })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: formulaireSoumis
                      ? null
                      : () async {
                          if (_formKey.currentState!.isValid) {
                            setState(() {
                              formulaireSoumis = true;
                            });
                            final response = await ServyBackend()
                                .createServicePrestataire(
                                    photos: photos,
                                    service: service,
                                    tarif: tarifController.text,
                                    delai: delaiController.text,
                                    audio: audio,
                                    desc: descController.text,
                                    materiels: materiels);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${response[0]} ${response[1]}"),
                              ),
                            );
                            setState(() {
                              formulaireSoumis = false;
                            });
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Remplissez les champs requis"),
                              ),
                            );
                          }
                        },
                  child: formulaireSoumis
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Palette.background,
                          ),
                        )
                      : const Text(
                          "Confirmer la création",
                          textAlign: TextAlign.center,
                        ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
