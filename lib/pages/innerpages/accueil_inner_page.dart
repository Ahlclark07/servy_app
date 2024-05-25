import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/components/cards/vendeur_card.dart';
import 'package:servy_app/components/home_search_bar.dart';
import 'package:servy_app/utils/servy_backend.dart';

class AccueilInnerPage extends StatefulWidget {
  final Function() callback;
  const AccueilInnerPage({super.key, required this.callback});

  @override
  State<AccueilInnerPage> createState() => _AccueilInnerPageState();
}

class _AccueilInnerPageState extends State<AccueilInnerPage> {
  bool shouldUpHeight = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Que recherchez vous aujourd'hui ?",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Entrez en contact avec des centaines d'artisans et d'ouvriers talentueux au Benin.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          HomeSearchBar(
            callback: () => widget.callback(),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Meilleurs vendeurs",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          AsyncBuilder(
              waiting: (context) => const CircularProgressIndicator(),
              future: ServyBackend().getListOfVendeurs(),
              builder: (context, users) {
                return users!.isNotEmpty
                    ? FlutterCarousel(
                        items: List<VendeurCard>.generate(users.length,
                            (index) => VendeurCard(vendeur: users[index])),
                        options: CarouselOptions(
                          initialPage: 3,
                          viewportFraction: 1 / 2,
                          showIndicator: false,
                          enableInfiniteScroll: true,
                          height: 175,
                        ))
                    : const Text("Pas de vendeurs pour le moment sorry bro");
              }),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Meilleurs services",
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          AsyncBuilder(
              waiting: (context) => const CircularProgressIndicator(),
              future: ServyBackend().getListOfServicesPrestataires(),
              builder: (context, services) {
                return services!.isEmpty
                    ? const Text("Pas de services pour le moment")
                    : FlutterCarousel(
                        items: [
                            ...List<ServiceCard>.generate(
                                services.length,
                                ((index) => ServiceCard(
                                    vendeur: services[index]["vendeur"],
                                    service: services[index],
                                    onChange: () {
                                      setState(() {
                                        shouldUpHeight = !shouldUpHeight;
                                      });
                                    }))),
                          ],
                        options: CarouselOptions(
                          viewportFraction: .94,
                          showIndicator: false,
                          height: 325,
                          enableInfiniteScroll: true,
                        ));
              }),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
