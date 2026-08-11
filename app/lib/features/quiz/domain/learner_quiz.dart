/// A released quiz in the learner's list (Phase 6).
class LearnerQuizSummary {
  const LearnerQuizSummary({
    required this.id,
    required this.topic,
    required this.level,
  });

  final String id;
  final String topic;
  final String level;
}

/// One learner-facing question — no correct answer (QUIZ, grading is server-side).
class LearnerQuestion {
  const LearnerQuestion({
    required this.order,
    required this.questionText,
    required this.options,
  });

  final int order;
  final String questionText;
  final List<String> options; // 4
}

/// The learner-facing quiz to attempt.
class LearnerQuiz {
  const LearnerQuiz({
    required this.id,
    required this.topic,
    required this.questions,
  });

  final String id;
  final String topic;
  final List<LearnerQuestion> questions;
}
