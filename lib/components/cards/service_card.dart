import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/components/audio_player.dart';
import 'package:servy_app/components/buttons/dropdown_button.dart';

import 'package:servy_app/design/design_data.dart';

class ServiceCard extends StatefulWidget {
  final String nom;

  final String img;

  final String profession;
  final void Function() onChange;

  const ServiceCard(
      {super.key,
      required String this.nom,
      required String this.img,
      required String this.profession,
      required this.onChange});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isAudioActive = false;
  double audioHeight = 44;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 750,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Palette.background, boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(1, 0),
          blurRadius: 0,
          spreadRadius: 3,
        ),
        BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 4,
            blurRadius: 6,
            offset: const Offset(1, 1))
      ]),
      child: Column(
        children: [
          FlutterCarousel(items: [
            Image.network(
                "https://thumbor.comeup.com/unsafe/367x207/filters:format(webp):quality(90)/uploads/media/picture/2024-05-09/vignette-comeup-guillaume-guersan-backlinks-fr-663ceccbf1930.png"),
            Image.network(
                "https://thumbor.comeup.com/unsafe/367x207/filters:format(webp):quality(90)/uploads/media/picture/2022-07-01/galerie-service-backlinks-62beaf6494f79.png")
          ], options: CarouselOptions(height: 200, viewportFraction: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        "https://thumbor.comeup.com/unsafe/100x100/filters:quality(90):no_upscale()/user/a7f5d2e1-58f0-4fbf-8e1e-521b4ff86515.jpg",
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Text(
                            "Je vais reparer votre ampoule. avec deux ou 3 techniques",
                            maxLines: 2,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Ruben 1m60",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 10),
                  ),
                ],
              ),
              TabulationButton(
                onPressed: () {
                  widget.onChange();
                  setState(() {
                    isAudioActive = !isAudioActive;
                  });
                },
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: isAudioActive ? 45 : 0,
            child: AnimatedScale(
                scale: isAudioActive ? 1 : 0,
                alignment: Alignment.bottomRight,
                duration: Duration(milliseconds: 100),
                child: AudioPlayer()),
          ),
        ],
      ),
    );
  }
}
