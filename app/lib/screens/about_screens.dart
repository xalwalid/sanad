import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/sanad_theme.dart';

const _rakeezaEmail = 'rakeeza.ly@gmail.com';
const _siteBase = 'https://sanad.com.ly';

Future<void> _open(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Simple offline legal viewer. Full versions live on sanad.com.ly.
class LegalScreen extends StatelessWidget {
  final String title;
  final String body;
  final String fullPath; // e.g. /privacy
  final bool ar;
  const LegalScreen({super.key, required this.title, required this.body, required this.fullPath, required this.ar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SanadColors.page,
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Text(body, style: const TextStyle(fontSize: 14, height: 1.9, color: SanadColors.body)),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(ar ? 'اقرأ النسخة الكاملة على sanad.com.ly' : 'Read the full version on sanad.com.ly'),
            style: OutlinedButton.styleFrom(foregroundColor: SanadColors.primary, side: const BorderSide(color: SanadColors.ringB)),
            onPressed: () => _open('$_siteBase$fullPath'),
          ),
        ],
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  final bool ar;
  const ContactScreen({super.key, required this.ar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SanadColors.page,
      appBar: AppBar(title: Text(ar ? 'تواصل معنا' : 'Contact us')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          Text(
              ar
                  ? 'يسعدنا سماع رأيك أو أيّ مشكلة تواجهها. سند أحد منتجات ركيزة.'
                  : "We'd love your feedback or to help with any issue. Sanad is a product of Rakeeza.",
              style: const TextStyle(fontSize: 14, height: 1.7, color: SanadColors.body)),
          const SizedBox(height: 18),
          _row(Icons.mail_outline, ar ? 'البريد الإلكتروني' : 'Email', _rakeezaEmail,
              () => _open('mailto:$_rakeezaEmail?subject=Sanad')),
          _row(Icons.language, ar ? 'الموقع' : 'Website', 'sanad.com.ly', () => _open(_siteBase)),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value, VoidCallback onTap) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SanadColors.border)),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: SanadColors.iconTile, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: SanadColors.primary),
          ),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading, fontSize: 14)),
          subtitle: Text(value, style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
          trailing: const Icon(Icons.chevron_right, color: SanadColors.textSecondary),
        ),
      );
}

// ---- bundled concise legal text (full versions on sanad.com.ly) ----

const privacyAr = '''آخر تحديث: 1 يوليو 2026

خصوصيتك هي أساس سند. يعمل التطبيق بالكامل على جهازك دون حساب ودون اتصال بخوادمنا.

• لا نجمع أيّ بيانات شخصية: لا اسم، ولا بريد، ولا رقم هاتف، ولا تسجيل حساب.
• كل ما تُدخله (تاريخ الإقلاع، أيامك، تسجيلات المزاج والرغبة، الإعدادات) يُخزَّن محليًا على جهازك فقط.
• لا نستخدم أدوات تحليل أو تتبّع، ولا نعرض إعلانات.
• صلاحية الصور تُستخدم فقط عند حفظ بطاقة إنجازك في المعرض؛ لا نصل إلى صورك ولا نرفع أيّ صورة.
• لأنّ بياناتك على جهازك، يمكنك حذف رحلتك من داخل التطبيق في أيّ وقت، أو بحذف التطبيق.

سند أحد منتجات ركيزة. للأسئلة: rakeeza.ly@gmail.com''';

const privacyEn = '''Last updated: 1 July 2026

Your privacy is the foundation of Sanad. The app runs entirely on your device, with no account and no connection to our servers.

• We collect no personal data: no name, no email, no phone number, no sign-up.
• Everything you enter (quit date, clean days, mood/craving check-ins, settings) is stored locally on your device only.
• We use no analytics or tracking, and show no ads.
• The photo permission is used only to save your achievement card to your gallery; we never access your photos or upload any image.
• Because your data is on your device, you can delete your journey in-app anytime, or by uninstalling.

Sanad is a product of Rakeeza. Questions: rakeeza.ly@gmail.com''';

const termsAr = '''آخر تحديث: 1 يوليو 2026

باستخدامك سند فإنك توافق على هذه الشروط.

• سند مساحة دعم ذاتي ومجتمعي. وهو ليس خدمة طبّية أو نفسية أو علاجية أو طارئة، ولا يُغني عن استشارة المختصّين.
• إن كنت في أزمة أو تفكّر في إيذاء نفسك، فاتصل فورًا بخدمات الطوارئ المحلية أو بشخص تثق به.
• المعلومات داخل التطبيق لأغراض داعمة وتثقيفية عامّة وقد تختلف من شخص لآخر.
• التعافي رحلة شخصية، وأنت مسؤول عن قراراتك المتعلّقة بصحّتك.
• اسم سند وشعاره ومحتواه مملوكة لركيزة.
• يُقدَّم التطبيق «كما هو» دون ضمانات، إلى الحدّ الذي يسمح به القانون. تخضع الشروط لقوانين ليبيا.

للأسئلة: rakeeza.ly@gmail.com''';

const termsEn = '''Last updated: 1 July 2026

By using Sanad you agree to these terms.

• Sanad is a self-help and peer-support space. It is not a medical, psychological, therapeutic, or emergency service, and is not a substitute for professional advice.
• If you are in crisis or thinking about harming yourself, contact your local emergency services or someone you trust immediately.
• Information in the app is for general supportive and educational purposes and may vary from person to person.
• Recovery is a personal journey, and you are responsible for your health-related decisions.
• The Sanad name, logo, and content are owned by Rakeeza.
• The app is provided "as is" without warranties, to the extent permitted by law. These terms are governed by the laws of Libya.

Questions: rakeeza.ly@gmail.com''';
