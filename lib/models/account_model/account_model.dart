import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String? name;
  final String? avatarLink;
  final String? uid;

  const AccountModel({
    this.name,
    this.avatarLink,
    this.uid,
  });

  const AccountModel.empty({
    this.name,
    this.avatarLink,
    this.uid,
  });

  AccountModel copyWith({
    String? name,
    String? avatarLink,
    String? uid,
  }) {
    return AccountModel(
      name: name ?? this.name,
      avatarLink: avatarLink ?? this.avatarLink,
      uid: uid ?? this.uid,
    );
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['name'],
      avatarLink: json['avatarLink'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['avatarLink'] = avatarLink;
    data['uid'] = uid;
    return data;
  }

  @override
  List<Object?> get props => [
    name,
    avatarLink,
    uid,
  ];

}
