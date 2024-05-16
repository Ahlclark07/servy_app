import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class ProfilInnerPage extends StatelessWidget {
  const ProfilInnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AsyncBuilder(
          future: ServyBackend().getConnectedUser(),
          waiting: (context) => const CircularProgressIndicator(),
          builder: (context, user) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ServyBackend.basePhotoURL}/uploads/images/photodeprofils/${user?["photoDeProfil"]}")),
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Text(
                          user?["nom_complet"],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${user!["role"]} ${user["enTransition"] ? "(en transition)" : ""}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        Container(
                          width: 250,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: Text(
                                  user["adresses"][0]["show_address"],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Palette.cendre,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: 150,
                    height: 1,
                    color: Palette.blue,
                  ),
                ),
                !user["enTransition"]
                    ? ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/devenirVendeur"),
                        child: Text("Devenir vendeur"))
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Text("Liste des commandes payées",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                const Center(child: Text("Aucune commande pour le moment"))
              ],
            );
          }),
    );
  }
}
