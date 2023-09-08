class LessonModel {
  String? link;
  String? name;
  int? duration;

  LessonModel({
    this.link,
    this.name,
    this.duration,
  });

  @override
  String toString() {
    return 'link_length: ${link.toString().length}, name: $name, duration: $duration';
  }

  LessonModel.empty({
    this.link,
    this.name,
    this.duration,
  });

  LessonModel copyWith({
    String? link,
    String? name,
    int? duration,
  }) {
    return LessonModel(
      link: link ?? this.link,
      name: name ?? this.name,
      duration: duration ?? this.duration,
    );
  }

  LessonModel.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    name = json['name'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['name'] = this.name;
    data['duration'] = this.duration;
    return data;
  }
}
