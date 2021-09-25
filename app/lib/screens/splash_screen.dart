import 'package:app/widgets/app_header.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const route = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

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
