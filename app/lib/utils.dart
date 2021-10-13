import 'package:app/services/storage.dart';
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

bool validateName(String name) {
  if (name.trim() == "") {
    return false;
  }
  final nameRegex = RegExp(r'^[a-zA-Z][a-zA-Z ]+[a-zA-Z]$');
  return nameRegex.hasMatch(name);
}

bool validateUsername(String username) {
  if (username.trim() == "") {
    return false;
  }
  final nameRegex = RegExp(r'^[a-zA-Z][a-zA-Z._]+[a-zA-Z]$');
  return nameRegex.hasMatch(username);
}

bool validateBio(String bio) {
  return bio.trim().length < 180;
}

String firstName() {
  return (storage.name ?? "").split(" ")[0];
}
