import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import '../widgets/calendar.dart';
import 'home_screen.dart';

const _habitIcons = {
  Habit.cannabis: Icons.eco_outlined,
  Habit.alcohol: Icons.local_bar_outlined,
  Habit.cigarettes: Icons.smoking_rooms_outlined,
  Habit.vaping: Icons.air_outlined,
  Habit.gambling: Icons.casino_outlined,
  Habit.porn: Icons.visibility_off_outlined,
  Habit.other: Icons.more_horiz,
};

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0; // 0 welcome, 1 habit, 2 date, 3 spend
  Habit _habit = Habit.cannabis;
  DateTime _quit = DateTime.now();

  bool _costOn = true;
  CostPeriod _period = CostPeriod.daily;
  double _costAmount = 15;
  bool _timeOn = true;
  int _timeAmount = 45;
  bool _usageOn = true;
  String _method = 'joint';
  int _usageAmount = 3;

  String get code => context.read<AppState>().lang;
  String tr(L l) => l.t(code);

  double get _dailyCost {
    if (!_costOn) return 0;
    switch (_period) {
      case CostPeriod.daily:
        return _costAmount;
      case CostPeriod.weekly:
        return _costAmount / 7;
      case CostPeriod.hourly:
      case CostPeriod.perUse:
        return _costAmount * _usageAmount;
    }
  }

  void _finish() {
    final p = RecoveryProfile(
      habit: _habit,
      quitDate: _quit,
      costOn: _costOn,
      costPeriod: _period,
      costAmount: _costAmount,
      timeSetupOn: _timeOn,
      timeAmount: _timeAmount,
      usageOn: _usageOn,
      usageMethod: _method,
      usageAmount: _usageAmount,
    );
    context.read<AppState>().createProfile(p);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: switch (_step) {
          0 => _welcome(),
          1 => _habitStep(),
          2 => _dateStep(),
          _ => _spendStep(),
        },
      ),
    );
  }

  // ---- progress bar ----
  Widget _progress(int active) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i < active ? SanadColors.primary : SanadColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      );

  Widget _topBar(int active) => Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: SanadColors.heading),
            onPressed: () => setState(() => _step--),
          ),
          Expanded(child: _progress(active)),
          const SizedBox(width: 48),
        ],
      );

  // ---- step 0: welcome ----
  Widget _welcome() {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: TextButton(
              onPressed: () => context.read<AppState>().toggleLocale(),
              child: Text(code == 'ar' ? 'EN' : 'ع',
                  style: const TextStyle(color: SanadColors.primary, fontWeight: FontWeight.w700)),
            ),
          ),
          const Spacer(),
          Container(
            width: 236,
            padding: const EdgeInsets.symmetric(vertical: 34),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: SanadTheme.cardShadow,
            ),
            child: const Column(
              children: [
                Text('سند',
                    style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: SanadColors.primary)),
                Text('SANAD',
                    style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 4,
                        color: SanadColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(tr(S.welcomeTitle),
              style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 8),
          Text(tr(S.welcomeSub),
              textAlign: TextAlign.center,
              style: const TextStyle(color: SanadColors.textSecondary, fontSize: 15)),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: SanadColors.border)),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: SanadColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(tr(S.privacy), style: const TextStyle(color: SanadColors.body, fontSize: 13))),
              ],
            ),
          ),
          const Spacer(),
          FilledButton(onPressed: () => setState(() => _step = 1), child: Text(tr(S.begin))),
        ],
      ),
    );
  }

  // ---- step 1: habit ----
  Widget _habitStep() {
    return Column(
      children: [
        _topBar(1),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 14),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(tr(S.habitTitle),
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            children: Habit.values.map((h) {
              final on = h == _habit;
              return GestureDetector(
                onTap: () => setState(() {
                  _habit = h;
                  _method = h == Habit.alcohol ? 'drink' : 'joint';
                }),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 11),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: on ? SanadColors.selectedTint : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: on ? SanadColors.primary : SanadColors.border, width: on ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: SanadColors.iconTile, borderRadius: BorderRadius.circular(12)),
                        child: Icon(_habitIcons[h], color: SanadColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(tr(habitCatalog[h]!.name),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SanadColors.heading)),
                      ),
                      if (on) const Icon(Icons.check_circle, color: SanadColors.primary),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(onPressed: () => setState(() => _step = 2), child: Text(tr(S.cont))),
        ),
      ],
    );
  }

  // ---- step 2: date ----
  Widget _dateStep() {
    final today = DateTime.now();
    final isToday = _quit.year == today.year && _quit.month == today.month && _quit.day == today.day;
    return Column(
      children: [
        _topBar(2),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 18),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(tr(S.dateTitle),
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            children: [
              _bigChoice(tr(S.dateToday), Icons.today, isToday, () => setState(() => _quit = DateTime.now())),
              const SizedBox(height: 12),
              _bigChoice(tr(S.datePast), Icons.history, !isToday, () {
                // default to ~a month back when switching to "past"
                if (isToday) setState(() => _quit = today.subtract(const Duration(days: 30)));
              }),
              if (!isToday) ...[
                const SizedBox(height: 14),
                SanadCalendar(
                  selected: _quit,
                  lang: code,
                  onSelect: (d) => setState(() => _quit = d),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(onPressed: () => setState(() => _step = 3), child: Text(tr(S.cont))),
        ),
      ],
    );
  }

  Widget _bigChoice(String label, IconData icon, bool on, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: on ? SanadColors.selectedTint : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: on ? SanadColors.primary : SanadColors.border, width: on ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: SanadColors.primary),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: SanadColors.heading)),
            const Spacer(),
            if (on) const Icon(Icons.check_circle, color: SanadColors.primary),
          ],
        ),
      ),
    );
  }

  // ---- step 3: spend ----
  Widget _spendStep() {
    final monthly = (_dailyCost * 30).round();
    return Column(
      children: [
        _topBar(3),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 6, 26, 12),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(tr(S.spendTitle),
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            children: [
              _setupCard(
                title: tr(S.moneyHeader),
                on: _costOn,
                onToggle: (v) => setState(() => _costOn = v),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        _chip(tr(S.pDaily), _period == CostPeriod.daily, () => setState(() => _period = CostPeriod.daily)),
                        _chip(tr(S.pWeekly), _period == CostPeriod.weekly, () => setState(() => _period = CostPeriod.weekly)),
                        _chip(tr(S.pHourly), _period == CostPeriod.hourly, () => setState(() => _period = CostPeriod.hourly)),
                        _chip(tr(S.pPerUse), _period == CostPeriod.perUse, () => setState(() => _period = CostPeriod.perUse)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _stepper('${_costAmount.round()} ${profileCurrency()}',
                        () => setState(() => _costAmount = (_costAmount - 5).clamp(0, 100000)),
                        () => setState(() => _costAmount += 5)),
                    if (_costOn)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _infoPill(S.monthlyEst.t(code).replaceFirst('{x}', '$monthly').replaceFirst('{cur}', profileCurrency())),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _setupCard(
                title: tr(S.timeHeader),
                on: _timeOn,
                onToggle: (v) => setState(() => _timeOn = v),
                child: _stepper('$_timeAmount ${tr(S.minutes)}',
                    () => setState(() => _timeAmount = (_timeAmount - 5).clamp(5, 600)),
                    () => setState(() => _timeAmount += 5)),
              ),
              const SizedBox(height: 12),
              _setupCard(
                title: tr(S.usageHeader),
                on: _usageOn,
                onToggle: (v) => setState(() => _usageOn = v),
                child: _stepper('$_usageAmount ${tr(S.perDay)}',
                    () => setState(() => _usageAmount = (_usageAmount - 1).clamp(1, 20)),
                    () => setState(() => _usageAmount = (_usageAmount + 1).clamp(1, 20))),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: FilledButton(onPressed: _finish, child: Text(tr(S.finishSetup))),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextButton(onPressed: _finish, child: Text(tr(S.skipStep), style: const TextStyle(color: SanadColors.textSecondary))),
        ),
      ],
    );
  }

  String profileCurrency() => code == 'ar' ? 'د.ل' : 'LYD';

  Widget _setupCard({required String title, required bool on, required ValueChanged<bool> onToggle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: SanadColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SanadColors.heading)),
              const Spacer(),
              Switch(value: on, activeColor: SanadColors.primary, onChanged: onToggle),
            ],
          ),
          if (on) ...[const SizedBox(height: 6), child] else
            Padding(padding: const EdgeInsets.only(top: 4), child: Text(tr(S.offMoney), style: const TextStyle(color: SanadColors.textSecondary, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _chip(String label, bool on, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: on ? SanadColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: on ? SanadColors.primary : SanadColors.border),
        ),
        child: Text(label, style: TextStyle(color: on ? Colors.white : SanadColors.heading, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }

  Widget _stepper(String value, VoidCallback minus, VoidCallback plus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _rnd(Icons.remove, minus),
        Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: SanadColors.heading)),
        _rnd(Icons.add, plus),
      ],
    );
  }

  Widget _rnd(IconData i, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: SanadColors.iconTile, borderRadius: BorderRadius.circular(12)),
          child: Icon(i, color: SanadColors.primary),
        ),
      );

  Widget _infoPill(String text) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: SanadColors.softCardB, borderRadius: BorderRadius.circular(16)),
        child: Text(text, style: const TextStyle(color: SanadColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
      );
}
