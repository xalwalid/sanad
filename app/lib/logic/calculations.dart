import '../models/models.dart';
import '../data/catalog.dart';

/// All stats computed from the quit date — never stored stale.
class Stats {
  Stats(this.p, {DateTime? now}) : _now = now ?? DateTime.now();
  final RecoveryProfile p;
  final DateTime _now;

  int get daysClean {
    final d = _now.difference(_dayStart(p.quitDate)).inDays;
    return d < 0 ? 0 : d;
  }

  int get nextMilestone =>
      milestones.firstWhere((m) => m > daysClean, orElse: () => 365);
  int get daysToNext => nextMilestone - daysClean;
  double get ringProgress => (daysClean / nextMilestone).clamp(0, 1).toDouble();
  int get longest => daysClean > p.longestStreakDays ? daysClean : p.longestStreakDays;

  // ---- period helpers ----
  static double _perDay(double amount, CostPeriod period) {
    switch (period) {
      case CostPeriod.daily:
        return amount;
      case CostPeriod.weekly:
        return amount / 7;
      case CostPeriod.hourly:
        return amount * 16; // waking hours
      case CostPeriod.perUse:
        return amount; // treat as per-day occurrences
    }
  }

  double get usagePerDay => _perDay(p.usageAmount, p.usagePeriod);

  double get dailyCost {
    if (!p.costOn) return 0;
    switch (p.costPeriod) {
      case CostPeriod.daily:
        return p.costAmount;
      case CostPeriod.weekly:
        return p.costAmount / 7;
      case CostPeriod.hourly:
        return p.costAmount * 16;
      case CostPeriod.perUse:
        return p.costAmount * usagePerDay;
    }
  }

  int get money => (dailyCost * daysClean).round();
  int get monthly => (dailyCost * 30).round();

  /// Total minutes reclaimed (timeAmount is minutes/day).
  int get timeMinutesTotal => p.timeSetupOn ? p.timeAmount * daysClean : 0;

  /// Amount avoided, in the user's chosen unit (may be fractional, e.g. liters).
  double get unitsAvoided => p.usageOn ? usagePerDay * daysClean : 0;

  // ---- 30-day share card ----
  double get _perDayOrGuess => usagePerDay <= 0 ? 1 : usagePerDay;
  double get cardUnits => _perDayOrGuess * 30;
  int get cardMoney => ((p.costOn ? dailyCost : _perDayOrGuess * 3) * 30).round();
  int get cardTimeMinutes => (p.timeSetupOn ? p.timeAmount : 60) * 30;

  String get phaseKey {
    final d = daysClean;
    if (d <= 3) return 'start';
    if (d <= 7) return 'week1';
    if (d <= 28) return 'clarity';
    if (d <= 60) return 'stabilize';
    return 'deep';
  }

  static DateTime _dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

  // ---- formatting helpers ----
  /// 110 -> "1س 50د" / "1h 50m". Western digits always.
  static String fmtDuration(int totalMinutes, String code) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    final hU = code == 'ar' ? 'س' : 'h';
    final mU = code == 'ar' ? 'د' : 'm';
    if (h == 0) return '$m$mU';
    if (m == 0) return '$h$hU';
    return '$h$hU $m$mU';
  }

  /// Round nicely: whole -> "5", fractional -> "1.5".
  static String fmtNum(double v) =>
      v == v.roundToDouble() ? '${v.round()}' : v.toStringAsFixed(1);
}
