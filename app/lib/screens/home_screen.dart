import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import '../widgets/progress_ring.dart';
import 'checkin_screen.dart';
import 'milestone_card_screen.dart';

/// Home tab body (no Scaffold — RootShell provides it).
class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onOpenRecovery});
  final VoidCallback onOpenRecovery;
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  Timer? _t;
  late final AnimationController _breathe;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
    _breathe = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _t?.cancel();
    _breathe.dispose();
    super.dispose();
  }

  String two(int n) => n < 10 ? '0$n' : '$n';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    String tr(L l) => l.t(code);
    final s = app.stats;
    final p = app.profile!;
    final habitName = tr(habitCatalog[p.habit]!.name);

    final since = DateTime.now().difference(p.quitDate);
    final h = since.inHours % 24, m = since.inMinutes % 60, sec = since.inSeconds % 60;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Row(
            children: [
              Image.asset('assets/brand/sanad-mark.png', height: 26),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Text(code == 'ar' ? 'EN' : 'ع',
                    style: const TextStyle(color: SanadColors.primary, fontWeight: FontWeight.w700)),
                onPressed: () => app.toggleLocale(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr(S.greeting), style: const TextStyle(color: SanadColors.textSecondary, fontSize: 14)),
                Text(S.quittingFrom.t(code).replaceFirst('{habit}', habitName),
                    style: const TextStyle(color: SanadColors.heading, fontSize: 19, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _clockCard(s, tr, code, h, m, sec),
          const SizedBox(height: 14),
          _pledge(app, code),
          const SizedBox(height: 12),
          _checkinCta(context, code),
          const SizedBox(height: 16),
          _statsGrid(s, p, code),
          const SizedBox(height: 14),
          _recoveryBanner(code),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.ios_share),
            label: Text(tr(S.shareMilestone)),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ShareCardScreen())),
          ),
        ],
      ),
    );
  }

  Widget _clockCard(Stats s, String Function(L) tr, String code, int h, int m, int sec) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
      decoration: BoxDecoration(
        gradient: SanadColors.heroGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: SanadTheme.cardShadow,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 230,
            height: 230,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // breathing glow
                AnimatedBuilder(
                  animation: _breathe,
                  builder: (_, __) {
                    final t = _breathe.value;
                    return Container(
                      width: 150 + 40 * t,
                      height: 150 + 40 * t,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05 + 0.06 * t),
                      ),
                    );
                  },
                ),
                ProgressRing(
                  progress: s.ringProgress,
                  size: 222,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${s.daysClean}',
                          style: const TextStyle(color: Colors.white, fontSize: 78, fontWeight: FontWeight.w800, height: 1)),
                      Text(tr(S.daysClean), style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 13)),
                      const SizedBox(height: 8),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text('${two(h)}:${two(m)}:${two(sec)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15, fontFeatures: [FontFeature.tabularFigures()])),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${tr(S.nextMilestone)} — ${S.remains.t(code).replaceFirst('{n}', '${s.daysToNext}').replaceFirst('{m}', '${s.nextMilestone}')}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFD7EDE0), fontSize: 12.5),
          ),
        ],
      ),
    );
  }

  Widget _pledge(AppState app, String code) {
    final done = app.pledgedToday;
    return GestureDetector(
      onTap: () => app.setPledged(!done),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: done ? SanadColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: done ? SanadColors.primary : SanadColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(done ? Icons.check_circle : Icons.shield_outlined,
                color: done ? Colors.white : SanadColors.primary, size: 20),
            const SizedBox(width: 10),
            Text(done ? S.pledged.t(code) : S.pledge.t(code),
                style: TextStyle(color: done ? Colors.white : SanadColors.heading, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _checkinCta(BuildContext context, String code) => GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckInScreen())),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: SanadColors.border)),
          child: Row(
            children: [
              const Icon(Icons.favorite_outline, color: SanadColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.checkinCta.t(code), style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading)),
                    Text(S.checkinSub.t(code), style: const TextStyle(color: SanadColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: SanadColors.textSecondary),
            ],
          ),
        ),
      );

  Widget _statsGrid(Stats s, p, String code) {
    final cur = code == 'ar' ? 'د.ل' : 'LYD';
    final cells = [
      _stat(S.mMoney.t(code), p.costOn ? '${s.money} $cur' : '—'),
      _stat(S.mTime.t(code), p.timeSetupOn ? '${s.timeH} ${S.unitHour.t(code)}' : '—'),
      _stat(S.mLongest.t(code), '${s.longest}'),
      _stat(S.mAvoided.t(code), p.usageOn ? '${s.units}' : '—'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: cells,
    );
  }

  Widget _stat(String label, String value) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: SanadColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: SanadColors.heading)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
          ],
        ),
      );

  Widget _recoveryBanner(String code) => GestureDetector(
        onTap: widget.onOpenRecovery,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [SanadColors.softCardA, SanadColors.softCardB]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.spa_outlined, color: SanadColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.recoveryPath.t(code), style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading)),
                    Text(S.recoveryPathSub.t(code), style: const TextStyle(color: SanadColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: SanadColors.primary),
            ],
          ),
        ),
      );
}
