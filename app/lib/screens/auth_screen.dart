import 'package:app/theme.dart';
import 'package:app/widgets/app_header.dart';
import 'package:app/widgets/resizable_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class AuthScreen extends StatelessWidget {
  static const route = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BrickSpacing.xxl,
              vertical: BrickSpacing.xxl,
            ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: BrickSpacing.xxl),
                  child: Text(
                    'Hey there 👋\nGet ready to experience live chat, aka the crazy chatting experience!',
                    style: BrickTheme.textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const ResizableArrow(
                    text: 'Chaliye shuru karte hain',
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
