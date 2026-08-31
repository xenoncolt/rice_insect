import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import 'processing_result_screen.dart';

/// Node 1:17419, backed by the device's photo library.
///
/// If the permission is refused the screen says so and offers the settings
/// shortcut. If the plugin is unavailable at all - as under `flutter test` -
/// it falls back to placeholder tiles so the layout still renders.
class GalleryPickerScreen extends StatefulWidget {
  const GalleryPickerScreen({this.debugPhotoLoader, super.key});

  /// Test seam. `PhotoManager.requestPermissionExtend` waits on the user, so it
  /// never completes without a platform channel and cannot be given a timeout
  /// without cutting off a real permission prompt. Supplying a loader here
  /// bypasses the plugin entirely; production always leaves it null.
  @visibleForTesting
  final Future<List<AssetEntity>> Function()? debugPhotoLoader;

  /// Placeholder tile count used only when no library is reachable.
  static const int placeholderCount = 12;

  /// How many photos to read from the camera roll.
  static const int pageSize = 60;

  @override
  State<GalleryPickerScreen> createState() => _GalleryPickerScreenState();
}

class _GalleryPickerScreenState extends State<GalleryPickerScreen> {
  List<AssetEntity> _assets = const <AssetEntity>[];
  final Set<int> _selected = <int>{};
  bool _loading = true;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final Future<List<AssetEntity>> Function()? loader =
        widget.debugPhotoLoader;
    if (loader != null) {
      final List<AssetEntity> injected = await loader();
      if (mounted) {
        setState(() {
          _assets = injected;
          if (injected.isNotEmpty) {
            _selected.add(0);
          }
          _loading = false;
        });
      }
      return;
    }

    try {
      final PermissionState state =
          await PhotoManager.requestPermissionExtend();
      if (!state.hasAccess) {
        if (mounted) {
          setState(() {
            _permissionDenied = true;
            _loading = false;
          });
        }
        return;
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.image,
      );
      final List<AssetEntity> assets = albums.isEmpty
          ? const <AssetEntity>[]
          : await albums.first.getAssetListPaged(
              page: 0,
              size: GalleryPickerScreen.pageSize,
            );

      if (!mounted) {
        return;
      }
      setState(() {
        _assets = assets;
        // Figma shows the first photo already picked.
        if (assets.isNotEmpty) {
          _selected.add(0);
        }
        _loading = false;
      });
    } on Object {
      // MissingPluginException under `flutter test`, or an unreadable library.
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  int get _tileCount => _assets.isNotEmpty
      ? _assets.length
      : GalleryPickerScreen.placeholderCount;

  void _toggle(int index) {
    setState(() {
      if (!_selected.remove(index)) {
        _selected.add(index);
      }
    });
  }

  Future<void> _upload() async {
    String? imagePath;
    if (_assets.isNotEmpty) {
      final int index = _selected.first;
      if (index < _assets.length) {
        try {
          imagePath = (await _assets[index].file)?.path;
        } on Object {
          // Fall through with no image; processing still runs.
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          _header(context),
          Expanded(child: _body(context)),
        ],
      ),
      bottomNavigationBar: _permissionDenied ? null : _uploadBar(context),
    );
  }

  Widget _body(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_permissionDenied) {
      return _permissionPrompt(context);
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: _folderRow(context)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return _PhotoTile(
                asset: index < _assets.length ? _assets[index] : null,
                selected: _selected.contains(index),
                onTap: () => _toggle(index),
              );
            }, childCount: _tileCount),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 96)),
      ],
    );
  }

  Widget _permissionPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              context.tr('gallery.permissionTitle'),
              textAlign: TextAlign.center,
              style: appTextStyle(
                size: 22,
                lineHeight: 28,
                weight: FontWeight.w500,
                color: AppColors.onSurfaceStrong,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('gallery.permissionBody'),
              textAlign: TextAlign.center,
              style: appTextStyle(
                size: 14,
                lineHeight: 20,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryPillButton(
              label: context.tr('gallery.grantAccess'),
              height: 48,
              width: null,
              onPressed: PhotoManager.openSetting,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 20),
                color: AppColors.onSurface,
              ),
              Flexible(
                child: Text(
                  context.tr('gallery.title'),
                  style: appTextStyle(
                    size: 28,
                    lineHeight: 36,
                    weight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _folderRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      context.tr('gallery.recent'),
                      style: appTextStyle(
                        size: 22,
                        lineHeight: 28,
                        weight: FontWeight.w500,
                        color: AppColors.onSurfaceStrong,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.onSurfaceStrong,
                  ),
                ],
              ),
            ),
          ),
          Text(
            context.tr('gallery.source'),
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 17, bottom: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.progressTrack)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Flexible so a longer translation shrinks the label instead of
            // overflowing the bar.
            Flexible(
              child: PrimaryPillButton(
                label: context.tr('gallery.upload', <String, String>{
                  'count': '${_selected.length}',
                }),
                icon: Icons.file_upload_outlined,
                iconSize: 16,
                width: null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                onPressed: _selected.isEmpty ? null : _upload,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  /// Null when no library is reachable, which draws the placeholder tile.
  final AssetEntity? asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AssetEntity? entity = asset;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          // Selecting insets and rounds the thumbnail, as drawn in Figma.
          Positioned.fill(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.all(selected ? 5.83 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(selected ? 8 : 4),
                ),
                child: entity == null
                    ? Icon(
                        Icons.image_outlined,
                        size: 28,
                        color: AppColors.outline.withValues(alpha: 0.8),
                      )
                    : AssetEntityImage(
                        entity,
                        isOriginal: false,
                        thumbnailSize: const ThumbnailSize.square(250),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.broken_image_outlined,
                          size: 28,
                          color: AppColors.outline.withValues(alpha: 0.8),
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.7),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
