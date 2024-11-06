import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'timestamp_formatter.dart';

void main() async {

  final mainLocale = PlatformDispatcher.instance.locales[0];
  await initializeDateFormatting(mainLocale.languageCode);

  runApp(MaterialApp(
    title: 'discord_timestamp', // TODO: what does this do?
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
      ),
      useMaterial3: true,
    ),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: PlatformDispatcher.instance.locales,
    home: Scaffold(
      body: TimestampFormatter(),
    ),
  ));
}