import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageProfil extends StatelessWidget {
  final Map vendeur;
  const PageProfil({super.key, required this.vendeur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        color: Palette.blue,
                        width: double.maxFinite,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 10,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
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
            AsyncBuilder(
                future: ServyBackend().getUserServices(vendeur["_id"]),
                waiting: (context) => const CircularProgressIndicator(),
                builder: (context, services) {
                  if (services == null || services.isEmpty) {
                    return const Text("Pas de services pour le moment");
                  }
                  return Column(
                    children: [
                      ...List<Widget>.generate(
                          services.length,
                          ((index) => services[index]["verifie"] != "En attente"
                              ? ServiceCard(
                                  vendeur: vendeur,
                                  service: services[index],
                                  onChange: () {})
                              : Container())),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
