import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import '../widgets/setup_cards.dart';

/// Edit money / time / intake during the journey (no delete+recreate).
class EditSetupScreen extends StatefulWidget {
  const EditSetupScreen({super.key});
  @override
  State<EditSetupScreen> createState() => _EditSetupScreenState();
}

class _EditSetupScreenState extends State<EditSetupScreen> {
  late final SetupValues _values;

  @override
  void initState() {
    super.initState();
    _values = SetupValues.fromProfile(context.read<AppState>().profile!);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final code = app.lang;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: SanadColors.heading,
        elevation: 0,
        title: Text(S.editSetup.t(code), style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SetupCards(values: _values, habit: app.profile!.habit, code: code),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await app.updateProfile((p) => _values.applyTo(p));
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(S.save.t(code)),
          ),
        ],
      ),
    );
  }
}
