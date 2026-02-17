class QuizQuestion {
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}
