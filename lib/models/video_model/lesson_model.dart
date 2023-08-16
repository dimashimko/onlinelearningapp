class LessonModel {
  String? link;
  String? name;

  LessonModel({
    this.link,
    this.name,
  });

  @override
  String toString() {
    return 'link_length: ${link.toString().length}, name: $name';
  }

  LessonModel.empty({
    this.link,
    this.name,
  });

  LessonModel copyWith({
    String? link,
    String? name,
    String? phoneNumber,
    String? linkToImage,
    String? nameImage,
    int? typeSubscriptions,
  }) {
    return LessonModel(
      link: link ?? this.link,
      name: name ?? this.name,
    );
  }

  LessonModel.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['name'] = this.name;
    return data;
  }
}
