import 'package:app/theme.dart';
import 'package:flutter/material.dart';

enum SnackBarType { error, message }

void showSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: BrickColors.englishRusk,
      padding: const EdgeInsets.all(BrickSpacing.l1),
    ),
  );
}
