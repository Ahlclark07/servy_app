
import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/components/buttons/refresh_button.dart';
import 'package:servy_app/components/cards/service_card.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class ProfilInnerPage extends StatefulWidget {
  const ProfilInnerPage({super.key});

  @override
  State<ProfilInnerPage> createState() => _ProfilInnerPageState();
}

class _ProfilInnerPageState extends State<ProfilInnerPage> {
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ServyBackend.basePhotodeProfilURL}/${user?["photoDeProfil"]}")),
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
                          "${user?["nom_complet"]}, ${user?["profession"] ?? "particulier"}",
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
                        SizedBox(
                          width: 200,
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
                    ),
                    RefreshButton(callback: () => setState(() {}))
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
                !user["enTransition"] && user["role"] == "client"
                    ? ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, "/devenirVendeur"),
                        child: const Text("Devenir vendeur"))
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Container(),
                const SizedBox(
                  height: 20,
                ),
                user["demande"] != null &&
                        user["demande"]["status"] != "acceptée"
                    ? Text(
                        "Messsage de l'admin : ${user["demande"] != null ? user["demande"]["show_message"] : ""}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.red),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Text("Liste des services créés",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                AsyncBuilder(
                    future: ServyBackend().getUserServices(user["_id"]),
                    waiting: (context) => const CircularProgressIndicator(),
                    builder: (context, list) {
                      if (list!.isEmpty) {
                        return const Center(
                            child: Text("Aucun service pour le moment"));
                      }
                      return Column(
                        children: [
                          ...List<ServiceCard>.generate(
                              list.length,
                              (index) => ServiceCard(
                                  vendeur: user,
                                  service: list[index],
                                  onChange: () {}))
                        ],
                      );
                    }),
                Text("Liste des commandes payées",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                AsyncBuilder(
                    future: ServyBackend().getCommandes(),
                    waiting: (context) => const CircularProgressIndicator(),
                    builder: (context, list) {
                      if (list!.isEmpty) {
                        return const Center(
                            child: Text("Aucun service pour le moment"));
                      }
                      return Column(
                        children: [
                          ...List<Container>.generate(
                              list.length,
                              (index) => Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(list[index]["_id"]),
                                        Text(
                                            "${list[index]["service"]["tarif"]} FCFA"),
                                      ],
                                    ),
                                  ))
                        ],
                      );
                    }),
              ],
            );
          }),
    );
  }
}
