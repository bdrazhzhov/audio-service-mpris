part of 'audio_service_mpris.dart';

class _Defaults {
  final String dBusName;
  final bool fullscreen;
  final bool canSetFullscreen;
  final String identity;
  final String desktopEntry;
  final List<String> supportedUriSchemes;
  final List<String> supportedMimeTypes;
  final double minimumRate;
  final double maximumRate;
  final bool canGoNext;
  final bool canGoPrevious;
  final bool canPlay;
  final bool canPause;
  final bool canControl;
  final void Function()? onQuitRequest;
  final void Function()? onRaiseRequest;

  _Defaults({
    this.dBusName = 'audio_service',
    this.fullscreen = false,
    this.canSetFullscreen = false,
    this.identity = 'My Audio Player',
    this.desktopEntry = '',
    List<String>? supportedUriSchemes,
    List<String>? supportedMimeTypes,
    this.minimumRate = 1.0,
    this.maximumRate = 1.0,
    this.canGoNext = false,
    this.canGoPrevious = false,
    this.canPlay = false,
    this.canPause = false,
    this.canControl = false,
    this.onQuitRequest,
    this.onRaiseRequest,
  })  : supportedUriSchemes = supportedUriSchemes ?? [],
        supportedMimeTypes = supportedMimeTypes ?? [];
}
