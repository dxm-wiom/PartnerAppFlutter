import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../data/quiz_data.dart';
import '../services/storage_service.dart';
import 'intro_step.dart';
import 'quiz_step.dart';
import 'success_step.dart';

enum QuizState { intro, quiz, success }

class QuizModal extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback onShowRestartToast;

  const QuizModal({
    super.key,
    required this.onDismiss,
    required this.onShowRestartToast,
  });

  @override
  State<QuizModal> createState() => _QuizModalState();
}

class _QuizModalState extends State<QuizModal>
    with SingleTickerProviderStateMixin {
  QuizState _state = QuizState.intro;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final _quizKey = GlobalKey<QuizStepState>();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    setState(() => _state = QuizState.quiz);
  }

  void _onQuizComplete() async {
    await StorageService.setQuizPassed();
    setState(() => _state = QuizState.success);
  }

  void _onRestart() {
    widget.onShowRestartToast();
    _quizKey.currentState?.resetQuiz();
  }

  void _onDismiss() {
    _animController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = screenHeight * 0.50;
    final maxHeight = screenHeight * 0.90;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        color: WiomColors.modalScrim,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: minHeight,
                maxHeight: maxHeight,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case QuizState.intro:
        return IntroStep(onStart: _startQuiz);
      case QuizState.quiz:
        return QuizStep(
          key: _quizKey,
          questions: defaultQuizData,
          onComplete: _onQuizComplete,
          onRestart: _onRestart,
        );
      case QuizState.success:
        return SingleChildScrollView(
          child: SuccessStep(onContinue: _onDismiss),
        );
    }
  }
}
