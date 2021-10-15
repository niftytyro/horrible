import 'dart:convert';
import 'dart:io';

import 'package:app/constants.dart';
import 'package:app/models/search.dart';
import 'package:app/models/user.dart';
import 'package:app/services/storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

Future<Map> onboard() async {
  try {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      return {"error": "We couldn't login. Please try again soon!"};
    }
    final response = await http.post(
      Uri.parse("$backendUrl/onboard"),
      body: jsonEncode(<String, String>{
        "email": account.email,
        "name": account.displayName ?? "",
      }),
    );
    if (response.statusCode != 200) {
      return {"error": response.body};
    }
    final responseBody = json.decode(response.body);
    storage.setJwt(responseBody["token"]);
    await storage.setUserDetails(
      bio: responseBody["bio"],
      email: account.email,
      name: responseBody["name"],
      username: responseBody["username"],
    );
    return {
      "bio": responseBody["bio"],
      "email": responseBody["email"],
      "name": responseBody["name"],
      "username": responseBody["username"],
    };
  } catch (err) {
    return {"error": "We couldn't login. Please try again soon!"};
  }
}

Future<Map> getUser() async {
  try {
    final response = await http.get(
      Uri.parse("$backendUrl/user"),
      headers: {
        HttpHeaders.authorizationHeader: await storage.jwt ?? '',
      },
    );
    if (response.statusCode != 200) {
      return {};
    }
    final responseBody = json.decode(response.body);
    await storage.setUserDetails(
      bio: responseBody["bio"],
      email: responseBody["email"],
      name: responseBody["name"],
      username: responseBody["username"],
    );
    return {
      "bio": responseBody["bio"],
      "email": responseBody["email"],
      "name": responseBody["name"],
      "username": responseBody["username"],
    };
  } catch (err) {
    return {};
  }
}

Future<Map> updateProfile(
  String? name,
  String? username,
  String? bio,
) async {
  try {
    final response = await http.post(
      Uri.parse("$backendUrl/user/"),
      headers: {
        HttpHeaders.authorizationHeader: await storage.jwt ?? '',
      },
      body: jsonEncode(<String, String>{
        "name": name ?? "",
        "username": username ?? "",
        "bio": bio ?? "",
      }),
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      return {"error": responseBody["error"]};
    }
    await storage.setUserDetails(
      bio: responseBody["bio"] ?? "",
      email: responseBody["email"],
      name: responseBody["name"],
      username: responseBody["username"],
    );
    return {
      "bio": responseBody["bio"],
      "email": responseBody["email"],
      "name": responseBody["name"],
      "username": responseBody["username"],
    };
  } catch (err) {
    return {"error": "We couldn't login. Please try again soon!"};
  }
}

Future<SearchResult> search({String? key}) async {
  SearchResult searchResult;
  try {
    final response = await http.get(
      Uri.parse("$backendUrl/search?q=${key ?? ""}"),
      headers: {
        HttpHeaders.authorizationHeader: await storage.jwt ?? '',
      },
    );
    Iterable res = json.decode(response.body);
    List<User> users = List<User>.from(res.map((each) => User.fromJson(each)));
    searchResult = SearchResult.fromJson(users);
  } catch (err) {
    searchResult = SearchResult.fromJson([], error: "Couldn't fetch users.");
  }
  return searchResult;
}
