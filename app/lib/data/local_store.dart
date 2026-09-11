import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Phase-1 persistence. On-device only, no network.
///
/// Backed by SharedPreferences for the scaffold — simple, synchronous-feeling,
/// zero codegen. When data volume grows (history/insights), swap this class for
/// a Drift/SQLite or Isar implementation behind the same method surface.
///
/// Since 1.0.3 several habits can be tracked at once: profiles live in a list
/// (`sanad.profiles`) with the currently shown one in `sanad.active`. The old
/// single-profile key (`sanad.profile`) is migrated on first read and never
/// written again.
class LocalStore {
  static const _kProfile = 'sanad.profile'; // legacy (≤ 1.0.2), read-only
  static const _kProfiles = 'sanad.profiles';
  static const _kActive = 'sanad.active';
  static const _kCheckins = 'sanad.checkins';
  static const _kRelapses = 'sanad.relapses';
  static const _kLocale = 'sanad.locale';

  final SharedPreferences _prefs;
  LocalStore(this._prefs);

  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());

  // ---- profiles ----
  List<RecoveryProfile> readProfiles() {
    final list = _prefs.getStringList(_kProfiles);
    if (list != null) {
      return list
          .map((s) =>
              RecoveryProfile.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    }
    // Legacy single profile → wrap it. Written back on the next writeProfiles.
    final raw = _prefs.getString(_kProfile);
    if (raw == null) return [];
    return [RecoveryProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>)];
  }

  Future<void> writeProfiles(List<RecoveryProfile> ps) async {
    await _prefs.setStringList(
        _kProfiles, ps.map((p) => jsonEncode(p.toJson())).toList());
    if (_prefs.containsKey(_kProfile)) await _prefs.remove(_kProfile);
  }

  int readActive() => _prefs.getInt(_kActive) ?? 0;
  Future<void> writeActive(int i) => _prefs.setInt(_kActive, i);

  /// Wipe everything — the user's full journey. Used by "delete journey"
  /// when the last habit is removed.
  Future<void> clearAll() async {
    await _prefs.remove(_kProfile);
    await _prefs.remove(_kProfiles);
    await _prefs.remove(_kActive);
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
  ///
  /// v2 carries every habit. `profile` (the first one) is kept so a code made
  /// here still restores on a phone running 1.0.2 or older.
  String exportBackup() {
    final profiles = readProfiles();
    return jsonEncode({
      'v': 2,
      'profile': profiles.isEmpty ? null : jsonEncode(profiles.first.toJson()),
      'profiles': profiles.map((p) => jsonEncode(p.toJson())).toList(),
      'active': readActive(),
      'checkins': _prefs.getStringList(_kCheckins),
      'relapses': _prefs.getStringList(_kRelapses),
    });
  }

  Future<void> importBackup(String data) async {
    final j = jsonDecode(data) as Map<String, dynamic>;
    final profiles = j['profiles'];
    if (profiles is List && profiles.isNotEmpty) {
      await _prefs.setStringList(_kProfiles, profiles.cast<String>());
      await _prefs.remove(_kProfile);
      await _prefs.setInt(_kActive, (j['active'] as int?) ?? 0);
    } else if (j['profile'] != null) {
      await _prefs.setStringList(_kProfiles, [j['profile'] as String]);
      await _prefs.remove(_kProfile);
      await _prefs.setInt(_kActive, 0);
    }
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
