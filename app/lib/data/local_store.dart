import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Phase-1 persistence. On-device only, no network.
///
/// Backed by SharedPreferences for the scaffold — simple, synchronous-feeling,
/// zero codegen. When data volume grows (history/insights), swap this class for
/// a Drift/SQLite or Isar implementation behind the same method surface.
class LocalStore {
  static const _kProfile = 'sanad.profile';
  static const _kCheckins = 'sanad.checkins';
  static const _kRelapses = 'sanad.relapses';
  static const _kLocale = 'sanad.locale';

  final SharedPreferences _prefs;
  LocalStore(this._prefs);

  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());

  // ---- profile ----
  RecoveryProfile? readProfile() {
    final raw = _prefs.getString(_kProfile);
    if (raw == null) return null;
    return RecoveryProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> writeProfile(RecoveryProfile p) =>
      _prefs.setString(_kProfile, jsonEncode(p.toJson()));

  Future<void> clearProfile() => _prefs.remove(_kProfile);

  /// Wipe everything — the user's full journey. Used by "delete journey".
  Future<void> clearAll() async {
    await _prefs.remove(_kProfile);
    await _prefs.remove(_kCheckins);
    await _prefs.remove(_kRelapses);
  }

  // ---- check-ins ----
  List<CheckIn> readCheckIns() {
    final raw = _prefs.getStringList(_kCheckins) ?? [];
    return raw
        .map((s) => CheckIn.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addCheckIn(CheckIn c) async {
    final list = _prefs.getStringList(_kCheckins) ?? [];
    list.add(jsonEncode(c.toJson()));
    await _prefs.setStringList(_kCheckins, list);
  }

  // ---- relapses ----
  List<Relapse> readRelapses() {
    final raw = _prefs.getStringList(_kRelapses) ?? [];
    return raw
        .map((s) => Relapse.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRelapse(Relapse r) async {
    final list = _prefs.getStringList(_kRelapses) ?? [];
    list.add(jsonEncode(r.toJson()));
    await _prefs.setStringList(_kRelapses, list);
  }

  // ---- locale ----
  String? readLocale() => _prefs.getString(_kLocale);
  Future<void> writeLocale(String code) => _prefs.setString(_kLocale, code);

  /// Identity-free export: the whole on-device state as a JSON string the user
  /// can copy/save and restore on another device. No account, no server.
  String exportBackup() => jsonEncode({
        'v': 1,
        'profile': _prefs.getString(_kProfile),
        'checkins': _prefs.getStringList(_kCheckins),
        'relapses': _prefs.getStringList(_kRelapses),
      });

  Future<void> importBackup(String data) async {
    final j = jsonDecode(data) as Map<String, dynamic>;
    if (j['profile'] != null) await _prefs.setString(_kProfile, j['profile']);
    if (j['checkins'] != null) {
      await _prefs.setStringList(
          _kCheckins, (j['checkins'] as List).cast<String>());
    }
    if (j['relapses'] != null) {
      await _prefs.setStringList(
          _kRelapses, (j['relapses'] as List).cast<String>());
    }
  }
}
