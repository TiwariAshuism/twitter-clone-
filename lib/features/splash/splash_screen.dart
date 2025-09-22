import 'package:chirper/features/auth/domain/services/user_session_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final UserSessionService userSessionService;
  const SplashScreen({super.key, required this.userSessionService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    final hasSession = await widget.userSessionService.hasActiveSession();
    if (!mounted) return;
    if (hasSession) {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
