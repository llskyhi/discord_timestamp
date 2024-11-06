part of 'cubit.dart';

@immutable
sealed class DateTimeToConvertState {
  @override
  String toString() => runtimeType.toString();
}

final class DateTimeToConvertInitial extends DateTimeToConvertState {}

final class DateTimeToConvertDateTimeUpdated extends DateTimeToConvertState {}

final class DateTimeToConvertTimezoneOffsetUpdated extends DateTimeToConvertState {}
