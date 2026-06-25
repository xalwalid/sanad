import 'package:flutter/material.dart';
import '../data/local_store.dart';
import '../models/models.dart';
import '../logic/calculations.dart';

/// Single source of app truth. Wraps the on-device store and notifies the UI.
class AppState extends ChangeNotifier {
  LocalStore? _store;
  RecoveryProfile? _profile;
  Locale _locale = const Locale('ar');
  bool pledgedToday = false; // in-memory for now

  bool get hasProfile => _profile != null;
  RecoveryProfile? get profile => _profile;
  Locale get locale => _locale;
  String get lang => _locale.languageCode;
  bool get isRtl => _locale.languageCode == 'ar';

  Stats get stats => Stats(_profile!);

  Future<void> load() async {
    _store = await LocalStore.open();
    _profile = _store!.readProfile();
    final loc = _store!.readLocale();
    if (loc != null) _locale = Locale(loc);
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    _locale = Locale(code);
    await _store!.writeLocale(code);
    notifyListeners();
  }

  void toggleLocale() => setLocale(_locale.languageCode == 'ar' ? 'en' : 'ar');

  Future<void> createProfile(RecoveryProfile p) async {
    _profile = p;
    await _store!.writeProfile(p);
    notifyListeners();
  }

  /// Mutate the profile then persist + notify.
  Future<void> updateProfile(void Function(RecoveryProfile p) fn) async {
    if (_profile == null) return;
    fn(_profile!);
    await _store!.writeProfile(_profile!);
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
  Future<void> logRelapse({String note = ''}) async {
    final current = stats.daysClean;
    final p = _profile!;
    if (current > p.longestStreakDays) p.longestStreakDays = current;
    p.quitDate = DateTime.now();
    pledgedToday = false;
    await _store!.addRelapse(Relapse(date: DateTime.now(), note: note));
    await _store!.writeProfile(p);
    notifyListeners();
  }

  String exportBackup() => _store!.exportBackup();
  Future<void> importBackup(String data) async {
    await _store!.importBackup(data);
    _profile = _store!.readProfile();
    notifyListeners();
  }
}
