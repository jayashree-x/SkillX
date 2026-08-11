import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/chat_repository.dart';
import '../domain/chat.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) => ChatRepository());

/// The signed-in user's uid, for "is this message mine" checks.
final currentUidProvider = Provider<String>(
  (ref) => FirebaseAuth.instance.currentUser?.uid ?? '',
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
