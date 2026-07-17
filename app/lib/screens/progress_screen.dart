import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    String tr(L l) => l.t(code);
    // Deleting the journey nulls the profile while this tab is still mounted in
    // the IndexedStack; app.stats would throw. Bail out for that frame.
    if (app.profile == null) return const SizedBox.shrink();
    final s = app.stats;
    final checkins = app.checkIns.reversed.toList(); // newest first
    final last7 = app.checkIns.length <= 7
        ? app.checkIns
        : app.checkIns.sublist(app.checkIns.length - 7);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Text(tr(S.progressTitle),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 16),

          // milestones
          Text(tr(S.milestonesTitle),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SanadColors.textSecondary)),
          const SizedBox(height: 10),
          _milestones(s.daysClean),
          const SizedBox(height: 20),

          if (last7.isNotEmpty) ...[
            Text(tr(S.moodLast),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SanadColors.textSecondary)),
            const SizedBox(height: 8),
            _chart(last7, (c) => c.mood, false, tr(S.moodLow), tr(S.moodHigh), code),
            const SizedBox(height: 16),
            Text(tr(S.cravingLast),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SanadColors.textSecondary)),
            const SizedBox(height: 8),
            _chart(last7, (c) => c.craving, true, tr(S.cravingMild), tr(S.cravingStrong), code),
            const SizedBox(height: 20),
          ],

          Text(tr(S.checkinHistory),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SanadColors.textSecondary)),
          const SizedBox(height: 10),
          if (checkins.isEmpty)
            _empty(tr(S.noCheckins))
          else
            ...checkins.map((c) => _checkRow(c, code)),
        ],
      ),
    );
  }

  Widget _milestones(int days) {
    return Row(
      children: milestones.map((mDay) {
        final earned = days >= mDay;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: earned ? SanadColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: earned ? SanadColors.primary : SanadColors.border),
            ),
            child: Column(
              children: [
                Icon(Icons.workspace_premium,
                    size: 22, color: earned ? const Color(0xFFFFDD91) : SanadColors.border),
                const SizedBox(height: 4),
                Text('$mDay',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: earned ? Colors.white : SanadColors.textSecondary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _chart(List<CheckIn> data, int Function(CheckIn) val, bool invert, String lowLabel, String highLabel, String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: SanadColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 116,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [for (var n = 5; n >= 1; n--) Text('$n', style: const TextStyle(fontSize: 9, color: SanadColors.textMuted))],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(child: _bars(data, val, invert)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.axisDay.t(code), style: const TextStyle(fontSize: 11, color: SanadColors.textSecondary)),
              Text('$highLabel ↑ · $lowLabel ↓', style: const TextStyle(fontSize: 11, color: SanadColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bars(List<CheckIn> data, int Function(CheckIn) val, bool invert) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((c) {
        final v = val(c); // 0..4
        final frac = (v + 1) / 5.0;
        final highlight = invert ? v <= 1 : v >= 3;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    heightFactor: frac,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: invert
                            ? SanadColors.craving[v]
                            : (highlight ? SanadColors.primary : SanadColors.ringB),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${c.date.day}',
                    style: const TextStyle(fontSize: 10, color: SanadColors.textSecondary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _checkRow(CheckIn c, String code) {
    final d = c.date;
    final date = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SanadColors.border)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading)),
              if (c.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(c.note, style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
                ),
            ],
          ),
          const Spacer(),
          _pill(S.moodLabel.t(code), c.mood + 1, SanadColors.primary),
          const SizedBox(width: 8),
          _pill(S.cravingLabel.t(code), c.craving + 1, SanadColors.craving[c.craving]),
        ],
      ),
    );
  }

  Widget _pill(String label, int v, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text('$v', style: TextStyle(fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 9, color: SanadColors.textSecondary)),
          ],
        ),
      );

  Widget _empty(String msg) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: SanadColors.selectedTint, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            const Icon(Icons.favorite_border, color: SanadColors.accent),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(color: SanadColors.body))),
          ],
        ),
      );
}
