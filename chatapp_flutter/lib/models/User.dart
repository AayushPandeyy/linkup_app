// models/user.dart
class User {
  final String id;
  final String email;
  final String username;

  User({
    required this.id,
    required this.email,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
