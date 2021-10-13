import 'package:app/screens/auth/auth_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/services/storage.dart';
import 'package:app/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timeDilation = 3;
    Future.delayed(const Duration(seconds: 2), () async {
      if ((await storage.jwt) == null) {
        Navigator.pushReplacementNamed(context, AuthScreen.route);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Hero(
          tag: AppHeader.heroTag,
          child: AppHeader(),
        ),
      ),
    );
  }
}
