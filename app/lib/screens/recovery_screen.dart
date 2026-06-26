import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../logic/calculations.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  String _phase(String key, String code) {
    switch (key) {
      case 'start':
        return S.phaseStart.t(code);
      case 'week1':
        return S.phaseWeek1.t(code);
      case 'clarity':
        return S.phaseClarity.t(code);
      case 'stabilize':
        return S.phaseStabilize.t(code);
      default:
        return S.phaseDeep.t(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    final s = app.stats;
    final gauges = s.healthGauges();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Text(S.healthTitle.t(code),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 12),
          // phase header — where you are now
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: SanadColors.heroGradient, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${S.youAreIn.t(code)}: ${_phase(s.phaseKey, code)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  S.healedSummary.t(code).replaceFirst('{x}', '${s.fullyHealed}').replaceFirst('{y}', '${gauges.length}'),
                  style: const TextStyle(color: Color(0xFFD7EDE0), fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: gauges.map((g) => _GaugeCard(g, code)).toList(),
          ),
        ],
      ),
    );
  }
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard(this.g, this.code);
  final HealthGauge g;
  final String code;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HealthDetailScreen(gauge: g))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: g.def.tint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: g.done ? g.def.color : SanadColors.border),
        ),
        child: Column(
          children: [
            Text(g.def.name.t(code), style: TextStyle(fontWeight: FontWeight.w700, color: g.def.color)),
            const SizedBox(height: 6),
            SizedBox(
              width: 110,
              height: 64,
              child: CustomPaint(
                painter: _SemiGauge(g.value / 100, g.def.color),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text('${g.value}%',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: g.def.color)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              g.done ? '${S.completeMark.t(code)} ✓' : S.remainingDays.t(code).replaceFirst('{n}', '${g.remaining}'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: g.done ? g.def.color : SanadColors.textSecondary),
            ),
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

class HealthDetailScreen extends StatelessWidget {
  const HealthDetailScreen({super.key, required this.gauge});
  final HealthGauge gauge;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    final d = gauge.def;
    final daysClean = app.stats.daysClean;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(d.name.t(code), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          // legend
          Row(
            children: [
              _legend(d.color, S.curveRecovery.t(code)),
              const SizedBox(width: 16),
              _legend(SanadColors.sos2, S.curveSymptoms.t(code)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 190,
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: SanadColors.border)),
            child: CustomPaint(
              painter: _RecoveryCurve(
                full: d.full.toDouble(),
                daysClean: daysClean,
                color: d.color,
                code: code,
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 18),
          _block(S.alreadyHealed.t(code), d.done.t(code), Icons.check_circle, d.color),
          _block(S.healingNow.t(code), d.now.t(code), Icons.autorenew, d.color),
          _block(S.whatsComing.t(code), d.coming.t(code), Icons.north_east, d.color),
          const SizedBox(height: 8),
          Text(S.notMedical.t(code), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _legend(Color c, String label) => Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: SanadColors.body)),
        ],
      );

  Widget _block(String title, String body, IconData icon, Color color) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: SanadColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8), Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color))]),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(height: 1.55, color: SanadColors.body)),
          ],
        ),
      );
}

/// Recovery (rising) vs symptom-intensity (falling) over 60 days.
/// RTL time axis: day 0 at the RIGHT, day 60 at the LEFT.
class _RecoveryCurve extends CustomPainter {
  _RecoveryCurve({required this.full, required this.daysClean, required this.color, required this.code});
  final double full;
  final int daysClean;
  final Color color;
  final String code;

  void _text(Canvas c, String s, Offset at, Color col, {double size = 10, bool center = false}) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: TextStyle(color: col, fontSize: size, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = center ? at.dx - tp.width / 2 : at.dx;
    tp.paint(c, Offset(dx, at.dy));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 26.0, padR = 10.0, padT = 8.0, padB = 26.0;
    final plotW = size.width - padL - padR;
    final plotH = size.height - padT - padB;
    double px(double day) => padL + (1 - (day.clamp(0, 60)) / 60) * plotW; // RTL
    double py(double v) => padT + (1 - v / 100) * plotH;

    final grid = Paint()..color = SanadColors.border..strokeWidth = 1;
    for (final v in [0, 50, 100]) {
      final y = py(v.toDouble());
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), grid);
      _text(canvas, '$v', Offset(2, y - 6), SanadColors.textMuted, size: 9);
    }

    // x ticks (RTL): day -> label
    final ticks = <int, String>{
      0: S.axisStart.t(code),
      14: S.axisTwoWeeks.t(code),
      30: S.axisMonth.t(code),
      42: S.axisSixWeeks.t(code),
      60: S.axisTwoMonths.t(code),
    };
    ticks.forEach((day, label) {
      _text(canvas, label, Offset(px(day.toDouble()), size.height - padB + 6), SanadColors.textMuted, size: 9, center: true);
    });

    double rec(double d) => (100 * (1 - math.pow(1 - math.min(1.0, d / full), 1.7))).toDouble();
    double inten(double d) {
      final v = d <= 3 ? 50 + (90 - 50) * (d / 3) : 90 * math.exp(-(d - 3) / (math.max(12.0, full) * 0.42));
      return v.clamp(0, 100).toDouble();
    }

    final recPath = Path(), intPath = Path();
    for (double d = 0; d <= 60; d += 1.5) {
      final xr = px(d);
      if (d == 0) {
        recPath.moveTo(xr, py(rec(d)));
        intPath.moveTo(xr, py(inten(d)));
      } else {
        recPath.lineTo(xr, py(rec(d)));
        intPath.lineTo(xr, py(inten(d)));
      }
    }
    canvas.drawPath(intPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = SanadColors.sos2.withValues(alpha: 0.85));
    canvas.drawPath(recPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = color);

    // you are here
    final dx = daysClean.clamp(0, 60).toDouble();
    final hx = px(dx), hy = py(rec(dx));
    canvas.drawCircle(Offset(hx, hy), 5, Paint()..color = color);
    canvas.drawCircle(Offset(hx, hy), 5, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.white);
    _text(canvas, S.youAreHere.t(code), Offset(hx, hy - 18), color, size: 10, center: true);
  }

  @override
  bool shouldRepaint(_RecoveryCurve o) => o.daysClean != daysClean || o.full != full;
}
