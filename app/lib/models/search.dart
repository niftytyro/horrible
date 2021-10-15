import 'package:app/models/user.dart';

class SearchResult {
  final List<User> users;
  String? error;

  SearchResult({required this.users, this.error});

  factory SearchResult.fromJson(List<User> users, {String? error}) {
    return SearchResult(users: users, error: error);
  }
}
