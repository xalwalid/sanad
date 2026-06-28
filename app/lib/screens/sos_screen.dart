import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/catalog.dart';
import '../data/strings.dart';
import '../state/app_state.dart';
import '../theme/sanad_theme.dart';

/// Craving SOS: a calming, pulsing breathing guide (breathe in / out).
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});
  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = context.read<AppState>().lang;
    String tr(L l) => l.t(code);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: SanadColors.heroGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Spacer(),
                Text(tr(S.sosTitle),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(tr(S.sosSub),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFCFE6D8), height: 1.5)),
                const SizedBox(height: 36),
                AnimatedBuilder(
                  animation: _c,
                  builder: (_, __) {
                    final v = _c.value; // 0..1
                    final inhale = v < 0.5;
                    final p = inhale ? v / 0.5 : 1 - (v - 0.5) / 0.5; // 0..1 grow/shrink
                    final scale = 0.62 + 0.38 * p;
                    return Column(
                      children: [
                        SizedBox(
                          height: 230,
                          width: 230,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // outer glow
                              Container(
                                width: 200 * scale,
                                height: 200 * scale,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SanadColors.sos2.withValues(alpha: 0.18 + 0.18 * p),
                                ),
                              ),
                              Container(
                                width: 150 * scale,
                                height: 150 * scale,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [SanadColors.sos1, SanadColors.sos2],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(inhale ? tr(S.breatheIn) : tr(S.breatheOut),
                                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                Text(tr(S.sosReassure),
                    style: const TextStyle(color: Color(0xFFCFE6D8), fontSize: 13)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: SanadColors.primary),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(tr(S.imOkay)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
