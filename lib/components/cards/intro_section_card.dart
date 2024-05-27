import 'package:flutter/material.dart';

class IntroSectionCard extends StatelessWidget {
  final String titre;

  final String imageName;

  final String description;

  const IntroSectionCard(
      {super.key,
      required this.titre,
      required this.description,
      required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      margin: const EdgeInsets.only(top: 100, bottom: 25),
      child: Column(
        children: [
          Image.asset(imageName),
          const SizedBox(
            height: 15,
          ),
          Text(
            titre,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
