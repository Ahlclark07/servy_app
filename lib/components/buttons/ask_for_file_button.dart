import 'dart:io';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servy_app/design/design_data.dart';

class AskForFile extends StatefulWidget {
  final Function(File) callback;
  final String nom;
  final int limit;
  final double hauteur;
  const AskForFile(
      {super.key,
      required this.callback,
      required this.nom,
      this.limit = 1,
      this.hauteur = 150});

  @override
  State<AskForFile> createState() => _AskForFileState();
}

class _AskForFileState extends State<AskForFile> {
  bool fileSubmitted = false;
  List<File> files = [];
  Future<void> _askForFileMethod() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      widget.callback(file);
      setState(() {
        fileSubmitted = true;
        files.add(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
        child: const Icon(Icons.add),
        onPressed: () async {
          try {
            await _askForFileMethod();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Veuillez permettre l'utilisation du stockage dans les paramètres"),
              ),
            );
            await Future.delayed(const Duration(seconds: 1));
            Geolocator.openAppSettings();
          }
        },
        builder: (context, child, callback, state) {
          // if (fileSubmitted) {
          //   return ElevatedButton(
          //       onPressed: null, child: Text("Upload de ${widget.nom} reussi"));
          // }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Charger ${widget.limit > 1 ? 'les fichiers' : 'le fichier'} : ${widget.nom}",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                width: 400,
                height: widget.hauteur,
                color: Palette.cendre.withAlpha(50),
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  children: [
                    ...List<Container>.generate(
                        files.length,
                        (index) => Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(files[index])),
                              ),
                            )),
                    widget.limit != files.length
                        ? ElevatedButton(onPressed: callback, child: child)
                        : const IconButton(
                            onPressed: null, icon: Icon(Icons.check)),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
