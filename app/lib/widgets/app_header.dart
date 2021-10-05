import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  static const heroTag = 'app-header';
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BrickColors.white,
      child: Text(
        'Horrible',
        textAlign: TextAlign.center,
        style: BrickTheme.textTheme.headline1,
      ),
    );
  }
}
