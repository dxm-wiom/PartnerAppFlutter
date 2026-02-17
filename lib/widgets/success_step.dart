import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class SuccessStep extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Badge with dashed ring
          SizedBox(
            width: 116,
            height: 116,
            child: CustomPaint(
              painter: _DashedCirclePainter(
                color: WiomColors.brand300,
                strokeWidth: 3,
                dashLength: 6,
                gapLength: 4,
              ),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment(-0.7, -0.7),
                      end: Alignment(0.7, 0.7),
                      colors: [Color(0xFF6D17CE), Color(0xFF9B4DFF)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'PayG',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'CERTIFIED',
                        style: WiomTextStyles.badgeLabel.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('बधाई हो!', style: WiomTextStyles.popupTitle),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: WiomTextStyles.bodyText,
                children: [
                  const TextSpan(
                    text:
                        'आपने PayG सिस्टम की सभी बातें समझ ली हैं। अब आपको हर ',
                  ),
                  TextSpan(
                    text: 'नए सफल इंस्टॉल',
                    style: WiomTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' पर मिलेंगे'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Payout chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: WiomColors.positive100,
              border: Border.all(color: WiomColors.positive300, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '\u20B9300 प्रति नया इंस्टॉल',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: WiomColors.positive600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Note box
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: WiomColors.neutral100,
                border: Border.all(color: WiomColors.neutral300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'ध्यान दें: पुराना नियम (churned कस्टमर पर \u20B9300) अब लागू नहीं है। यह पेआउट सिर्फ नए इंस्टॉल पर मिलेगा।',
                style: WiomTextStyles.successNote,
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
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
                'आगे बढ़ें',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();
    final dashAngle = (dashLength / circumference) * 2 * math.pi;
    final gapAngle = (gapLength / circumference) * 2 * math.pi;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * (dashAngle + gapAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
