import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/pages/page_categorie.dart';
import 'package:servy_app/utils/servy_backend.dart';

class CategorieCard extends StatelessWidget {
  final Map categorie;

  const CategorieCard({
    super.key,
    required this.categorie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageCategorie(
                    categorie: categorie,
                  ))),
      child: Container(
          width: 300,
          height: 163,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
              border: Border.all(color: Palette.background),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Palette.primary.withOpacity(.45), BlendMode.colorBurn),
                  image: CachedNetworkImageProvider(
                      "${ServyBackend.basePhotosCategories}/${categorie["image"]}"))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Palette.blue,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Text(
                  categorie["nom"],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Palette.background),
                ),
              ),
            ],
          )),
    );
  }
}
