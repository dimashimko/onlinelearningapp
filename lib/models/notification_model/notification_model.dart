import 'package:equatable/equatable.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';

class NotificationModel extends Equatable {
  final TypeNotification? typeNotification;
  final String? uid; // uid
  final String? time;
  final String? text;

  const NotificationModel({
    this.typeNotification,
    this.uid,
    this.time,
    this.text,
  });

/*  const NotificationModel.empty({
    this.typeNotification = TypeNotification.simple,
    this.uid = '',
    this.time = '0',
    this.text = '',
  });*/

  //
  @override
  List<Object?> get props => [
    typeNotification,
    uid,
    time,
    text,
  ];



  NotificationModel copyWith({
    TypeNotification? typeNotification,
    String? uid,
    String? time,
    String? text,
    String? imageLink,
  }) {
    return NotificationModel(
      typeNotification: typeNotification ?? this.typeNotification,
      uid: uid ?? this.uid,
      time: time ?? this.time,
      text: text ?? this.text,
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
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> outputJson = {
      'typeNotification': typeNotification?.name,
      'uid': uid,
      'time': time,
      'text': text,
    };
    return outputJson;
  }
}
