import 'package:app/constants.dart';
import 'package:app/screens/auth/indicators.dart';
import 'package:app/screens/auth/loading_page.dart';
import 'package:app/screens/auth/login_page.dart';
import 'package:app/screens/auth/profile_page.dart';
import 'package:app/services/onboarding.dart';
import 'package:app/theme.dart';
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
  double firstDotWidth = Dot.maxWidth;
  double secondDotWidth = Dot.minWidth;
  double thirdDotWidth = Dot.minWidth;
  String message = "";

  void chaloShuruKaro() async {
    final error = await onboard();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: BrickColors.englishRusk,
        ),
      );
    } else {
      setState(() {
        scale = 0;
        firstDotWidth = Dot.minWidth;
        secondDotWidth = Dot.maxWidth;
      });
      _pageController.animateToPage(
        1,
        duration: animationDuration,
        curve: Curves.ease,
      );
    }
  }

  void chaloKhatamKaro() {
    // NOTE: this is just for dev purposes
    _pageController.jumpToPage(0);
    setState(() {
      firstDotWidth = Dot.maxWidth;
      thirdDotWidth = Dot.minWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      timeDilation = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    const LoginPage(),
                    LoadingPage(
                      slideToProfilePage: () {
                        setState(() {
                          scale = 1;
                          secondDotWidth = Dot.minWidth;
                          thirdDotWidth = Dot.maxWidth;
                        });
                        _pageController.animateToPage(
                          2,
                          duration: animationDuration,
                          curve: Curves.ease,
                        );
                      },
                    ),
                    const ProfilePage(),
                  ],
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0.0) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BrickSpacing.xxl,
                  ),
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.easeInOut,
                    constraints: BoxConstraints(
                      maxWidth: scale * MediaQuery.of(context).size.width,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_pageController.page == 0) {
                          chaloShuruKaro();
                        } else {
                          chaloKhatamKaro();
                        }
                      },
                      child: const ResizableArrow(
                        text: 'Chaliye shuru karte hain',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Indicators(
                  firstDotWidth: firstDotWidth,
                  secondDotWidth: secondDotWidth,
                  thirdDotWidth: thirdDotWidth,
                ),
                const SizedBox(height: 25),
              ]
            ],
          ),
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
