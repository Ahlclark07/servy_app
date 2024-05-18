import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/components/audio_player.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageService extends StatelessWidget {
  final Map service;
  final Map vendeur;

  const PageService({super.key, required this.service, required this.vendeur});
  @override
  Widget build(BuildContext context) {
    final images = service["images"];
    final width = MediaQuery.of(context).size.width;
    inspect(service);
    return Scaffold(
      bottomNavigationBar: Container(
        color: Palette.blue,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tarif: ${service["tarif"]} FCFA",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Palette.background, fontWeight: FontWeight.w700),
            ),
            ElevatedButton(
              onPressed: null,
              child: Text("Commander"),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  foregroundColor: MaterialStatePropertyAll(Palette.blue),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Palette.background)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Stack(
                  children: [
                    FlutterCarousel(
                        items: [
                          ...List<Image>.generate(
                              images.length,
                              (index) => Image.network(
                                  fit: BoxFit.cover,
                                  "${ServyBackend.basePhotodeServicesPrestataires}/${images[index]}")),
                        ],
                        options: CarouselOptions(
                            height: 200, viewportFraction: 1, autoPlay: true)),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "${ServyBackend.basePhotodeProfilURL}/${vendeur["photoDeProfil"]}"),
                        radius: 60,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vendeur["nom_complet"],
                      ),
                      Text(
                        (vendeur["profession"]),
                      ),
                    ]),
              ),
            ]),
          ),
          AudioPlayer(
            audio: service["vocal"] ?? "",
          ),
          const Text("Description du service"),
          Container(
            width: width - 40,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Text(
                    service['service']["nom"],
                    maxLines: 2,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width - 40,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Text(
                    service['description'] ?? "Pas de description",
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const Text("Liste des matériaux"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: List<Row>.generate(
                  service["materiaux"]!.length,
                  (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "${ServyBackend.basePhotodeMateriau}/${service["materiaux"][index]["image"]}")),
                            ),
                          ),
                          Expanded(
                              child: Text(service["materiaux"][index]["nom"])),
                          Container(
                            color: Palette.background,
                            child: Text(
                                service["materiaux"][index]["prix"].toString()),
                          )
                        ],
                      )),
            ),
          )
        ]),
      ),
    );
  }
}
