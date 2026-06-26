import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import '../widgets/progress_ring.dart';
import 'checkin_screen.dart';
import 'health_screen.dart';
import 'milestone_card_screen.dart';
import 'relapse_screen.dart';
import 'crisis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _t?.cancel();
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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            // header row: mark + language + settings
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
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.settings_outlined, color: SanadColors.heading),
                  onPressed: () => _openSettings(context, app),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // greeting
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr(S.greeting),
                      style: const TextStyle(color: SanadColors.textSecondary, fontSize: 14)),
                  Text(S.quittingFrom.t(code).replaceFirst('{habit}', habitName),
                      style: const TextStyle(
                          color: SanadColors.heading, fontSize: 19, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // sober-clock card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
              decoration: BoxDecoration(
                gradient: SanadColors.heroGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: SanadTheme.cardShadow,
              ),
              child: Column(
                children: [
                  ProgressRing(
                    progress: s.ringProgress,
                    size: 220,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${s.daysClean}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 78,
                                fontWeight: FontWeight.w800,
                                height: 1)),
                        Text(tr(S.daysClean),
                            style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 13)),
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text('${two(h)}:${two(m)}:${two(sec)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFeatures: [FontFeature.tabularFigures()])),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${tr(S.nextMilestone)} — ${S.remains.t(code).replaceFirst('{n}', '${s.daysToNext}').replaceFirst('{m}', '${s.nextMilestone}')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFD7EDE0), fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            _pledge(app, code),
            const SizedBox(height: 12),
            _checkinCta(context, code),
            const SizedBox(height: 16),
            _statsGrid(s, p, code),
            const SizedBox(height: 14),
            _recoveryBanner(context, code),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.ios_share, color: SanadColors.primary),
              label: Text(tr(S.shareMilestone), style: const TextStyle(color: SanadColors.primary)),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  side: const BorderSide(color: SanadColors.ringB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ShareCardScreen())),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RelapseScreen())),
              child: Text(tr(S.logRelapse), style: const TextStyle(color: SanadColors.textSecondary)),
            ),
          ],
        ),
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

  Widget _statsGrid(s, p, String code) {
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

  Widget _recoveryBanner(BuildContext context, String code) => GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HealthScreen())),
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

  void _openSettings(BuildContext context, AppState app) {
    final code = app.lang;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language, color: SanadColors.primary),
              title: Text(code == 'ar' ? 'English' : 'العربية'),
              onTap: () { app.toggleLocale(); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: SanadColors.primary),
              title: Text(S.logRelapse.t(code)),
              onTap: () { Navigator.pop(context); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RelapseScreen())); },
            ),
            ListTile(
              leading: const Icon(Icons.support_outlined, color: SanadColors.sos2),
              title: Text(S.needSupport.t(code)),
              onTap: () { Navigator.pop(context); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CrisisScreen())); },
            ),
          ],
        ),
      ),
    );
  }
}
