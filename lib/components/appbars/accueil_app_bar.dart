import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class AccueilAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function callBack;
  const AccueilAppBar({super.key, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: AsyncBuilder(
          future: ServyBackend().getConnectedUser(),
          waiting: (context) => const CircularProgressIndicator(),
          builder: (context, user) {
            return AppBar(
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
                                "${ServyBackend.basePhotoURL}/uploads/images/photodeprofils/${user?["photoDeProfil"]}")),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            );
          }),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(105);
}
