// Data Connect surface — see auth/data/profile_repository.dart for the codegen note.
import 'package:skillx/generated/dataconnect/default.dart' as dc;

import '../domain/learner_quiz.dart';
import '../domain/teaching_session.dart';

/// Reads quiz-related data: the teacher's sessions, the learner's released
/// quizzes, and a learner-facing quiz (correctIndex omitted by the query).
class QuizRepository {
  dc.DefaultConnector get _connector => dc.DefaultConnector.instance;

  Future<List<TeachingSession>> getMyTeachingSessions() async {
    final res = await _connector.getMyTeachingSessions().execute();
    return res.data.sessions
        .map(
          (s) => TeachingSession(
            id: s.id,
            topic: s.topic,
            level: s.level.stringValue,
            status: s.status.stringValue,
            plannedSubtopics: s.plannedSubtopics ?? const [],
            coveredSubtopics: s.coveredSubtopics ?? const [],
          ),
        )
        .toList();
  }

  Future<List<LearnerQuizSummary>> getMyQuizzes() async {
    final res = await _connector.getMyQuizzes().execute();
    final quizzes = <LearnerQuizSummary>[];
    for (final sl in res.data.sessionLearners) {
      for (final q in sl.session.quizzes) {
        quizzes.add(
          LearnerQuizSummary(id: q.id, topic: q.topic, level: q.level.stringValue),
        );
      }
    }
    return quizzes;
  }

  Future<LearnerQuiz?> getLearnerQuiz(String quizId) async {
    final res = await _connector.getLearnerQuiz(quizId: quizId).execute();
    final quiz = res.data.quiz;
    if (quiz == null) return null;
    return LearnerQuiz(
      id: quiz.id,
      topic: quiz.topic,
      questions: quiz.questions
          .map(
            (q) => LearnerQuestion(
              order: q.order,
              questionText: q.questionText,
              options: [q.option0, q.option1, q.option2, q.option3],
            ),
          )
          .toList(),
    );
  }
}
