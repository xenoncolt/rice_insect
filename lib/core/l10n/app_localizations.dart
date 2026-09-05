import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// languages we ship. add one here + drop assets/i18n/<code>.json next to
/// the others.
const List<Locale> kSupportedLocales = <Locale>[Locale('en'), Locale('bn')];

/// strings live in json as flat a.b.c keys, so translating never means
/// touching dart.
class AppLocalizations {
  const AppLocalizations(this.locale, this._strings);

  final Locale locale;
  final Map<String, String> _strings;

  static AppLocalizations of(BuildContext context) {
    final AppLocalizationsScope? scope = context
        .dependOnInheritedWidgetOfExactType<AppLocalizationsScope>();
    assert(scope != null, 'No AppLocalizationsScope found in context');
    return scope!.localizations;
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final String raw = await rootBundle.loadString(
      'assets/i18n/${locale.languageCode}.json',
    );
    final Map<String, dynamic> decoded =
        json.decode(raw) as Map<String, dynamic>;
    return AppLocalizations(locale, _flatten(decoded));
  }

  /// {"home": {"greeting": "Hi"}} -> {"home.greeting": "Hi"}
  static Map<String, String> _flatten(
    Map<String, dynamic> source, [
    String prefix = '',
  ]) {
    final Map<String, String> out = <String, String>{};
    source.forEach((String key, dynamic value) {
      final String path = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        out.addAll(_flatten(value, path));
      } else {
        out[path] = '$value';
      }
    });
    return out;
  }

  /// missing key returns the key itself, so I can see it on screen instead
  /// of getting a blank.
  ///
  /// params fills {name} holes: t('gallery.upload', {'count': '3'})
  String t(String key, [Map<String, String>? params]) {
    String value = _strings[key] ?? key;
    if (params != null) {
      params.forEach((String name, String replacement) {
        value = value.replaceAll('{$name}', replacement);
      });
    }
    return value;
  }
}

class AppLocalizationsScope extends InheritedWidget {
  const AppLocalizationsScope({
    required this.localizations,
    required super.child,
    super.key,
  });

  final AppLocalizations localizations;

  @override
  bool updateShouldNotify(AppLocalizationsScope oldWidget) =>
      localizations != oldWidget.localizations;
}

/// shortcut: context.tr('home.greeting')
extension AppLocalizationsX on BuildContext {
  String tr(String key, [Map<String, String>? params]) =>
      AppLocalizations.of(this).t(key, params);
}
