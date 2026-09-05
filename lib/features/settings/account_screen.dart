import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/primary_pill_button.dart';
import '../../core/widgets/surface_card.dart';
import 'widgets/settings_app_bar.dart';

/// figma 1:17706. 358x559 card, 96pt avatar with the camera badge, two
/// labelled fields, save button on the right.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController _name = TextEditingController(
    text: context.tr('account.fullNameValue'),
  );
  late final TextEditingController _phone = TextEditingController(
    text: context.tr('account.phoneValue'),
  );

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackdrop,
      body: Column(
        children: <Widget>[
          SettingsAppBar(title: context.tr('account.title')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
              children: <Widget>[
                SurfaceCard(
                  color: AppColors.surfaceSubtle,
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _sectionHeader(context),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Center(child: _avatar(context)),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            context.tr('account.changePhoto'),
                            style: appTextStyle(
                              size: 14,
                              lineHeight: 20,
                              letterSpacing: 0.1,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _field(
                        context,
                        label: context.tr('account.fullName'),
                        controller: _name,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        context,
                        label: context.tr('account.phoneNumber'),
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: PrimaryPillButton(
                          label: context.tr('account.saveChanges'),
                          height: 40,
                          width: null,
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.badge_outlined,
            size: 16,
            color: AppColors.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            context.tr('account.sectionTitle'),
            style: appTextStyle(
              size: 22,
              lineHeight: 28,
              letterSpacing: 0.25,
              color: AppColors.onSurfaceStrong,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _avatar(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.chatBubble,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 32,
              color: AppColors.outlineStrong,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.photo_camera,
                size: 14,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: appTextStyle(
            size: 12,
            lineHeight: 16,
            letterSpacing: 0.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppText.body,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceCard,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 13,
              ),
              border: _border(AppColors.outlineStrong),
              enabledBorder: _border(AppColors.outlineStrong),
              focusedBorder: _border(AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
