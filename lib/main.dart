import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/auth/auth_gateway.dart';

void main() {
  runApp(const TalentBridgeApp());
}

class TalentBridgeApp extends StatelessWidget {
  const TalentBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Talent Bridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AuthGateway(),
    );
  }
}
