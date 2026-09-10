import 'package:flutter/material.dart';
import '../data/local_store.dart';
import '../models/models.dart';
import '../logic/calculations.dart';
import '../logic/recovery_content.dart';

/// Single source of app truth. Wraps the on-device store and notifies the UI.
///
/// Several habits can be tracked at once. Each is its own [RecoveryProfile]
/// (own quit date, cost setup, relapse counter). One of them is *active* —
/// the one Home is showing — and every other tab follows it.
class AppState extends ChangeNotifier {
  LocalStore? _store;
  List<RecoveryProfile> _profiles = [];
  int _active = 0;
  Locale _locale = const Locale('ar');
  bool pledgedToday = false; // in-memory for now

  bool get hasProfile => _profiles.isNotEmpty;
  List<RecoveryProfile> get profiles => List.unmodifiable(_profiles);
  int get activeIndex => _active;

  /// The habit currently shown on Home (null only when nothing is tracked).
  RecoveryProfile? get profile =>
      _profiles.isEmpty ? null : _profiles[_active];
  Locale get locale => _locale;
  String get lang => _locale.languageCode;
  bool get isRtl => _locale.languageCode == 'ar';

  Stats get stats => Stats(profile!);
  Stats statsFor(RecoveryProfile p) => Stats(p);

  List<CheckIn> get checkIns => _store!.readCheckIns();
  List<Relapse> get relapses => _store!.readRelapses();

  Future<void> load() async {
    await RecoveryContent.instance.load();
    _store = await LocalStore.open();
    _profiles = _store!.readProfiles();
    _active = _clamp(_store!.readActive());
    final loc = _store!.readLocale();
    if (loc != null) _locale = Locale(loc);
    notifyListeners();
  }

  int _clamp(int i) {
    if (_profiles.isEmpty) return 0;
    if (i < 0) return 0;
    return i >= _profiles.length ? _profiles.length - 1 : i;
  }

  Future<void> setLocale(String code) async {
    _locale = Locale(code);
    await _store!.writeLocale(code);
    notifyListeners();
  }

  void toggleLocale() => setLocale(_locale.languageCode == 'ar' ? 'en' : 'ar');

  /// Show another tracked habit (Home swipe).
  Future<void> setActive(int i) async {
    final next = _clamp(i);
    if (next == _active) return;
    _active = next;
    pledgedToday = false;
    notifyListeners();
    await _store!.writeActive(next);
  }

  /// Add a habit to track. Becomes the active one.
  Future<void> createProfile(RecoveryProfile p) async {
    _profiles = [..._profiles, p];
    _active = _profiles.length - 1;
    pledgedToday = false;
    notifyListeners(); // swap to the app shell immediately, then persist
    await _store!.writeProfiles(_profiles);
    await _store!.writeActive(_active);
  }

  /// Mutate the active profile then persist + notify.
  Future<void> updateProfile(void Function(RecoveryProfile p) fn) async {
    final p = profile;
    if (p == null) return;
    fn(p);
    await _store!.writeProfiles(_profiles);
    notifyListeners();
  }

  void setPledged(bool v) {
    pledgedToday = v;
    notifyListeners();
  }

  Future<void> addCheckIn(int mood, int craving, {String note = ''}) async {
    await _store!.addCheckIn(
        CheckIn(date: DateTime.now(), mood: mood, craving: craving, note: note));
    notifyListeners();
  }

  /// Relapse: keep longest streak + history, reset the clock. Never "failure".
  /// Only the active habit's counter resets.
  Future<void> logRelapse({String note = ''}) async {
    final p = profile!;
    final current = stats.daysClean;
    if (current > p.longestStreakDays) p.longestStreakDays = current;
    p.quitDate = DateTime.now();
    pledgedToday = false;
    await _store!
        .addRelapse(Relapse(date: DateTime.now(), note: note, profileId: p.id));
    await _store!.writeProfiles(_profiles);
    notifyListeners();
  }

  /// Correct the quit date (editing, not relapse). Keeps history.
  Future<void> setQuitDate(DateTime d) async {
    final p = profile!;
    final current = stats.daysClean;
    if (current > p.longestStreakDays) p.longestStreakDays = current;
    p.quitDate = DateTime(d.year, d.month, d.day);
    await _store!.writeProfiles(_profiles);
    notifyListeners();
  }

  /// Delete the habit currently shown. Removing the last one wipes everything
  /// and returns to onboarding (the root gate reacts to [hasProfile]).
  Future<void> deleteJourney() async {
    if (_profiles.isEmpty) return;
    final remaining = [..._profiles]..removeAt(_active);
    _profiles = remaining;
    _active = _clamp(_active);
    pledgedToday = false;
    notifyListeners(); // swap the UI first, then touch storage
    if (remaining.isEmpty) {
      await _store!.clearAll();
    } else {
      await _store!.writeProfiles(remaining);
      await _store!.writeActive(_active);
    }
  }

  String exportBackup() => _store!.exportBackup();
  Future<void> importBackup(String data) async {
    await _store!.importBackup(data);
    _profiles = _store!.readProfiles();
    _active = _clamp(_store!.readActive());
    pledgedToday = false;
    notifyListeners();
  }
}
