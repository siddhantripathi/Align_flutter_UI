class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? idToken;
  final String? accessToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.idToken,
    this.accessToken,
  });

  factory UserModel.fromFirebaseUser(dynamic user, {String? idToken, String? accessToken}) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'User',
      photoURL: user.photoURL,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'idToken': idToken,
      'accessToken': accessToken,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      idToken: json['idToken'],
      accessToken: json['accessToken'],
    );
  }

  // Get first name from display name
  String get firstName {
    if (displayName.isEmpty) return 'User';
    return displayName.split(' ').first;
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? idToken,
    String? accessToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      idToken: idToken ?? this.idToken,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
