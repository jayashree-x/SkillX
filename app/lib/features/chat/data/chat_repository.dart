import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/chat.dart';

/// Realtime 1:1 chat over Firestore. Chat docs are created server-side when a
/// request is accepted (`acceptRequest`); this handles messaging + unread.
class ChatRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<List<ChatSummary>> chats() {
    // No `orderBy` on the query — that would need a composite index
    // (participants + lastMessageAt). Sort newest-first client-side instead;
    // a user has few chats, so this is cheap and needs no index.
    return _db
        .collection('chats')
        .where('participants', arrayContains: _uid)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(_toSummary).toList();
      list.sort((a, b) {
        final at = a.lastMessageAt, bt = b.lastMessageAt;
        if (at == null && bt == null) return 0;
        if (at == null) return 1; // nulls last
        if (bt == null) return -1;
        return bt.compareTo(at); // newest first
      });
      return list;
    });
  }

  ChatSummary _toSummary(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final participants =
        (data['participants'] as List?)?.cast<String>() ?? const [];
    final otherUid =
        participants.firstWhere((p) => p != _uid, orElse: () => _uid);
    final members = (data['members'] as Map?) ?? const {};
    final other = (members[otherUid] as Map?) ?? const {};
    final unread = ((data['unread'] as Map?)?[_uid] as num?)?.toInt() ?? 0;
    return ChatSummary(
      chatId: doc.id,
      otherUid: otherUid,
      otherName: other['name'] as String? ?? 'SkillX user',
      otherPhotoUrl: other['photoUrl'] as String?,
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      unread: unread,
    );
  }

  Stream<List<ChatMessage>> messages(String chatId) {
    return _db
        .collection('chats/$chatId/messages')
        .orderBy('sentAt')
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final m = d.data();
              return ChatMessage(
                id: d.id,
                senderId: m['senderId'] as String? ?? '',
                text: m['text'] as String? ?? '',
                sentAt: (m['sentAt'] as Timestamp?)?.toDate(),
              );
            }).toList());
  }

  Stream<ChatSessionCard?> sessionCard(String chatId) {
    return _db.doc('chats/$chatId').snapshots().map((doc) {
      final s = doc.data()?['session'] as Map?;
      if (s == null) return null;
      return ChatSessionCard(
        sessionId: s['id'] as String? ?? '',
        teacherUid: s['teacherUid'] as String? ?? '',
        topic: s['topic'] as String? ?? 'Session',
        meetingLink: s['meetingLink'] as String? ?? '',
        scheduledAt: _parseWhen(s['scheduledAt']),
      );
    });
  }

  Future<void> sendMessage(String chatId, String otherUid, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final chatRef = _db.doc('chats/$chatId');
    final batch = _db.batch()
      ..set(chatRef.collection('messages').doc(), {
        'senderId': _uid,
        'text': trimmed,
        'sentAt': FieldValue.serverTimestamp(),
      })
      ..set(
        chatRef,
        {
          'lastMessage': trimmed,
          'lastMessageAt': FieldValue.serverTimestamp(),
          'unread': {otherUid: FieldValue.increment(1)},
          // Marks the conversation as started so the teacher's "Ready to teach"
          // card drops off the home screen once discussion has begun.
          'initiated': true,
        },
        SetOptions(merge: true),
      );
    await batch.commit();
  }

  /// Chat ids the signed-in user is in that have an actual conversation going
  /// (at least one message sent). No `orderBy`, so this needs only the default
  /// array-contains index — unlike [chats].
  Stream<Set<String>> initiatedChatIds() {
    return _db
        .collection('chats')
        .where('participants', arrayContains: _uid)
        .snapshots()
        .map((snap) => snap.docs
            .where((d) => d.data()['initiated'] == true)
            .map((d) => d.id)
            .toSet());
  }

  Future<void> markRead(String chatId) async {
    await _db.doc('chats/$chatId').set(
      {
        'unread': {_uid: 0},
      },
      SetOptions(merge: true),
    );
  }

  static DateTime? _parseWhen(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v);
    return null;
  }
}
