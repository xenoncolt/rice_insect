import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'scan_detail_screen.dart';
import 'widgets/activity_cards.dart';

/// Nodes 1:17873, 50:276, 50:414, 50:502 and 50:577.
///
/// Figma draws these as five frames, but they are one screen: the same header,
/// search field and filter chips with a different list underneath, plus a
/// search-focused state. Built as one screen with a filter, which is what the
/// frames describe.
enum ActivityFilter { all, thisWeek, lastMonth, pests, healthy }

class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({this.initialFilter = ActivityFilter.all, super.key});

  final ActivityFilter initialFilter;

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> {
  late ActivityFilter _filter = widget.initialFilter;
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus != _searching) {
        setState(() => _searching = _searchFocus.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  String _labelFor(ActivityFilter f) => switch (f) {
    ActivityFilter.all => context.tr('activity.filterAll'),
    ActivityFilter.thisWeek => context.tr('activity.filterThisWeek'),
    ActivityFilter.lastMonth => context.tr('activity.filterLastMonth'),
    ActivityFilter.pests => context.tr('activity.filterPests'),
    ActivityFilter.healthy => context.tr('activity.filterHealthy'),
  };

  void _openScan() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const ScanDetailScreen(),
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
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _searchField(context),
                ),
                if (_searching)
                  Expanded(child: _recentSearches(context))
                else ...<Widget>[
                  const SizedBox(height: 16),
                  _filterChips(context),
                  Expanded(child: _list(context)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.surface),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: <Widget>[
              const SizedBox(width: 16),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  context.tr('activity.title'),
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

  /// Node 1:17880 - a 358x50 #ECEFE3 field with the icon inset at x12.
  Widget _searchField(BuildContext context) {
    return Row(
      spacing: 8,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: _search,
              focusNode: _searchFocus,
              onChanged: (_) => setState(() {}),
              style: appTextStyle(
                size: 16,
                lineHeight: 24,
                letterSpacing: 0.5,
                color: AppColors.onSurfaceStrong,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.divider,
                isDense: true,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 41,
                  minHeight: 18,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintText: context.tr('activity.searchHint'),
                hintStyle: appTextStyle(
                  size: 16,
                  lineHeight: 24,
                  letterSpacing: 0.5,
                  color: AppColors.onSurfaceVariant,
                ),
                border: _searchBorder,
                enabledBorder: _searchBorder,
                focusedBorder: _searchBorder,
              ),
            ),
          ),
        ),
        if (_searching)
          TextButton(
            onPressed: () {
              _search.clear();
              _searchFocus.unfocus();
            },
            child: Text(
              context.tr('activity.cancel'),
              style: appTextStyle(
                size: 14,
                lineHeight: 20,
                weight: FontWeight.w500,
                letterSpacing: 0.1,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder get _searchBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  );

  /// Node 50:283 - the focused state swaps the list for recent searches.
  Widget _recentSearches(BuildContext context) {
    final List<String> terms = <String>[
      context.tr('activity.recentSearch1'),
      context.tr('activity.recentSearch2'),
      context.tr('activity.recentSearch3'),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      children: <Widget>[
        Text(
          context.tr('activity.recentSearches'),
          style: appTextStyle(
            size: 12,
            lineHeight: 16,
            weight: FontWeight.w500,
            letterSpacing: 0.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        for (final String term in terms)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.history,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            title: Text(
              term,
              style: appTextStyle(
                size: 16,
                lineHeight: 24,
                letterSpacing: 0.5,
                color: AppColors.onSurfaceStrong,
              ),
            ),
            onTap: () {
              _search.text = term;
              _searchFocus.unfocus();
            },
          ),
      ],
    );
  }

  /// Node 1:17886 - 32pt pills, active #A8E77B, the rest #E7E9DD. The row is
  /// 461pt of chips in a 358pt frame, so it scrolls.
  Widget _filterChips(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ActivityFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (BuildContext context, int i) {
          final ActivityFilter f = ActivityFilter.values[i];
          final bool active = f == _filter;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.scanAccent : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _labelFor(f),
                style: appTextStyle(
                  size: 14,
                  lineHeight: 20,
                  letterSpacing: 0.1,
                  color: active
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceStrong,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _list(BuildContext context) {
    return switch (_filter) {
      ActivityFilter.all => _scanList(context, healthyOnly: false),
      ActivityFilter.healthy => _scanList(context, healthyOnly: true),
      ActivityFilter.pests => _pestList(context),
      ActivityFilter.thisWeek || ActivityFilter.lastMonth => _timeline(context),
    };
  }

  /// Node 1:17897 - 358x103 rows with a 64pt thumbnail.
  Widget _scanList(BuildContext context, {required bool healthyOnly}) {
    final List<ScanEntry> entries = <ScanEntry>[
      ScanEntry(
        title: context.tr('activity.scan1Title'),
        pest: true,
        date: context.tr('activity.scan1Date'),
        block: context.tr('activity.scan1Block'),
      ),
      ScanEntry(
        title: context.tr('activity.scan2Title'),
        pest: false,
        date: context.tr('activity.scan2Date'),
        block: context.tr('activity.scan2Block'),
      ),
      ScanEntry(
        title: context.tr('activity.scan3Title'),
        pest: true,
        date: context.tr('activity.scan3Date'),
        block: context.tr('activity.scan3Block'),
      ),
      ScanEntry(
        title: context.tr('activity.scan4Title'),
        pest: false,
        date: context.tr('activity.scan4Date'),
        block: context.tr('activity.scan4Block'),
      ),
    ];
    final List<ScanEntry> shown = healthyOnly
        ? entries.where((ScanEntry e) => !e.pest).toList()
        : entries;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      itemCount: shown.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int i) => ScanEntryCard(
        entry: shown[i],
        pestLabel: context.tr('activity.badgePest'),
        healthyLabel: context.tr('activity.badgeHealthy'),
        onTap: _openScan,
      ),
    );
  }

  /// Node 50:421 - entries grouped under a date heading.
  Widget _timeline(BuildContext context) {
    final bool week = _filter == ActivityFilter.thisWeek;
    final String prefix = week ? 'activity.week' : 'activity.month';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: <Widget>[
        Text(
          context.tr('${prefix}Group1'),
          style: appTextStyle(
            size: 22,
            lineHeight: 28,
            weight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TimelineCard(
          title: context.tr('${prefix}Item1Title'),
          body: context.tr('${prefix}Item1Body'),
          time: context.tr('${prefix}Item1Time'),
          badge: week ? context.tr('activity.actionRequired') : null,
          tint: AppColors.scanAccent,
          icon: Icons.pest_control_outlined,
          iconColor: AppColors.onPrimaryContainer,
        ),
        const SizedBox(height: 16),
        TimelineCard(
          title: context.tr('${prefix}Item2Title'),
          body: context.tr('${prefix}Item2Body'),
          time: context.tr('${prefix}Item2Time'),
          tint: AppColors.videoTint,
          icon: Icons.water_drop_outlined,
          iconColor: AppColors.navLabel,
        ),
      ],
    );
  }

  /// Node 50:584 - 358x419 cards with a photo, risk badge and an action.
  Widget _pestList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: <Widget>[
        PestCard(
          name: context.tr('activity.pest1Name'),
          time: context.tr('activity.pest1Time'),
          location: context.tr('activity.pest1Location'),
          body: context.tr('activity.pest1Body'),
          risk: PestRisk.high,
          riskLabel: context.tr('activity.riskHigh'),
          typeLabel: context.tr('activity.badgePest'),
          action: context.tr('activity.viewDetails'),
          onAction: _openScan,
        ),
        const SizedBox(height: 16),
        PestCard(
          name: context.tr('activity.pest2Name'),
          time: context.tr('activity.pest2Time'),
          location: context.tr('activity.pest2Location'),
          body: context.tr('activity.pest2Body'),
          risk: PestRisk.moderate,
          riskLabel: context.tr('activity.riskModerate'),
          typeLabel: context.tr('activity.badgePest'),
          action: context.tr('activity.reviewAdvice'),
          onAction: _openScan,
        ),
      ],
    );
  }
}
