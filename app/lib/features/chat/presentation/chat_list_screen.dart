import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../application/chat_providers.dart';
import '../domain/chat.dart';
import 'chat_thread_screen.dart';

/// Module 12 — the list of 1:1 conversations, newest first, with unread badges.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(chatsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load messages.')),
        data: (chats) {
          if (chats.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No conversations yet. A chat opens once a teacher accepts '
                  'your request.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textTertiary),
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 76, color: AppColors.border),
            itemBuilder: (_, i) => _ChatTile(chat: chats[i]),
          );
        },
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});
  final ChatSummary chat;

  @override
  Widget build(BuildContext context) {
    final unread = chat.unread > 0;
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screen, vertical: 6),
      leading: UserAvatar(
          name: chat.otherName, photoUrl: chat.otherPhotoUrl, radius: 24),
      title: Text(
        chat.otherName,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13,
          color: unread ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _time(chat.lastMessageAt),
            style: TextStyle(
              fontSize: 11.5,
              color: unread ? AppColors.primary : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 6),
          if (unread)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: Text(
                '${chat.unread}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            )
          else
            const SizedBox(height: 18),
        ],
      ),
      onTap: () => context.push(
        '/chat-thread',
        extra: ChatThreadArgs(
          chatId: chat.chatId,
          otherUid: chat.otherUid,
          title: chat.otherName,
        ),
      ),
    );
  }

  String _time(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final sameDay =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    return sameDay ? DateFormat.Hm().format(dt) : DateFormat.MMMd().format(dt);
  }
}
