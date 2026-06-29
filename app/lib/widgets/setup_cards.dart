import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../logic/calculations.dart';
import '../models/models.dart';
import '../theme/sanad_theme.dart';

/// Mutable holder for the cost/time/usage setup, shared by onboarding + edit.
class SetupValues {
  SetupValues({
    required this.costOn,
    required this.costPeriod,
    required this.costAmount,
    required this.timeOn,
    required this.timeAmount,
    required this.usageOn,
    required this.usageAmount,
    required this.usageUnit,
    required this.usagePeriod,
  });

  bool costOn;
  CostPeriod costPeriod;
  double costAmount;
  bool timeOn;
  int timeAmount;
  bool usageOn;
  double usageAmount;
  String usageUnit;
  CostPeriod usagePeriod;

  factory SetupValues.fromProfile(RecoveryProfile p) => SetupValues(
        costOn: p.costOn, costPeriod: p.costPeriod, costAmount: p.costAmount,
        timeOn: p.timeSetupOn, timeAmount: p.timeAmount,
        usageOn: p.usageOn, usageAmount: p.usageAmount,
        usageUnit: p.usageUnit, usagePeriod: p.usagePeriod,
      );

  factory SetupValues.defaults(Habit habit, String code) => SetupValues(
        costOn: true, costPeriod: CostPeriod.daily, costAmount: 15,
        timeOn: true, timeAmount: 60,
        usageOn: true, usageAmount: 2,
        usageUnit: habitUnits[habit]!.first.t(code), usagePeriod: CostPeriod.daily,
      );

  void applyTo(RecoveryProfile p) {
    p.costOn = costOn; p.costPeriod = costPeriod; p.costAmount = costAmount;
    p.timeSetupOn = timeOn; p.timeAmount = timeAmount;
    p.usageOn = usageOn; p.usageAmount = usageAmount;
    p.usageUnit = usageUnit; p.usagePeriod = usagePeriod;
  }
}

class SetupCards extends StatefulWidget {
  const SetupCards({super.key, required this.values, required this.habit, required this.code});
  final SetupValues values;
  final Habit habit;
  final String code;
  @override
  State<SetupCards> createState() => _SetupCardsState();
}

class _SetupCardsState extends State<SetupCards> {
  late final TextEditingController _cost;
  late final TextEditingController _time;
  late final TextEditingController _usage;
  late final TextEditingController _customUnit;
  late bool _customMode;

  String tr(L l) => l.t(widget.code);

  @override
  void initState() {
    super.initState();
    final v = widget.values;
    _cost = TextEditingController(text: Stats.fmtNum(v.costAmount));
    _time = TextEditingController(text: '${v.timeAmount}');
    _usage = TextEditingController(text: Stats.fmtNum(v.usageAmount));
    final opts = habitUnits[widget.habit]!.map((u) => u.t(widget.code)).toList();
    _customMode = v.usageUnit.isNotEmpty && !opts.contains(v.usageUnit);
    _customUnit = TextEditingController(text: _customMode ? v.usageUnit : '');
  }

  @override
  void dispose() {
    _cost.dispose(); _time.dispose(); _usage.dispose(); _customUnit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.values;
    final cur = widget.code == 'ar' ? 'د.ل' : 'LYD';
    final units = habitUnits[widget.habit]!;
    final monthly = (Stats(_previewProfile()).monthly);

    return Column(
      children: [
        // money
        _card(
          title: tr(S.moneyHeader),
          on: v.costOn,
          offText: tr(S.offMoney),
          onToggle: (b) => setState(() => v.costOn = b),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _periods(v.costPeriod, (pp) => setState(() => v.costPeriod = pp)),
              const SizedBox(height: 10),
              _amount(_cost, cur, (d) => setState(() => v.costAmount = d)),
              if (v.costOn && monthly > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _pill(S.monthlyEst.t(widget.code).replaceFirst('{x}', '$monthly').replaceFirst('{cur}', cur)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // time (per day)
        _card(
          title: tr(S.timePerDayLabel),
          on: v.timeOn,
          offText: tr(S.offTime),
          onToggle: (b) => setState(() => v.timeOn = b),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _amount(_time, tr(S.minutes), (d) => setState(() => v.timeAmount = d.round()), decimal: false),
              const SizedBox(height: 6),
              Text('≈ ${Stats.fmtDuration(v.timeAmount, widget.code)}',
                  style: const TextStyle(color: SanadColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // usage / intake
        _card(
          title: tr(S.usageHeader),
          on: v.usageOn,
          offText: tr(S.offUsage),
          onToggle: (b) => setState(() => v.usageOn = b),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr(S.usageHowMuch), style: const TextStyle(fontSize: 13, color: SanadColors.textSecondary)),
              const SizedBox(height: 8),
              Text(tr(S.unitLabel), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  ...units.map((u) {
                    final label = u.t(widget.code);
                    final on = !_customMode && v.usageUnit == label;
                    return _chip(label, on, () => setState(() {
                          _customMode = false;
                          v.usageUnit = label;
                        }));
                  }),
                  _chip(tr(S.customUnit), _customMode, () => setState(() {
                        _customMode = true;
                        v.usageUnit = _customUnit.text.trim();
                      })),
                ],
              ),
              if (_customMode)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: _customUnit,
                    decoration: InputDecoration(
                      hintText: tr(S.customUnitHint),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (t) => setState(() => v.usageUnit = t.trim()),
                  ),
                ),
              const SizedBox(height: 12),
              _periods(v.usagePeriod, (pp) => setState(() => v.usagePeriod = pp)),
              const SizedBox(height: 10),
              _amount(_usage, _unitWord(), (d) => setState(() => v.usageAmount = d)),
            ],
          ),
        ),
      ],
    );
  }

  String _unitWord() => widget.values.usageUnit.isNotEmpty
      ? widget.values.usageUnit
      : habitUnits[widget.habit]!.first.t(widget.code);

  RecoveryProfile _previewProfile() {
    final v = widget.values;
    return RecoveryProfile(
      habit: widget.habit, quitDate: DateTime.now(),
      costOn: v.costOn, costPeriod: v.costPeriod, costAmount: v.costAmount,
      timeSetupOn: v.timeOn, timeAmount: v.timeAmount,
      usageOn: v.usageOn, usageAmount: v.usageAmount, usagePeriod: v.usagePeriod,
    );
  }

  // ---- pieces ----
  Widget _card({required String title, required bool on, required String offText, required ValueChanged<bool> onToggle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: SanadColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SanadColors.heading)),
            const Spacer(),
            Switch(value: on, activeColor: SanadColors.primary, onChanged: onToggle),
          ]),
          if (on) ...[const SizedBox(height: 6), child]
          else Padding(padding: const EdgeInsets.only(top: 4), child: Text(offText, style: const TextStyle(color: SanadColors.textSecondary, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _periods(CostPeriod sel, ValueChanged<CostPeriod> onSel) => Wrap(
        spacing: 8, runSpacing: 8,
        children: [
          _chip(tr(S.pDaily), sel == CostPeriod.daily, () => onSel(CostPeriod.daily)),
          _chip(tr(S.pWeekly), sel == CostPeriod.weekly, () => onSel(CostPeriod.weekly)),
          _chip(tr(S.pHourly), sel == CostPeriod.hourly, () => onSel(CostPeriod.hourly)),
          _chip(tr(S.pPerUse), sel == CostPeriod.perUse, () => onSel(CostPeriod.perUse)),
        ],
      );

  Widget _chip(String label, bool on, VoidCallback onTap) => GestureDetector(
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

  Widget _amount(TextEditingController c, String suffix, ValueChanged<double> onVal, {bool decimal = true}) {
    void bump(double delta) {
      final cur = double.tryParse(c.text) ?? 0;
      final next = (cur + delta).clamp(0, 100000).toDouble();
      c.text = Stats.fmtNum(next);
      onVal(next);
    }

    return Row(
      children: [
        _rnd(Icons.remove, () => bump(decimal ? -1 : -5)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: c,
            keyboardType: TextInputType.numberWithOptions(decimal: decimal),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(decimal ? r'[0-9.]' : r'[0-9]'))],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: SanadColors.heading),
            decoration: InputDecoration(
              isDense: true,
              suffixText: suffix,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (t) => onVal(double.tryParse(t) ?? 0),
          ),
        ),
        const SizedBox(width: 10),
        _rnd(Icons.add, () => bump(decimal ? 1 : 5)),
      ],
    );
  }

  Widget _rnd(IconData i, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 46, height: 46,
          decoration: BoxDecoration(color: SanadColors.iconTile, borderRadius: BorderRadius.circular(12)),
          child: Icon(i, color: SanadColors.primary),
        ),
      );

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: SanadColors.softCardB, borderRadius: BorderRadius.circular(16)),
        child: Text(text, style: const TextStyle(color: SanadColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
      );
}
