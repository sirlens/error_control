class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String displayName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.displayName,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      displayName: '${user.name} (${user.email})',
    );
  }
}