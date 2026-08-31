import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/starting_screen.dart';

class DhanerPokaApp extends StatefulWidget {
  const DhanerPokaApp({this.home, super.key});

  /// Overridden by tests that want to land on a specific screen instead of
  /// walking the splash and login flow.
  final Widget? home;

  @override
  State<DhanerPokaApp> createState() => _DhanerPokaAppState();
}

class _DhanerPokaAppState extends State<DhanerPokaApp> {
  late final LocaleController _localeController = LocaleController(
    kSupportedLocales.first,
  )..addListener(_onLocaleChanged);

  /// Held rather than rebuilt from a Future on every frame: swapping languages
  /// keeps the previous strings on screen until the new file has loaded, so the
  /// navigation stack is never torn down mid-flow.
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

    // Both scopes sit above MaterialApp so that pushed routes - which build
    // under the Navigator - can still reach them.
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
          // Without these, Material's own strings resolve only for English and
          // every TextField throws "No MaterialLocalizations found" as soon as
          // the locale is Bengali.
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
