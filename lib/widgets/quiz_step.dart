import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../models/quiz_question.dart';
import 'option_card.dart';

class QuizStep extends StatefulWidget {
  final List<QuizQuestion> questions;
  final VoidCallback onComplete;
  final VoidCallback onRestart;

  const QuizStep({
    super.key,
    required this.questions,
    required this.onComplete,
    required this.onRestart,
  });

  @override
  State<QuizStep> createState() => QuizStepState();
}

class QuizStepState extends State<QuizStep> {
  int _currentQuestion = 0;
  int? _selectedOption;
  bool _answered = false;

  void resetQuiz() {
    setState(() {
      _currentQuestion = 0;
      _selectedOption = null;
      _answered = false;
    });
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
    });
  }

  bool get _isCorrect =>
      _selectedOption == widget.questions[_currentQuestion].correct;

  bool get _isLastQuestion =>
      _currentQuestion == widget.questions.length - 1;

  void _nextQuestion() {
    setState(() {
      _currentQuestion++;
      _selectedOption = null;
      _answered = false;
    });
  }

  OptionState _getOptionState(int index) {
    if (!_answered) return OptionState.normal;

    final correctIndex = widget.questions[_currentQuestion].correct;
    if (index == correctIndex) return OptionState.correct;
    if (index == _selectedOption) return OptionState.wrong;
    return OptionState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / widget.questions.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            height: 4,
            alignment: Alignment.centerLeft,
            color: WiomColors.neutral200,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(color: WiomColors.brand600),
            ),
          ),
        ),
        // Scrollable content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_currentQuestion + 1}/${widget.questions.length}',
                  style: WiomTextStyles.quizCounter,
                ),
                const SizedBox(height: 12),
                Text(question.question, style: WiomTextStyles.quizQuestion),
                const SizedBox(height: 20),
                // Options
                ...List.generate(question.options.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i < question.options.length - 1 ? 10 : 0,
                    ),
                    child: OptionCard(
                      index: i,
                      text: question.options[i],
                      state: _getOptionState(i),
                      onTap: () => _selectOption(i),
                    ),
                  );
                }),
                // Feedback
                if (_answered) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _isCorrect
                          ? WiomColors.positive100
                          : WiomColors.negative100,
                      border: Border.all(
                        color: _isCorrect
                            ? WiomColors.positive300
                            : WiomColors.negative300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isCorrect
                          ? '\u2713 सही जवाब! ${question.explanation}'
                          : '\u2717 गलत जवाब। ${question.explanation}',
                      style: _isCorrect
                          ? WiomTextStyles.feedbackCorrect
                          : WiomTextStyles.feedbackWrong,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isCorrect) {
                          if (_isLastQuestion) {
                            widget.onComplete();
                          } else {
                            _nextQuestion();
                          }
                        } else {
                          widget.onRestart();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCorrect
                            ? WiomColors.positive600
                            : WiomColors.brand600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isCorrect
                            ? (_isLastQuestion
                                ? 'पूरा हुआ \u2713'
                                : 'अगला सवाल \u2192')
                            : 'फिर से शुरू करें',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
