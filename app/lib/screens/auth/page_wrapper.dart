import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  PageWrapper({
    Key? key,
    this.child,
  }) : super(key: key);
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BrickSpacing.xxl,
        vertical: BrickSpacing.xxl,
      ),
      child: child,
    );
  }
}
