import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../domain/quiz_draft.dart';
import '../domain/quiz_result.dart';

/// Calls the quiz Cloud Functions (generate / approve / grade) over HTTPS with
/// the Firebase ID token — same transport as requests/FunctionsRepository.
class QuizFunctionsRepository {
  static const _baseUrl = 'https://us-central1-skillx-9a717.cloudfunctions.net';

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
    return (jsonDecode(response.body) as Map).cast<String, dynamic>();
  }

  /// QUIZ-13: generate a draft quiz from the confirmed covered subtopics.
  Future<({String quizId, List<DraftQuestion> questions})> generateQuiz({
    required String sessionId,
    required List<String> coveredSubtopics,
  }) async {
    final data = await _post('generateQuiz', {
      'sessionId': sessionId,
      'coveredSubtopics': coveredSubtopics,
    });
    final questions = (data['questions'] as List).map((raw) {
      final q = (raw as Map).cast<String, dynamic>();
      return DraftQuestion(
        questionText: q['questionText'] as String,
        options: (q['options'] as List).cast<String>(),
        correctIndex: q['correctIndex'] as int,
      );
    }).toList();
    return (quizId: data['quizId'] as String, questions: questions);
  }

  /// QUIZ-18: release the quiz to learners, applying any teacher edits.
  Future<void> approveQuiz({
    required String quizId,
    required List<DraftQuestion> questions,
  }) async {
    final edits = [
      for (var i = 0; i < questions.length; i++)
        {
          'order': i + 1,
          'questionText': questions[i].questionText,
          'options': questions[i].options,
          'correctIndex': questions[i].correctIndex,
        },
    ];
    await _post('approveQuiz', {'quizId': quizId, 'edits': edits});
  }

  /// QUIZ-07: submit answers for server-side grading. [localDate] is the
  /// device's local calendar date (YYYY-MM-DD) so the server applies the
  /// streak rules against the learner's own day (RWD-05).
  Future<QuizResult> gradeQuiz({
    required String quizId,
    required List<int> answers,
    required String localDate,
  }) async {
    final data = await _post('gradeQuiz', {
      'quizId': quizId,
      'answers': answers,
      'localDate': localDate,
    });
    return QuizResult(
      score: data['score'] as int,
      total: data['total'] as int,
      percentage: (data['percentage'] as num).toDouble(),
      badge: data['badge'] as String,
      correctIndexes: (data['correctIndexes'] as List).cast<int>(),
      currentStreak: data['currentStreak'] as int?,
    );
  }
}
