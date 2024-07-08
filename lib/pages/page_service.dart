import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:servy_app/components/audio_player.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/page_profil.dart';
import 'package:servy_app/utils/servy_backend.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class PageService extends StatelessWidget {
  final Map service;
  final Map vendeur;
  const PageService({super.key, required this.service, required this.vendeur});
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
  }

  @override
  Widget build(BuildContext context) {
    final images = service["images"];
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        color: Palette.blue,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tarif: ${service["tarif"]} FCFA",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Palette.background, fontWeight: FontWeight.w700),
            ),
            (vendeur["_id"] != ServyBackend().user["_id"] &&
                    service["verifie"] == "Accepté")
                ? ElevatedButton(
                    onPressed: () async {
                      final response = await ServyBackend()
                          .passerCommande(serviceprestataire: service["_id"]);
                      if (response[0] == ServyBackend.success) {
                        final room = await FirebaseChatCore.instance.createRoom(
                            types.User(id: vendeur["idFirebase"]),
                            metadata: {
                              "name":
                                  "${vendeur["nom"]} | ${vendeur["profession"]}",
                              "imageUrl": vendeur["photoDeProfil"]
                            });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Votre commande a été crée avec succès"),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("/main"));
                      }
                    },
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style
                        ?.copyWith(
                            foregroundColor:
                                WidgetStatePropertyAll(Palette.blue),
                            backgroundColor: WidgetStatePropertyAll<Color>(
                                Palette.background)),
                    child: const Text("Commander"),
                  )
                : Container()
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
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FlutterCarousel(
                    items: [
                      ...List<CachedNetworkImage>.generate(
                          images.length,
                          (index) => CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl:
                                  "${ServyBackend.basePhotodeServicesPrestataires}/${images[index]}")),
                    ],
                    options: CarouselOptions(
                        height: 200, viewportFraction: 1, autoPlay: true)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageProfil(
                                      vendeur: vendeur,
                                    ))),
                        child: SizedBox(
                          width: 85,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                "${ServyBackend.basePhotodeProfilURL}/${vendeur["photoDeProfil"]}"),
                            radius: 60,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            "${vendeur["nom_complet"]}, ${vendeur["profession"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          AudioPlayer(
                            mini: true,
                            audio: service["vocal"] ?? "",
                          ),
                        ],
                      ),
                    ]),
              ),
            ]),
          ),
          // Container(
          //   color: Palette.inputBackground,
          //   padding: const EdgeInsets.only(top: 30, bottom: 20),
          //   child: AudioPlayer(
          //     audio: service["vocal"] ?? "",
          //   ),
          // ),
          Container(
            color: Palette.background,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Description du service",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Palette.blue),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
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
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
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
              ],
            ),
          ),

          service["materiaux"]!.length > 0
              ? Container(
                  color: Palette.background,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Text(
                          "Liste des matériaux nécessaires",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Palette.blue),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: List<Row>.generate(
                              service["materiaux"]!.length,
                              (index) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  "${ServyBackend.basePhotodeMateriau}/${service["materiaux"][index]["image"]}")),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(service["materiaux"]
                                              [index]["nom"])),
                                      Container(
                                        color: Palette.background,
                                        child: Text(
                                            "${service["materiaux"][index]["prix"]} FCFA"),
                                      )
                                    ],
                                  )),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),

          service["verifie"] == "refusé"
              ? SizedBox(
                  width: width - 40,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Text(
                          service['messageAdmin']!,
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
                )
              : Container(),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Ce vendeur est à : ",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pin_drop,
                size: 50,
              ),
              Text(
                " ${_getDistance()} de vous",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          const SizedBox(
            height: 100,
          )
        ]),
      ),
    );
  }
}
