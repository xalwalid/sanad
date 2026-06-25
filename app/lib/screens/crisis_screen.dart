import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

/// Ships even in the fully-offline Phase 1. Gentle, never shames, never
/// diagnoses. Localize the resource list per country before launch.
class CrisisScreen extends StatelessWidget {
  const CrisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.read<AppState>().lang;
    String tr(L l) => l.t(code);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(tr(S.crisisTitle), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(tr(S.crisisBody), style: const TextStyle(height: 1.6, color: SanadColors.body)),
          const SizedBox(height: 18),
          _res(Icons.favorite_border, code == 'ar' ? 'ابحث عن خط دعم قريب' : 'Find a helpline near you', 'findahelpline.com'),
          _res(Icons.people_outline, code == 'ar' ? 'تواصل مع شخص تثق به' : 'Reach a trusted person', code == 'ar' ? 'اتصل أو راسل من تثق به.' : 'Call or message someone you trust.'),
          _res(Icons.local_hospital_outlined, code == 'ar' ? 'خدمات الطوارئ' : 'Emergency services', code == 'ar' ? 'إن كنت في خطر فوري، اتصل برقم الطوارئ المحلي.' : 'If in immediate danger, call your local emergency number.'),
          const SizedBox(height: 14),
          Text(tr(S.notMedical), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _res(IconData icon, String title, String sub) => Card(
        child: ListTile(
          leading: Icon(icon, color: SanadColors.sos2),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(sub),
        ),
      );
}
