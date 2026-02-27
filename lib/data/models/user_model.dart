class User {
  final int? id;
  final String email;
  final String? password;
  final String? token;
  final bool isGuest;

  User({
    this.id,
    required this.email,
    this.password,
    this.token,
    this.isGuest = false,
  });

  factory User.guest() {
    return User(email: 'guest@example.com', isGuest: true);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['userId'], email: json['email'], token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token, 'isGuest': isGuest};
  }
}
