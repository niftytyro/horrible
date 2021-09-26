import 'package:app/screens/auth/indicators.dart';
import 'package:app/screens/auth/loading_page.dart';
import 'package:app/screens/auth/login_page.dart';
import 'package:app/screens/auth/profile_page.dart';
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
  final PageController _pageController = PageController();
  double scale = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      timeDilation = 1;
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
                // physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                children: [
                  const LoginPage(),
                  LoadingPage(
                    slideToProfilePage: () {
                      setState(() {
                        scale = 1;
                      });
                      _pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  const ProfilePage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: BrickSpacing.xxl,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                constraints: BoxConstraints(
                  maxWidth: scale * MediaQuery.of(context).size.width,
                ),
                child: TextButton(
                  onPressed: () {
                    if (_pageController.page == 0) {
                      setState(() {
                        scale = 0;
                      });
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      // NOTE: this is just for dev purposes
                      _pageController.jumpToPage(0);
                    }
                  },
                  child: const ResizableArrow(
                    text: 'Chaliye shuru karte hain',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Indicators(pageController: _pageController),
            const SizedBox(height: 25),
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
