import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/page_profil.dart';
import 'package:servy_app/utils/servy_backend.dart';

class VendeurCard extends StatelessWidget {
  final Map vendeur;

  const VendeurCard({
    super.key,
    required this.vendeur,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageProfil(
                    vendeur: vendeur,
                  ))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 500,
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
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "${ServyBackend.basePhotodeProfilURL}/${vendeur["photoDeProfil"]}"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Text(
              vendeur["nom"],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              vendeur["profession"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
