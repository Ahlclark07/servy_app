import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/components/cards/vendeur_card.dart';
import 'package:servy_app/utils/servy_backend.dart';

class InnerPageRecherche extends StatelessWidget {
  final ValueNotifier<String> query;
  const InnerPageRecherche({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ValueListenableBuilder(
          valueListenable: query,
          builder: (context, query, child) {
            return AsyncBuilder(
                retain: true,
                keepAlive: true,
                waiting: (context) => const CircularProgressIndicator(),
                future: ServyBackend().getResearch(query),
                builder: (context, datas) {
                  return Column(
                    children: [
                      Text(
                        "Liste des vendeurs",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      datas!["vendeurs"]!.isNotEmpty
                          ? FlutterCarousel(
                              items: List<VendeurCard>.generate(
                                  datas["vendeurs"]!.length,
                                  (index) => VendeurCard(
                                      vendeur: datas["vendeurs"]![index])),
                              options: CarouselOptions(
                                initialPage: 3,
                                viewportFraction: 1 / 2,
                                showIndicator: false,
                                enableInfiniteScroll: true,
                                height: 175,
                              ))
                          : const Text(
                              "Pas de vendeurs pour le moment sorry bro"),
                      Text(
                        "Liste des services",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      datas["services"]!.isEmpty
                          ? const Text("Pas de services pour le moment")
                          : FlutterCarousel(
                              items: [
                                  ...List<ServiceCard>.generate(
                                      datas["services"]!.length,
                                      ((index) => ServiceCard(
                                          vendeur: datas["services"]![index]
                                              ["vendeur"],
                                          service: datas["services"]![index],
                                          onChange: () {}))),
                                ],
                              options: CarouselOptions(
                                viewportFraction: .94,
                                showIndicator: false,
                                height: 320,
                                enableInfiniteScroll: true,
                              )),
                    ],
                  );
                });
          }),
    );
  }
}
