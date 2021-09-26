import 'package:app/screens/auth/page_wrapper.dart';
import 'package:app/theme.dart';
import 'package:app/widgets/app_header.dart';
import 'package:app/widgets/resizable_arrow.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Hero(
            tag: AppHeader.heroTag,
            child: AppHeader(),
          ),
          Text(
            'The Crazy Chat App',
            style: BrickTheme.textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BrickSpacing.xxl),
            child: Text(
              'Hey there 👋\nGet ready to experience live chat, aka the crazy chatting experience!',
              style: BrickTheme.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
