import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sanad/data/catalog.dart';
import 'package:sanad/data/local_store.dart';
import 'package:sanad/models/models.dart';

RecoveryProfile _p(Habit h, {String currency = 'LYD'}) => RecoveryProfile(
    habit: h, quitDate: DateTime(2026, 1, 1), currency: currency);

void main() {
  test('legacy single profile (≤1.0.2) is read as a one-item list', () async {
    final legacy = _p(Habit.cigarettes).toJson()..remove('id');
    SharedPreferences.setMockInitialValues({
      'sanad.profile': jsonEncode(legacy),
    });
    final store = await LocalStore.open();
    final ps = store.readProfiles();
    expect(ps.length, 1);
    expect(ps.first.habit, Habit.cigarettes);
    expect(ps.first.id, isNotEmpty); // id is minted for old data

    // Writing moves it to the list key and drops the legacy key.
    await store.writeProfiles(ps);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('sanad.profile'), isFalse);
    expect(prefs.getStringList('sanad.profiles')!.length, 1);
  });

  test('several profiles round-trip with the active index', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.open();
    await store.writeProfiles([_p(Habit.cannabis), _p(Habit.gambling)]);
    await store.writeActive(1);
    expect(store.readProfiles().map((p) => p.habit).toList(),
        [Habit.cannabis, Habit.gambling]);
    expect(store.readActive(), 1);
  });

  test('backup v2 exports every habit and restores it', () async {
    SharedPreferences.setMockInitialValues({});
    final a = await LocalStore.open();
    await a.writeProfiles([_p(Habit.alcohol), _p(Habit.porn, currency: r'$')]);
    await a.writeActive(1);
    await a.addCheckIn(CheckIn(date: DateTime(2026, 2, 2), mood: 3, craving: 1));
    final code = a.exportBackup();

    SharedPreferences.setMockInitialValues({});
    final b = await LocalStore.open();
    await b.importBackup(code);
    final ps = b.readProfiles();
    expect(ps.length, 2);
    expect(ps[1].habit, Habit.porn);
    expect(ps[1].currency, r'$');
    expect(b.readActive(), 1);
    expect(b.readCheckIns().length, 1);
  });

  test('backup v1 (single profile) still restores', () async {
    final v1 = jsonEncode({
      'v': 1,
      'profile': jsonEncode(_p(Habit.vaping).toJson()),
      'checkins': <String>[],
      'relapses': <String>[],
    });
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.open();
    await store.importBackup(v1);
    expect(store.readProfiles().single.habit, Habit.vaping);
    expect(store.readActive(), 0);
  });

  test('currency label: LYD stays localized, anything else is verbatim', () {
    expect(currencyLabel(_p(Habit.other), 'ar'), 'د.ل');
    expect(currencyLabel(_p(Habit.other), 'en'), 'LYD');
    expect(currencyLabel(_p(Habit.other, currency: 'lyd'), 'ar'), 'د.ل');
    expect(currencyLabel(_p(Habit.other, currency: '€'), 'ar'), '€');
    expect(currencyLabel(_p(Habit.other, currency: 'ريال'), 'en'), 'ريال');
    expect(currencyLabel(_p(Habit.other, currency: '  '), 'en'), 'LYD');
  });
}
