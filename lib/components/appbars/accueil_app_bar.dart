import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:servy_app/components/search_bar.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class AccueilAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;
  final Function callBack;
  final ValueNotifier<String> queryNotifier;
  const AccueilAppBar(
      {super.key,
      required this.callBack,
      this.showSearch = false,
      required this.queryNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: AsyncBuilder(
          future: ServyBackend().getConnectedUser(),
          waiting: (context) => const CircularProgressIndicator(),
          error: (context, error, stackTrace) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Erreur : Votre profil n'est pas rempli !"),
                ),
              );
              Navigator.of(context).popAndPushNamed("/remplirProfil");
            });
            return Container();
          },
          builder: (context, user) {
            inspect(user);

            return AppBar(
              bottom: showSearch
                  ? HomeSearchBar(queryNotifier: queryNotifier)
                  : null,
              scrolledUnderElevation: 0,
              leadingWidth: double.infinity,
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello ! 🖖",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 20),
                  ),
                  Text(
                    user?["nom_complet"],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Palette.cendre,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    callBack();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "${ServyBackend.basePhotodeProfilURL}/${user?["photoDeProfil"]}")),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            );
          }),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(showSearch ? 140 : 105);
}
