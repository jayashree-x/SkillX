import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quiz_functions_repository.dart';
import '../data/quiz_repository.dart';
import '../domain/learner_quiz.dart';
import '../domain/teaching_session.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) => QuizRepository());

final quizFunctionsRepositoryProvider =
    Provider<QuizFunctionsRepository>((ref) => QuizFunctionsRepository());

/// The teacher's sessions (to run the post-session form + quiz).
final myTeachingSessionsProvider = FutureProvider<List<TeachingSession>>(
  (ref) => ref.watch(quizRepositoryProvider).getMyTeachingSessions(),
);

/// Released quizzes the learner can attempt.
final myQuizzesProvider = FutureProvider<List<LearnerQuizSummary>>(
  (ref) => ref.watch(quizRepositoryProvider).getMyQuizzes(),
);

/// A learner-facing quiz to attempt (correctIndex omitted).
final learnerQuizProvider =
    FutureProvider.autoDispose.family<LearnerQuiz?, String>(
  (ref, quizId) => ref.watch(quizRepositoryProvider).getLearnerQuiz(quizId),
);
