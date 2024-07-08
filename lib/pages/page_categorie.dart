import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/components/not_found.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageCategorie extends StatelessWidget {
  final Map categorie;
  const PageCategorie({super.key, required this.categorie});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Service en ${categorie["nom"]}"),
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
              width: width,
              height: width / 1.84,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          "${ServyBackend.basePhotosCategories}/${categorie["image"]}"))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Palette.blue,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    child: Text(
                      categorie["nom"],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Palette.background),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(14),
              child: Text(
                categorie["description"],
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AsyncBuilder(
                retain: true,
                waiting: (context) => const CircularProgressIndicator(),
                future: ServyBackend().getServicesByCategory(categorie["_id"]),
                builder: (context, services) {
                  inspect(services);
                  return services!.isEmpty
                      ? const NotFound(text: "Pas de services pour le moment")
                      : Column(
                          children: [
                            ...List<ServiceCard>.generate(
                                services.length,
                                ((index) => ServiceCard(
                                      vendeur: services[index]["vendeur"],
                                      service: services[index],
                                      onChange: () {},
                                    ))),
                          ],
                        );
                }),
          ],
        ),
      ),
    );
  }
}
