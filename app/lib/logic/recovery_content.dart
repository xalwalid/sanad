import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/catalog.dart'; // L

class Source {
  Source(this.label, this.url);
  final String label;
  final String url;
}

class WeekInfo {
  WeekInfo(this.fromDay, this.toDay, this.label, this.expect, this.feel, this.support);
  final int fromDay, toDay;
  final L label, expect, feel, support;
}

class IndicatorInfo {
  IndicatorInfo(this.key, this.name, this.color, this.full, this.done, this.now, this.coming);
  final String key;
  final L name;
  final Color color;
  final int full;
  final L done, now, coming;
}

class HabitContent {
  HabitContent({
    required this.unit,
    required this.perDayDefault,
    required this.massPer,
    required this.massRound,
    required this.massLabel,
    required this.weeks,
    required this.indicators,
    required this.sources,
    this.caution,
    this.minutesDefault,
  });
  final L unit;
  final int perDayDefault;
  final double massPer;
  final int massRound;
  final L massLabel;
  final List<WeekInfo> weeks;
  final List<IndicatorInfo> indicators;
  final List<Source> sources;
  final L? caution;
  final int? minutesDefault;

  WeekInfo weekFor(int daysClean) {
    for (final w in weeks) {
      if (daysClean >= w.fromDay && daysClean <= w.toDay) return w;
    }
    return weeks.last;
  }
}

/// Loads per-habit recovery content from assets/content/recovery.json (once).
class RecoveryContent {
  RecoveryContent._();
  static final RecoveryContent instance = RecoveryContent._();

  final Map<String, HabitContent> _byHabit = {};
  bool _loaded = false;

  static L _l(dynamic m) => L((m?['ar'] ?? '') as String, (m?['en'] ?? '') as String);

  static Color _color(String s) =>
      Color(int.parse(s.replaceFirst('0x', ''), radix: 16));

  Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/content/recovery.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    for (final entry in data.entries) {
      if (entry.key.startsWith('_')) continue;
      final h = entry.value as Map<String, dynamic>;
      _byHabit[entry.key] = HabitContent(
        unit: _l(h['unit']),
        perDayDefault: (h['perDayDefault'] as int?) ?? 1,
        massPer: (h['massPer'] as num?)?.toDouble() ?? 0,
        massRound: (h['massRound'] as int?) ?? 0,
        massLabel: _l(h['massLabel']),
        minutesDefault: h['minutesDefault'] as int?,
        caution: h.containsKey('caution') ? _l(h['caution']) : null,
        weeks: (h['weeks'] as List).map((w) {
          final m = w as Map<String, dynamic>;
          return WeekInfo(m['fromDay'] as int, m['toDay'] as int, _l(m['label']),
              _l(m['expect']), _l(m['feel']), _l(m['support']));
        }).toList(),
        indicators: (h['indicators'] as List).map((i) {
          final m = i as Map<String, dynamic>;
          return IndicatorInfo(
            m['key'] as String,
            _l(m['name']),
            _color(m['color'] as String),
            m['full'] as int,
            _l(m['done']),
            _l(m['now']),
            _l(m['coming']),
          );
        }).toList(),
        sources: (h['sources'] as List)
            .map((s) => Source((s['label']) as String, (s['url']) as String))
            .toList(),
      );
    }
    _loaded = true;
  }

  HabitContent forHabit(String id) => _byHabit[id] ?? _byHabit['other']!;
}
