part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {
  const AccountEvent();
}

class OnChangeUserAvatar extends AccountEvent {
  const OnChangeUserAvatar({
    required this.newUserAvatar,
  });

  final String newUserAvatar;
}

class OnChangeUserName extends AccountEvent {
  const OnChangeUserName({
    required this.newName,
  });

  final String newName;
}

class GetAccountModel extends AccountEvent {}

/*class GetAccountModel extends AccountEvent {
  const GetAccountModel({
    required this.counter,
  });

  final int counter;
}*/
