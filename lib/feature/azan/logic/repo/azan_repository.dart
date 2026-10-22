import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/services/location_service.dart';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/models/data.dart';
import 'package:great_quran/feature/azan/logic/models/date.dart';
import 'package:great_quran/feature/azan/logic/models/designation.dart';
import 'package:great_quran/feature/azan/logic/models/hijri.dart';
import 'package:great_quran/feature/azan/logic/models/month.dart';
import 'package:great_quran/feature/azan/logic/models/timings.dart';
import 'package:great_quran/feature/azan/logic/models/weekday.dart';
import 'package:great_quran/feature/settings/logic/models/azan_sound_option.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAzanRepository {
  Future<Azan> getAzan({bool allowPrompt = false});
  Future<Azan?> getCachedAzan();
  Azan getInitialAzan();
}

class AzanRepository implements IAzanRepository {
  static final provider = Provider<IAzanRepository>(
    (ref) => AzanRepository(
      ref.read(LocationService.provider),
    ),
  );

  final LocationService _locationService;
  AzanRepository(this._locationService);

  // إحداثيات افتراضية للقاهرة في حال تعذر الحصول على الموقع
  static const double _defaultLat = 30.0444;
  static const double _defaultLng = 31.2357;

  static const String _prefLat = 'cached_azan_lat';
  static const String _prefLng = 'cached_azan_lng';
  static const String _prefAzanJson = 'cached_azan_json';

  static const String _prefAzanSettingsKey =
      'azan_notification_preferences_key';

  DaylightSavingMode _getCachedMode(SharedPreferences prefs) {
    try {
      final saved = prefs.getString(_prefAzanSettingsKey);
      if (saved != null && saved.isNotEmpty) {
        final decoded = jsonDecode(saved);
        final modeName = decoded['daylightSavingMode'];
        return DaylightSavingMode.values.firstWhere(
          (m) => m.name == modeName,
          orElse: () => DaylightSavingMode.auto,
        );
      }
    } catch (_) {}
    return DaylightSavingMode.auto;
  }

  int _getCachedAdjustment(SharedPreferences prefs) {
    try {
      final saved = prefs.getString(_prefAzanSettingsKey);
      if (saved != null && saved.isNotEmpty) {
        final decoded = jsonDecode(saved);
        return decoded['minuteAdjustment'] as int? ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  @override
  Azan getInitialAzan() {
    return _calculateFor(_defaultLat, _defaultLng);
  }

  @override
  Future<Azan?> getCachedAzan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mode = _getCachedMode(prefs);
      final adj = _getCachedAdjustment(prefs);

      final cachedLat = prefs.getDouble(_prefLat);
      final cachedLng = prefs.getDouble(_prefLng);
      if (cachedLat != null && cachedLng != null) {
        return _calculateFor(cachedLat, cachedLng,
            mode: mode, minuteOffset: adj);
      }

      final savedJson = prefs.getString(_prefAzanJson);
      if (savedJson != null && savedJson.isNotEmpty) {
        return Azan.fromJson(jsonDecode(savedJson));
      }
    } catch (e) {
      "Error reading cached azan: $e".log();
    }
    return null;
  }

  @override
  Future<Azan> getAzan({bool allowPrompt = false}) async {
    double lat = _defaultLat;
    double lng = _defaultLng;
    DaylightSavingMode mode = DaylightSavingMode.auto;
    int minuteAdjustment = 0;

    try {
      final prefs = await SharedPreferences.getInstance();
      mode = _getCachedMode(prefs);
      minuteAdjustment = _getCachedAdjustment(prefs);

      final cachedLat = prefs.getDouble(_prefLat);
      final cachedLng = prefs.getDouble(_prefLng);
      if (cachedLat != null && cachedLng != null) {
        lat = cachedLat;
        lng = cachedLng;
      }
    } catch (_) {}

    try {
      final locationData =
          await _locationService.getCurrentLocation(allowPrompt: allowPrompt);
      if (locationData != null &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        lat = locationData.latitude!;
        lng = locationData.longitude!;

        // حفظ الإحداثيات الجديدة في التخزين المحلي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_prefLat, lat);
        await prefs.setDouble(_prefLng, lng);
      }
    } catch (e) {
      "Location retrieval fallback to cached/default: $e".log();
    }

    final azan =
        _calculateFor(lat, lng, mode: mode, minuteOffset: minuteAdjustment);

    // حفظ نسخة من بيانات الأذان في التخزين المحلي
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefAzanJson, jsonEncode(azan.toJson()));
    } catch (_) {}

    return azan;
  }

  Azan _calculateFor(
    double lat,
    double lng, {
    DaylightSavingMode mode = DaylightSavingMode.auto,
    int minuteOffset = 0,
  }) {
    final coordinates = Coordinates(lat, lng);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    int totalMinutes = minuteOffset;
    if (mode == DaylightSavingMode.summer) {
      totalMinutes += 60;
    }

    DateTime adjust(DateTime dt) {
      if (totalMinutes == 0) return dt;
      return dt.add(Duration(minutes: totalMinutes));
    }

    String fmt(DateTime dt) => DateFormat('HH:mm').format(adjust(dt));

    final now = DateTime.now();

    final maghribAdj = adjust(prayerTimes.maghrib);
    final fajrAdj = adjust(prayerTimes.fajr);
    // قياس الليل الشرعي من المغرب إلى فجر اليوم التالي
    final nextFajr = fajrAdj.isBefore(maghribAdj)
        ? fajrAdj.add(const Duration(days: 1))
        : fajrAdj;
    final nightDuration = nextFajr.difference(maghribAdj);
    final halfNight = Duration(milliseconds: nightDuration.inMilliseconds ~/ 2);
    final thirdNight =
        Duration(milliseconds: nightDuration.inMilliseconds ~/ 3);

    final midnightTime = maghribAdj.add(halfNight);
    final firstThirdTime = maghribAdj.add(thirdNight);
    final lastThirdTime = nextFajr.subtract(thirdNight);

    final timings = Timings(
      fmt(prayerTimes.fajr),
      fmt(prayerTimes.sunrise),
      fmt(prayerTimes.dhuhr),
      fmt(prayerTimes.asr),
      fmt(prayerTimes.maghrib),
      fmt(prayerTimes.maghrib),
      fmt(prayerTimes.isha),
      fmt(prayerTimes.fajr.subtract(const Duration(minutes: 10))),
      DateFormat('HH:mm').format(midnightTime),
      DateFormat('HH:mm').format(firstThirdTime),
      DateFormat('HH:mm').format(lastThirdTime),
    );

    HijriCalendar.setLocal('ar');
    final hijriNow = HijriCalendar.now();

    const weekdaysAr = [
      "",
      "الإثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت",
      "الأحد",
    ];
    const weekdaysEn = [
      "",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    final weekdayAr = (now.weekday >= 1 && now.weekday <= 7)
        ? weekdaysAr[now.weekday]
        : "اليوم";
    final weekdayEn = (now.weekday >= 1 && now.weekday <= 7)
        ? weekdaysEn[now.weekday]
        : "Today";

    final hijri = Hijri(
      "${hijriNow.hDay}-${hijriNow.hMonth}-${hijriNow.hYear}",
      "DD-MM-YYYY",
      hijriNow.hDay.toString(),
      Weekday(weekdayEn, weekdayAr),
      Month(hijriNow.hMonth, hijriNow.longMonthName),
      hijriNow.hYear.toString(),
      Designation("AH", "Anno Hegirae"),
    );

    final readableDate = DateFormat('dd MMM yyyy').format(now);
    final date = Date(
      readableDate,
      (now.millisecondsSinceEpoch ~/ 1000).toString(),
      hijri,
    );

    return Azan(
      200,
      "OK",
      Data(timings, date),
    );
  }
}
