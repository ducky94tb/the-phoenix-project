import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';

import '../../pages/albums/albums.dart';

List<AlbumModel> allAlbums = [];
List<RssFeed> allRss = [];
List<String?> allAlbumsName = [];
Map<String, Uint8List?> albumsArts = {};
List<SongModel> inAlbumSongs = [];
List inAlbumSongsArtIndex = [];
List? insideInAlbumSongs = [];
int? numberOfAlbumArtist;
List<MediaItem> albumMediaItems = [];
Map<int, Uint8List?> artworksData = {};
List<int> allSongIds = [];

List<String> rssUrls = [
  'https://anchor.fm/s/ffb9e650/podcast/rss',
];

Future<RssFeed?> loadFeed(String rssUrl) async {
  try {
    final response = await http.get(Uri.parse(rssUrl));
    if (response.statusCode == 200) {
      final rssFeed = RssFeed.parse(response.body);
      return rssFeed;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

Future<Uint8List?> getImageBytes(String imageUrl) async {
  try {
    // Fetch the image data from the URL
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Return the image data as a Uint8List
      return response.bodyBytes;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

//TODO albumModel's album on_audio_query returns null while it is not nullable. See error in the page end which was reported from one device.
gettinAlbums() async {
  allRss = [];
  allAlbums = [];
  albumsArts = {};
  inAlbumSongs = [];
  inAlbumSongsArtIndex = [];
  insideInAlbumSongs = [];
  allAlbumsName = [];
  songList = [];
  List songSortTypes = [
    SongSortType.TITLE,
    SongSortType.DATE_ADDED,
    SongSortType.ALBUM,
    SongSortType.ARTIST
  ];
  final sortType = songSortTypes[(musicBox.get('trackSort') ?? [0])[0]];
  final orderType = (musicBox.get('trackSort') ?? [0, 4])[1] == 4
      ? OrderType.ASC_OR_SMALLER
      : OrderType.DESC_OR_GREATER;
  for (int i = 0; i < rssUrls.length; i++) {
    var rssFeed = await loadFeed(rssUrls[i]);
    if (rssFeed != null) {
      allRss.add(rssFeed);
      var album = AlbumModel({
        "_id": rssFeed.hashCode,
        "album": rssFeed.title,
        "artist": rssFeed.author,
        "numsongs": rssFeed.items.length,
        "image": rssFeed.image?.url,
      });
      allAlbums.add(album);
      allAlbumsName.add(rssFeed.title);
      final items = rssFeed.items;
      for (int i = 0; i < items.length; i++) {
        final model = songModelFromRssItem(items[i], album);
        songList.add(model);
      }
    }
  }
  songList.sort(
    (a, b) {
      int r = 0;
      switch (sortType) {
        case SongSortType.TITLE:
          r = a.title.compareTo(b.title);
          break;
        case SongSortType.DATE_ADDED:
          var timeA = _parseUTC(b.getMap['pubDate'] as String);
          var timeB = _parseUTC(a.getMap['pubDate'] as String);
          r = timeA.compareTo(timeB);
          break;
        case SongSortType.ALBUM:
          r = a.album?.compareTo(b?.album ?? "") ?? 0;
          break;
        case SongSortType.ARTIST:
          r = a.artist?.compareTo(b?.artist ?? "") ?? 0;
          break;
      }
      return orderType == OrderType.ASC_OR_SMALLER ? r : -r;
    },
  );
}

DateTime _parseUTC(String utc) {
  DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
  DateTime date = format.parseUTC(utc);
  return date;
}

gettinAlbumsArts() async {
  List<String> albumswoArt = [];
  if (!await Directory("${applicationFileDirectory.path}/artworks").exists()) {
    await Directory("${applicationFileDirectory.path}/artworks").create();
  }
  if (!await File("${applicationFileDirectory.path}/artworks/null.jpeg")
      .exists()) {
    ByteData bytes = await rootBundle.load("assets/res/default.jpg");
    Uint8List data = bytes.buffer.asUint8List();
    await File("${applicationFileDirectory.path}/artworks/null.jpeg")
        .writeAsBytes(data);
  }
  for (int i = 0; i < allAlbums.length; i++) {
    final album = allAlbums[i];
    if (await File(
            "${applicationFileDirectory.path}/artworks/${album.album.replaceAll(RegExp(r'[^\w\s]+'), '')}.jpeg")
        .exists()) {
      albumsArts[album.album] = await File(
              "${applicationFileDirectory.path}/artworks/${album.album.replaceAll(RegExp(r'[^\w\s]+'), '')}.jpeg")
          .readAsBytes();
    } else {
      final imageUrl = album.getMap["image"];
      if (imageUrl != null) {
        albumsArts[album.album] = await getImageBytes(imageUrl);
      }
      /*albumsArts[allAlbums[i].album] = await OnAudioQuery().queryArtwork(
          allAlbums[i].id, ArtworkType.ALBUM,
          format: ArtworkFormat.JPEG, size: 375);*/
      if (albumsArts[allAlbums[i].album] != null) {
        await File(
                "${applicationFileDirectory.path}/artworks/${allAlbums[i].album.replaceAll(RegExp(r'[^\w\s]+'), '')}.jpeg")
            .writeAsBytes(albumsArts[allAlbums[i].album]!,
                mode: FileMode.write);
      } else {
        albumswoArt.add(allAlbums[i].album);
      }
    }
  }
  musicBox.put("AlbumsWithoutArt", albumswoArt);
}

songModelFromRssItem(RssItem item, AlbumModel album) {
  var enclosure = item.enclosure;
  final extension = enclosure?.url?.split('.').last ?? ".mp3";
  return SongModel({
    "_id": item.hashCode,
    "_display_name": item.title ?? "-",
    "_display_name_wo_ext": item.title ?? "-",
    "_uri": enclosure?.url,
    "title": item.title ?? "-",
    "file_extension": extension,
    "album": album.album,
    "album_id": album.id,
    "artist": item.author ?? album.artist ?? "-",
    "is_podcast": true,
    "_size": enclosure?.length ?? -1,
    "_data": enclosure?.url ?? "",
    "pubDate": item.pubDate,
    "description": item.description,
    "duration": enclosure?.length ?? -1,
    "length": enclosure?.length,
    "type": enclosure?.type,
    "image": item.itunes?.image?.href,
  });
}

albumSongs() async {
  bool sortByDate =
      (musicBox.get('albumSort') ?? [0, 2])[0] == 0 ? true : false;
  bool sortAscending =
      (musicBox.get('albumSort') ?? [0, 2])[1] == 2 ? true : false;
  final rssFeed = allRss[passedIndexAlbum!];
  final album = allAlbums[passedIndexAlbum!];
  var items = rssFeed.items;
  for (int i = 0; i < items.length; i++) {
    SongModel model = songModelFromRssItem(items[i], album);
    inAlbumSongs.add(model);
  }
  inAlbumSongs.sort(
    (a, b) {
      int r;
      if (sortByDate) {
        r = (a.getMap['pubDate'] as String)
            .compareTo(b.getMap['pubDate'] as String);
      } else {
        r = a.title.compareTo(b.title);
      }
      return sortAscending ? r : -r;
    },
  );
  for (int i = 0; i < inAlbumSongs.length; i++) {
    MediaItem mi = MediaItem(
        id: inAlbumSongs[i].data,
        album: inAlbumSongs[i].album,
        title: inAlbumSongs[i].title,
        artist: inAlbumSongs[i].artist,
        duration: Duration(milliseconds: getDuration(inAlbumSongs[i])!),
        artUri: Uri.tryParse(inAlbumSongs[i].getMap["image"] ?? "-"),
        extras: {"id": inAlbumSongs[i].id});
    albumMediaItems.add(mi);
    inAlbumSongsArtIndex.add(i);
  }
}
