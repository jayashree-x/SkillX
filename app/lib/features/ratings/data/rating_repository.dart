import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Submits a session rating via the `submitRating` Cloud Function, which also
/// recomputes the teacher's average.
class RatingRepository {
  static const _baseUrl = 'https://us-central1-skillx-9a717.cloudfunctions.net';

  Future<void> submitRating({
    required String sessionId,
    required String teacherUid,
    required int stars,
    String? feedback,
  }) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/submitRating'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'sessionId': sessionId,
        'teacherUid': teacherUid,
        'stars': stars,
        if (feedback != null && feedback.trim().isNotEmpty)
          'feedback': feedback.trim(),
      }),
    );
    if (response.statusCode >= 400) {
      throw Exception('submitRating failed (${response.statusCode})');
    }
  }
}

final ratingRepositoryProvider =
    Provider<RatingRepository>((ref) => RatingRepository());
