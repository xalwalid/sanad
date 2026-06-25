import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

/// 30-day achievement / share card with full selective disclosure: the user can
/// independently hide money, time, units, mass, AND the habit type — so they can
/// share numbers without revealing what they're recovering from.
class ShareCardScreen extends StatelessWidget {
  const ShareCardScreen({super.key});
  static final _boundary = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    final s = app.stats;
    final p = app.profile!;
    final hu = habitCatalog[p.habit]!;
    final cur = code == 'ar' ? 'د.ل' : 'LYD';

    final cleanLine = p.showHabit
        ? S.cleanFrom.t(code).replaceFirst('{habit}', hu.name.t(code))
        : S.cleanPlain.t(code);

    Future<void> share() async {
      final b = _boundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final img = await b.toImage(pixelRatio: 3);
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      final dir = await getTemporaryDirectory();
      final f = File('${dir.path}/sanad_card.png');
      await f.writeAsBytes(bytes!.buffer.asUint8List());
      await Share.shareXFiles([XFile(f.path)], text: 'سند · sanad.com.ly');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(S.shareTitle.t(code), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          RepaintBoundary(
            key: _boundary,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 22),
              decoration: BoxDecoration(
                gradient: SanadColors.heroGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium_outlined, color: Color(0xFFFFDD91), size: 40),
                  const SizedBox(height: 8),
                  Text('${s.daysClean}',
                      style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w800, height: 1)),
                  const SizedBox(height: 2),
                  Text(cleanLine, style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 14)),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 26,
                    runSpacing: 12,
                    children: [
                      if (p.showMoney && p.costOn) _cardStat('${s.money} $cur', S.mMoney.t(code)),
                      if (p.showTime && p.timeSetupOn) _cardStat('${s.timeH} ${S.unitHour.t(code)}', S.mTime.t(code)),
                      if (p.showUnits && p.usageOn) _cardStat('${s.units}', S.mAvoided.t(code)),
                      if (p.showMass && hu.massPer > 0)
                        _cardStat(
                            hu.massRound == 0 ? '${s.cardMass.round()}' : s.cardMass.toStringAsFixed(1),
                            hu.massLabel.t(code)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('سند · sanad.com.ly', style: TextStyle(color: Color(0xFF9FCBB1), fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _toggle(S.mMoney.t(code), p.showMoney, (v) => app.updateProfile((x) => x.showMoney = v)),
          _toggle(S.mTime.t(code), p.showTime, (v) => app.updateProfile((x) => x.showTime = v)),
          _toggle(S.mAvoided.t(code), p.showUnits, (v) => app.updateProfile((x) => x.showUnits = v)),
          if (hu.massPer > 0)
            _toggle(S.chMass.t(code), p.showMass, (v) => app.updateProfile((x) => x.showMass = v)),
          _toggle(S.chHabit.t(code), p.showHabit, (v) => app.updateProfile((x) => x.showHabit = v)),
          const SizedBox(height: 14),
          FilledButton.icon(
            icon: const Icon(Icons.ios_share),
            label: Text(S.shareBtn.t(code)),
            onPressed: share,
          ),
        ],
      ),
    );
  }

  Widget _cardStat(String v, String l) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(v, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          Text(l, style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 11)),
        ],
      );

  Widget _toggle(String label, bool on, ValueChanged<bool> onChanged) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: SanadColors.border)),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: SanadColors.heading))),
            Switch(value: on, activeColor: SanadColors.primary, onChanged: onChanged),
          ],
        ),
      );
}
