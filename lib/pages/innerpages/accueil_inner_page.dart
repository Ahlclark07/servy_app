import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/components/cards/vendeur_card.dart';
import 'package:servy_app/components/home_search_bar.dart';

class AccueilInnerPage extends StatefulWidget {
  const AccueilInnerPage({super.key});

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
            "Who would you like to hire today ?",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Connect with the most talented Freelancer on Benin.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          const HomeSearchBar(),
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
          AsyncBuilder(builder: (context, users) {
            return FlutterCarousel(
                items: const [
                  VendeurCard(
                    nom: "Ruben",
                    profession: "Ahoco man",
                    img:
                        "https://thumbor.comeup.com/unsafe/100x100/filters:quality(90):no_upscale()/user/a7f5d2e1-58f0-4fbf-8e1e-521b4ff86515.jpg",
                  ),
                ],
                options: CarouselOptions(
                  initialPage: 3,
                  viewportFraction: 1 / 2,
                  showIndicator: false,
                  enableInfiniteScroll: true,
                  height: 175,
                ));
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
          FlutterCarousel(
              items: [
                ServiceCard(
                  onChange: () => setState(() {
                    shouldUpHeight = !shouldUpHeight;
                  }),
                  nom: "Ruben",
                  profession: "Ahoco man",
                  img:
                      "https://thumbor.comeup.com/unsafe/100x100/filters:quality(90):no_upscale()/user/a7f5d2e1-58f0-4fbf-8e1e-521b4ff86515.jpg",
                ),
              ],
              options: CarouselOptions(
                viewportFraction: .94,
                showIndicator: false,
                height: shouldUpHeight ? 320 : 280,
                enableInfiniteScroll: true,
              )),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
