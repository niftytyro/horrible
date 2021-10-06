import 'dart:convert';
import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/services/storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

Future<String?> onboard() async {
  try {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      return "We couldn't login. Please try again soon!";
    }
    final response = await http.post(
      Uri.parse("$backendUrl/onboard"),
      body: jsonEncode(<String, String>{
        "email": account.email,
        "name": account.displayName ?? "",
      }),
    );
    if (response.statusCode != 200) {
      return response.body;
    }
    secureStorage.setJwt(json.decode(response.body));
  } catch (err) {
    return "We couldn't login. Please try again soon!";
  }
}

Future<String?> updateProfile(
    String? name, String? username, String? bio) async {
  try {
    final response = await http.post(
      Uri.parse("$backendUrl/user"),
      headers: {
        HttpHeaders.authorizationHeader: await secureStorage.jwt ?? '',
      },
      body: jsonEncode(<String, String>{
        "name": name ?? "",
        "username": username ?? "",
        "bio": bio ?? "",
      }),
    );
    if (response.statusCode != 200) {
      return response.body;
    }
  } catch (err) {
    return "We couldn't login. Please try again soon!";
  }
}
