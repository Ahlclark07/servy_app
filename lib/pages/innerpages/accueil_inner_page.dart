import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/components/cards/vendeur_card.dart';
import 'package:servy_app/components/home_search_bar.dart';
import 'package:servy_app/components/not_found.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

import '../../components/cards/categorie_card.dart';

class AccueilInnerPage extends StatefulWidget {
  final Function() callback;
  const AccueilInnerPage({super.key, required this.callback});

  @override
  State<AccueilInnerPage> createState() => _AccueilInnerPageState();
}

class _AccueilInnerPageState extends State<AccueilInnerPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: 7,
            margin: const EdgeInsets.only(bottom: 15),
            color: Colors.grey.shade100,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
            child: Column(
              children: [
                Text(
                  "Que recherchez vous aujourd'hui ?",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 25),
                ).animate().fade(duration: const Duration(seconds: 2)).blurXY(
                    begin: 1, end: 0, duration: const Duration(seconds: 2)),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Entrez en contact avec des centaines d'artisans et d'ouvriers talentueux au Benin.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate().fade(duration: const Duration(seconds: 1)).slideY(
                    duration: const Duration(seconds: 1), begin: 1, end: 0),
                const SizedBox(
                  height: 20,
                ),
                HomeSearchBar(
                  callback: () => widget.callback(),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          AsyncBuilder(
              waiting: (context) => const CircularProgressIndicator(),
              future: ServyBackend().getCategories(),
              builder: (context, categories) {
                return Container(
                  color: Palette.blue.withOpacity(1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "A la une",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 20,
                                color: Palette.background,
                                fontWeight: FontWeight.bold),
                      ).animate().fadeIn(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Découvrez toute une sélection de catégories de services pour satisfaire vos besoins",
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontSize: 15, color: Palette.background),
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 500)),
                      const SizedBox(
                        height: 20,
                      ),
                      categories != null
                          ? FlutterCarousel(
                                  items: List<CategorieCard>.generate(
                                      categories.length,
                                      (index) => CategorieCard(
                                            categorie: categories[index],
                                          )),
                                  options: CarouselOptions(
                                      showIndicator: false,
                                      autoPlay: true,
                                      height: 165,
                                      viewportFraction: .85))
                              .animate()
                              .fadeIn(delay: const Duration(milliseconds: 800))
                          : Container()
                    ],
                  ),
                );
              }),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meilleurs vendeurs",
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Palette.blue,
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .moveX(
                        begin: 0,
                        end: 7,
                        duration: const Duration(milliseconds: 1500))
                    .moveX(
                        begin: 7,
                        end: 0,
                        duration: const Duration(milliseconds: 500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Text(
              "Découvrez les vendeurs talentueux, professionnels comme particuliers qui s'occuperont de remplir vos tâches et de répondre à vos besoins.",
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 15, color: Palette.primary),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AsyncBuilder(
              waiting: (context) => const CircularProgressIndicator(),
              future: ServyBackend().getListOfVendeurs(),
              retain: true,
              builder: (context, users) {
                return users!.isNotEmpty
                    ? FlutterCarousel(
                        items: List<VendeurCard>.generate(users.length,
                            (index) => VendeurCard(vendeur: users[index])),
                        options: CarouselOptions(
                          viewportFraction: .75,
                          showIndicator: false,
                          enableInfiniteScroll: true,
                          height: (width * 15 / 32) + 100,
                        ))
                    : const NotFound(
                        text: "Pas de vendeurs pour le moment sorry bro");
              }),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meilleurs services",
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Palette.blue,
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .moveX(
                        begin: 0,
                        end: 7,
                        duration: const Duration(milliseconds: 1500))
                    .moveX(
                        begin: 7,
                        end: 0,
                        duration: const Duration(milliseconds: 500))
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AsyncBuilder(
              retain: true,
              waiting: (context) => const CircularProgressIndicator(),
              future: ServyBackend().getListOfServicesPrestataires(),
              builder: (context, services) {
                return services!.isEmpty
                    ? const NotFound(text: "Pas de services pour le moment")
                    : Column(
                        children: [
                          ...List<ServiceCard>.generate(
                              services.length,
                              ((index) => ServiceCard(
                                  vendeur: services[index]["vendeur"],
                                  service: services[index],
                                  onChange: () {}))),
                        ],
                      );
              }),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
