import 'package:dbus/dbus.dart';

/// https://www.freedesktop.org/wiki/Specifications/mpris-spec/metadata/
class Metadata {
  Metadata(
      {required this.trackId,
      required this.title,
      this.length,
      this.artist,
      this.lyrics,
      this.artUrl,
      this.album,
      this.albumArtist,
      this.discNumber,
      this.trackNumber,
      this.genre});

  /// mpris:trackid
  ///
  /// D-Bus path: A unique identity for this track within the context of an MPRIS object (eg: tracklist).
  final String trackId;

  /// xesam:title
  ///
  /// String: The track title.
  final String title;

  /// mpris:length
  ///
  /// 64-bit integer: The duration of the track in microseconds.
  final Duration? length;

  /// xesam:artist
  ///
  /// List of Strings: The track artist(s).
  final List<String>? artist;

  /// xesam:asText
  ///
  /// String: The track lyrics.
  final String? lyrics;

  /// mpris:artUrl
  ///
  /// URI: The location of an image representing the track or album. Clients should not assume this will continue to exist when the media player stops giving out the URL.
  final String? artUrl;

  /// xesam:album
  ///
  /// String: The album name.
  final String? album;

  /// xesam:albumArtist
  ///
  /// List of Strings: The album artist(s).
  final List<String>? albumArtist;

  /// xesam:discNumber
  ///
  /// Integer: The disc number on the album that this track is from.
  final int? discNumber;

  /// xesam:trackNumber
  ///
  /// Integer: The track number on the album disc.
  final int? trackNumber;

  /// xesam:genre
  ///
  /// List of Strings: The genre(s) of the track.
  final List<String>? genre;

  // xesam:audioBPM
  // Integer: The speed of the music, in beats per minute.
  //
  // xesam:autoRating
  // Float: An automatically-generated rating, based on things such as how often it has been played. This should be in the range 0.0 to 1.0.
  //
  // xesam:comment
  // List of Strings: A (list of) freeform comment(s).
  //
  // xesam:composer
  // List of Strings: The composer(s) of the track.
  //
  // xesam:contentCreated
  // Date/Time: When the track was created. Usually only the year component will be useful.
  //
  // xesam:firstUsed
  // Date/Time: When the track was first played.
  //
  // xesam:lastUsed
  // Date/Time: When the track was last played.
  //
  // xesam:lyricist
  // List of Strings: The lyricist(s) of the track.
  //
  // xesam:url
  // URI: The location of the media file.
  //
  // xesam:useCount
  // Integer: The number of times the track has been played.
  //
  // xesam:userRating
  // Float: A user-specified rating. This should be in the range 0.0 to 1.0.

  DBusValue toValue() {
    final result = DBusDict.stringVariant({
      "mpris:trackid": DBusObjectPath(trackId),
      "xesam:title": DBusString(title),
      if (length != null) "mpris:length": DBusInt64(length!.inMicroseconds),
      if (artist != null) "xesam:artist": DBusArray.string(artist!),
      if (lyrics != null) "xesam:asText": DBusString(lyrics!),
      if (artUrl != null) "mpris:artUrl": DBusString(artUrl!),
      if (album != null) "xesam:album": DBusString(album!),
      if (albumArtist != null)
        "xesam:albumArtist": DBusArray.string(albumArtist!),
      if (discNumber != null) "xesam:discNumber": DBusInt64(discNumber!),
      if (trackNumber != null) "xesam:trackNumber": DBusInt64(trackNumber!),
      if (genre != null) "xesam:genre": DBusArray.string(genre!),
    });
    return result;
  }

  Metadata copyWith(
      {String? trackId,
      String? title,
      Duration? length,
      List<String>? artist,
      String? lyrics,
      String? artUrl,
      String? album,
      List<String>? albumArtist,
      int? discNumber,
      int? trackNumber,
      List<String>? genre}) {
    return Metadata(
      trackId: trackId ?? this.trackId,
      title: title ?? this.title,
      length: length ?? this.length,
      artist: artist ?? this.artist,
      lyrics: lyrics ?? this.lyrics,
      artUrl: artUrl ?? this.artUrl,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      discNumber: discNumber ?? this.discNumber,
      trackNumber: trackNumber ?? this.trackNumber,
      genre: genre ?? this.genre,
    );
  }
}
