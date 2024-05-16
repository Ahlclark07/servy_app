import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final void Function() onPressed;

  const PlayButton({super.key, required this.onPressed});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool onPlay = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.onPressed();
          setState(() {
            onPlay = !onPlay;
          });
        },
        icon: Icon(onPlay ? Icons.pause : Icons.play_arrow));
  }
}
