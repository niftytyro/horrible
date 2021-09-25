import 'package:app/screens/auth/loading_page.dart';
import 'package:app/screens/auth/login_page.dart';
import 'package:app/theme.dart';
import 'package:app/widgets/app_header.dart';
import 'package:app/widgets/resizable_arrow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class AuthScreen extends StatefulWidget {
  static const route = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final PageController _pageController;
  double scale = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      timeDilation = 1;
    });
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        scale = 1 - _pageController.offset / MediaQuery.of(context).size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                children: const [
                  LoginPage(),
                  LoadingPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BrickSpacing.xxl,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.ease,
                constraints: BoxConstraints(
                  maxWidth: scale * MediaQuery.of(context).size.width,
                ),
                child: TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      _pageController.page == 0 ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const ResizableArrow(
                    text: 'Chaliye shuru karte hain',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
