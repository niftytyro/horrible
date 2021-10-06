import 'package:flutter/foundation.dart';

const backendUrl = kReleaseMode ? "" : "http://localhost:8080";

const animationDuration = Duration(milliseconds: 420);

enum InputFieldErrorMessageKey { bio, email, name, username }

const Map inputFieldErrorMessages = {
  InputFieldErrorMessageKey.bio: "Bio can't contain over 180 characters",
  InputFieldErrorMessageKey.email: "Invalid email",
  InputFieldErrorMessageKey.name: "Name can only contain alphabets and spaces",
  InputFieldErrorMessageKey.username:
      "Username can only contain alphabets, '.' and '_'",
};
