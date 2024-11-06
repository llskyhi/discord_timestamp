import 'package:shared_preferences/shared_preferences.dart';

class AppPreferenceRepository {
  static const preferredTimezoneOffsetKey = 'preferred-timezone-offset-milliseconds';

  static final instance = AppPreferenceRepository._();

  final _preference = SharedPreferencesAsync();

  AppPreferenceRepository._();

  Future<Duration?> get preferredTimezoneOffset async {
    late final int? preferredTimezoneOffsetMilliseconds;
    try {
      preferredTimezoneOffsetMilliseconds = await _preference.getInt(preferredTimezoneOffsetKey);
    }
    on TypeError {
      await _preference.remove(preferredTimezoneOffsetKey);
      preferredTimezoneOffsetMilliseconds = null;
    }
    return preferredTimezoneOffsetMilliseconds == null ? null : Duration(milliseconds: preferredTimezoneOffsetMilliseconds);
  }

  Future<void> setPreferredTimezoneOffset(Duration? timezoneOffset) async{
    if (timezoneOffset == null) {
      await _preference.remove(preferredTimezoneOffsetKey);
    }
    else {
      await _preference.setInt(preferredTimezoneOffsetKey, timezoneOffset.inMilliseconds);
    }
  }
}