import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String? iconLink;
  final String? name;
  final String? time;
  final String? text;
  final String? imageLink;

  const MessageModel({
    this.iconLink,
    this.name,
    this.time,
    this.text,
    this.imageLink,
  });

  const MessageModel.empty({
    this.iconLink = '',
    this.name = '',
    this.time = '0',
    this.text = '',
    this.imageLink = '',
  });

  //
  @override
  List<Object?> get props => [
        iconLink,
        name,
        time,
        text,
        imageLink,
      ];


  @override
  String toString() {
    return 'MessageModel{iconLink: $iconLink, name: $name, time: $time, text: $text, imageLink: $imageLink}';
  }

  MessageModel copyWith({
    String? iconLink,
    String? name,
    String? time,
    String? text,
    String? imageLink,
  }) {
    return MessageModel(
      iconLink: iconLink ?? this.iconLink,
      name: name ?? this.name,
      time: time ?? this.time,
      text: text ?? this.text,
      imageLink: imageLink ?? this.imageLink,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      iconLink: json['iconLink'],
      name: json['name'],
      time: json['time'],
      text: json['text'],
      imageLink: json['imageLink'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> outputJson = {
      'iconLink': iconLink,
      'name': name,
      'time': time,
      'text': text,
      'imageLink': imageLink,
    };
    return outputJson;
  }
}
