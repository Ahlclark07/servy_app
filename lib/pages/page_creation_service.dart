import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/components/forms/customSelectField.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageCreationService extends StatefulWidget {
  const PageCreationService({super.key});

  @override
  State<PageCreationService> createState() => _PageCreationServiceState();
}

class _PageCreationServiceState extends State<PageCreationService> {
  int nombrePhoto = 0;
  String service = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: AsyncBuilder(
              retain: true,
              waiting: (context) => const CircularProgressIndicator(),
              future: ServyBackend().getListOfServices(),
              builder: (context, services) {
                List<String> titres = [];
                List<String> values = [];
                print("En voila des manières");
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
                  ],
                );
              }),
        ),
      ),
    );
  }
}
