import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/auth_service.dart';
import 'package:servy_app/utils/servy_backend.dart';

class ChatPage extends StatefulWidget {
  final types.Room room;

  const ChatPage({super.key, required this.room});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool appBarFullSize = false;
  @override
  Widget build(BuildContext context) {
    final String id = widget.room.metadata!["name"] ?? "";
    final width = MediaQuery.of(context).size.width;
    final double height =
        appBarFullSize ? MediaQuery.of(context).size.height - 500 : 180;
    return AsyncBuilder(
        retain: true,
        future: ServyBackend().getCommande(id),
        builder: (context, commande) {
          inspect(commande);
          final vendeur =
              commande != null ? commande["service"]["vendeur"] : [];
          final statutCommande = commande != null ? commande["statut"] : "";
          return Scaffold(
            appBar: AppBar(
              title: Text(id),
              toolbarHeight: 50,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(height - 90),
                child: commande != null
                    ? GestureDetector(
                        onTap: () => setState(() {
                          appBarFullSize = !appBarFullSize;
                        }),
                        child: AnimatedContainer(
                          height: height - 90,
                          duration: const Duration(milliseconds: 300),
                          color: Colors.yellow,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: appBarFullSize
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              "${ServyBackend.basePhotodeProfilURL}/${vendeur["photoDeProfil"]}"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          textAlign: TextAlign.left,
                                          "${vendeur["nom_complet"]}, ${vendeur["profession"]}"),
                                      Text(
                                          textAlign: TextAlign.center,
                                          "Service commandé : ${commande["service"]["service"]["nom"]}"),
                                    ],
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: appBarFullSize ? 30 : 0,
                              ),
                              appBarFullSize
                                  ? Expanded(
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          "Bienvenu dans le menu de gestion de commande. Vous pouvez discuter avec votre prestataire des taches, de la commande en cours, donner des indications et autres concernant la commande. Votre commande est actuellement en statut \"$statutCommande\"."))
                                  : Container(),
                              appBarFullSize
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                            onPressed: null,
                                            child: Text(statutCommande ==
                                                    "non_payer"
                                                ? "Payer les ${commande["service"]["tarif"]} FCFA"
                                                : "Valider la commande")),
                                        ElevatedButton(
                                            style: Theme.of(context)
                                                .elevatedButtonTheme
                                                .style
                                                ?.copyWith(
                                                    backgroundColor:
                                                        const WidgetStatePropertyAll(
                                                            Colors.red)),
                                            onPressed: () async {
                                              final String response =
                                                  await ServyBackend()
                                                      .annulerCommande(id);
                                              inspect(response);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(response),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                                "Annuler la commande")),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<types.Message>>(
                    stream: FirebaseChatCore.instance.messages(widget.room),
                    initialData: const [],
                    builder: (context, snapshot) {
                      return Chat(
                        emptyState: const Center(
                          child: Text("Pas de message, envoyez un message !"),
                        ),
                        messages: snapshot.data!,
                        onSendPressed: (partialText) async {
                          final message =
                              types.PartialText(text: partialText.text);
                          FirebaseChatCore.instance
                              .sendMessage(message, widget.room.id);
                        },
                        user: types.User(id: AuthService().currentUser!.uid),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
