import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/surface_card.dart';

/// Node 59:391 - greeting over a frosted weather panel, with a blurred green
/// bloom escaping the top-right corner.
///
/// The reading is live: coordinates from the device, forecast from Open-Meteo,
/// place name from the platform geocoder. Figma's single illustrated icon is
/// replaced by a per-condition icon, since one drawing cannot stand in for
/// fifteen weather states.
class WelcomeWeatherCard extends StatefulWidget {
  const WelcomeWeatherCard({this.service = const WeatherService(), super.key});

  /// Swapped for a fake in tests.
  final WeatherService service;

  @override
  State<WelcomeWeatherCard> createState() => _WelcomeWeatherCardState();
}

class _WelcomeWeatherCardState extends State<WelcomeWeatherCard> {
  late Future<WeatherSnapshot> _weather = widget.service.load();

  void _retry() {
    setState(() => _weather = widget.service.load());
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      height: 327,
      clipContents: true,
      padding: const EdgeInsets.all(33),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: -161,
            right: -97,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  color: AppColors.decorationGlow.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          FutureBuilder<WeatherSnapshot>(
            future: _weather,
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<WeatherSnapshot> snapshot,
                ) {
                  final WeatherSnapshot? data = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _Greeting(placeName: data?.placeName),
                      _WeatherPanel(
                        snapshot: snapshot,
                        onRetry: _retry,
                      ),
                    ],
                  );
                },
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.placeName});

  final String? placeName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.tr('home.greeting'), style: AppText.body),
        const SizedBox(height: 4),
        // Figma reserves an empty 48pt block here; the resolved place sits in it.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: placeName == null
              ? const SizedBox(key: ValueKey<String>('no-place'), height: 20)
              : Row(
                  key: ValueKey<String>(placeName!),
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: <Widget>[
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                    Text(placeName!, style: AppText.caption),
                  ],
                ),
        ),
      ],
    );
  }
}

class _WeatherPanel extends StatelessWidget {
  const _WeatherPanel({required this.snapshot, required this.onRetry});

  final AsyncSnapshot<WeatherSnapshot> snapshot;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: _content(context),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final WeatherSnapshot? data = snapshot.data;
    if (data != null) {
      return _Reading(data: data);
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _Message(text: context.tr('home.weather.loading'), busy: true);
    }
    return _Message(
      text: context.tr(_failureKey(snapshot.error)),
      onRetry: onRetry,
      retryLabel: context.tr('home.weather.retry'),
    );
  }

  String _failureKey(Object? error) {
    if (error is WeatherException) {
      return switch (error.failure) {
        WeatherFailure.permissionDenied => 'home.weather.locationDenied',
        WeatherFailure.locationServicesOff => 'home.weather.locationOff',
        WeatherFailure.unavailable => 'home.weather.unavailable',
      };
    }
    return 'home.weather.unavailable';
  }
}

class _Reading extends StatelessWidget {
  const _Reading({required this.data});

  final WeatherSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${data.temperatureC.round()}°C',
                    style: AppText.display,
                  ),
                  Text(
                    context.tr(weatherConditionKey(data.weatherCode)),
                    style: AppText.bodyMuted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              _conditionIcon(data.weatherCode),
              size: 56,
              color: _conditionColor(data.weatherCode),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(top: 9),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.outline.withValues(alpha: 0.2)),
            ),
          ),
          child: Row(
            children: <Widget>[
              _WeatherMetric(
                icon: Icons.thermostat,
                label: context.tr('home.weather.highLow', <String, String>{
                  'high': '${data.highC.round()}',
                  'low': '${data.lowC.round()}',
                }),
              ),
              const SizedBox(width: 12),
              _WeatherMetric(
                icon: Icons.water_drop,
                label: context.tr('home.weather.humidity', <String, String>{
                  'humidity': '${data.humidityPercent}',
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static IconData _conditionIcon(int code) {
    return switch (code) {
      0 || 1 => Icons.wb_sunny,
      2 => Icons.wb_cloudy,
      3 => Icons.cloud,
      45 || 48 => Icons.blur_on,
      51 || 53 || 55 || 56 || 57 => Icons.grain,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => Icons.umbrella,
      71 || 73 || 75 || 77 || 85 || 86 => Icons.ac_unit,
      95 || 96 || 99 => Icons.flash_on,
      _ => Icons.help_outline,
    };
  }

  static Color _conditionColor(int code) {
    return switch (code) {
      0 || 1 => const Color(0xFFF5A623),
      95 || 96 || 99 => const Color(0xFFB8860B),
      71 || 73 || 75 || 77 || 85 || 86 => const Color(0xFF7FB2E5),
      _ => AppColors.onSurfaceVariant,
    };
  }
}

/// Keeps the panel the same height whether it is loading, failed, or showing a
/// reading, so the card never jumps.
class _Message extends StatelessWidget {
  const _Message({
    required this.text,
    this.busy = false,
    this.onRetry,
    this.retryLabel,
  });

  final String text;
  final bool busy;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 91,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            spacing: 12,
            children: <Widget>[
              if (busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(
                  Icons.cloud_off,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
              Expanded(
                child: Text(
                  text,
                  style: AppText.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (onRetry != null) ...<Widget>[
            const SizedBox(height: 8),
            InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  retryLabel ?? '',
                  style: AppText.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  const _WeatherMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: AppText.caption),
      ],
    );
  }
}
