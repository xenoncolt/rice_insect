import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Locales the app ships translation files for. Add a locale here and drop a
/// matching `assets/i18n/<code>.json` next to the existing ones.
const List<Locale> kSupportedLocales = <Locale>[Locale('en'), Locale('bn')];

/// Strings are held in flat `a.b.c` keys read from `assets/i18n/<code>.json`,
/// so translations can be edited without touching Dart code.
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

  /// `{"home": {"greeting": "Hi"}}` becomes `{"home.greeting": "Hi"}`.
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

  /// Returns the key itself when a translation is missing, which makes an
  /// untranslated string obvious on screen rather than silently blank.
  ///
  /// [params] fills `{name}` placeholders, so a translator can move the value
  /// to wherever it belongs in their sentence:
  /// `t('gallery.upload', {'count': '3'})`.
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

/// Shorthand: `context.tr('home.greeting')`.
extension AppLocalizationsX on BuildContext {
  String tr(String key, [Map<String, String>? params]) =>
      AppLocalizations.of(this).t(key, params);
}
