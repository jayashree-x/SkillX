import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/chat_repository.dart';
import '../domain/chat.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository());

/// The signed-in user's uid, for "is this message mine" checks. Watches the
/// reactive [authUidProvider] (not a one-shot `FirebaseAuth.currentUser`) so it
/// never caches an empty uid read during the cold-start auth-restore gap -- which
/// made the user's own messages mis-render as the other person's (left-aligned).
final currentUidProvider = Provider<String>(
  (ref) => ref.watch(authUidProvider) ?? '',
);

final chatsProvider = StreamProvider<List<ChatSummary>>(
  (ref) => ref.watch(chatRepositoryProvider).chats(),
);

final messagesProvider = StreamProvider.family<List<ChatMessage>, String>(
  (ref, chatId) => ref.watch(chatRepositoryProvider).messages(chatId),
);

final chatSessionCardProvider =
    StreamProvider.family<ChatSessionCard?, String>(
  (ref, chatId) => ref.watch(chatRepositoryProvider).sessionCard(chatId),
);

/// Chat ids where discussion has actually started — used to drop accepted
/// requests off "Ready to teach" once the teacher has begun chatting.
final initiatedChatIdsProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(chatRepositoryProvider).initiatedChatIds(),
);
