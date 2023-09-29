class UserModel {
  String? uid;
  String? verificationId;
  String? name;
  String? phoneNumber;
  String? linkToImage;
  String? nameImage;
  int? typeSubscriptions;

  UserModel({
    this.uid,
    this.verificationId,
    this.name,
    this.phoneNumber,
    this.linkToImage,
    this.nameImage,
    this.typeSubscriptions,
  });

  @override
  String toString() {
    return ' uid: $uid,  verificationId_length: ${verificationId.toString().length}, name: $name, phoneNumber: $phoneNumber, linkToImage: $linkToImage, nameImage: $nameImage, typeSubscriptions: $typeSubscriptions';
  }

  UserModel.empty({
    this.uid,
    this.verificationId,
    this.name,
    this.phoneNumber,
    this.linkToImage,
    this.nameImage,
    this.typeSubscriptions,
  });

  UserModel copyWith({
    String? uid,
    String? verificationId,
    String? name,
    String? phoneNumber,
    String? linkToImage,
    String? nameImage,
    int? typeSubscriptions,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      verificationId: verificationId ?? this.verificationId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      linkToImage: linkToImage ?? this.linkToImage,
      nameImage: nameImage ?? this.nameImage,
      typeSubscriptions: typeSubscriptions ?? this.typeSubscriptions,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    verificationId = json['verificationId'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    linkToImage = json['linkToImage'];
    nameImage = json['nameImage'];
    typeSubscriptions = json['typeSubscriptions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['verificationId'] = verificationId;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['linkToImage'] = linkToImage;
    data['nameImage'] = nameImage;
    data['typeSubscriptions'] = typeSubscriptions;
    return data;
  }
}
