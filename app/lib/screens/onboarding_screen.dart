import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import '../widgets/calendar.dart';
import '../widgets/setup_cards.dart';
import 'root_shell.dart';

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

  final _customName = TextEditingController();
  SetupValues? _setup;

  String get code => context.read<AppState>().lang;
  String tr(L l) => l.t(code);

  void _finish() {
    final v = _setup ?? SetupValues.defaults(_habit, code);
    final p = RecoveryProfile(
      habit: _habit,
      customName: _habit == Habit.other ? _customName.text.trim() : null,
      quitDate: _quit,
    );
    v.applyTo(p);
    context.read<AppState>().createProfile(p);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RootShell()));
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
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: SanadTheme.cardShadow,
            ),
            child: Image.asset('assets/brand/sanad-logo.png', width: 180),
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
            children: [
              ...Habit.values.map((h) {
              final on = h == _habit;
              return GestureDetector(
                onTap: () => setState(() {
                  _habit = h;
                  _setup = null; // re-default unit options for the new habit
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
              }),
              if (_habit == Habit.other)
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
                  child: TextField(
                    controller: _customName,
                    decoration: InputDecoration(
                      labelText: tr(S.customHabitPrompt),
                      hintText: tr(S.customHabitHint),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
            ],
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
          child: FilledButton(
              onPressed: () => setState(() {
                    _setup ??= SetupValues.defaults(_habit, code);
                    _step = 3;
                  }),
              child: Text(tr(S.cont))),
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

  // ---- step 3: spend / intake ----
  Widget _spendStep() {
    final v = _setup ??= SetupValues.defaults(_habit, code);
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
            children: [SetupCards(values: v, habit: _habit, code: code)],
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
}
