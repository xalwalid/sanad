import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});
  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int _mood = 2; // 0..4
  int _craving = 1; // 0..4
  final _note = TextEditingController();

  static const _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  @override
  Widget build(BuildContext context) {
    final code = context.read<AppState>().lang;
    String tr(L l) => l.t(code);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(tr(S.checkinTitle), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
        children: [
          Text(tr(S.moodQ), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: SanadColors.heading)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final on = i == _mood;
              return GestureDetector(
                onTap: () => setState(() => _mood = i),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: on ? SanadColors.primary : Colors.white,
                  child: Icon(_moodIcons[i], color: on ? Colors.white : SanadColors.textSecondary, size: 26),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          Text(tr(S.cravingQ), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: SanadColors.heading)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (i) {
              final active = i <= _craving;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _craving = i),
                  child: Container(
                    height: 46,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: active ? SanadColors.craving[i] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SanadColors.border),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr(S.noCraving), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
              Text(tr(S.strongCraving), style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _note,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: tr(S.noteHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () async {
              await context.read<AppState>().addCheckIn(_mood, _craving, note: _note.text);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(tr(S.save)),
          ),
        ],
      ),
    );
  }
}
