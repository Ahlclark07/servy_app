import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/components/cards/vendeur_card.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageVendeursProches extends StatelessWidget {
  const PageVendeursProches({super.key});
  @override
  Widget build(BuildContext context) {
    final Function()? callback =
        ModalRoute.of(context)?.settings.arguments as Function()?;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                  return Wrap(
                      spacing: 10,
                      children: List<VendeurCard>.generate(vendeurs!.length,
                          (index) => VendeurCard(vendeur: vendeurs[index])));
                }),
          ],
        ),
      ),
    );
  }
}
