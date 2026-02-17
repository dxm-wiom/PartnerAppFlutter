import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _quizPassedKey = 'wiom_quiz_passed';

  static Future<bool> isQuizPassed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_quizPassedKey) ?? false;
  }

  static Future<void> setQuizPassed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_quizPassedKey, true);
  }
}
