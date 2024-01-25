class User {
  final String? email;
  final String? displayName;
  final String? photoURL;
  final List<String>? learn;
  final List<String>? known;
  final List<String>? unknown;

  User({
    this.email,
    this.displayName,
    this.photoURL,
    this.learn,
    this.known,
    this.unknown,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      learn: json['learn'] != null ? List<String>.from(json['learn']) : [],
      known: json['known'] != null ? List<String>.from(json['known']) : [],
      unknown:
          json['unknown'] != null ? List<String>.from(json['unknown']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'learn': learn,
        'known': known,
        'unknown': unknown,
      };
}
