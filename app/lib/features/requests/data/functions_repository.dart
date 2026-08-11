import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Calls the privileged Cloud Functions (HTTPS onRequest) with the caller's
/// Firebase ID token. These do the writes clients can't (session creation,
/// chat open, meeting-link email, notifications).
///
/// After deploy, confirm the base URL — v2 functions also expose a
/// `<region>-<project>.cloudfunctions.net` alias, which this uses.
class FunctionsRepository {
  static const _baseUrl =
      'https://us-central1-skillx-9a717.cloudfunctions.net';

  Future<Map<String, dynamic>> _post(
    String name,
    Map<String, dynamic> body,
  ) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/$name'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      throw Exception('$name failed (${response.statusCode})');
    }
    if (response.body.isEmpty) return const {};
    return (jsonDecode(response.body) as Map).cast<String, dynamic>();
  }

  /// HOME-05: a learner sends a request; the server inserts it and notifies the
  /// teacher (capped 3/day).
  Future<void> sendRequest({
    required String teacherUid,
    required String skillId,
    DateTime? preferredDateTime,
    String? message,
  }) =>
      _post('sendRequest', {
        'teacherUid': teacherUid,
        'skillId': skillId,
        'preferredDateTime': preferredDateTime?.toUtc().toIso8601String(),
        if (message != null && message.trim().isNotEmpty) 'message': message.trim(),
      });

  /// Real accept: ACCEPTED + opens the chat + notifies the learner.
  Future<void> acceptRequest(String requestId) =>
      _post('acceptRequest', {'requestId': requestId});

  /// Pre-Session Form submit → creates the session. The backend creates a
  /// Google Calendar event + Meet link and emails invites to both people, so
  /// no meeting link is sent from the client.
  Future<String> createSession({
    required String requestId,
    required List<String> learnerUids,
    required String topic,
    required List<String> topicTags,
    required List<String> plannedSubtopics,
    required String level,
    required int durationHours,
    DateTime? scheduledAt,
  }) async {
    final data = await _post('createSession', {
      'requestId': requestId,
      'learnerUids': learnerUids,
      'topic': topic,
      'topicTags': topicTags,
      'plannedSubtopics': plannedSubtopics,
      'level': level,
      'durationHours': durationHours,
      'scheduledAt': scheduledAt?.toUtc().toIso8601String(),
    });
    return data['sessionId'] as String;
  }
}
