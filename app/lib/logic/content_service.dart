import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

/// Loads the bundled, offline "what to expect this week" content.
class WeeklyContent {
  WeeklyContent(this.week, this.title, this.body, {this.caution});
  final int week;
  final String title;
  final String body;
  final String? caution;
}

class ContentService {
  static Map<String, dynamic>? _cache;

  static Future<void> _ensure() async {
    if (_cache != null) return;
    final raw = await rootBundle.loadString('assets/content/weekly_en.json');
    _cache = jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Returns the guidance entry for the user's habit and current day.
  static Future<WeeklyContent?> forDay(Habit habit, int daysClean) async {
    await _ensure();
    final entries = (_cache![habit.id] as List?) ?? (_cache!['other'] as List);
    final week = (daysClean ~/ 7) + 1;
    Map<String, dynamic>? best;
    for (final e in entries.cast<Map<String, dynamic>>()) {
      if ((e['week'] as int) <= week) best = e;
    }
    best ??= entries.first as Map<String, dynamic>;
    return WeeklyContent(
      best['week'] as int,
      best['title'] as String,
      best['body'] as String,
      caution: best['caution'] as String?,
    );
  }
}
