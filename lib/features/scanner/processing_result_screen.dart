import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../pest/pest_details_screen.dart';

/// Node 1:17303.
///
/// The ring sweeps and the status line cross-fades over a fixed duration. When
/// the AI model lands, drive [_controller] from its real progress and pass the
/// result through to [PestDetailsScreen] instead of just the image.
class ProcessingResultScreen extends StatefulWidget {
  const ProcessingResultScreen({this.imagePath, super.key});

  /// The captured or picked photo. Null when the camera was unavailable.
  final String? imagePath;

  static const Duration analysisDuration = Duration(milliseconds: 4200);

  @override
  State<ProcessingResultScreen> createState() => _ProcessingResultScreenState();
}

class _ProcessingResultScreenState extends State<ProcessingResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: ProcessingResultScreen.analysisDuration,
  );

  @override
  void initState() {
    super.initState();
    // whenComplete does not fire if the controller is disposed first, so
    // cancelling out of the screen simply drops the hand-off.
    _controller.forward().whenComplete(_showResult);
  }

  void _showResult() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            PestDetailsScreen(imagePath: widget.imagePath),
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
        fit: StackFit.expand,
        children: <Widget>[
          _BlurredBackdrop(imagePath: widget.imagePath),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 512),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 192,
                        height: 192,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (BuildContext context, _) {
                                  return CircularProgressIndicator(
                                    value: _controller.value,
                                    strokeWidth: 8,
                                    backgroundColor: AppColors.progressTrack,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              width: 96,
                              height: 96,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.psychology,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        context.tr('processing.title'),
                        textAlign: TextAlign.center,
                        style: appTextStyle(
                          size: 28,
                          lineHeight: 36,
                          color: AppColors.onSurfaceStrong,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(height: 32, child: _statusMessage(context)),
                      const SizedBox(height: 16),
                      Text(
                        context.tr('processing.note'),
                        textAlign: TextAlign.center,
                        style: appTextStyle(
                          size: 14,
                          lineHeight: 20,
                          letterSpacing: 0.25,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 56),
                      _cancelButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Figma stacks two messages with the second at zero opacity; they swap
  /// halfway through the analysis.
  Widget _statusMessage(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final bool second = _controller.value > 0.5;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            context.tr(second ? 'processing.checking' : 'processing.analyzing'),
            key: ValueKey<bool>(second),
            textAlign: TextAlign.center,
            style: appTextStyle(
              size: 22,
              lineHeight: 28,
              weight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _cancelButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).maybePop(),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.outline),
        ),
        child: Text(
          context.tr('processing.cancel'),
          style: appTextStyle(
            size: 14,
            lineHeight: 20,
            weight: FontWeight.w500,
            letterSpacing: 0.1,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Node 1:17304 - the photo being analysed, blurred right back so the status
/// text stays readable over it.
class _BlurredBackdrop extends StatelessWidget {
  const _BlurredBackdrop({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final String? path = imagePath;
    if (path == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Transform.scale(
          scale: 1.05,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Opacity(
              opacity: 0.3,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.surface.withValues(alpha: 0.8),
                AppColors.surface.withValues(alpha: 0.9),
                AppColors.surface,
              ],
              stops: const <double>[0, 0.5, 1],
            ),
          ),
        ),
      ],
    );
  }
}
