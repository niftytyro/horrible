import 'package:app/constants.dart';
import 'package:app/screens/auth/indicators.dart';
import 'package:app/screens/auth/loading_page.dart';
import 'package:app/screens/auth/login_page.dart';
import 'package:app/screens/auth/profile_page.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/api/user.dart';
import 'package:app/theme.dart';
import 'package:app/utils.dart';
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
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool invalidName = false;
  bool invalidUsername = false;
  bool invalidBio = false;
  String ctaText = "Chaliye shuru karte hain";
  double scale = 1;
  double firstDotWidth = Dot.maxWidth;
  double secondDotWidth = Dot.minWidth;
  double thirdDotWidth = Dot.minWidth;

  void chaloShuruKaro() async {
    final response = await onboard();
    if (response["error"] != null) {
      showSnackBar(
          context: context,
          message: response["error"],
          type: SnackBarType.error);
    } else {
      setState(() {
        scale = 0;
        firstDotWidth = Dot.minWidth;
        secondDotWidth = Dot.maxWidth;
      });
      _bioController.text = response["bio"] ?? "";
      _nameController.text = response["name"];
      _usernameController.text = response["username"];
      _pageController.animateToPage(
        1,
        duration: animationDuration,
        curve: Curves.ease,
      );
    }
  }

  void chaloKhatamKaro() async {
    setState(() {
      if (!validateName(_nameController.text)) {
        invalidName = true;
      } else {
        invalidName = false;
      }
      if (!validateUsername(_usernameController.text)) {
        invalidUsername = true;
      } else {
        invalidUsername = false;
      }
      if (!validateBio(_bioController.text)) {
        invalidBio = true;
      } else {
        invalidBio = false;
      }
    });
    if (!invalidBio && !invalidName && !invalidUsername) {
      final response = await updateProfile(
          _nameController.text, _usernameController.text, _bioController.text);
      if (response["error"] != null) {
        showSnackBar(
            context: context,
            message: response["error"],
            type: SnackBarType.error);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      }
    }
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
                          ctaText = "Welcome onboard";
                        });
                        _pageController.animateToPage(
                          2,
                          duration: animationDuration,
                          curve: Curves.ease,
                        );
                      },
                    ),
                    ProfilePage(
                      bioController: _bioController,
                      nameController: _nameController,
                      usernameController: _usernameController,
                      invalidBio: invalidBio,
                      invalidName: invalidName,
                      invalidUserame: invalidUsername,
                    ),
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
                      child: ResizableArrow(
                        text: ctaText,
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
    _bioController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
