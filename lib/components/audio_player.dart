import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:servy_app/utils/servy_backend.dart';

class AudioPlayer extends StatefulWidget {
  final String audio;
  const AudioPlayer({super.key, required this.audio});

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  bool finished = false;
  bool onPlay = false;
  bool alreadyPlayed = false;
  Duration duree = Duration.zero;
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    player.closePlayer();

    super.dispose();
  }

  Future<void> play() async {
    if (alreadyPlayed) {
      await player.resumePlayer();
    } else {
      final temps = await player.startPlayer(
          fromURI: "${ServyBackend.baseAudio}/${widget.audio}",
          whenFinished: () {
            player.stopPlayer();
            setState(() {
              alreadyPlayed = false;
              finished = false;
              onPlay = false;
            });
          });
      setState(() {
        alreadyPlayed = true;
        duree = temps ?? Duration.zero;
      });
    }
  }

  Future<void> pause() async {
    await player.pausePlayer();
  }

  Future initPlayer() async {
    await player.openPlayer();

    await player.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, -10),
          child: IconButton(
              onPressed: widget.audio != ""
                  ? () async {
                      if (player.isPlaying) {
                        await pause();
                      } else {
                        await play();
                      }
                      setState(() {
                        onPlay = !onPlay;
                        finished = false;
                      });
                    }
                  : null,
              icon: Icon(onPlay ? Icons.pause : Icons.play_arrow)),
        ),
        AsyncBuilder(
            retain: true,
            initial: null,
            stream: player.onProgress,
            builder: (context, value) {
              return SizedBox(
                width: 250,
                child: ProgressBar(
                  progress: value != null
                      ? (finished ? value.duration : value.position)
                      : Duration.zero,
                  buffered: value != null ? value.position : Duration.zero,
                  total: duree,
                ),
              );
            }),
      ],
    );
  }
}
