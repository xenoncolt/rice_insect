import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../activity/recent_activity_screen.dart';
import 'gallery_picker_screen.dart';
import 'processing_result_screen.dart';

/// Node 1:16968, backed by a live camera preview.
///
/// Every plugin call is guarded: on a device with no camera, with the
/// permission refused, or in a widget test where no platform channel exists,
/// the screen falls back to [_CameraViewport]'s message instead of throwing.
class CameraScannerScreen extends StatefulWidget {
  const CameraScannerScreen({super.key});

  @override
  State<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const double _viewfinderWidth = 280;
  static const double _viewfinderHeight = 373.33;

  late final AnimationController _scanLine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  List<CameraDescription> _cameras = const <CameraDescription>[];
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _flashOn = false;
  bool _initialising = true;
  bool _cameraFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanLine.dispose();
    _controller?.dispose();
    super.dispose();
  }

  /// Release the camera while the app is backgrounded and pick it up again on
  /// resume - Android revokes the handle otherwise.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _selectCamera(_cameraIndex);
    }
  }

  Future<void> _initCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        _markFailed();
        return;
      }
      _cameras = cameras;
      await _selectCamera(0);
    } on Object {
      // CameraException, permission refusal, or MissingPluginException under
      // `flutter test` - all end in the same fallback.
      _markFailed();
    }
  }

  Future<void> _selectCamera(int index) async {
    final CameraController? previous = _controller;
    final CameraController controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await previous?.dispose();
      await controller.initialize();
      await controller.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    } on Object {
      _markFailed();
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _controller = controller;
      _cameraIndex = index;
      _initialising = false;
      _cameraFailed = false;
    });
  }

  void _markFailed() {
    if (mounted) {
      setState(() {
        _initialising = false;
        _cameraFailed = true;
      });
    }
  }

  Future<void> _toggleFlash() async {
    setState(() => _flashOn = !_flashOn);
    try {
      await _controller?.setFlashMode(
        _flashOn ? FlashMode.torch : FlashMode.off,
      );
    } on Object {
      // Plenty of front cameras have no torch; the button just does nothing.
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) {
      return;
    }
    await _selectCamera((_cameraIndex + 1) % _cameras.length);
  }

  Future<void> _capture() async {
    final CameraController? controller = _controller;
    String? imagePath;

    if (controller != null && controller.value.isInitialized) {
      try {
        final XFile shot = await controller.takePicture();
        imagePath = shot.path;
      } on Object {
        // Fall through with no image; processing still runs.
      }
    }

    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ProcessingResultScreen(imagePath: imagePath),
      ),
    );
  }

  Future<void> _openGallery() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const GalleryPickerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _CameraViewport(
            controller: _controller,
            initialising: _initialising,
            failed: _cameraFailed,
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                _topBar(context),
                Expanded(child: _scanningArea(context)),
                _bottomControls(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _GlassCircleButton(
                icon: Icons.close,
                iconSize: 16.33,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              _GlassPill(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 9,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: <Widget>[
                    const _PulsingDot(),
                    Text(
                      context.tr('scanner.live'),
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        weight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _GlassCircleButton(
                icon: Icons.help_outline,
                iconSize: 23.33,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _GlassPill(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 11),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: <Widget>[
                const Icon(Icons.query_stats, size: 20, color: Colors.white),
                Text(
                  context.tr('scanner.detecting'),
                  style: appTextStyle(
                    size: 14,
                    lineHeight: 20,
                    weight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scanningArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: _viewfinderWidth,
            height: _viewfinderHeight,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                const _CornerAccent(alignment: Alignment.topLeft),
                const _CornerAccent(alignment: Alignment.topRight),
                const _CornerAccent(alignment: Alignment.bottomLeft),
                const _CornerAccent(alignment: Alignment.bottomRight),
                Center(
                  child: Opacity(
                    opacity: 0.3,
                    child: Icon(
                      Icons.center_focus_weak,
                      size: 36,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _scanLine,
                  builder: (BuildContext context, _) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: (_viewfinderHeight - 6) * _scanLine.value,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.scanAccent,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.scanAccent.withValues(
                                alpha: 0.9,
                              ),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _GlassPill(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
            child: Text(
              context.tr('scanner.hint'),
              textAlign: TextAlign.center,
              style: appTextStyle(
                size: 16,
                lineHeight: 24,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomControls(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[Colors.black, Color(0xCC000000), Color(0x00000000)],
          stops: <double>[0, 0.5, 1],
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            context.tr('scanner.mode'),
            style: appTextStyle(
              size: 12,
              lineHeight: 16,
              weight: FontWeight.w500,
              letterSpacing: 2.4,
              color: AppColors.scanAccent,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _GalleryThumbButton(onTap: _openGallery),
              _ControlIconButton(
                icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                onTap: _toggleFlash,
              ),
              _CaptureButton(
                key: const ValueKey<String>('capture-button'),
                onTap: _capture,
              ),
              _ControlIconButton(icon: Icons.cameraswitch, onTap: _flipCamera),
              _ControlIconButton(
                icon: Icons.history,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const RecentActivityScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The live preview, cropped to fill the screen, under the design's dark
/// scrim. Falls back to a message when no camera is available.
class _CameraViewport extends StatelessWidget {
  const _CameraViewport({
    required this.controller,
    required this.initialising,
    required this.failed,
  });

  final CameraController? controller;
  final bool initialising;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final CameraController? camera = controller;

    if (camera == null || !camera.value.isInitialized) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: initialising && !failed
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.scanAccent,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    context.tr('scanner.cameraUnavailable'),
                    textAlign: TextAlign.center,
                    style: appTextStyle(
                      size: 14,
                      lineHeight: 20,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
        ),
      );
    }

    final Size preview = camera.value.previewSize ?? const Size(1, 1);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            // previewSize is reported landscape-first, so swap the axes to
            // fill a portrait screen without stretching the image.
            width: preview.height,
            height: preview.width,
            child: CameraPreview(camera),
          ),
        ),
        const ColoredBox(color: Color(0x4D000000)),
      ],
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.scanGlass.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.scanGlass.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}

/// The green "live" dot, breathing so the chip reads as active.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: AppColors.scanAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _CornerAccent extends StatelessWidget {
  const _CornerAccent({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: AppColors.scanAccent, width: 4);
    const Radius radius = Radius.circular(24);

    final bool isTop = alignment.y < 0;
    final bool isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: 0.8,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              top: isTop ? side : BorderSide.none,
              bottom: isTop ? BorderSide.none : side,
              left: isLeft ? side : BorderSide.none,
              right: isLeft ? BorderSide.none : side,
            ),
            borderRadius: BorderRadius.only(
              topLeft: isTop && isLeft ? radius : Radius.zero,
              topRight: isTop && !isLeft ? radius : Radius.zero,
              bottomLeft: !isTop && isLeft ? radius : Radius.zero,
              bottomRight: !isTop && !isLeft ? radius : Radius.zero,
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlIconButton extends StatelessWidget {
  const _ControlIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}

/// Opens the in-app gallery grid. Shows the newest photo as its thumbnail once
/// the picker hands one back.
class _GalleryThumbButton extends StatelessWidget {
  const _GalleryThumbButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.scanGlass.withValues(alpha: 0.6),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.photo_library_outlined,
          size: 20,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatefulWidget {
  const _CaptureButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  State<_CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<_CaptureButton> {
  bool _held = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _held = true),
      onTapUp: (_) => setState(() => _held = false),
      onTapCancel: () => setState(() => _held = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _held ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 105,
          height: 105,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.scanAccent.withValues(alpha: 0.2),
          ),
          child: Container(
            width: 84,
            height: 84,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 6),
            ),
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
