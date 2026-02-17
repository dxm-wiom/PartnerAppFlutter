import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class IntroStep extends StatelessWidget {
  final VoidCallback onStart;

  const IntroStep({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'नया नियम: \u20B9300 हर नए इंस्टॉल पर!',
            style: WiomTextStyles.popupTitle,
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: WiomTextStyles.bodyText,
              children: [
                const TextSpan(text: 'अब आपको हर '),
                TextSpan(
                  text: 'नए सफल इंस्टॉल',
                  style: WiomTextStyles.bodyText.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: WiomColors.brand600,
                    color: WiomColors.brand600,
                  ),
                ),
                const TextSpan(
                  text:
                      ' पर \u20B9300 मिलेंगे। इस नियम को चालू करने के लिए एक छोटा सा क्विज़ पूरा करें।',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: WiomColors.brand600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'क्विज़ शुरू करें',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
