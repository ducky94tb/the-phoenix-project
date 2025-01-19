import 'dart:io';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
// import 'package:device_info/device_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phoenix/src/beginning/begin.dart';
import 'package:phoenix/src/beginning/utilities/apis/image_scrape.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/mansion_back.dart';

import 'has_network.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

cacheImages() async {
  applicationFileDirectory = await getApplicationDocumentsDirectory();
  // next update -> https://www.pexels.com/photo/white-and-black-fur-textile-1793273/
  ByteData bytes =
      await rootBundle.load('assets/res/pexels-lucas-cavalcante-1793273.jpg');
  art = bytes.buffer.asUint8List();
  defaultArt = art;
  if (!await File("${applicationFileDirectory.path}/artworks/null.jpeg")
      .exists()) {
    ByteData bites = await rootBundle.load('assets/res/default.jpg');
    defaultNone = bites.buffer.asUint8List();
  } else {
    defaultNone =
        await File("${applicationFileDirectory.path}/artworks/null.jpeg")
            .readAsBytes();
  }
}

dataInit() async {
  await Hive.initFlutter();

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ),
  );
  remoteConfig.onConfigUpdated.listen((event) async {
    await remoteConfig.fetchAndActivate();
  });
  await remoteConfig.fetchAndActivate();

  musicBox = await Hive.openBox('musicDataBox');
  // var info = await DeviceInfoPlugin().androidInfo;
  // androidSdkVersion = info.version.sdkInt;
  // if (androidSdkVersion >= 30) {
  //   MetadataGod.initialize();
  // }
  // isAndroid11Above = info.version.sdkInt > 29 ? true : false;
  glassBlur = ImageFilter.blur(
      sigmaX: musicBox.get("glassBlur") ?? 10,
      sigmaY: musicBox.get("glassBlur") ?? 10);
  glassOpacity =
      Colors.white.withOpacity((musicBox.get("glassOverlayColor") ?? 2) / 100);
  glassShadowOpacity = musicBox.get("glassShadow") ?? 6;
}

//  bool _hasPermission = false;
//   checkAndRequestPermissions({bool retry = false}) async {
//     final OnAudioQuery _audioQuery = OnAudioQuery();
//     // The param 'retryRequest' is false, by default.
//     _hasPermission = await _audioQuery.checkAndRequest(
//       retryRequest: retry,
//     );

// Only call update the UI if application has all required permissions.
// _hasPermission ? setState(() {}) : null;
// }

fetchSongs() async {}

fetchAll() async {
  await gettinAlbums();
  await gettinAlbumsArts();
  await gettinMansion();
  await songListToMediaItem();
  /*await gettinArtists();
  await gettinArtistsAlbums();
  await gettinGenres();
  await smartArtistsArts();*/
  ascend = true;
  debugPrint("ASCENDED");
  rootState.provideman();
  if (musicBox.get("isolation") == null
      ? true
      : !musicBox.get("isolation") && await hasNetwork()) {
    /// TODO do scraping only when phone's awake so you don't get HandshakeException: Connection terminated during handshake
    isolatedArtistScrapeInit();
  }
  Begin.isLoading = false;
}

songListToMediaItem() async {
  songListMediaItems = [];
  for (int i = 0; i < songList.length; i++) {
    MediaItem item = MediaItem(
        id: songList[i].data,
        album: songList[i].album,
        artist: songList[i].artist,
        duration: Duration(milliseconds: getDuration(songList[i])!),
        artUri: Uri.parse(songList[i].getMap["image"]),
        title: songList[i].title,
        extras: {"id": songList[i].id});
    songListMediaItems.add(item);
  }
}
