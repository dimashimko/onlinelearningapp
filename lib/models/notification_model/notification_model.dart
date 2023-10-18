import 'package:equatable/equatable.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';

class NotificationModel extends Equatable {
  final TypeNotification? typeNotification;
  final String? uid; // uid
  final String? time;
  final String? text;
  final String? title;

  const NotificationModel({
    this.typeNotification,
    this.uid,
    this.time,
    this.text,
    this.title,
  });

  NotificationModel copyWith({
    TypeNotification? typeNotification,
    String? uid,
    String? time,
    String? text,
    String? title,
  }) {
    return NotificationModel(
      typeNotification: typeNotification ?? this.typeNotification,
      uid: uid ?? this.uid,
      time: time ?? this.time,
      text: text ?? this.text,
      title: title ?? this.title,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    TypeNotification? typeNotification;
    if (json['typeNotification'] != null) {
      typeNotification = TypeNotification.values.byName(
        json['typeNotification'],
      );
    }

    return NotificationModel(
      typeNotification: typeNotification,
      uid: json['uid'],
      time: json['time'],
      text: json['text'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> outputJson = {
      'typeNotification': typeNotification?.name,
      'uid': uid,
      'time': time,
      'text': text,
      'title': title,
    };
    return outputJson;
  }

  @override
  List<Object?> get props => [
        typeNotification,
        uid,
        time,
        text,
        title,
      ];
}
