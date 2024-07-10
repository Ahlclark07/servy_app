import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:servy_app/components/cards/vendeur_card.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageVendeursProches extends StatelessWidget {
  LatLng _parseCoordinates(String coordinates) {
    List<String> parts =
        coordinates.split('|').map((part) => part.trim()).toList();
    double longitude = double.parse(parts[0]);
    double latitude = double.parse(parts[1]);
    return LatLng(latitude, longitude);
  }

  const PageVendeursProches({super.key});
  @override
  Widget build(BuildContext context) {
    final Function()? callback =
        ModalRoute.of(context)?.settings.arguments as Function()?;

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "En cours d'implémentation ! Vous pourrez plus tard envoyer des notifs SOS"),
            ),
          );
        },
        child: const Icon(Icons.sos),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              callback!();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Dans un rayon de 20km"),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Liste des vendeurs les plus proches",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            AsyncBuilder(
                future: ServyBackend().getListOfCloseVendeurs(),
                waiting: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                builder: (context, vendeurs) {
                  return Column(
                    children: [
                      Container(
                        width: width,
                        height: 300,
                        margin: const EdgeInsets.all(10),
                        child: GoogleMap(
                            mapType: MapType.normal,
                            markers: {
                              Marker(
                                  markerId:
                                      MarkerId(ServyBackend().user["nom"]),
                                  position: _parseCoordinates(ServyBackend()
                                      .user["adresses"][0]["localisationMap"])),
                              ...List<Marker>.generate(
                                  vendeurs!.length,
                                  (index) => Marker(
                                      markerId:
                                          MarkerId(vendeurs[index]["nom"]),
                                      position: _parseCoordinates(
                                          vendeurs[index]["adresses"][0]
                                              ["localisationMap"])))
                            },
                            initialCameraPosition: CameraPosition(
                                zoom: 14,
                                target: _parseCoordinates(ServyBackend()
                                    .user["adresses"][0]["localisationMap"]))),
                      ),
                      Wrap(
                          spacing: 10,
                          children: List<VendeurCard>.generate(
                              vendeurs!.length,
                              (index) =>
                                  VendeurCard(vendeur: vendeurs[index]))),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
