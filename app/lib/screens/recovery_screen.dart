import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../logic/recovery_content.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    // Deleting the journey nulls the profile while this tab is still mounted
    // in the IndexedStack; app.stats would throw. Bail out for that frame.
    final p = app.profile;
    if (p == null) return const SizedBox.shrink();
    final days = app.stats.daysClean;
    final c = RecoveryContent.instance.forHabit(p.habit.id);
    final week = c.weekFor(days);
    final healed = c.indicators.where((i) => days >= i.full).length;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Text(S.healthTitle.t(code),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 12),

          // phase / current-week header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(gradient: SanadColors.heroGradient, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.youAreIn.t(code),
                    style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 13)),
                const SizedBox(height: 2),
                Text(week.label.t(code),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  S.healedSummary.t(code).replaceFirst('{x}', '$healed').replaceFirst('{y}', '${c.indicators.length}'),
                  style: const TextStyle(color: Color(0xFFD7EDE0), fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (c.caution != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFBECEC), borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: SanadColors.danger, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(c.caution!.t(code), style: const TextStyle(color: SanadColors.danger, height: 1.45))),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // current week panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: SanadColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _para(Icons.visibility_outlined, S.expectThisWeek.t(code), week.expect.t(code)),
                const SizedBox(height: 12),
                _para(Icons.groups_outlined, S.peopleFeel.t(code), week.feel.t(code)),
                const SizedBox(height: 12),
                _para(Icons.favorite_outline, S.aWord.t(code), week.support.t(code)),
                const SizedBox(height: 14),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: Text(S.readMore.t(code)),
                    onPressed: () => _openReadMore(context, c, code, days),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Text(S.indicatorsTitle.t(code),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SanadColors.textSecondary)),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.touch_app_outlined, size: 14, color: SanadColors.primary),
              const SizedBox(width: 4),
              Text(S.tapToSeeMore.t(code),
                  style: const TextStyle(fontSize: 12, color: SanadColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: c.indicators.map((ind) => _GaugeCard(ind, days, c, code)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _para(IconData icon, String title, String body) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: SanadColors.primary), const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading))]),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(height: 1.55, color: SanadColors.body)),
        ],
      );

  void _openReadMore(BuildContext context, HabitContent c, String code, int days) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SanadColors.page,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: SanadColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text(S.fullJourney.t(code), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: SanadColors.heading)),
            const SizedBox(height: 12),
            ...c.weeks.map((w) {
              final current = days >= w.fromDay && days <= w.toDay;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: current ? SanadColors.primary : SanadColors.border, width: current ? 1.5 : 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(w.label.t(code), style: const TextStyle(fontWeight: FontWeight.w800, color: SanadColors.heading)),
                      if (current) ...[const SizedBox(width: 8), _nowBadge(code)],
                    ]),
                    const SizedBox(height: 6),
                    Text(w.expect.t(code), style: const TextStyle(height: 1.5, color: SanadColors.body)),
                    const SizedBox(height: 6),
                    Text(w.feel.t(code), style: const TextStyle(height: 1.5, color: SanadColors.textSecondary)),
                    const SizedBox(height: 6),
                    Text(w.support.t(code), style: const TextStyle(height: 1.5, color: SanadColors.primary, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            _sources(c, code),
            const SizedBox(height: 10),
            Text(S.notMedical.t(code), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _nowBadge(String code) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: SanadColors.selectedTint, borderRadius: BorderRadius.circular(8)),
        child: Text(S.nowTag.t(code), style: const TextStyle(fontSize: 10, color: SanadColors.primary, fontWeight: FontWeight.w700)),
      );

  static Widget _sources(HabitContent c, String code) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.sourcesTitle.t(code), style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading, fontSize: 13)),
          const SizedBox(height: 6),
          ...c.sources.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• ${s.label}\n  ${s.url}',
                    style: const TextStyle(fontSize: 11, color: SanadColors.textSecondary, height: 1.4)),
              )),
        ],
      );
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard(this.ind, this.days, this.content, this.code);
  final IndicatorInfo ind;
  final int days;
  final HabitContent content;
  final String code;

  @override
  Widget build(BuildContext context) {
    final value = ((days / ind.full) * 100).round().clamp(0, 100);
    final remaining = (ind.full - days) < 0 ? 0 : (ind.full - days);
    final done = remaining == 0;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => IndicatorDetailScreen(ind: ind, days: days, content: content))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ind.color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: done ? ind.color : SanadColors.border),
        ),
        child: Column(
          children: [
            Text(ind.name.t(code), textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, color: ind.color)),
            const SizedBox(height: 6),
            SizedBox(
              width: 110, height: 64,
              child: CustomPaint(
                painter: _SemiGauge(value / 100, ind.color),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text('$value%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ind.color)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(done ? '${S.completeMark.t(code)} ✓' : S.remainingDays.t(code).replaceFirst('{n}', '$remaining'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: done ? ind.color : SanadColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _SemiGauge extends CustomPainter {
  _SemiGauge(this.t, this.color);
  final double t;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, (size.height - stroke) * 2);
    final track = Paint()..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round..color = Colors.white;
    final fill = Paint()..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round..color = color;
    canvas.drawArc(rect, math.pi, math.pi, false, track);
    canvas.drawArc(rect, math.pi, math.pi * t.clamp(0, 1), false, fill);
  }

  @override
  bool shouldRepaint(_SemiGauge o) => o.t != t;
}

class IndicatorDetailScreen extends StatelessWidget {
  const IndicatorDetailScreen({super.key, required this.ind, required this.days, required this.content});
  final IndicatorInfo ind;
  final int days;
  final HabitContent content;

  @override
  Widget build(BuildContext context) {
    final code = context.watch<AppState>().lang;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(ind.name.t(code), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Row(children: [
            _legend(SanadColors.primary, S.curveRecovery.t(code)),
            const SizedBox(width: 16),
            _legend(SanadColors.sos1, S.curveSymptoms.t(code)),
          ]),
          const SizedBox(height: 10),
          Container(
            height: 190,
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: SanadColors.border)),
            child: CustomPaint(
              painter: _RecoveryCurve(full: ind.full.toDouble(), daysClean: days, color: SanadColors.primary, code: code),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 18),
          _block(S.alreadyHealed.t(code), ind.done.t(code), Icons.check_circle, ind.color),
          _block(S.healingNow.t(code), ind.now.t(code), Icons.autorenew, ind.color),
          _block(S.whatsComing.t(code), ind.coming.t(code), Icons.north_east, ind.color),
          const SizedBox(height: 6),
          RecoveryScreen._sources(content, code),
          const SizedBox(height: 10),
          Text(S.notMedical.t(code), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _legend(Color cc, String label) => Row(children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: cc, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: SanadColors.body)),
      ]);

  Widget _block(String title, String body, IconData icon, Color color) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: SanadColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color))]),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(height: 1.55, color: SanadColors.body)),
          ],
        ),
      );
}

class _RecoveryCurve extends CustomPainter {
  _RecoveryCurve({required this.full, required this.daysClean, required this.color, required this.code});
  final double full;
  final int daysClean;
  final Color color;
  final String code;

  void _text(Canvas c, String s, Offset at, Color col, {double size = 9, bool center = false}) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: TextStyle(color: col, fontSize: size, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(center ? at.dx - tp.width / 2 : at.dx, at.dy));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 26.0, padR = 10.0, padT = 8.0, padB = 26.0;
    final plotW = size.width - padL - padR;
    final plotH = size.height - padT - padB;
    double px(double day) => padL + (1 - (day.clamp(0, 60)) / 60) * plotW;
    double py(double v) => padT + (1 - v / 100) * plotH;

    final grid = Paint()..color = SanadColors.border..strokeWidth = 1;
    for (final v in [0, 50, 100]) {
      final y = py(v.toDouble());
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), grid);
      _text(canvas, '$v', Offset(2, y - 6), SanadColors.textMuted);
    }
    final ticks = {
      0: S.axisStart.t(code), 14: S.axisTwoWeeks.t(code), 30: S.axisMonth.t(code),
      42: S.axisSixWeeks.t(code), 60: S.axisTwoMonths.t(code),
    };
    ticks.forEach((day, label) =>
        _text(canvas, label, Offset(px(day.toDouble()), size.height - padB + 6), SanadColors.textMuted, center: true));

    double rec(double d) => (100 * (1 - math.pow(1 - math.min(1.0, d / full), 1.7))).toDouble();
    double inten(double d) {
      final v = d <= 3 ? 50 + (90 - 50) * (d / 3) : 90 * math.exp(-(d - 3) / (math.max(12.0, full) * 0.42));
      return v.clamp(0, 100).toDouble();
    }

    final recPath = Path(), intPath = Path();
    for (double d = 0; d <= 60; d += 1.5) {
      final xr = px(d);
      if (d == 0) { recPath.moveTo(xr, py(rec(d))); intPath.moveTo(xr, py(inten(d))); }
      else { recPath.lineTo(xr, py(rec(d))); intPath.lineTo(xr, py(inten(d))); }
    }
    canvas.drawPath(intPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = SanadColors.sos1.withValues(alpha: 0.9));
    canvas.drawPath(recPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = color);

    final dx = daysClean.clamp(0, 60).toDouble();
    final hx = px(dx), hy = py(rec(dx));
    canvas.drawCircle(Offset(hx, hy), 5, Paint()..color = color);
    canvas.drawCircle(Offset(hx, hy), 5, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.white);
    _text(canvas, S.youAreHere.t(code), Offset(hx, hy - 18), color, size: 10, center: true);
  }

  @override
  bool shouldRepaint(_RecoveryCurve o) => o.daysClean != daysClean || o.full != full;
}
