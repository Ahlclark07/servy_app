import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/static_test/fr.dart';
import 'package:servy_app/utils/servy_backend.dart';

import '../components/cards/intro_section_card.dart';

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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: screenSize.width, minHeight: screenSize.height),
          child: Stack(
            children: [
              FlutterCarousel(
                items: const [
                  IntroSectionCard(
                    imageName: "assets/images/3d_african.png",
                    titre: "Trouvez des services pour tous vos besoins",
                    description:
                        "Des prestataires professionnels comme des particuliers de votre régions proposent des services pour remplir vos tâches du quotidien et pallier aux problèmes que vous rencontrez",
                  ),
                  IntroSectionCard(
                    imageName: "assets/images/3d_worker.png",
                    titre: "Vous avez une compétences vendables ?",
                    description:
                        "Vous avez une prestation physique que vous souhaitez vendre ? Coiffure ? Mécanique ? Ménuserie ? Cours de maison ? Un nouveau service qui sort de votre imagination et de vos mains ? Venez les vendre à qui en a besoin !",
                  ),
                  IntroSectionCard(
                    imageName: "assets/images/3d_african.png",
                    titre: "Des fonctionnalités intuitives",
                    description:
                        "Pas de temps à perdre ? En urgence ? Pas comprendre beaucoup français ? Secouez votre téléphone et ayez la liste des vendeurs les plus proches, écoutez la description des services en fon plutot que lire, traduisez les messages textes en francais en message audio en fon directement !",
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
                                          duration: const Duration(
                                              milliseconds: 200));
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
      ),
    );
  }
}
