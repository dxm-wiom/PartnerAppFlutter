import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RestartToast extends StatefulWidget {
  final VoidCallback onDismiss;

  const RestartToast({super.key, required this.onDismiss});

  @override
  State<RestartToast> createState() => _RestartToastState();
}

class _RestartToastState extends State<RestartToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: WiomColors.negative100,
            border: Border(
              bottom: BorderSide(color: WiomColors.negative300, width: 2),
            ),
          ),
          child: Text(
            'कोई बात नहीं! चलो फिर से शुरू करते हैं',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: WiomColors.negative600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
