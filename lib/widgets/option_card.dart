import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

enum OptionState { normal, correct, wrong, disabled }

class OptionCard extends StatelessWidget {
  final int index;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.index,
    required this.text,
    required this.state,
    this.onTap,
  });

  static const _letters = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final isDisabled = state == OptionState.disabled;
    final isCorrect = state == OptionState.correct;
    final isWrong = state == OptionState.wrong;

    Color borderColor;
    Color bgColor;
    Color letterBg;
    Color letterText;

    if (isCorrect) {
      borderColor = WiomColors.positive600;
      bgColor = WiomColors.positive100;
      letterBg = WiomColors.positive600;
      letterText = Colors.white;
    } else if (isWrong) {
      borderColor = WiomColors.negative600;
      bgColor = WiomColors.negative100;
      letterBg = WiomColors.negative600;
      letterText = Colors.white;
    } else {
      borderColor = WiomColors.neutral200;
      bgColor = Colors.white;
      letterBg = WiomColors.neutral100;
      letterText = WiomColors.neutral800;
    }

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: (isDisabled || isCorrect || isWrong) ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: letterBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _letters[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: letterText,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text, style: WiomTextStyles.optionText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
