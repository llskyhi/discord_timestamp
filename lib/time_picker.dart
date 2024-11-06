import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

import 'bloc/date_time_to_convert/cubit.dart';
import 'timezone.dart';

class DateTimePicker extends StatelessWidget {
  static final DateTime _firstDate = DateTime.utc(00000, 01, 01);
  static final DateTime _lastDate = DateTime.utc(10000, 12, 31);
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  const DateTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final timezoneOffsetsList = timezoneOffsets.toList()..sort();
    return BlocBuilder<DateTimeToConvertCubit, DateTimeToConvertState>(
      builder: (context, state) {
        final dateTimeToConvertCubit = BlocProvider.of<DateTimeToConvertCubit>(context);

        return Column(
          children: [
            TextButton.icon(
              icon: Icon(Icons.public),
              label: Text(dateTimeToConvertCubit.timezoneOffset.utcOffsetName),
              onPressed: () async {
                Duration? pickedTimezoneOffset = await showMaterialScrollPicker(
                  context: context,
                  title: 'Timezone Offset', // TODO: localization?
                  items: timezoneOffsetsList,
                  selectedItem: dateTimeToConvertCubit.timezoneOffset,
                  transformer: (timezoneOffset) => timezoneOffset.utcOffsetName,
                );
                if (pickedTimezoneOffset == null) {
                  return;
                }
                dateTimeToConvertCubit.setPreferredTimezoneOffset(pickedTimezoneOffset);
              },
              onLongPress: () {
                dateTimeToConvertCubit.setPreferredTimezoneOffset(null);
              },
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              icon: Icon(Icons.date_range_outlined),
              label: Text(_dateFormat.format(dateTimeToConvertCubit.localDateTime)),
              onPressed: () async {
                final DateTime currentLocalDateTime = DateTime.fromMillisecondsSinceEpoch(
                  DateTime.timestamp().millisecondsSinceEpoch + dateTimeToConvertCubit.timezoneOffset.inMilliseconds,
                  isUtc: true,
                );
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dateTimeToConvertCubit.localDateTime,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  currentDate: currentLocalDateTime,
                );
                if (pickedDate == null) {
                  return;
                }
                dateTimeToConvertCubit.setLocalDate(pickedDate);
              },
              onLongPress: () {
                final currentLocalDateTime = DateTime.fromMillisecondsSinceEpoch(
                  DateTime.timestamp().millisecondsSinceEpoch + dateTimeToConvertCubit.timezoneOffset.inMilliseconds,
                  isUtc: true,
                );
                dateTimeToConvertCubit.setLocalDateTime(dateTimeToConvertCubit.localDateTime.copyWith(
                  year: currentLocalDateTime.year,
                  month: currentLocalDateTime.month,
                  day: currentLocalDateTime.day,
                  hour: currentLocalDateTime.hour,
                  minute: currentLocalDateTime.minute,
                ));
              },
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              icon: Icon(Icons.timer_outlined),
              label: Text(_timeFormat.format(dateTimeToConvertCubit.localDateTime)),
              onPressed: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(dateTimeToConvertCubit.localDateTime),
                );
                if (pickedTime == null) {
                  return;
                }
                dateTimeToConvertCubit.setLocalTime(dateTimeToConvertCubit.localDateTime.copyWith(
                  hour: pickedTime.hour,
                  minute: pickedTime.minute,
                ));
              },
              onLongPress: () {
                dateTimeToConvertCubit.setLocalTime(dateTimeToConvertCubit.localDateTime.copyWith(
                  hour: 00,
                  minute: 00,
                ));
              },
            ),
          ],
        );
      }
    );
  }
}
