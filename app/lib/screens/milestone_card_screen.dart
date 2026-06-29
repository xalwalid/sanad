import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'dart:typed_data';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../logic/calculations.dart';
import '../logic/recovery_content.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

/// Celebratory share card with full selective disclosure: hide money, time,
/// units, mass, AND the habit type independently.
class ShareCardScreen extends StatelessWidget {
  const ShareCardScreen({super.key});
  static final _boundary = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    final s = app.stats;
    final p = app.profile!;
    final hu = RecoveryContent.instance.forHabit(p.habit.id);
    final cur = code == 'ar' ? 'د.ل' : 'LYD';
    final massVal = hu.massPer * s.cardUnits;
    final unitWord = p.usageUnit.isNotEmpty ? p.usageUnit : habitUnits[p.habit]!.first.t(code);

    final cleanLine = p.showHabit
        ? S.cleanFrom.t(code).replaceFirst('{habit}', habitTitle(p, code))
        : S.cleanPlain.t(code);

    final chips = <Widget>[
      if (p.showMoney && p.costOn) _chip('${s.money} $cur', S.mMoney.t(code)),
      if (p.showTime && p.timeSetupOn) _chip(Stats.fmtDuration(s.timeMinutesTotal, code), S.mTime.t(code)),
      if (p.showUnits && p.usageOn) _chip('${Stats.fmtNum(s.unitsAvoided)} $unitWord', S.mAvoided.t(code)),
      if (p.showMass && hu.massPer > 0)
        _chip(hu.massRound == 0 ? '${massVal.round()}' : massVal.toStringAsFixed(1), hu.massLabel.t(code)),
    ];

    Future<List<int>> capture() async {
      final b = _boundary.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final img = await b.toImage(pixelRatio: 3);
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    }

    Future<void> share() async {
      final dir = await getTemporaryDirectory();
      final f = File('${dir.path}/sanad_card.png');
      await f.writeAsBytes(await capture());
      await Share.shareXFiles([XFile(f.path)], text: 'سند · sanad.com.ly');
    }

    Future<void> saveImage() async {
      try {
        final bytes = Uint8List.fromList(await capture());
        await Gal.putImageBytes(bytes, name: 'sanad_${s.daysClean}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.savedToGallery.t(code)), backgroundColor: SanadColors.primary),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.saveFailed.t(code))));
        }
      }
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
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: SanadColors.heroGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  // decorative depth
                  Positioned(top: -40, right: -30, child: _blob(140, 0.07)),
                  Positioned(bottom: -50, left: -40, child: _blob(170, 0.06)),
                  Positioned(
                    bottom: 8, right: 10,
                    child: Icon(Icons.eco, size: 90, color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 22),
                    child: Column(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3B23C).withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFDD91), width: 1.5),
                          ),
                          child: const Icon(Icons.workspace_premium, color: Color(0xFFFFDD91), size: 30),
                        ),
                        const SizedBox(height: 12),
                        Text('${s.daysClean}',
                            style: const TextStyle(color: Colors.white, fontSize: 62, fontWeight: FontWeight.w800, height: 1)),
                        Text(cleanLine, style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 14)),
                        const SizedBox(height: 18),
                        if (chips.isNotEmpty)
                          Wrap(alignment: WrapAlignment.center, spacing: 10, runSpacing: 10, children: chips),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/brand/sanad-mark-light.png', height: 16),
                            const SizedBox(width: 8),
                            const Text('سند · sanad.com.ly', style: TextStyle(color: Color(0xFF9FCBB1), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _toggle(S.mMoney.t(code), p.showMoney, (v) => app.updateProfile((x) => x.showMoney = v)),
          _toggle(S.mTime.t(code), p.showTime, (v) => app.updateProfile((x) => x.showTime = v)),
          _toggle(S.mAvoided.t(code), p.showUnits, (v) => app.updateProfile((x) => x.showUnits = v)),
          if (hu.massPer > 0) _toggle(S.chMass.t(code), p.showMass, (v) => app.updateProfile((x) => x.showMass = v)),
          _toggle(S.chHabit.t(code), p.showHabit, (v) => app.updateProfile((x) => x.showHabit = v)),
          const SizedBox(height: 14),
          FilledButton.icon(icon: const Icon(Icons.download_rounded), label: Text(S.saveImage.t(code)), onPressed: saveImage),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.ios_share, color: SanadColors.primary),
            label: Text(S.shareBtn.t(code), style: const TextStyle(color: SanadColors.primary)),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: SanadColors.ringB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            onPressed: share,
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, double alpha) => Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: alpha)),
      );

  Widget _chip(String v, String l) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(v, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            Text(l, style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 10)),
          ],
        ),
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
