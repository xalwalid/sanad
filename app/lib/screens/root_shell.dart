import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'recovery_screen.dart';
import 'community_screen.dart';
import 'me_screen.dart';

/// The 5-tab shell: Home · Progress · Recovery · Community · Me.
class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final code = context.watch<AppState>().lang;
    final tabs = [
      HomeTab(onOpenRecovery: () => setState(() => _index = 2)),
      const ProgressScreen(),
      const RecoveryScreen(),
      const CommunityScreen(),
      const MeScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: SanadColors.selectedTint,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          height: 66,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            _dest(Icons.home_outlined, Icons.home, S.navHome.t(code)),
            _dest(Icons.show_chart_outlined, Icons.show_chart, S.navProgress.t(code)),
            _dest(Icons.spa_outlined, Icons.spa, S.navRecovery.t(code)),
            _dest(Icons.groups_outlined, Icons.groups, S.navCommunity.t(code)),
            _dest(Icons.person_outline, Icons.person, S.navMe.t(code)),
          ],
        ),
      ),
    );
  }

  NavigationDestination _dest(IconData icon, IconData sel, String label) =>
      NavigationDestination(
        icon: Icon(icon, color: SanadColors.textSecondary),
        selectedIcon: Icon(sel, color: SanadColors.primary),
        label: label,
      );
}
