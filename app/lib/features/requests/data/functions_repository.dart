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
      // Surface the server's friendly message (fail() returns { error }).
      String msg = '$name failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['error'] is String) msg = body['error'] as String;
      } catch (_) {}
      throw FunctionFailure(msg, response.statusCode);
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

  /// Real accept: ACCEPTED + opens the chat + notifies the learner. Returns the
  /// 1:1 chat id so the teacher can be dropped straight into the conversation.
  Future<String?> acceptRequest(String requestId) async {
    final data = await _post('acceptRequest', {'requestId': requestId});
    return data['chatId'] as String?;
  }

  /// Reject: REJECTED + notifies the learner. Goes through the function (not a
  /// client Data Connect mutation) so the decline can push a notification.
  Future<void> rejectRequest(String requestId) =>
      _post('rejectRequest', {'requestId': requestId});

  /// "Session didn't happen" — mark a scheduled session CANCELLED (idempotent),
  /// clear its chat card and notify the other party. Used when a meeting fell
  /// through (e.g. the teacher disconnected and never returned).
  Future<void> cancelSession(String sessionId) =>
      _post('cancelSession', {'sessionId': sessionId});

  /// Learner "skills in progress" (reworked learning path). Each entry:
  /// { skill, attempts, bestPercentage, passed, topics: [{name, done}] }.
  Future<List<Map<String, dynamic>>> getSkillProgress() async {
    final data = await _post('getSkillProgress', const {});
    return ((data['skills'] as List?) ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  /// Teacher detail extras: reviews + trusted skills + rating summary, and
  /// (when skillId is given) whether the caller already has an open request.
  Future<Map<String, dynamic>> getTeacherExtras(String teacherUid,
      {String? skillId}) {
    final body = <String, dynamic>{'teacherUid': teacherUid};
    if (skillId != null) body['skillId'] = skillId;
    return _post('getTeacherExtras', body);
  }

  /// TRUST quiz step 1 -> { skillName, questions: [{questionText, options}] }.
  Future<Map<String, dynamic>> startTrustQuiz(String skillId) =>
      _post('startTrustQuiz', {'skillId': skillId});

  /// TRUST quiz step 2 -> { passed, percentage, score, total }.
  Future<Map<String, dynamic>> submitTrustQuiz(
          String skillId, List<int> answers) =>
      _post('submitTrustQuiz', {'skillId': skillId, 'answers': answers});

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

/// A Cloud Function call that failed, carrying the server's message + status
/// so callers can show it (e.g. the duplicate-request 409).
class FunctionFailure implements Exception {
  const FunctionFailure(this.message, this.statusCode);
  final String message;
  final int statusCode;
  @override
  String toString() => message;
}
