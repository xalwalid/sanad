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
            home: app.hasProfile ? const RootShell() : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
