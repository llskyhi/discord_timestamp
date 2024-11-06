import 'dart:ui';

import 'package:intl/intl.dart';

enum DiscordTimestampStyle {
  // https://discord.com/developers/docs/reference#message-formatting
  shortTime    ('t',    'Short Time'),
   longTime    ('T',     'Long Time'),
  shortDate    ('d',    'Short Date'),
   longDate    ('D',     'Long Date'),
  shortDateTime('f',    'Short Date/Time'),
  longDateTime ('F',     'Long Date/Time'),
  relativeTime ('R', 'Relative Time'),
  ;

  final String style;
  final String description;

  const DiscordTimestampStyle(this.style, this.description);

  static DiscordTimestampStyle fromDescription(String description) {
    return values.firstWhere((value) => value.description == description);
  }

  String message(final DateTime time) => "<t:${time.millisecondsSinceEpoch ~/ 1000}:$style>";
  String preview(final DateTime time, [final Locale? locale]) {
    // https://unicode-org.github.io/icu/userguide/format_parse/datetime/#formatting-dates
    // https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
    switch (this) {
      case shortTime:
        return DateFormat.Hm(locale?.languageCode).format(time);
      case longTime:
        return DateFormat.Hms(locale?.languageCode).format(time);
      case shortDate:
        return DateFormat.yMd(locale?.languageCode).format(time);
      case longDate:
        return DateFormat.yMMMMd(locale?.languageCode).format(time);
      case shortDateTime:
        return '${DateFormat.yMMMMd(locale?.languageCode).format(time)} ${DateFormat.Hm(locale?.languageCode).format(time)}';
      case longDateTime:
        return '${DateFormat.yMMMMEEEEd(locale?.languageCode).format(time)} ${DateFormat.Hm(locale?.languageCode).format(time)}';
      case relativeTime:
        return '(preview not implemented)'; // TODO
    }
  }
}
