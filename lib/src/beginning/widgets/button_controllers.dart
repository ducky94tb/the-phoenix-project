import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:phoenix/src/beginning/widgets/play_back_speed_dialog.dart';
import 'package:provider/provider.dart';

import '../utilities/audio_handlers/previous_play_skip.dart';
import '../utilities/global_variables.dart';
import '../utilities/provider/provider.dart';

class ButtonControllers extends StatelessWidget {
  const ButtonControllers({
    super.key,
    this.skyBlur = 30,
    this.skyFadeDuration = 600,
    this.miniPlaying = false,
  });

  final double skyBlur;
  final int skyFadeDuration;
  final bool miniPlaying;

  @override
  Widget build(BuildContext context) {
    final delta = miniPlaying ? 14 : 8;
    return SizedBox(
      width: deviceWidth! - 10,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const SizedBox(
          width: 12,
        ),
        Consumer<Leprovider>(builder: (context, shuf, _) {
          return IconButton(
            icon: Icon(Ionicons.shuffle_outline,
                color: musicBox.get("dynamicArtDB") ?? true
                    ? shuffleSelected
                        ? isArtworkDark!
                            ? Colors.white
                            : Colors.black
                        : isArtworkDark!
                            ? Colors.white.withOpacity(0.4)
                            : Colors.black.withOpacity(0.4)
                    : shuffleSelected
                        ? Colors.white
                        : Colors.white38),
            iconSize: deviceWidth! / 18,
            onPressed: () async {
              if (shuffleSelected) {
                shuf.changeShuffle(false);
              } else {
                shuf.changeShuffle(true);
              }
              await shuffleMode();
            },
          );
        }),
        IconButton(
            icon: Icon(
              MdiIcons.skipPrevious,
              color: musicBox.get("dynamicArtDB") ?? true
                  ? isArtworkDark!
                      ? Colors.white
                      : Colors.black
                  : Colors.white,
            ),
            iconSize: deviceWidth! / 14,
            onPressed: () async {
              audioHandler.skipToPrevious();
            }),
        Container(
          width: deviceWidth! / delta,
          height: deviceWidth! / delta,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(deviceWidth! / (delta * 2)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: skyBlur, sigmaY: skyBlur),
              child: AnimatedContainer(
                duration: Duration(milliseconds: skyFadeDuration),
                color: nowColor.withOpacity(0.3),
                child: Center(
                  child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      icon: AnimatedIcon(
                        progress: animatedPlayPause,
                        icon: AnimatedIcons.pause_play,
                        color: musicBox.get("dynamicArtDB") ?? true
                            ? isArtworkDark!
                                ? Colors.white
                                : Colors.black
                            : Colors.white,
                      ),
                      iconSize: deviceWidth! / (miniPlaying ? delta : 11),
                      alignment: Alignment.center,
                      onPressed: () async {
                        pauseResume();
                      }),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            MdiIcons.skipNext,
            color: musicBox.get("dynamicArtDB") ?? true
                ? isArtworkDark!
                    ? Colors.white
                    : Colors.black
                : Colors.white,
          ),
          iconSize: deviceWidth! / 14,
          onPressed: () async {
            audioHandler.skipToNext();
          },
        ),
        Consumer<Leprovider>(builder: (context, loo, _) {
          return IconButton(
            icon: Icon(
              Ionicons.repeat_outline,
              color: musicBox.get("dynamicArtDB") ?? true
                  ? loopSelected
                      ? isArtworkDark!
                          ? Colors.white
                          : Colors.black
                      : isArtworkDark!
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4)
                  : loopSelected
                      ? Colors.white
                      : Colors.white38,
            ),
            iconSize: deviceWidth! / 17,
            onPressed: () async {
              if (loopSelected) {
                loo.changeLoop(false);
              } else {
                loo.changeLoop(true);
              }
              await loopMode();
            },
          );
        }),
        Consumer<Leprovider>(builder: (context, loo, _) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(Icons.slow_motion_video,
                      color: isArtworkDark! ? Colors.white : Colors.black),
                  iconSize: deviceWidth! / 17,
                  onPressed: () {
                    _showPlaybackSpeedDialog(context, loo);
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: 2,
                child: Text(
                  "${playbackSpeed}x",
                  style: TextStyle(
                      color: isArtworkDark!
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black.withOpacity(0.7),
                      fontSize: 12.0),
                ),
              )
            ],
          );
        }),
      ]),
    );
  }
}

Future<void> _showPlaybackSpeedDialog(
    BuildContext context, Leprovider loo) async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isDismissible: false,
    builder: (context) {
      return PlaybackSpeedSelector(
        currentSpeed: playbackSpeed,
        onSpeedSelected: (speed) async {
          Navigator.pop(context); // Close the bottom sheet
          loo.changeSpeed(speed);
          await speedMode();
        },
      );
    },
  );
}
