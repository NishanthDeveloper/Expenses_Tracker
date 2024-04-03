class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final int monthlyIncome;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.monthlyIncome,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'monthlyIncome': 0,
        "photoUrl": photoUrl,
      };
}
