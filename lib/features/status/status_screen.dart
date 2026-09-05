import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import 'comments_screen.dart';

/// figma 49:6. community feed - composer on top, then posts with author,
/// optional alert badge, body and counts.
class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final TextEditingController _composer = TextEditingController();

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  void _openComments() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CommentsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _appBar(context),
        Expanded(
          child: ColoredBox(
            color: AppColors.surfaceBackdrop,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
              children: <Widget>[
                _composerCard(context),
                const SizedBox(height: 32),
                _PostCard(
                  author: context.tr('status.post1Author'),
                  meta: context.tr('status.post1Meta'),
                  badge: context.tr('status.post1Badge'),
                  body: context.tr('status.post1Body'),
                  link: context.tr('status.post1Link'),
                  likes: context.tr('status.post1Likes'),
                  comments: context.tr('status.post1Comments'),
                  onComments: _openComments,
                ),
                const SizedBox(height: 24),
                _PostCard(
                  author: context.tr('status.post2Author'),
                  meta: context.tr('status.post2Meta'),
                  body: context.tr('status.post2Body'),
                  likes: context.tr('status.post2Likes'),
                  comments: context.tr('status.post2Comments'),
                  onComments: _openComments,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _appBar(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 32,
                  height: 32,
                  filterQuality: FilterQuality.medium,
                  cacheWidth: 96,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('app.name'),
                    style: appTextStyle(
                      size: 28,
                      lineHeight: 36,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 22,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// white card with the prompt + Post button
  Widget _composerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            controller: _composer,
            maxLines: 3,
            style: appTextStyle(
              size: 16,
              lineHeight: 24,
              color: AppColors.onSurfaceStrong,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: context.tr('status.composerHint'),
              hintStyle: appTextStyle(
                size: 16,
                lineHeight: 24,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          PrimaryPillButton(
            label: context.tr('status.post'),
            height: 40,
            width: null,
            onPressed: () => _composer.clear(),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.author,
    required this.meta,
    required this.body,
    required this.likes,
    required this.comments,
    required this.onComments,
    this.badge,
    this.link,
  });

  final String author;
  final String meta;
  final String body;
  final String likes;
  final String comments;
  final VoidCallback onComments;
  final String? badge;
  final String? link;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 22,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      author,
                      style: appTextStyle(
                        size: 16,
                        lineHeight: 24,
                        weight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceStrong,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      meta,
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge!,
                    style: appTextStyle(
                      size: 10,
                      lineHeight: 16,
                      weight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: AppColors.onErrorContainer,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: appTextStyle(
              size: 14,
              lineHeight: 20,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (link != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              link!,
              style: appTextStyle(
                size: 14,
                lineHeight: 20,
                weight: FontWeight.w500,
                letterSpacing: 0.25,
                color: AppColors.primary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              _Count(icon: Icons.favorite_border, label: likes),
              const SizedBox(width: 24),
              InkWell(
                onTap: onComments,
                child: _Count(
                  icon: Icons.chat_bubble_outline,
                  label: comments,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        Text(
          label,
          style: appTextStyle(
            size: 14,
            lineHeight: 20,
            letterSpacing: 0.25,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
