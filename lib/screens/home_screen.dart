import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/home_dashboard.dart';
import '../widgets/quiz_modal.dart';
import '../widgets/restart_toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showModal = false;
  bool _showToast = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkQuizState();
  }

  Future<void> _checkQuizState() async {
    final passed = await StorageService.isQuizPassed();
    setState(() {
      _showModal = !passed;
      _loading = false;
    });
  }

  void _dismissModal() {
    setState(() => _showModal = false);
  }

  void _showRestartToast() {
    setState(() => _showToast = true);
  }

  void _dismissToast() {
    setState(() => _showToast = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const HomeDashboard(),
          if (_showModal)
            QuizModal(
              onDismiss: _dismissModal,
              onShowRestartToast: _showRestartToast,
            ),
          if (_showToast)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: RestartToast(onDismiss: _dismissToast),
            ),
        ],
      ),
    );
  }
}
