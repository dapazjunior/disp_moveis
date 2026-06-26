class User {
  final String id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromMap(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }
}