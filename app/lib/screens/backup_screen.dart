import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

/// Identity-free backup: the whole on-device journey encoded as a code the user
/// can copy and paste on another phone. No account, no server.
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});
  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _restoreCtrl = TextEditingController();

  String _code(AppState app) =>
      base64Encode(utf8.encode(app.exportBackup()));

  Future<void> _restore(AppState app) async {
    final code = app.lang == 'ar';
    try {
      final json = utf8.decode(base64Decode(_restoreCtrl.text.trim()));
      await app.importBackup(json);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(code ? 'تمت الاستعادة بنجاح' : 'Restored successfully'),
          backgroundColor: SanadColors.primary));
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(code
              ? 'الرمز غير صالح. تأكّد من نسخه كاملًا.'
              : "That code isn't valid. Make sure you copied all of it.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final ar = app.lang == 'ar';
    final code = _code(app);

    return Scaffold(
      backgroundColor: SanadColors.page,
      appBar: AppBar(title: Text(ar ? 'نسخة احتياطية' : 'Backup')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
        children: [
          Text(ar ? 'احفظ رحلتك' : 'Save your journey',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 6),
          Text(
              ar
                  ? 'انسخ هذا الرمز واحفظه في مكان آمن. الصقه في تطبيق سند على هاتف جديد لاستعادة أيامك وسجلّاتك — بلا حساب.'
                  : 'Copy this code and keep it safe. Paste it into Sanad on a new phone to restore your days and check-ins — no account needed.',
              style: const TextStyle(fontSize: 13, color: SanadColors.body, height: 1.6)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: SanadColors.border)),
            child: SelectableText(code,
                maxLines: 6,
                style: const TextStyle(fontSize: 11, color: SanadColors.body, height: 1.5)),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.copy_rounded),
            label: Text(ar ? 'نسخ الرمز' : 'Copy code'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ar ? 'تم نسخ الرمز' : 'Code copied'),
                  backgroundColor: SanadColors.primary));
            },
          ),

          const Divider(height: 44),

          Text(ar ? 'استعادة من رمز' : 'Restore from a code',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: SanadColors.heading)),
          const SizedBox(height: 6),
          Text(
              ar
                  ? 'الصق رمز النسخة الاحتياطية هنا. سيحلّ محلّ بيانات هذا الجهاز.'
                  : "Paste a backup code here. It will replace this device's data.",
              style: const TextStyle(fontSize: 13, color: SanadColors.body, height: 1.6)),
          const SizedBox(height: 12),
          TextField(
            controller: _restoreCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: ar ? 'الصق الرمز…' : 'Paste code…',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: SanadColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: SanadColors.border)),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.restore),
            label: Text(ar ? 'استعادة' : 'Restore'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: SanadColors.ringB),
                foregroundColor: SanadColors.primary),
            onPressed: () => _restore(app),
          ),
        ],
      ),
    );
  }
}
