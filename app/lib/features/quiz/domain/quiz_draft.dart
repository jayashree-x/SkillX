/// A generated question on the teacher's approval screen — mutable so the
/// teacher can edit text and the correct answer before releasing (QUIZ-13).
class DraftQuestion {
  DraftQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });

  String questionText;
  List<String> options; // 4
  int correctIndex; // 0..3
}
