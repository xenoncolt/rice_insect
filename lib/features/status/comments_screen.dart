import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../settings/widgets/settings_app_bar.dart';

/// figma 49:186. the thread behind a post - question, indented replies,
/// composer stuck to the bottom.
class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _Comment {
  const _Comment({
    required this.author,
    required this.time,
    required this.body,
    required this.likes,
    this.reply = false,
  });

  final String author;
  final String time;
  final String body;
  final String likes;
  final bool reply;
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_Comment> thread = <_Comment>[
      _Comment(
        author: context.tr('comments.c1Author'),
        time: context.tr('comments.c1Time'),
        body: context.tr('comments.c1Body'),
        likes: context.tr('comments.c1Likes'),
      ),
      _Comment(
        author: context.tr('comments.c2Author'),
        time: context.tr('comments.c2Time'),
        body: context.tr('comments.c2Body'),
        likes: context.tr('comments.c2Likes'),
        reply: true,
      ),
      _Comment(
        author: context.tr('comments.c3Author'),
        time: context.tr('comments.c3Time'),
        body: context.tr('comments.c3Body'),
        likes: context.tr('comments.c3Likes'),
        reply: true,
      ),
      _Comment(
        author: context.tr('comments.c4Author'),
        time: context.tr('comments.c4Time'),
        body: context.tr('comments.c4Body'),
        likes: context.tr('comments.c4Likes'),
        reply: true,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          SettingsAppBar(title: context.tr('comments.title')),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              itemCount: thread.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (BuildContext context, int i) =>
                  _CommentTile(comment: thread[i]),
            ),
          ),
          _composer(context),
        ],
      ),
    );
  }

  Widget _composer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          spacing: 8,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _input,
                style: appTextStyle(
                  size: 16,
                  lineHeight: 24,
                  color: AppColors.onSurfaceStrong,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                  hintText: context.tr('comments.inputHint'),
                  hintStyle: appTextStyle(
                    size: 16,
                    lineHeight: 24,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _input.clear(),
              icon: const Icon(Icons.send, size: 20, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final _Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: comment.reply ? 32 : 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: comment.reply
              ? AppColors.surfaceSubtle
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    comment.author,
                    style: appTextStyle(
                      size: 14,
                      lineHeight: 20,
                      weight: FontWeight.w500,
                      letterSpacing: 0.25,
                      color: AppColors.onSurfaceStrong,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  comment.time,
                  style: appTextStyle(
                    size: 12,
                    lineHeight: 16,
                    letterSpacing: 0.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.body,
              style: appTextStyle(
                size: 14,
                lineHeight: 20,
                letterSpacing: 0.25,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 16,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: <Widget>[
                    const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                    Text(
                      comment.likes,
                      style: appTextStyle(
                        size: 12,
                        lineHeight: 16,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  context.tr('comments.reply'),
                  style: appTextStyle(
                    size: 12,
                    lineHeight: 16,
                    weight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
