// Firestore-backed 1:1 chat models (Module 12 — the app's only realtime layer).

class ChatSummary {
  const ChatSummary({
    required this.chatId,
    required this.otherUid,
    required this.otherName,
    this.otherPhotoUrl,
    required this.lastMessage,
    this.lastMessageAt,
    required this.unread,
  });

  final String chatId;
  final String otherUid;
  final String otherName;
  final String? otherPhotoUrl;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unread;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    this.sentAt,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime? sentAt;

  bool isMine(String uid) => senderId == uid;
}

/// The session-link card shown in a chat once a session is scheduled (CHAT-05).
class ChatSessionCard {
  const ChatSessionCard({
    required this.sessionId,
    required this.teacherUid,
    required this.topic,
    required this.meetingLink,
    this.scheduledAt,
  });

  final String sessionId;
  final String teacherUid;
  final String topic;
  final String meetingLink;
  final DateTime? scheduledAt;
}
