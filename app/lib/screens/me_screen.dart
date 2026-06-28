import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import 'relapse_screen.dart';
import 'crisis_screen.dart';
import 'sos_screen.dart';

const _habitIcons = {
  Habit.cannabis: Icons.eco_outlined,
  Habit.alcohol: Icons.local_bar_outlined,
  Habit.cigarettes: Icons.smoking_rooms_outlined,
  Habit.vaping: Icons.air_outlined,
  Habit.gambling: Icons.casino_outlined,
  Habit.porn: Icons.visibility_off_outlined,
  Habit.other: Icons.more_horiz,
};

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final code = app.lang;
    String tr(L l) => l.t(code);
    final s = app.stats;
    final p = app.profile!;
    final cur = code == 'ar' ? 'د.ل' : 'LYD';

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          // profile header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(gradient: SanadColors.heroGradient, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  child: Image.asset('assets/brand/sanad-mark-light.png', width: 40),
                ),
                const SizedBox(height: 8),
                Text(tr(S.anonName),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                Text(p.countryCode, style: const TextStyle(color: Color(0xFFBFD6C9), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _section(tr(S.myReasons)),
          _tile(Icons.savings_outlined, S.mMoney.t(code), '${s.money} $cur', null),

          _section(tr(S.tracking)),
          _tile(_habitIcons[p.habit], habitTitle(p, code),
              '${s.daysClean} ${S.unitDay.t(code)}', null),
          _tile(Icons.event_outlined, tr(S.editQuitDate), tr(S.editQuitDateSub),
              () => _editDate(context, app)),

          _section(code == 'ar' ? 'الرحلة' : 'Journey'),
          _tile(Icons.refresh, tr(S.relapseReset), tr(S.relapseResetSub),
              () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RelapseScreen()))),
          _tile(Icons.delete_outline, tr(S.deleteJourney), tr(S.deleteJourneySub),
              () => _confirmDelete(context, app), danger: true),

          _section(code == 'ar' ? 'الخصوصية والبيانات' : 'Privacy & data'),
          _tile(Icons.phone_iphone, tr(S.onDevice), tr(S.onDeviceSub), null),
          _tile(Icons.download_outlined, tr(S.backupTitle), tr(S.backupSub), null),
          _tile(Icons.language, tr(S.languageLabel), code == 'ar' ? 'العربية · English' : 'English · العربية',
              () => app.toggleLocale()),

          _section(code == 'ar' ? 'الدعم' : 'Support'),
          _tile(Icons.self_improvement, tr(S.sosButton), tr(S.sosCue),
              () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosScreen())),
              accent: SanadColors.sos2),
          _tile(Icons.support_outlined, tr(S.needSupport), tr(S.crisisTitle),
              () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CrisisScreen())),
              accent: SanadColors.sos2),
        ],
      ),
    );
  }

  Future<void> _editDate(BuildContext context, AppState app) async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: app.profile!.quitDate,
      firstDate: today.subtract(const Duration(days: 3650)),
      lastDate: today,
    );
    if (picked != null) await app.setQuitDate(picked);
  }

  Future<void> _confirmDelete(BuildContext context, AppState app) async {
    final code = app.lang;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.deleteConfirmTitle.t(code)),
        content: Text(S.deleteConfirmBody.t(code)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(S.cancel.t(code))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: SanadColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.deleteConfirmYes.t(code)),
          ),
        ],
      ),
    );
    if (ok == true) await app.deleteJourney(); // flips to onboarding via MaterialApp.home
  }

  Widget _section(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SanadColors.textSecondary)),
      );

  Widget _tile(IconData? icon, String title, String sub, VoidCallback? onTap,
          {bool danger = false, Color? accent}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SanadColors.border)),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: danger ? const Color(0xFFFBECEC) : SanadColors.iconTile,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: danger ? SanadColors.danger : (accent ?? SanadColors.primary)),
          ),
          title: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: danger ? SanadColors.danger : SanadColors.heading,
                  fontSize: 14)),
          subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
          trailing: onTap == null ? null : const Icon(Icons.chevron_right, color: SanadColors.textSecondary),
        ),
      );
}
