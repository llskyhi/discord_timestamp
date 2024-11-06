import 'package:format/format.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

extension TimezoneOffset on Duration {
  String get utcOffsetName {
    return format(
      'UTC{}{:02}{:02}',
      isNegative ? '-' : '+',
      inHours.abs(),
      inMinutes.abs() % 60,
    );
  }
}

Set<Duration> _timezoneOffsets() {
  final numericTimezoneRegex = RegExp('^[+-]\\d{2}(\\d{2})?\$');
  tz.initializeTimeZones();
  return Set<Duration>.of(
    tz.timeZoneDatabase.locations.values
      .map((location) => location.zones)
      .expand(
        (timezones) => timezones
        .where((timezone) => numericTimezoneRegex.hasMatch(timezone.abbreviation))
        .map((timezone) => Duration(milliseconds: timezone.offset))
      ),
  );
}

final Duration localTimezoneOffset = DateTime.now().timeZoneOffset;
// NOTE: localTimezoneOffset should be already in [timezoneOffsets].
final Set<Duration> timezoneOffsets = _timezoneOffsets();
