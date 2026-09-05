import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/starting_screen.dart';

class DhanerPokaApp extends StatefulWidget {
  const DhanerPokaApp({this.home, super.key});

  /// tests use this to jump straight to a screen
  final Widget? home;

  @override
  State<DhanerPokaApp> createState() => _DhanerPokaAppState();
}

class _DhanerPokaAppState extends State<DhanerPokaApp> {
  late final LocaleController _localeController = LocaleController(
    kSupportedLocales.first,
  )..addListener(_onLocaleChanged);

  /// keep the loaded strings. if this is a Future rebuilt in build(), changing
  /// language throws away the whole nav stack while the new file loads.
  AppLocalizations? _localizations;

  @override
  void initState() {
    super.initState();
    _loadStrings(_localeController.value);
  }

  Future<void> _loadStrings(Locale locale) async {
    final AppLocalizations loaded = await AppLocalizations.load(locale);
    if (mounted) {
      setState(() => _localizations = loaded);
    }
  }

  void _onLocaleChanged() => _loadStrings(_localeController.value);

  @override
  void dispose() {
    _localeController
      ..removeListener(_onLocaleChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? localizations = _localizations;
    if (localizations == null) {
      return const SizedBox.shrink();
    }

    // these must sit above MaterialApp or pushed routes can't find them
    return LocaleScope(
      controller: _localeController,
      child: AppLocalizationsScope(
        localizations: localizations,
        child: MaterialApp(
          title: 'Dhaner Poka',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: _localeController.value,
          supportedLocales: kSupportedLocales,
          // needed for bn. without them every TextField throws
          // "No MaterialLocalizations found" the moment you switch.
          localizationsDelegates: const <LocalizationsDelegate<Object>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: widget.home ?? const StartingScreen(),
        ),
      ),
    );
  }
}
