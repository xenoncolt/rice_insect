import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'language_screen.dart';

/// Node 59:239 - the splash. The logo settles in while the bar fills, then the
/// screen hands off to language selection.
class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  static const Duration holdDuration = Duration(milliseconds: 2400);

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: StartingScreen.holdDuration,
  );

  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.35, curve: Curves.easeOut),
  );

  late final Animation<double> _logoScale = Tween<double>(begin: 0.88, end: 1)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0, 0.45, curve: Curves.easeOutBack),
        ),
      );

  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.1, 1, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(_goToLanguage);
  }

  void _goToLanguage() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) => const LanguageScreen(),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondary,
              Widget child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Stack(
        children: <Widget>[
          Center(
            child: FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 290,
                      height: 290,
                      filterQuality: FilterQuality.medium,
                      cacheWidth: 870,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.tr('app.name'),
                      style: appTextStyle(
                        size: 32,
                        lineHeight: 40,
                        weight: FontWeight.w500,
                        letterSpacing: -0.8,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 65,
            child: Center(
              child: SizedBox(
                width: 100,
                height: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.progressTrack,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (BuildContext context, _) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          // Starts at the 40pt bar drawn in Figma and fills.
                          widthFactor: 0.4 + (0.6 * _progress.value),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
