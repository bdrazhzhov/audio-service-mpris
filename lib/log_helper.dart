part of 'audio_service_mpris.dart';

void _log(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (AudioServiceMpris.enableLogging) {
    developer.log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: 'audio_service_mpris',
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
