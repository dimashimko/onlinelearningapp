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
class OnChangeUserAccount extends AccountEvent {
  const OnChangeUserAccount({
    required this.newName,
    required this.newAvatarLocalLink,
  });

  final String? newName;
  final String? newAvatarLocalLink;

}

class GetAccountModel extends AccountEvent {}

/*class GetAccountModel extends AccountEvent {
  const GetAccountModel({
    required this.counter,
  });

  final int counter;
}*/
