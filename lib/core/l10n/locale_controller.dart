import 'package:flutter/material.dart';

/// current locale. set it with LocaleScope.of(context).value = ...
class LocaleController extends ValueNotifier<Locale> {
  LocaleController(super.value);
}

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    required LocaleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final LocaleScope? scope = context
        .dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'No LocaleScope found in context');
    return scope!.notifier!;
  }
}
