class User {
  final int id;
  final String bio;
  final String email;
  final String name;
  final String username;

  User({
    required this.bio,
    required this.email,
    required this.id,
    required this.name,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      bio: json["bio"] ?? "",
      email: json["email"],
      id: json["id"],
      name: json["name"],
      username: json["username"],
    );
  }
}
