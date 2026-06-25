import '../models/models.dart';
import '../data/catalog.dart';

class HealthGauge {
  HealthGauge(this.def, this.value, this.remaining);
  final MetricDef def;
  final int value; // 0..100
  final int remaining; // days left to full
  bool get done => remaining == 0;
}

/// All stats computed from the quit date — never stored stale.
/// Mirrors the hand-off's renderVals() logic.
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

  double get dailyCost {
    if (!p.costOn) return 0;
    switch (p.costPeriod) {
      case CostPeriod.daily:
        return p.costAmount;
      case CostPeriod.weekly:
        return p.costAmount / 7;
      case CostPeriod.hourly:
        return p.costAmount * p.usageAmount;
      case CostPeriod.perUse:
        return p.costAmount * p.usageAmount;
    }
  }

  int get money => (dailyCost * daysClean).round();
  int get monthly => (dailyCost * 30).round();
  int get timeH =>
      p.timeSetupOn ? (p.timeAmount * p.usageAmount * daysClean / 60).round() : 0;
  int get units => p.usageOn ? daysClean * p.usageAmount : 0;
  int get longest => daysClean > p.longestStreakDays ? daysClean : p.longestStreakDays;

  /// Health gauges, sorted by remaining days ascending (as in the hand-off).
  List<HealthGauge> healthGauges() {
    final list = metricsDef.map((m) {
      final v = ((daysClean / m.full) * 100).round().clamp(0, 100);
      final rem = (m.full - daysClean) < 0 ? 0 : (m.full - daysClean);
      return HealthGauge(m, v, rem);
    }).toList()
      ..sort((a, b) => a.remaining.compareTo(b.remaining));
    return list;
  }

  int get fullyHealed => metricsDef.where((m) => daysClean >= m.full).length;

  String get phaseKey {
    final d = daysClean;
    if (d <= 3) return 'start';
    if (d <= 7) return 'week1';
    if (d <= 28) return 'clarity';
    if (d <= 60) return 'stabilize';
    return 'deep';
  }

  // ---- 30-day achievement / share card ----
  int get _perDay => p.usageAmount < 1 ? 1 : p.usageAmount;
  int get cardUnits => _perDay * 30;
  int get cardMoney =>
      ((p.costOn ? dailyCost : _perDay * 3) * 30).round();
  int get cardTime =>
      ((p.timeAmount < 10 ? 10 : p.timeAmount) * _perDay * 30 / 60).round();
  double get cardMass {
    final hu = habitCatalog[p.habit]!;
    return hu.massPer == 0 ? 0 : cardUnits * hu.massPer;
  }

  static DateTime _dayStart(DateTime d) => DateTime(d.year, d.month, d.day);
}
