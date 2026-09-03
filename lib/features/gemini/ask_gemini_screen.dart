import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Node 1:17193.
///
/// Figma draws the assistant's reply as a header and timestamp with no body -
/// a mock-up placeholder rather than a real turn - so a reply bubble is
/// rendered here to make the conversation read sensibly. The sample exchange is
/// seeded content; swap [_seedConversation] for the real chat once a backend
/// exists.
class AskGeminiScreen extends StatefulWidget {
  const AskGeminiScreen({super.key});

  @override
  State<AskGeminiScreen> createState() => _AskGeminiScreenState();
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.time,
    required this.fromUser,
    this.hasAttachment = false,
  });

  final String text;
  final String time;
  final bool fromUser;
  final bool hasAttachment;
}

class _AskGeminiScreenState extends State<AskGeminiScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<_ChatMessage> _messages = const <_ChatMessage>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messages = _seedConversation(context);
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<_ChatMessage> _seedConversation(BuildContext context) {
    return <_ChatMessage>[
      _ChatMessage(
        text: context.tr('gemini.sampleQuestion'),
        time: context.tr('gemini.sampleQuestionTime'),
        fromUser: true,
        hasAttachment: true,
      ),
      _ChatMessage(
        text: context.tr('gemini.sampleAnswer'),
        time: context.tr('gemini.sampleAnswerTime'),
        fromUser: false,
      ),
    ];
  }

  void _send() {
    final String text = _input.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages = <_ChatMessage>[
        ..._messages,
        _ChatMessage(
          text: text,
          time: TimeOfDay.now().format(context),
          fromUser: true,
        ),
      ];
      _input.clear();
    });
    // Keep the newest turn in view once the list has laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _GeminiAppBar(),
        Expanded(
          child: ColoredBox(
            color: AppColors.surfaceBackdrop,
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                const _EmptyStateHeader(),
                for (final _ChatMessage message in _messages) ...<Widget>[
                  _MessageBubble(message: message),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        ),
        _InputBar(controller: _input, onSend: _send),
      ],
    );
  }
}

class _GeminiAppBar extends StatelessWidget {
  const _GeminiAppBar();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.surface),
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
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 20,
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
}

class _EmptyStateHeader extends StatelessWidget {
  const _EmptyStateHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.auto_awesome,
            size: 32,
            color: AppColors.geminiAccent,
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('gemini.emptyTitle'),
            textAlign: TextAlign.center,
            style: appTextStyle(
              size: 28,
              lineHeight: 36,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('gemini.emptyBody'),
            textAlign: TextAlign.center,
            style: appTextStyle(
              size: 16,
              lineHeight: 24,
              letterSpacing: 0.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool user = message.fromUser;

    return Column(
      crossAxisAlignment: user
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        if (!user) ...<Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: <Widget>[
                const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: AppColors.geminiAccent,
                ),
                Text(
                  context.tr('gemini.label'),
                  style: appTextStyle(
                    size: 12,
                    lineHeight: 16,
                    weight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: user ? AppColors.chatBubble : AppColors.surfaceCard,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(user ? 24 : 8),
                topRight: Radius.circular(user ? 8 : 24),
                bottomLeft: const Radius.circular(24),
                bottomRight: const Radius.circular(24),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: appTextStyle(
                size: 14,
                lineHeight: 20,
                letterSpacing: 0.25,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (message.hasAttachment) ...<Widget>[
          const SizedBox(height: 8),
          // Placeholder for the photo attached to a question; real chats carry
          // the captured or picked image here.
          Container(
            width: 192,
            height: 128,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outline.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              Icons.image_outlined,
              size: 28,
              color: AppColors.outline.withValues(alpha: 0.9),
            ),
          ),
        ],
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            message.time,
            style: appTextStyle(
              size: 12,
              lineHeight: 16,
              weight: FontWeight.w500,
              letterSpacing: 0.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: AppColors.surfaceBackdrop.withValues(alpha: 0.95),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(32),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              spacing: 8,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => onSend(),
                    textInputAction: TextInputAction.send,
                    style: appTextStyle(
                      size: 16,
                      lineHeight: 24,
                      letterSpacing: 0.5,
                      color: AppColors.onSurface,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: context.tr('gemini.inputHint'),
                      hintStyle: appTextStyle(
                        size: 16,
                        lineHeight: 24,
                        letterSpacing: 0.5,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onSend,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.send,
                    size: 19,
                    color: AppColors.primary,
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
