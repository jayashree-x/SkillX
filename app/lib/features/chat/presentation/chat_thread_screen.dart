import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../home/application/home_providers.dart';
import '../../quiz/application/quiz_providers.dart';
import '../../quiz/domain/teaching_session.dart';
import '../../ratings/presentation/rate_sheet.dart';
import '../../requests/application/requests_controller.dart';
import '../../requests/domain/accepted_request.dart';
import '../application/chat_providers.dart';
import '../domain/chat.dart';

class ChatThreadArgs {
  const ChatThreadArgs({
    required this.chatId,
    required this.otherUid,
    required this.title,
  });
  final String chatId;
  final String otherUid;
  final String title;
}

/// Module 12 — a 1:1 message thread with a session-link card (CHAT-05).
class ChatThreadScreen extends ConsumerStatefulWidget {
  const ChatThreadScreen({super.key, required this.args});
  final ChatThreadArgs args;

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final _input = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Opening the thread clears our unread counter.
    ref.read(chatRepositoryProvider).markRead(widget.args.chatId).catchError((_) {});
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _input.clear();
    try {
      await ref
          .read(chatRepositoryProvider)
          .sendMessage(widget.args.chatId, widget.args.otherUid, text);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider);
    final messages = ref.watch(messagesProvider(widget.args.chatId));
    final card = ref.watch(chatSessionCardProvider(widget.args.chatId));

    // The learner (not the teacher) can rate the session once one exists.
    final cardValue = card.valueOrNull;
    final canRate = cardValue != null && cardValue.teacherUid != uid;

    // If I'm the teacher for an accepted-but-not-yet-scheduled request with this
    // person, offer to start the session right from the chat (CHAT → session).
    AcceptedTeachingRequest? pendingTeach;
    for (final r in ref.watch(acceptedTeachingRequestsProvider).valueOrNull ??
        const <AcceptedTeachingRequest>[]) {
      if (r.learnerUid == widget.args.otherUid) {
        pendingTeach = r;
        break;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            UserAvatar(name: widget.args.title, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.args.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'SkillX chat',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (canRate)
            IconButton(
              tooltip: 'Rate teacher',
              icon: const Icon(Icons.star_outline_rounded),
              onPressed: () => showRateSheet(
                context,
                sessionId: cardValue.sessionId,
                teacherUid: cardValue.teacherUid,
                teacherName: widget.args.title,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          card.maybeWhen(
            // A scheduled session takes priority: show its Start/Join meeting
            // card. Otherwise, if I'm the teacher, offer to start one.
            data: (c) => c != null
                ? _SessionCard(card: c, isTeacher: c.teacherUid == uid)
                : (pendingTeach != null
                    ? _StartSessionCard(request: pendingTeach)
                    : const SizedBox.shrink()),
            orElse: () => const SizedBox.shrink(),
          ),
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text('Could not load messages.')),
              data: (list) {
                if (list.isEmpty) return const _EmptyThread();
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen, vertical: 12),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final idx = list.length - 1 - i; // chronological index
                    final msg = list[idx];
                    final prev = idx > 0 ? list[idx - 1] : null;
                    final showDay =
                        prev == null || !_sameDay(prev.sentAt, msg.sentAt);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showDay) _DayChip(msg.sentAt),
                        _Bubble(message: msg, mine: msg.isMine(uid)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _Composer(controller: _input, sending: _sending, onSend: _send),
        ],
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard({required this.card, required this.isTeacher});
  final ChatSessionCard card;
  final bool isTeacher;

  Future<void> _openMeet() async {
    if (card.meetingLink.isEmpty) return;
    final uri = Uri.tryParse(card.meetingLink);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Teacher wraps up (works even if the meeting finished early): jump straight
  /// to the post-session form, which generates the quiz and marks the session
  /// complete. If the full session object isn't loaded yet, fall back to the
  /// Teaching-sessions list where the same "Make quiz" action lives — so the
  /// teacher is never stranded (e.g. after a disconnect and app relaunch).
  void _endAndMakeQuiz(BuildContext context, WidgetRef ref) {
    final sessions = ref.read(myTeachingSessionsProvider).valueOrNull ??
        const <TeachingSession>[];
    TeachingSession? match;
    for (final s in sessions) {
      if (s.id == card.sessionId) {
        match = s;
        break;
      }
    }
    if (match != null) {
      context.push('/post-session-form', extra: match);
    } else {
      context.push('/teaching');
    }
  }

  Future<void> _markNotHeld(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Mark session as not held?'),
        content: const Text(
            'Use this only if the meeting did not take place. No quiz will be '
            'created and the learner can request again.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Keep')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Mark not held')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(functionsRepositoryProvider).cancelSession(card.sessionId);
      ref
        ..invalidate(upcomingSessionsProvider)
        ..invalidate(myTeachingSessionsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session marked as not held.')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not update the session. Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLink = card.meetingLink.isNotEmpty;
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.screen, AppSpacing.md, AppSpacing.screen, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.topic,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    Text(
                      card.scheduledAt == null
                          ? 'Meeting ready'
                          : DateFormat('EEE, MMM d · h:mm a')
                              .format(card.scheduledAt!),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isTeacher) ...[
            OutlinedButton.icon(
              onPressed: hasLink ? _openMeet : null,
              icon: const Icon(Icons.videocam_outlined, size: 18),
              label: const Text('Start / Rejoin meeting'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42)),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _endAndMakeQuiz(context, ref),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: const Text('End session & make quiz'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: hasLink ? _openMeet : null,
              icon: const Icon(Icons.videocam_rounded, size: 18),
              label: const Text('Join session'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your quiz will appear here once the teacher shares it.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ],
          Center(
            child: TextButton(
              onPressed: () => _markNotHeld(context, ref),
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text("Session didn't happen",
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Teacher-only prompt shown in the chat before a session is scheduled: opens
/// the Pre-Session Form to create the meeting.
class _StartSessionCard extends StatelessWidget {
  const _StartSessionCard({required this.request});
  final AcceptedTeachingRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.screen, AppSpacing.md, AppSpacing.screen, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ready to teach ${request.skillName}?',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Text(
                  'Set up the meeting when you\'ve agreed on a time.',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.push('/pre-session', extra: request),
            style: ElevatedButton.styleFrom(
              // Override the theme's full-width min so the button doesn't
              // starve the Expanded text column in this Row.
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});
  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final time = message.sentAt == null
        ? ''
        : DateFormat('h:mm a').format(message.sentAt!);
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.fromLTRB(14, 9, 14, 7),
        decoration: BoxDecoration(
          color: mine ? AppColors.primary : AppColors.surface,
          border: mine ? null : Border.all(color: AppColors.border),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 5),
            bottomRight: Radius.circular(mine ? 5 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.3,
                color: mine ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (time.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10.5,
                  color: mine
                      ? Colors.white.withValues(alpha: 0.75)
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A centered "Today / Yesterday / date" separator between days of messages.
class _DayChip extends StatelessWidget {
  const _DayChip(this.when);
  final DateTime? when;

  @override
  Widget build(BuildContext context) {
    final label = _dayLabel(when);
    if (label.isEmpty) return const SizedBox.shrink();
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.fill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _EmptyThread extends StatelessWidget {
  const _EmptyThread();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
                color: AppColors.blueTint, shape: BoxShape.circle),
            child: const Icon(Icons.waving_hand_rounded,
                color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 14),
          const Text('Say hello 👋',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Break the ice and plan your session.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

bool _sameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return a == b;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _dayLabel(DateTime? when) {
  if (when == null) return '';
  final now = DateTime.now();
  final d = DateTime(when.year, when.month, when.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(d).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return DateFormat('EEE, MMM d').format(when);
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.fill,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  decoration: const InputDecoration(
                    hintText: 'Message…',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: sending ? AppColors.borderStrong : AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: sending ? null : onSend,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded,
                          size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
