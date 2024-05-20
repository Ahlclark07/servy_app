import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/static_test/fr.dart';
import 'package:servy_app/utils/servy_backend.dart';

class PageIntro extends StatefulWidget {
  const PageIntro({super.key});

  @override
  State<PageIntro> createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  int slidePosition = 0;
  String link = "undefined";
  final CarouselController controller = CarouselController();

  Future setLink() async {
    try {
      link = (link == "undefined")
          ? await ServyBackend().userExist() == ServyBackend.success
              ? "/main"
              : "/inscription"
          : link;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    ButtonStyle? outlinedButtonStyle =
        Theme.of(context).outlinedButtonTheme.style;
    setLink();
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
                  titre: IntroText.titre_1,
                  description: IntroText.description_1,
                ),
                IntroSectionCard(
                  imageName: "assets/images/3d_worker.png",
                  titre: IntroText.titre_2,
                  description: IntroText.description_2,
                ),
                IntroSectionCard(
                  imageName: "assets/images/3d_african.png",
                  titre: IntroText.titre_3,
                  description: IntroText.description_3,
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
            SemiCercle(
              isLeft: true,
              size: 150,
              top: screenSize.height - 350,
            ),
            SemiCercle(
              isLeft: true,
              size: 120,
              top: screenSize.height - 335,
            ),
            const SemiCercle(
              isLeft: false,
              size: 150,
              top: 115,
            ),
            const SemiCercle(
              isLeft: false,
              size: 120,
              top: 130,
            ),
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
                                child: const Text(IntroText.actionpasser),
                                onPressed: () => Navigator.of(context)
                                    .popAndPushNamed(link)),
                            OutlinedButton(
                              onPressed: () {
                                if (slidePosition != 2) {
                                  controller.nextPage(
                                      duration: const Duration(milliseconds: 200));
                                } else {
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
                                        duration: const Duration(milliseconds: 200));
                                  }
                                },
                                style: outlinedButtonStyle?.copyWith(
                                  foregroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Palette.primary),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Palette.background),
                                ),
                                child: const Icon(Icons.arrow_back)),
                            TextButton(
                                child: const Text(IntroText.actionpasser),
                                onPressed: () => Navigator.of(context)
                                    .popAndPushNamed(link)),
                            OutlinedButton(
                              onPressed: () {
                                if (slidePosition != 2) {
                                  controller.nextPage(
                                      duration: const Duration(milliseconds: 200));
                                } else {
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

class SemiCercle extends StatelessWidget {
  final bool isLeft;

  final double size;
  final double top;

  const SemiCercle(
      {super.key, required this.isLeft, required this.size, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        left: isLeft ? -1 * (size / 2) : null,
        right: isLeft ? null : -1 * (size / 2),
        child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                    right: BorderSide(color: Palette.blue, width: 8),
                    top: BorderSide(color: Palette.blue, width: 8),
                    bottom: BorderSide(color: Palette.blue, width: 8),
                    left: BorderSide(color: Palette.blue, width: 8)),
                borderRadius: const BorderRadius.all(Radius.circular(100)))));
  }
}
