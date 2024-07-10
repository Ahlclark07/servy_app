import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servy_app/design/design_data.dart';
import 'package:servy_app/utils/servy_backend.dart';

class CustomBubble extends StatefulWidget {
  final String message;
  final Color color;
  final BubbleNip nip;
  const CustomBubble(
      {super.key,
      required this.message,
      required this.color,
      required this.nip});

  @override
  _CustomBubbleState createState() => _CustomBubbleState();
}

class _CustomBubbleState extends State<CustomBubble> {
  late bool traductionEnCours;
  late bool afficherTrad;
  String messageTraduit = "";
  @override
  void initState() {
    traductionEnCours = false;
    afficherTrad = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        if (!afficherTrad) {
          setState(() {
            traductionEnCours = !traductionEnCours;
          });
          if (messageTraduit == "") {
            final response =
                await ServyBackend().traduction(data: widget.message);

            messageTraduit = response["translation"];
          }
        }
        setState(() {
          traductionEnCours = false;
          afficherTrad = !afficherTrad;
        });
      },
      child: Bubble(
        color: widget.color,
        margin: const BubbleEdges.symmetric(horizontal: 6),
        nip: widget.nip,
        padding: const BubbleEdges.all(15),
        child: !traductionEnCours
            ? Text(
                afficherTrad ? messageTraduit : widget.message,
                style: !afficherTrad
                    ? Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontSize: 15, color: Palette.background)
                    : GoogleFonts.notoSans(
                        fontSize: 15, color: Palette.background),
              )
            : CircularProgressIndicator(
                color: Palette.background,
              ),
      ),
    );
  }
}
