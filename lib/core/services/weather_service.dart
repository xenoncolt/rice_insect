import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// why the lookup failed. each one gets its own message on the home card so
/// the user knows what to actually do about it.
enum WeatherFailure { locationServicesOff, permissionDenied, unavailable }

class WeatherException implements Exception {
  const WeatherException(this.failure);

  final WeatherFailure failure;

  @override
  String toString() => 'WeatherException($failure)';
}

/// one reading for wherever the user is
class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperatureC,
    required this.highC,
    required this.lowC,
    required this.humidityPercent,
    required this.weatherCode,
    this.placeName,
  });

  final double temperatureC;
  final double highC;
  final double lowC;
  final int humidityPercent;

  /// WMO code, see weatherConditionKey
  final int weatherCode;

  /// town/district from reverse geocoding. null is fine, the reading still
  /// works without it.
  final String? placeName;
}

/// live weather.
///
/// open-meteo needs no api key or account, and the place name comes from the
/// phone's own geocoder, so nothing here costs money.
class WeatherService {
  const WeatherService();

  static const Duration _networkTimeout = Duration(seconds: 15);
  static const Duration _locationTimeout = Duration(seconds: 20);

  Future<WeatherSnapshot> load() async {
    final Position position = await _resolvePosition();
    final Map<String, dynamic> forecast = await _fetchForecast(
      position.latitude,
      position.longitude,
    );
    final String? place = await _resolvePlaceName(
      position.latitude,
      position.longitude,
    );

    try {
      final Map<String, dynamic> current =
          forecast['current'] as Map<String, dynamic>;
      final Map<String, dynamic> daily =
          forecast['daily'] as Map<String, dynamic>;

      return WeatherSnapshot(
        temperatureC: (current['temperature_2m'] as num).toDouble(),
        humidityPercent: (current['relative_humidity_2m'] as num).round(),
        weatherCode: (current['weather_code'] as num).toInt(),
        highC: ((daily['temperature_2m_max'] as List<dynamic>).first as num)
            .toDouble(),
        lowC: ((daily['temperature_2m_min'] as List<dynamic>).first as num)
            .toDouble(),
        placeName: place,
      );
    } on Object {
      throw const WeatherException(WeatherFailure.unavailable);
    }
  }

  Future<Position> _resolvePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const WeatherException(WeatherFailure.locationServicesOff);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const WeatherException(WeatherFailure.permissionDenied);
    }

    try {
      // medium accuracy is fine for weather and way faster than a gps fix
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: _locationTimeout,
        ),
      );
    } on Object {
      // an old fix beats no weather at all
      final Position? last = await Geolocator.getLastKnownPosition();
      if (last == null) {
        throw const WeatherException(WeatherFailure.unavailable);
      }
      return last;
    }
  }

  Future<Map<String, dynamic>> _fetchForecast(double lat, double lon) async {
    final Uri uri = Uri.https('api.open-meteo.com', '/v1/forecast', <String, String>{
      'latitude': lat.toStringAsFixed(4),
      'longitude': lon.toStringAsFixed(4),
      'current': 'temperature_2m,relative_humidity_2m,weather_code',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
      'forecast_days': '1',
    });

    try {
      final http.Response response = await http
          .get(uri)
          .timeout(_networkTimeout);
      if (response.statusCode != 200) {
        throw const WeatherException(WeatherFailure.unavailable);
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on WeatherException {
      rethrow;
    } on Object {
      throw const WeatherException(WeatherFailure.unavailable);
    }
  }

  /// best effort, never fail the reading just because of the name
  Future<String?> _resolvePlaceName(double lat, double lon) async {
    try {
      // geocoding 5.x moved this onto a Geocoding instance
      final List<Placemark> marks = await Geocoding().placemarkFromCoordinates(
        lat,
        lon,
      );
      if (marks.isEmpty) {
        return null;
      }
      final Placemark mark = marks.first;
      for (final String? candidate in <String?>[
        mark.locality,
        mark.subAdministrativeArea,
        mark.administrativeArea,
        mark.country,
      ]) {
        if (candidate != null && candidate.trim().isNotEmpty) {
          return candidate.trim();
        }
      }
      return null;
    } on Object {
      return null;
    }
  }
}

/// WMO code -> translation key. codes are from the open-meteo docs.
String weatherConditionKey(int code) {
  return switch (code) {
    0 => 'weatherCondition.clear',
    1 => 'weatherCondition.mainlyClear',
    2 => 'weatherCondition.partlyCloudy',
    3 => 'weatherCondition.overcast',
    45 || 48 => 'weatherCondition.fog',
    51 || 53 || 55 => 'weatherCondition.drizzle',
    56 || 57 => 'weatherCondition.freezingDrizzle',
    61 || 63 || 65 => 'weatherCondition.rain',
    66 || 67 => 'weatherCondition.freezingRain',
    71 || 73 || 75 => 'weatherCondition.snow',
    77 => 'weatherCondition.snowGrains',
    80 || 81 || 82 => 'weatherCondition.rainShowers',
    85 || 86 => 'weatherCondition.snowShowers',
    95 => 'weatherCondition.thunderstorm',
    96 || 99 => 'weatherCondition.thunderstormHail',
    _ => 'weatherCondition.unknown',
  };
}
