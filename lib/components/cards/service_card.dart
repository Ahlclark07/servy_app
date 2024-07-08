import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/components/audio_player.dart';
import 'package:servy_app/components/buttons/dropdown_button.dart';

import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/page_service.dart';
import 'package:servy_app/utils/servy_backend.dart';

class ServiceCard extends StatefulWidget {
  final Map vendeur;
  final Map service;
  final void Function() onChange;

  const ServiceCard(
      {super.key,
      required this.vendeur,
      required this.service,
      required this.onChange});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isAudioActive = false;
  double audioHeight = 44;
  @override
  Widget build(BuildContext context) {
    final List<dynamic> images = widget.service["images"];
    final Color etat = widget.service["verifie"] == "En attente"
        ? Colors.yellow
        : widget.service["verifie"] == "refuse"
            ? Colors.red
            : Palette.blue;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageService(
                    vendeur: widget.vendeur,
                    service: widget.service,
                  ))),
      child: Container(
        width: screenWidth,
        // width: screenWidth - 30 > 750 ? 750 : screenWidth - 30,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Palette.background, boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(1, 0),
            blurRadius: 0,
            spreadRadius: 1,
          ),
          BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(1, 1))
        ]),
        child: Column(
          children: [
            Stack(
              children: [
                FlutterCarousel(items: [
                  ...List<CachedNetworkImage>.generate(
                      images.length,
                      (index) => CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl:
                              "${ServyBackend.basePhotodeServicesPrestataires}/${images[index]}")),
                ], options: CarouselOptions(height: 200, viewportFraction: 1)),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: etat, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        widget.service["verifie"],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Palette.background,
                            fontWeight: FontWeight.w300),
                      ),
                    ))
              ],
            ),
            SizedBox(
              width: screenWidth - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "${ServyBackend.basePhotodeProfilURL}/${widget.vendeur["photoDeProfil"]}"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth / 2,
                          // width: 200,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: Text(
                                  "${widget.service['service']["nom"]} pour ${widget.service["tarif"]} FCFA",
                                  maxLines: 2,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.vendeur["nom_complet"]}, ${widget.vendeur["profession"]}",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
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
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: isAudioActive ? 45 : 0,
              child: AnimatedScale(
                  scale: isAudioActive ? 1 : 0,
                  alignment: Alignment.bottomRight,
                  duration: const Duration(milliseconds: 100),
                  child: isAudioActive
                      ? AudioPlayer(
                          audio: widget.service["vocal"] ?? "",
                        )
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
