import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../logic/calculations.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    final s = app.stats;
    final gauges = s.healthGauges();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(S.healthTitle.t(code), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          Text(
            S.healedSummary.t(code).replaceFirst('{x}', '${s.fullyHealed}').replaceFirst('{y}', '${gauges.length}'),
            style: const TextStyle(color: SanadColors.textSecondary),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
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
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => HealthDetailScreen(gauge: g))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: g.def.tint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: g.done ? g.def.color : SanadColors.border),
        ),
        child: Column(
          children: [
            Text(g.def.name.t(code),
                style: TextStyle(fontWeight: FontWeight.w700, color: g.def.color)),
            const SizedBox(height: 6),
            SizedBox(
              width: 110,
              height: 64,
              child: CustomPaint(
                painter: _SemiGauge(g.value / 100, g.def.color),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text('${g.value}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: g.def.color)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              g.done ? '${S.completeMark.t(code)} ✓' : S.remainingDays.t(code).replaceFirst('{n}', '${g.remaining}'),
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
  final double t; // 0..1
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, (size.height - stroke) * 2);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, math.pi, math.pi, false, track);
    canvas.drawArc(rect, math.pi, math.pi * t.clamp(0, 1), false, fill);
  }

  @override
  bool shouldRepaint(_SemiGauge old) => old.t != t;
}

class HealthDetailScreen extends StatelessWidget {
  const HealthDetailScreen({super.key, required this.gauge});
  final HealthGauge gauge;

  @override
  Widget build(BuildContext context) {
    final code = context.watch<AppState>().lang;
    final d = gauge.def;
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
          Container(
            height: 150,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: d.tint, borderRadius: BorderRadius.circular(20)),
            child: CustomPaint(painter: _RecoveryCurve(gauge, d.color), size: Size.infinite),
          ),
          const SizedBox(height: 18),
          _block(S.alreadyHealed.t(code), d.done.t(code), Icons.check_circle, d.color),
          _block(S.healingNow.t(code), d.now.t(code), Icons.autorenew, d.color),
          _block(S.whatsComing.t(code), d.coming.t(code), Icons.north_east, d.color),
        ],
      ),
    );
  }

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

/// Simplified recovery + symptom-intensity curves over the metric's window.
class _RecoveryCurve extends CustomPainter {
  _RecoveryCurve(this.g, this.color);
  final HealthGauge g;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final full = g.def.full.toDouble();
    final w = size.width, h = size.height;
    // RTL time axis: start at right, end (60d) at left.
    double px(double tt) => w * (1 - (tt.clamp(0, 60)) / 60);
    double py(double v) => h * (1 - v / 100) * 0.85 + 6;
    double rec(double tt) => (100 * (1 - math.pow(1 - math.min(1.0, tt / full), 1.7))).toDouble();
    double inten(double tt) => tt <= 3 ? 50 + 40 * (tt / 3) : 90 * math.exp(-(tt - 3) / (math.max(12.0, full) * 0.42));

    final recPath = Path(), intPath = Path();
    for (double tt = 0; tt <= 60; tt += 2) {
      final x = px(tt);
      final yr = py(rec(tt)), yi = py(inten(tt));
      if (tt == 0) { recPath.moveTo(x, yr); intPath.moveTo(x, yi); }
      else { recPath.lineTo(x, yr); intPath.lineTo(x, yi); }
    }
    canvas.drawPath(intPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = SanadColors.sos2.withValues(alpha: 0.7));
    canvas.drawPath(recPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = color);

    // "you are here" marker
    final cx = px(g.def.full - g.remaining.toDouble());
    final cy = py(rec(g.def.full - g.remaining.toDouble()));
    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_RecoveryCurve old) => false;
}
