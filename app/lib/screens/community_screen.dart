import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.watch<AppState>().lang;
    String tr(L l) => l.t(code);
    final samples = code == 'ar'
        ? const [
            ['QN', 'هادئ', 'اليوم 12 · القنّب', 'تجاوزت عطلة صعبة جدًا. تمرين التنفّس ساعدني الساعة الثانية فجرًا. شكرًا لكم.'],
            ['SR', 'مستقر', 'اليوم 90 · الكحول', '90 يومًا اليوم. قبل ستة أشهر لم أظنّ أنّي سأتجاوز اليوم الثالث. الأمر يتحسّن.'],
            ['M7', 'جبل', 'اليوم 4 · النيكوتين', 'هاجمتني الرغبة بعد الغداء. نشرت هنا بدل أن أستسلم. انتصار صغير لكنه لي.'],
          ]
        : const [
            ['QN', 'QuietNorth', 'day 12 · cannabis', 'Made it through a really hard weekend. The breathing exercise helped at 2am. Thank you all.'],
            ['SR', 'SteadyRiver', 'day 90 · alcohol', "90 days today. Six months ago I didn't think I'd pass day 3. It does get easier."],
            ['M7', 'Mountain7', 'day 4 · nicotine', 'Craving hit hard after lunch. Posted here instead of giving in. Small win but mine.'],
          ];

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Text(tr(S.communityTitle),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: SanadColors.softCardB, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: SanadColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(S.communitySoon),
                          style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading)),
                      Text(tr(S.communitySoonSub),
                          style: const TextStyle(fontSize: 12, color: SanadColors.body)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...samples.map((p) => _post(p[0], p[1], p[2], p[3])),
        ],
      ),
    );
  }

  Widget _post(String initials, String name, String meta, String text) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SanadColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 18, backgroundColor: SanadColors.accent, child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading, fontSize: 13)),
                    Text(meta, style: const TextStyle(fontSize: 11, color: SanadColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(height: 1.5, color: SanadColors.body, fontSize: 13)),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.favorite_border, size: 16, color: SanadColors.textSecondary),
                SizedBox(width: 16),
                Icon(Icons.mode_comment_outlined, size: 16, color: SanadColors.textSecondary),
              ],
            ),
          ],
        ),
      );
}
