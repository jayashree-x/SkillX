import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../ratings/presentation/rate_sheet.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title),
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
            data: (c) => c == null
                ? const SizedBox.shrink()
                : _SessionCard(card: c, isTeacher: c.teacherUid == uid),
            orElse: () => const SizedBox.shrink(),
          ),
          Expanded(
            child: messages.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text('Could not load messages.')),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text('Say hello 👋',
                        style: TextStyle(color: AppColors.textTertiary)),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(AppSpacing.screen),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final msg = list[list.length - 1 - i]; // newest at bottom
                    return _Bubble(message: msg, mine: msg.isMine(uid));
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

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.card, required this.isTeacher});
  final ChatSessionCard card;
  final bool isTeacher;

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
                      : DateFormat('EEE, MMM d · h:mm a').format(card.scheduledAt!),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: card.meetingLink.isEmpty
                ? null
                : () async {
                    final uri = Uri.tryParse(card.meetingLink);
                    if (uri != null) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: Text(isTeacher ? 'Start' : 'Join'),
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
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? AppColors.primary : AppColors.surface,
          border: mine ? null : Border.all(color: AppColors.border),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.3,
            color: mine ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Message…',
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: sending ? null : onSend,
              icon: const Icon(Icons.send_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
