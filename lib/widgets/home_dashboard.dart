import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTabBar(),
        Expanded(
          child: Container(
            color: Colors.white,
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: WiomColors.secondary,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
      child: Row(
        children: [
          // Partner icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: WiomColors.brand600,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('P+', style: WiomTextStyles.partnerIcon),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'नमस्ते, रोहित',
              style: WiomTextStyles.homeGreeting,
            ),
          ),
          // Rating badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\u2605',
                  style: TextStyle(
                    fontSize: 14,
                    color: WiomColors.goldStar,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: WiomColors.goldStar,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '\u2630',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: WiomColors.brand600, width: 2),
                ),
              ),
              child: const Center(
                child: Text(
                  'नेटवर्क बढ़ायें',
                  style: WiomTextStyles.tabLabelActive,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: WiomColors.neutral200, width: 2),
                ),
              ),
              child: const Center(
                child: Text('पैसा कमायें', style: WiomTextStyles.tabLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: WiomColors.brand100,
              border: Border.all(color: WiomColors.brand300, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '08',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: WiomColors.neutral900,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Avatar dots
                      SizedBox(
                        height: 28,
                        child: Stack(
                          children: List.generate(4, (i) {
                            final colors = [
                              WiomColors.brand600,
                              WiomColors.info600,
                              WiomColors.positive600,
                              WiomColors.neutral500,
                            ];
                            return Positioned(
                              left: i * 20.0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: colors[i],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: WiomColors.brand100,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'कस्टमर प्रतीक्षा कर रहे हैं',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: WiomColors.neutral800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: WiomColors.brand600,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '\u2192',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Stats row
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: WiomColors.neutral200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'कुल एक्टिव कस्टमर',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: WiomColors.neutral700,
                  ),
                ),
                const Text(
                  '276',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: WiomColors.neutral900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
