import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Calls the learning-path Cloud Functions over HTTPS with the Firebase ID
/// token (UserProgress is server-write only).
class PathsFunctionsRepository {
  static const _baseUrl = 'https://us-central1-skillx-9a717.cloudfunctions.net';

  /// PATH-01: enrol the caller in a path (creates their progress row).
  Future<void> enrollPath(String pathId) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/enrollPath'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'pathId': pathId}),
    );
    if (response.statusCode >= 400) {
      throw Exception('enrollPath failed (${response.statusCode})');
    }
  }
}
