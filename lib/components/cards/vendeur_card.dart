import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/page_profil.dart';
import 'package:servy_app/utils/servy_backend.dart';

class VendeurCard extends StatelessWidget {
  final Map vendeur;

  const VendeurCard({
    super.key,
    required this.vendeur,
  });
  LatLng _parseCoordinates(String coordinates) {
    List<String> parts =
        coordinates.split('|').map((part) => part.trim()).toList();
    double longitude = double.parse(parts[0]);
    double latitude = double.parse(parts[1]);
    return LatLng(latitude, longitude);
  }

  String _getDistance() {
    final LatLng parseCoordinates =
        _parseCoordinates(vendeur["adresses"][0]["localisationMap"]);
    try {
      final LatLng parseCoordinatesUser = _parseCoordinates(
          ServyBackend().user["adresses"][0]["localisationMap"]);
      final value = Geolocator.distanceBetween(
              parseCoordinates.latitude,
              parseCoordinates.longitude,
              parseCoordinatesUser.latitude,
              parseCoordinatesUser.longitude)
          .truncate();
      late final String message;
      if (value > 1000) {
        message = "${value / 1000}km";
      } else {
        message = "${value}m";
      }
      return message;
    } catch (e) {
      return "__";
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AsyncBuilder(
        future: ServyBackend().getConnectedUser(),
        builder: (context, _) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageProfil(
                          vendeur: vendeur,
                        ))),
            child: Container(
              width: 300,
              // width: width  / 2  - 30,
              // padding: const EdgeInsets.symmetric(: 10),
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(color: Palette.background, boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(1, 0),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
                BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 3,
                    blurRadius: 1,
                    offset: const Offset(1, 1))
              ]),
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: width * 14 / 32,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "${ServyBackend.basePhotodeProfilURL}/${vendeur["photoDeProfil"]}"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "${vendeur["nom_complet"]}, ${vendeur["profession"]}",
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "A ${_getDistance()} de vous",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ).animate().fade().moveY();
        });
  }
}
