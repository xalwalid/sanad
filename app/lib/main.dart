import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'theme/sanad_theme.dart';
import 'state/app_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/root_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(SanadApp(state: state));
}

class SanadApp extends StatelessWidget {
  const SanadApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<AppState>(
        builder: (context, app, _) {
          return MaterialApp(
            title: 'Sanad',
            debugShowCheckedModeBanner: false,
            theme: SanadTheme.light(),
            locale: app.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // Directionality follows the locale automatically (RTL for ar).
            home: const _RootGate(),
          );
        },
      ),
    );
  }
}

/// Decides between onboarding and the app shell *inside* the route, so the
/// swap is driven by a widget that lives under the Navigator. Deleting a
/// journey sets the profile to null; this rebuilds first (it is shallower than
/// the tabs) and tears the shell down before any tab can build against a
/// null profile - which used to throw and leave a blank screen.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final hasProfile = context.select<AppState, bool>((a) => a.hasProfile);
    return hasProfile ? const RootShell() : const OnboardingScreen();
  }
}
