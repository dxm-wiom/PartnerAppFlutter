import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'theme/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: WiomColors.secondary,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const WiomPartnerApp());
}

class WiomPartnerApp extends StatelessWidget {
  const WiomPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiom Partner App',
      debugShowCheckedModeBanner: false,
      locale: const Locale('hi'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: WiomColors.brand600),
        scaffoldBackgroundColor: WiomColors.neutralWhite,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
