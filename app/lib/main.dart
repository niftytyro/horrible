import 'package:app/screens/auth/auth_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/splash/splash_screen.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: BrickColors.white,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: BrickColors.white,
      ),
      child: MaterialApp(
        title: 'Horrible',
        theme: BrickTheme.lightTheme,
        routes: {
          SplashScreen.route: (context) => const SplashScreen(),
          AuthScreen.route: (context) => const AuthScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
        },
        initialRoute: SplashScreen.route,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
