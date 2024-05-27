import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';

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
