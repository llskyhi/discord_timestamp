import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../app_preference_repository.dart';
import '../../timezone.dart';

part 'state.dart';

class DateTimeToConvertCubit extends Cubit<DateTimeToConvertState> {
  final AppPreferenceRepository _appPreferenceRepository;
  Duration? _preferredTimezoneOffset;
  DateTime _utcDateTime = _truncateAccuracy(DateTime.timestamp());

  DateTimeToConvertCubit(this._appPreferenceRepository) : super(DateTimeToConvertInitial()) {
    _appPreferenceRepository.preferredTimezoneOffset.then((preferredTimezoneOffset) {
      _setPreferredTimezoneOffset(preferredTimezoneOffset);
    });
  }

  Duration get timezoneOffset => _preferredTimezoneOffset ?? localTimezoneOffset;

  DateTime get utcDateTime => _utcDateTime;

  DateTime get localDateTime => DateTime.fromMillisecondsSinceEpoch(
    utcDateTime.millisecondsSinceEpoch + timezoneOffset.inMilliseconds,
    isUtc: true,
  );

  void setPreferredTimezoneOffset(final Duration? newTimezoneOffset) {
    _appPreferenceRepository.setPreferredTimezoneOffset(newTimezoneOffset).then((_) {
      _setPreferredTimezoneOffset(newTimezoneOffset);
    });
  }

  void setLocalDateTime(final DateTime newLocalDateTime) => _setUtcDateTime(DateTime.fromMillisecondsSinceEpoch(
    newLocalDateTime.millisecondsSinceEpoch - timezoneOffset.inMilliseconds,
    isUtc: true,
  ));

  void setLocalDate(final DateTime newLocalDate) => setLocalDateTime(localDateTime.copyWith(
    year: newLocalDate.year,
    month: newLocalDate.month,
    day: newLocalDate.day,
  ));

  void setLocalTime(final DateTime newLocalTime) => setLocalDateTime(localDateTime.copyWith(
    hour: newLocalTime.hour,
    minute: newLocalTime.minute,
  ));

  /// Truncate a DateTime object's unused precision.
  static DateTime _truncateAccuracy(final DateTime time) {
    if (time.microsecondsSinceEpoch % (60 * 1000 * 1000) == 0) {
      return time;
    }
    return time.copyWith(
      // The only reason why here dropping seconds is that
      // the time picker UI current implementation is using doesn't provide seconds.
      second: 0,
      // The milliseconds/microseconds part of a DateTime object do not matter for this application
      // as Discord uses timestamp in precision of seconds.
      millisecond: 0,
      microsecond: 0,
    );
  }

  void _setPreferredTimezoneOffset(final Duration? newTimezoneOffset) {
    if (_preferredTimezoneOffset == newTimezoneOffset) {
      return;
    }
    _preferredTimezoneOffset = newTimezoneOffset;
    emit(DateTimeToConvertTimezoneOffsetUpdated());
  }

  void _setUtcDateTime(DateTime newUtcDateTime) {
    newUtcDateTime = _truncateAccuracy(newUtcDateTime);
    if (_utcDateTime == newUtcDateTime) {
      return;
    }
    _utcDateTime = newUtcDateTime;
    emit(DateTimeToConvertDateTimeUpdated());
  }
}
