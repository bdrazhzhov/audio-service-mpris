## 0.1.2

Fixed additional [issue](https://github.com/bdrazhzhov/audio-service-mpris/issues/1#issuecomment-1814442658): all received `MediaItem` ids are being mapped to uuid strings that allows to avoid invalid dbus path object creation for `trackId` field of `org.mpris.MediaPlayer2.Player.Metadata` property. 

## 0.1.1

Fixed issue [#1](https://github.com/bdrazhzhov/audio-service-mpris/issues/1): `androidNotificationChannelId` is used as a part of dbus interface name for an application instance now.

## 0.1.0

First release
