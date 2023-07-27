class UserModel {
  const UserModel({
    this.accessToken,
    this.refreshToken,
    this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['access'],
      refreshToken: json['refresh'],
      uid: json['id'],
    );
  }

  final String? accessToken;
  final String? refreshToken;
  final String? uid;

  UserModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? uid,
  }) {
    return UserModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toJson() => {
        'access': accessToken,
        'refresh': refreshToken,
        'id': uid,
      };
}
