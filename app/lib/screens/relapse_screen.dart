import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import 'crisis_screen.dart';

/// Compassionate reset — never "failure". Keeps longest streak + history.
class RelapseScreen extends StatelessWidget {
  const RelapseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final code = app.lang;
    String tr(L l) => l.t(code);
    final longest = app.stats.longest;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(tr(S.relapseTitle), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(color: SanadColors.selectedTint, shape: BoxShape.circle),
                child: const Icon(Icons.favorite_outline, color: SanadColors.accent, size: 32),
              ),
              const SizedBox(height: 16),
              Text(tr(S.relapseLine1), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: SanadColors.heading)),
              const SizedBox(height: 8),
              Text(tr(S.relapseLine2), textAlign: TextAlign.center, style: const TextStyle(color: SanadColors.textSecondary, height: 1.5)),
              const SizedBox(height: 24),
              _row(tr(S.longestKept), '$longest ${tr(S.unitDay)}'),
              const SizedBox(height: 10),
              _row(tr(S.historyKept), '✓'),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  await app.logRelapse();
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(tr(S.startAgain)),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.support_outlined, color: SanadColors.sos2, size: 18),
                label: Text(tr(S.needSupport), style: const TextStyle(color: SanadColors.sos2)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CrisisScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: SanadColors.softCardB, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: SanadColors.heading)),
            Text(value, style: const TextStyle(color: SanadColors.heading, fontWeight: FontWeight.w800)),
          ],
        ),
      );
}
