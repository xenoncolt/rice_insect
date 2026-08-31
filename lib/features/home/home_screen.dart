import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../scanner/camera_scanner_screen.dart';
import 'widgets/home_top_app_bar.dart';
import 'widgets/recent_activity_card.dart';
import 'widgets/scan_action_card.dart';
import 'widgets/welcome_weather_card.dart';

/// Node 59:356. Cards fade and rise in sequence on first paint.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CameraScannerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const HomeTopAppBar(),
        Expanded(
          child: ColoredBox(
            color: AppColors.surfaceBackdrop,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: <Widget>[
                  _Staggered(
                    controller: _entrance,
                    order: 0,
                    child: const WelcomeWeatherCard(),
                  ),
                  const SizedBox(height: 24),
                  _Staggered(
                    controller: _entrance,
                    order: 1,
                    child: ScanActionCard(onScanPressed: _openScanner),
                  ),
                  const SizedBox(height: 32),
                  _Staggered(
                    controller: _entrance,
                    order: 2,
                    child: const RecentActivityCard(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Fades and lifts [child] into place, offset by [order] so the cards arrive
/// one after another rather than all at once.
class _Staggered extends StatelessWidget {
  const _Staggered({
    required this.controller,
    required this.order,
    required this.child,
  });

  final AnimationController controller;
  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double start = (order * 0.15).clamp(0.0, 1.0);
    final CurvedAnimation animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        start,
        (start + 0.55).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
