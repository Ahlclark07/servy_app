import 'dart:io';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AskForFile extends StatefulWidget {
  final Function(File) callback;
  final String nom;
  const AskForFile({super.key, required this.callback, required this.nom});

  @override
  State<AskForFile> createState() => _AskForFileState();
}

class _AskForFileState extends State<AskForFile> {
  bool fileSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
        child: Text("Uploadez le fichier : ${widget.nom}"),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            File file = File(result.files.single.path!);

            widget.callback(file);
            setState(() {
              fileSubmitted = true;
            });
          }
        },
        builder: (context, child, callback, state) {
          if (fileSubmitted) {
            return ElevatedButton(
                onPressed: null, child: Text("Upload de ${widget.nom} reussi"));
          }

          return ElevatedButton(onPressed: callback, child: child);
        });
  }
}
