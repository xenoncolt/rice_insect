import 'package:flutter/material.dart';

/// Dips slightly while held, so taps feel physical. Used by the primary
/// buttons and the activity rows.
class PressScale extends StatefulWidget {
  const PressScale({
    required this.child,
    this.onTap,
    this.scale = 0.97,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _held = false;

  void _setHeld(bool value) {
    if (_held != value) {
      setState(() => _held = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setHeld(true),
      onTapUp: (_) => _setHeld(false),
      onTapCancel: () => _setHeld(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _held ? widget.scale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
