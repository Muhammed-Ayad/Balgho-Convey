import 'dart:async';
import 'package:great_quran/feature/azan/logic/models/azan.dart';
import 'package:great_quran/feature/azan/logic/providers/azan_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class NextPrayerModel {
  final String prayerName;
  final String formattedTime;
  final Duration remaining;
  final String hijriDate;

  const NextPrayerModel({
    required this.prayerName,
    required this.formattedTime,
    required this.remaining,
    required this.hijriDate,
  });

  String get remainingFormatted {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    if (hours > 0) {
      return "$hours س و $minutes د";
    } else {
      return "$minutes دقيقة";
    }
  }
}

final nextPrayerTickerProvider = StreamProvider.autoDispose<DateTime>((ref) {
  final controller = StreamController<DateTime>();
  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    if (!controller.isClosed) {
      controller.add(DateTime.now());
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

final nextPrayerProvider = Provider<NextPrayerModel?>((ref) {
  ref.watch(nextPrayerTickerProvider);
  final azanState = ref.watch(AzanTimeNotifier.provider);

  return azanState.when(
    data: (azan) => calculateNextPrayer(azan),
    loading: () => null,
    error: (_, __) => null,
  );
});

NextPrayerModel? calculateNextPrayer(Azan azan) {
  try {
    final timings = azan.data.timings;
    final now = DateTime.now();

    final prayerList = [
      MapEntry("الفجر", timings.fajr),
      MapEntry("الشروق", timings.sunrise),
      MapEntry("الظهر", timings.dhuhr),
      MapEntry("العصر", timings.asr),
      MapEntry("المغرب", timings.maghrib),
      MapEntry("العشاء", timings.isha),
    ];

    DateTime? nextTime;
    String nextName = "الفجر";

    for (final entry in prayerList) {
      final parsed = _parsePrayerTime(entry.value, now);
      if (parsed != null && parsed.isAfter(now)) {
        nextTime = parsed;
        nextName = entry.key;
        break;
      }
    }

    if (nextTime == null) {
      final fajrToday = _parsePrayerTime(timings.fajr, now);
      if (fajrToday != null) {
        nextTime = fajrToday.add(const Duration(days: 1));
        nextName = "الفجر";
      } else {
        return null;
      }
    }

    const hijriMonthsAr = [
      "",
      "محرم",
      "صفر",
      "ربيع الأول",
      "ربيع الآخر",
      "جمادى الأولى",
      "جمادى الآخرة",
      "رجب",
      "شعبان",
      "رمضان",
      "شوال",
      "ذو القعدة",
      "ذو الحجة",
    ];

    final monthNum = azan.data.date.hijri.month.number;
    final monthName = (monthNum >= 1 && monthNum <= 12)
        ? hijriMonthsAr[monthNum]
        : azan.data.date.hijri.month.en;

    final hijri =
        "${azan.data.date.hijri.weekday.ar} ${azan.data.date.hijri.day} $monthName ${azan.data.date.hijri.year} هـ";

    return NextPrayerModel(
      prayerName: nextName,
      formattedTime: DateFormat.jm().format(nextTime),
      remaining: nextTime.difference(now),
      hijriDate: hijri,
    );
  } catch (_) {
    return null;
  }
}

DateTime? _parsePrayerTime(String timeStr, DateTime date) {
  try {
    final clean = timeStr.split(' ').first.trim();
    final parts = clean.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  } catch (_) {
    return null;
  }
}
