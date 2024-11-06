import 'package:discord_timestamp/timezone.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/date_time_to_convert/cubit.dart';
import 'app_preference_repository.dart';
import 'discord_timestamp_style.dart';
import 'time_picker.dart';

class TimestampFormatter extends StatelessWidget {
  const TimestampFormatter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DateTimeToConvertCubit(AppPreferenceRepository.instance),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: CopyableTime(),
              ),
            ),
            SizedBox(height: 16),
            DateTimePicker(),
          ],
        ),
      ),
    );
  }
}

class CopyableTime extends StatelessWidget {
  const CopyableTime({super.key});
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final style in DiscordTimestampStyle.values)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: TimeTile(timeStyle: style),
          ),
        ],
      ),
    );
  }
}

class TimeTile extends StatelessWidget {
  const TimeTile({super.key, required this.timeStyle});

  final DiscordTimestampStyle timeStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateTimeToConvertCubit, DateTimeToConvertState>(
      buildWhen: (previous, current) => current is DateTimeToConvertDateTimeUpdated || current is DateTimeToConvertTimezoneOffsetUpdated,
      builder: (context, state) {
        final dateTimeToConvertCubit = BlocProvider.of<DateTimeToConvertCubit>(context);
        final timeMessage = timeStyle.message(dateTimeToConvertCubit.utcDateTime);
        final timePreview = timeStyle.preview(
          DateTime.fromMillisecondsSinceEpoch(
            dateTimeToConvertCubit.utcDateTime.millisecondsSinceEpoch + localTimezoneOffset.inMilliseconds,
            isUtc: true,
          ),
          Localizations.localeOf(context),
        );
        return Tooltip(
          message: timePreview,
          preferBelow: false,
          child: OutlinedButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: timeMessage));
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    timeMessage,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: (Theme.of(context).textTheme.labelLarge ?? TextStyle()).copyWith(
                      fontFamily: "monospace",
                    ),
                  ),
                ),
                SizedBox(width: 8),
                const Icon(Icons.copy),
              ],
            ),
          ),
        );
      },
    );
  }
}
