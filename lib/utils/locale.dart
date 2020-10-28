import 'dart:convert';

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final localizationsDelegates = <LocalizationsDelegate>[
  const I18nDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

class I18n {
  I18n(this.locale);

  final Locale locale;

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  Map<String, String> _localizedValues;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedValues =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String msg(String key) => _localizedValues[key];
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  // @override
  // Future<I18n> load(Locale locale) {
  //   return SynchronousFuture<I18n>(I18n(locale));
  // }
  @override
  Future<I18n> load(Locale locale) async {
    I18n localizations = I18n(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
}
