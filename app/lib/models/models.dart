// On-device data models. None of this ever leaves the phone in Phase 1.

enum Habit {
  cannabis,
  alcohol,
  cigarettes,
  vaping,
  gambling,
  porn,
  other;

  String get id => name;
  static Habit fromId(String id) =>
      Habit.values.firstWhere((h) => h.name == id, orElse: () => Habit.other);
}

enum CostPeriod { daily, weekly, hourly, perUse }

/// The core recovery profile + setup chosen during onboarding.
class RecoveryProfile {
  RecoveryProfile({
    required this.habit,
    this.customName,
    required this.quitDate,
    this.longestStreakDays = 0,
    this.countryCode = 'LY',
    this.currency = 'LYD',
    // cost setup
    this.costOn = true,
    this.costPeriod = CostPeriod.daily,
    this.costAmount = 15,
    // time setup (minutes per day)
    this.timeSetupOn = true,
    this.timeAmount = 60,
    // usage / intake setup
    this.usageOn = true,
    this.usageMethod = 'joint',
    this.usageAmount = 2,
    this.usageUnit = '',
    this.usagePeriod = CostPeriod.daily,
    // share-card selective disclosure
    this.showMoney = true,
    this.showTime = true,
    this.showUnits = true,
    this.showMass = true,
    this.showHabit = true,
  });

  Habit habit;
  String? customName; // user-typed name when habit == other
  DateTime quitDate;
  int longestStreakDays;
  String countryCode;
  String currency;

  bool costOn;
  CostPeriod costPeriod;
  double costAmount;
  bool timeSetupOn;
  int timeAmount; // minutes per day
  bool usageOn;
  String usageMethod; // legacy
  double usageAmount;
  String usageUnit; // display unit, e.g. liter / puff (empty = generic)
  CostPeriod usagePeriod;

  bool showMoney, showTime, showUnits, showMass, showHabit;

  Map<String, dynamic> toJson() => {
        'habit': habit.id,
        'customName': customName,
        'quitDate': quitDate.toIso8601String(),
        'longestStreakDays': longestStreakDays,
        'countryCode': countryCode,
        'currency': currency,
        'costOn': costOn,
        'costPeriod': costPeriod.name,
        'costAmount': costAmount,
        'timeSetupOn': timeSetupOn,
        'timeAmount': timeAmount,
        'usageOn': usageOn,
        'usageMethod': usageMethod,
        'usageAmount': usageAmount,
        'usageUnit': usageUnit,
        'usagePeriod': usagePeriod.name,
        'showMoney': showMoney,
        'showTime': showTime,
        'showUnits': showUnits,
        'showMass': showMass,
        'showHabit': showHabit,
      };

  factory RecoveryProfile.fromJson(Map<String, dynamic> j) => RecoveryProfile(
        habit: Habit.fromId(j['habit'] as String),
        customName: j['customName'] as String?,
        quitDate: DateTime.parse(j['quitDate'] as String),
        longestStreakDays: (j['longestStreakDays'] as int?) ?? 0,
        countryCode: (j['countryCode'] as String?) ?? 'LY',
        currency: (j['currency'] as String?) ?? 'LYD',
        costOn: (j['costOn'] as bool?) ?? true,
        costPeriod: CostPeriod.values.firstWhere(
            (c) => c.name == (j['costPeriod'] ?? 'daily'),
            orElse: () => CostPeriod.daily),
        costAmount: (j['costAmount'] as num?)?.toDouble() ?? 15,
        timeSetupOn: (j['timeSetupOn'] as bool?) ?? true,
        timeAmount: (j['timeAmount'] as int?) ?? 45,
        usageOn: (j['usageOn'] as bool?) ?? true,
        usageMethod: (j['usageMethod'] as String?) ?? 'joint',
        usageAmount: (j['usageAmount'] as num?)?.toDouble() ?? 2,
        usageUnit: (j['usageUnit'] as String?) ?? '',
        usagePeriod: CostPeriod.values.firstWhere(
            (c) => c.name == (j['usagePeriod'] ?? 'daily'),
            orElse: () => CostPeriod.daily),
        showMoney: (j['showMoney'] as bool?) ?? true,
        showTime: (j['showTime'] as bool?) ?? true,
        showUnits: (j['showUnits'] as bool?) ?? true,
        showMass: (j['showMass'] as bool?) ?? true,
        showHabit: (j['showHabit'] as bool?) ?? true,
      );
}

class CheckIn {
  CheckIn(
      {required this.date,
      required this.mood,
      required this.craving,
      this.note = ''});
  final DateTime date;
  final int mood; // 0..4
  final int craving; // 0..4
  final String note;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'mood': mood,
        'craving': craving,
        'note': note,
      };

  factory CheckIn.fromJson(Map<String, dynamic> j) => CheckIn(
        date: DateTime.parse(j['date'] as String),
        mood: j['mood'] as int,
        craving: j['craving'] as int,
        note: (j['note'] as String?) ?? '',
      );
}

class Relapse {
  Relapse({required this.date, this.note = ''});
  final DateTime date;
  final String note;

  Map<String, dynamic> toJson() =>
      {'date': date.toIso8601String(), 'note': note};
  factory Relapse.fromJson(Map<String, dynamic> j) => Relapse(
      date: DateTime.parse(j['date'] as String), note: (j['note'] as String?) ?? '');
}
