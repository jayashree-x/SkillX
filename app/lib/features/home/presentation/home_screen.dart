import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../discovery/application/discovery_providers.dart';
import '../../discovery/domain/offering.dart';
import '../../discovery/presentation/widgets/offering_card.dart';
import '../../requests/application/requests_controller.dart';
import '../../requests/domain/accepted_request.dart';
import '../application/home_providers.dart';
import '../domain/incoming_request.dart';
import '../domain/upcoming_session.dart';
import 'widgets/home_header.dart';
import 'widgets/incoming_request_card.dart';
import 'widgets/upcoming_session_card.dart';

/// Module 3 — Home: header + streak, search, upcoming sessions, incoming
/// requests (accept/reject), and browse offerings with a category filter.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _category;

  @override
  void initState() {
    super.initState();
    // Register the device push token now that the user is signed in (Module 8),
    // and route notification taps to the right screen (NOTIF-02).
    Future.microtask(() async {
      final fcm = ref.read(fcmServiceProvider);
      await fcm.registerToken().catchError((_) {});
      await fcm.setupTapHandling((route) {
        if (mounted) context.go(route);
      }).catchError((_) {});
    });
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(currentHomeUserProvider)
      ..invalidate(upcomingSessionsProvider)
      ..invalidate(incomingRequestsProvider)
      ..invalidate(acceptedTeachingRequestsProvider)
      ..invalidate(offeringsProvider);
  }

  Future<void> _join(String? link) async {
    final uri = link == null ? null : Uri.tryParse(link);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the meeting link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentHomeUserProvider);
    final upcoming = ref.watch(upcomingSessionsProvider);
    final incoming = ref.watch(incomingRequestsProvider);
    final accepted = ref.watch(acceptedTeachingRequestsProvider);
    final offerings = ref.watch(offeringsProvider);
    final requestsBusy = ref.watch(requestsControllerProvider).isLoading;

    ref.listen(requestsControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action failed. Please try again.')),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.md,
              AppSpacing.screen,
              AppSpacing.xl,
            ),
            children: [
              userAsync.when(
                data: (user) => HomeHeader(user: user),
                loading: () => const SizedBox(height: 46),
                error: (_, _) => const SizedBox(height: 46),
              ),
              const SizedBox(height: 18),
              _SearchBar(onTap: () => context.push('/search')),
              ..._upcomingSection(upcoming),
              ..._incomingSection(incoming, requestsBusy),
              ..._readyToTeachSection(accepted),
              ..._browseSection(offerings),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _upcomingSection(AsyncValue<List<UpcomingSession>> upcoming) {
    final sessions = upcoming.valueOrNull ?? const [];
    if (sessions.isEmpty) return const [];
    return [
      const _SectionHeader('Upcoming Sessions'),
      for (final s in sessions)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: UpcomingSessionCard(
              session: s, onJoin: () => _join(s.meetingLink)),
        ),
    ];
  }

  List<Widget> _incomingSection(
    AsyncValue<List<IncomingRequest>> incoming,
    bool busy,
  ) {
    final requests = incoming.valueOrNull ?? const [];
    if (requests.isEmpty) return const [];
    final controller = ref.read(requestsControllerProvider.notifier);
    return [
      _SectionHeader('Incoming Requests', count: requests.length),
      for (final r in requests)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: IncomingRequestCard(
            request: r,
            busy: busy,
            onAccept: () => controller.accept(r.id),
            onReject: () => controller.reject(r.id),
          ),
        ),
    ];
  }

  List<Widget> _readyToTeachSection(
    AsyncValue<List<AcceptedTeachingRequest>> accepted,
  ) {
    final requests = accepted.valueOrNull ?? const [];
    if (requests.isEmpty) return const [];
    return [
      _SectionHeader('Ready to teach', count: requests.length),
      for (final r in requests)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AcceptedRequestCard(
            request: r,
            onStart: () => context.push('/pre-session', extra: r),
          ),
        ),
    ];
  }

  List<Widget> _browseSection(AsyncValue<List<Offering>> offeringsAsync) {
    return [
      const _SectionHeader('Browse Skills'),
      offeringsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) =>
            const _EmptyState('Could not load skills. Pull to refresh.'),
        data: (offerings) {
          if (offerings.isEmpty) {
            return const _EmptyState(
              'No skills yet — seed the catalogue to see teachers here.',
            );
          }
          final categories = offerings.map((o) => o.category).toSet().toList()
            ..sort();
          final filtered = _category == null
              ? offerings
              : offerings.where((o) => o.category == _category).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categories.length > 1) _categoryChips(categories),
              for (final o in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OfferingCard(
                    offering: o,
                    onTap: () => context.push('/offering', extra: o),
                  ),
                ),
            ],
          );
        },
      ),
    ];
  }

  Widget _categoryChips(List<String> categories) {
    Widget chip(String? value, String label) {
      final selected = _category == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => setState(() => _category = value),
          showCheckmark: false,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip(null, 'All'),
            for (final c in categories) chip(c, c),
          ],
        ),
      ),
    );
  }
}

class _AcceptedRequestCard extends StatelessWidget {
  const _AcceptedRequestCard({required this.request, required this.onStart});

  final AcceptedTeachingRequest request;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          UserAvatar(
            name: request.learnerName,
            photoUrl: request.learnerPhotoUrl,
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.learnerName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  request.skillName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              child: const Text('Start Session'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, size: 20, color: AppColors.textTertiary),
            SizedBox(width: 10),
            Text(
              'Search skills or people',
              style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.count});
  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
