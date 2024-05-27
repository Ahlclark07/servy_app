import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/static_test/fr.dart';
import 'package:servy_app/utils/servy_backend.dart';

import '../components/cards/intro_section_card.dart';
import '../components/semi_cercle.dart';

class PageIntro extends StatefulWidget {
  const PageIntro({super.key});

  @override
  State<PageIntro> createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  int slidePosition = 0;
  String link = "/inscription";
  final CarouselController controller = CarouselController();

  Future setLink() async {
    try {
      link = await ServyBackend().userExist() == ServyBackend.success
          ? "/main"
          : "/inscription";
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    ButtonStyle? outlinedButtonStyle =
        Theme.of(context).outlinedButtonTheme.style;

    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: [
            FlutterCarousel(
              items: const [
                IntroSectionCard(
                  imageName: "assets/images/3d_african.png",
                  titre: "Titre 1 à remplir plus tard",
                  description:
                      "Description 1 à remplir plus tard parce que c'est pahomproblem",
                ),
                IntroSectionCard(
                  imageName: "assets/images/3d_worker.png",
                  titre: "Titre 2 à remplir plus tard",
                  description:
                      "Description 2 à remplir plus tard parce que c'est pahomproblem",
                ),
                IntroSectionCard(
                  imageName: "assets/images/3d_african.png",
                  titre: "Titre 3 à remplir plus tard",
                  description:
                      "Description 3 à remplir plus tard parce que c'est pahomproblem",
                ),
              ],
              options: CarouselOptions(
                  onPageChanged: (index, reason) => setState(() {
                        slidePosition = index;
                      }),
                  floatingIndicator: false,
                  controller: controller,
                  height: screenSize.height * 6 / 7,
                  viewportFraction: 1,
                  slideIndicator: CircularWaveSlideIndicator(
                      indicatorBorderColor: Palette.background,
                      indicatorBackgroundColor: Palette.primary,
                      itemSpacing: 35,
                      currentIndicatorColor: Palette.blue)),
            ),
            // SemiCercle(
            //   isLeft: true,
            //   size: 150,
            //   top: screenSize.height - 350,
            // ),
            // SemiCercle(
            //   isLeft: true,
            //   size: 120,
            //   top: screenSize.height - 335,
            // ),
            // const SemiCercle(
            //   isLeft: false,
            //   size: 150,
            //   top: 115,
            // ),
            // const SemiCercle(
            //   isLeft: false,
            //   size: 120,
            //   top: 130,
            // ),
            Positioned(
                bottom: 15,
                child: Container(
                  width: screenSize.width,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: slidePosition == 0
                        ? [
                            TextButton(
                                child: const Text("Passer l'intro"),
                                onPressed: () async {
                                  await setLink();
                                  Navigator.of(context).popAndPushNamed(link);
                                }),
                            OutlinedButton(
                              onPressed: () async {
                                if (slidePosition != 2) {
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200));
                                } else {
                                  await setLink();
                                  Navigator.of(context).popAndPushNamed(link);
                                }
                              },
                              child: slidePosition != 2
                                  ? const Icon(Icons.arrow_forward)
                                  : const Text("Continuer"),
                            )
                          ]
                        : [
                            OutlinedButton(
                                onPressed: () async {
                                  if (slidePosition != 0) {
                                    controller.previousPage(
                                        duration:
                                            const Duration(milliseconds: 200));
                                  }
                                },
                                style: outlinedButtonStyle?.copyWith(
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          Palette.primary),
                                  backgroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          Palette.background),
                                ),
                                child: const Icon(Icons.arrow_back)),
                            TextButton(
                                child: const Text(IntroText.actionpasser),
                                onPressed: () async {
                                  await setLink();
                                  Navigator.of(context).popAndPushNamed(link);
                                }),
                            OutlinedButton(
                              onPressed: () async {
                                if (slidePosition != 2) {
                                  controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200));
                                } else {
                                  await setLink();
                                  inspect(link);
                                  Navigator.of(context).popAndPushNamed(link);
                                }
                              },
                              child: const Icon(Icons.arrow_forward),
                            )
                          ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
