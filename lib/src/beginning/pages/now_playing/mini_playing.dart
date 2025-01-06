import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/widgets/button_controllers.dart';
import 'package:phoenix/src/beginning/widgets/custom/marquee.dart';
import 'package:phoenix/src/beginning/widgets/seek_bar.dart';

class Moderna extends StatefulWidget {
  const Moderna({super.key});

  @override
  State<Moderna> createState() => _ModernaState();
}

class _ModernaState extends State<Moderna> {
  @override
  Widget build(BuildContext context) {
    bool showButtons = musicBox.get("miniPlayerPosition") != "Hidden";
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: radiusFullscreen,
      ),
      child: Stack(
        children: [
          AnimatedCrossFade(
            duration: Duration(milliseconds: crossfadeDuration),
            firstChild: Container(
              decoration: BoxDecoration(
                image: art == null
                    ? null
                    : DecorationImage(
                        image: MemoryImage(art!),
                        fit: BoxFit.fitWidth,
                      ),
                color: Colors.black,
                borderRadius: radiusFullscreen,
              ),
              child: Center(
                child: Container(
                  height: 120,
                  width: orientedCar ? deviceHeight : deviceWidth,
                  decoration: BoxDecoration(
                    borderRadius: radiusFullscreen,
                  ),
                ),
              ),
            ),
            secondChild: Container(
              decoration: BoxDecoration(
                image: art2 == null
                    ? null
                    : DecorationImage(
                        image: MemoryImage(art2!),
                        fit: BoxFit.fitWidth,
                      ),
                borderRadius: radiusFullscreen,
                color: Colors.black,
              ),
              child: Center(
                child: Container(
                  height: 120,
                  width: orientedCar ? deviceHeight : deviceWidth,
                  decoration: BoxDecoration(
                    borderRadius: radiusFullscreen,
                  ),
                ),
              ),
            ),
            crossFadeState:
                first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: radiusFullscreen,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: orientedCar ? 8 : 5, sigmaY: orientedCar ? 8 : 5),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) async {
                  gestureDetectorFoo(details);
                },
                onTap: () async {
                  HapticFeedback.lightImpact();
                  if (!showButtons) pauseResume();
                },
                child: Column(
                  children: buildMiniPlayerViews(Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: deviceWidth! / 18, right: deviceWidth! / 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MarqueeText(
                            text: nowMediaItem.title,
                            speed: 20,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2.0,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            nowMediaItem.artist!,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 1.0,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Classix extends StatefulWidget {
  const Classix({super.key});

  @override
  State<Classix> createState() => _ClassixState();
}

class _ClassixState extends State<Classix> {
  @override
  Widget build(BuildContext context) {
    bool showButtons = musicBox.get("miniPlayerPosition") != "Hidden";
    return AnimatedContainer(
      duration: Duration(milliseconds: crossfadeDuration),
      decoration: BoxDecoration(
        color: musicBox.get("dynamicArtDB") ?? true ? nowColor : kMaterialBlack,
      ),
      child: Column(
        children: buildMiniPlayerViews(Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) async {
                  gestureDetectorFoo(details);
                },
                onTap: () async {
                  HapticFeedback.lightImpact();
                  if (!showButtons) pauseResume();
                },
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: deviceWidth! / 20)),
                    Center(
                      child: AnimatedCrossFade(
                        duration: Duration(milliseconds: crossfadeDuration),
                        firstChild: Card(
                          elevation: 3,
                          color: Colors.transparent,
                          child: Container(
                            height: musicBox.get("squareArt") ?? true ? 48 : 44,
                            width: musicBox.get("squareArt") ?? true ? 48 : 64,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(art!),
                              ),
                            ),
                          ),
                        ),
                        secondChild: Card(
                          elevation: 3,
                          color: Colors.transparent,
                          child: Container(
                            height: musicBox.get("squareArt") ?? true ? 48 : 44,
                            width: musicBox.get("squareArt") ?? true ? 48 : 64,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(art2!),
                              ),
                            ),
                          ),
                        ),
                        crossFadeState: first
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                    Container(
                      width: orientedCar
                          ? deviceHeight! / 1.6
                          : deviceWidth! / 1.6,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MarqueeText(
                            text: nowMediaItem.title,
                            speed: 20,
                            style: TextStyle(
                              color: musicBox.get("dynamicArtDB") ?? true
                                  ? nowContrast
                                  : Colors.white,
                              fontSize: 19,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2.0,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            nowMediaItem.artist!,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: musicBox.get("dynamicArtDB") ?? true
                                  ? nowContrast
                                  : Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 1.0,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

List<Widget> buildMiniPlayerViews(Widget child) {
  bool showButtons = musicBox.get("miniPlayerPosition") != "Hidden";
  bool reverse = musicBox.get("miniPlayerPosition") == "Top";
  final views = [
    child,
    Visibility(
        visible: showButtons,
        child: Column(
            children:
                reverse ? progressViews.reversed.toList() : progressViews)),
  ];
  return reverse ? views.reversed.toList() : views;
}

const progressViews = [
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.0),
    child: MiniSeekbar(),
  ),
  ButtonControllers(
    miniPlaying: true,
  ),
];

gestureDetectorFoo(details) async {
  if (details.primaryVelocity > 0) {
    HapticFeedback.lightImpact();
    audioHandler.skipToPrevious();
  } else if (details.primaryVelocity < 0) {
    HapticFeedback.lightImpact();
    audioHandler.skipToNext();
  }
}
