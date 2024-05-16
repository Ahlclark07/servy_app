import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servy_app/components/buttons/play_button.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlayButton(onPressed: () {}),
        Container(
          width: 250,
          child: ProgressBar(
            progress: Duration(milliseconds: 1000),
            buffered: Duration(milliseconds: 2000),
            total: Duration(milliseconds: 5000),
            onSeek: (duration) {
              print('User selected a new time: $duration');
            },
          ),
        ),
      ],
    );
  }
}
